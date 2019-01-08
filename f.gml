/// @function f("your_function(comma,separated,arguments)")
/// @description f() allows you to utilize object User Events to simulate local functions
/// @param "your_function(comma,separated,arguments)"
/*
MIT License

Copyright (c) 2019 Myles

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



SCRIPT VERSION: 1.0
PUBLISH DATE: JAN 08, 2019

==WHAT IS IT?==
f() is used to simulate local functions within an object utilizing User Events and
allowing you to pass in arguments.  This script is self contained and requires very 
little modification to existing code to add to your project.

==HOW DO I USE IT?==
In your object, add the following to your CREATE event.

	//f() function declarations
	functions = [
		"my_custom_function", // index 0 -> user event 0
		"my_other_function", // index 1 -> user event 1
	];

You will declare your function names IN USER EVENT NUMERICAL ORDER in the "functions"
array.  That is to say, the function that correlates to USER EVENT 0 will be first,
the function that correlates to USER EVENT 1 will be second, etc.

In your code, you may then call your function and its arguments with

	METHOD 1: f("my_custom_function('a string argument',1,2.532,true)");
		OR
	METHOD 2: f("my_custom_function",["a string argument",1,2.532,true]);
		OR
	METHOD 3: f("my_custom_function","a string argument",1,2.532,true);

You will then write your custom function code in the respective User Event. The only
caveats are that your return will have to be placed into a variable...
	ex User Event 0: 
		WRONG:
			return my_variable;
		
		RIGHT:
			_return = my_variable;
and your arguments will be prepended with an underscore...
	ex User Event 0: 
		WRONG:
			var my_variable = argument0 + argument1;
		
		RIGHT:
			var my_variable = _argument0 + _argument1;

From your User Event you can also see how many arguments to expect with
	_argument_count
and you can access more than 16 arguments by using the array
	_argument[0 ... max_num]

==HOW DOES IT WORK?==
String parsing.  That's really about it.  Check out the code below, I tried to
comment it well.

==WHAT ARE THE LIMITATIONS?==
At the time of writing this you are not able to have more than 16 custom functions 
per object.  This is a Game Maker limitation (16 User Events).

If you are using METHOD 1...

You cannot pass inline arrays ( ex: f("my_array_function([0,1,2],'whatever')"); )

You cannot pass in strings with commas ( "," ) in them.  You will want to first
put these strings into a variable...
	ex: 
		WRONG:
			f("my_function('hello, my friend', false)");
		
		RIGHT:
			var my_string = "hello, my friend";
			f("my_function(my_string, false)");

*/



/* ----------------------------------- */
/* EDIT THESE VARIABLES TO YOUR LIKING */
/* ----------------------------------- */
//Do you want this script to print out debug messages to the console? Opts: true or false
var show_debug_messages = true;

//How much info should we spit out if we are printing debug messages?
//	INFO	-> show ERROR messages and include additional information that may be useful
//				for debugging
//	ERROR	-> only print ERROR messages
var debug_message_verbosity = "INFO";

//If you renamed this script, enter the name here.  This is to make it easier to identify
//	and debug problems using the debug messages.
var this_script_name = "f";
/* ----------------------------------- */
/* ----------------------------------- */
/* ----------------------------------- */



// Initialize our faux arguments that will be used in the User Event in place of script arguments
_argument0 = undefined;
_argument1 = undefined;
_argument2 = undefined;
_argument3 = undefined;
_argument4 = undefined;
_argument5 = undefined;
_argument6 = undefined;
_argument7 = undefined;
_argument8 = undefined;
_argument9 = undefined;
_argument10 = undefined;
_argument11 = undefined;
_argument12 = undefined;
_argument13 = undefined;
_argument14 = undefined;
_argument15 = undefined;
_return = undefined;
_argument_count = undefined;
_argument = [];

// If we are showing debug messages (default: true) we will notify the user ONCE that they can disable the INFO/ERROR messages.
if(show_debug_messages && !variable_global_exists("f_has_been_run_once")) {
	show_debug_message(this_script_name+"()::NOTICE: You can enable, disable, and reduce these messages in script "+this_script_name+".gml on lines 109 and 115.");
	global.f_has_been_run_once = true;
}

// If we are logging INFO level show a debug message with the function being called.
if(show_debug_messages && debug_message_verbosity == "INFO") {
	show_debug_message(this_script_name+"()::INFO: Object "+object_get_name(object_index)+" calling function: "+string(argument[0]));
}


// function_name will store the parsed name of the function (surprise surprise)
var function_name = "";

// the function_index will store where in the functions array this function appears.  This is how we will know which user event to call.
var function_index = -1;

// the type of declaration that was used when calling this script.  We will use this to properly sort the arguments later.
var function_method = -1;

// first we check to see if we are using the function in the original format
//		f("my_function(1,2,3)");
if(argument_count == 1 && is_string(argument[0])) {
	// find the open and close parenthesis
	var open_parenthesis_index = string_pos("(", argument[0]);
	var close_parenthesis_index = string_pos(")", argument[0]);

	// if we couldn't find one of the parentheses we will ERROR out and exit the script
	if(open_parenthesis_index == 0 || close_parenthesis_index == 0) {
		if(show_debug_messages) {
			show_debug_message(this_script_name+"()::ERROR: Malformed function, parentheses expected.  Did you typo when entering the function?");
		}
		exit;
	}

	// grab everything before the open parenthesis.  This will be our function name.
	function_name = string_copy(argument[0], 1, open_parenthesis_index-1);
	function_method = 1;
	
	// if we are showing INFO let them know which function method we have found
	if(show_debug_messages && debug_message_verbosity == "INFO") {
		show_debug_message(this_script_name+"()::INFO: Parsing function using METHOD "+string(function_method));
	}
}
// next we will check to see if we are using the function with a function name then array of arguments
//		f("my_function",[1,2,3]);
else if(argument_count == 2 && is_string(argument[0]) && is_array(argument[1])) {
	function_name = argument[0];
	function_method = 2;
	
	// if we are showing INFO let them know which function method we have found
	if(show_debug_messages && debug_message_verbosity == "INFO") {
		show_debug_message(this_script_name+"()::INFO: Parsing function using METHOD "+string(function_method));
	}
}
// finally, we will check to see if we are using the function via arguments exclusively, with argument0 being the function name
//		f("my_function",1,2,3);
else if(argument_count >= 1 && is_string(argument[0])) {
	function_name = argument[0];
	function_method = 3;
	
	// if we are showing INFO let them know which function method we have found
	if(show_debug_messages && debug_message_verbosity == "INFO") {
		show_debug_message(this_script_name+"()::INFO: Parsing function using METHOD "+string(function_method));
	}
}
// otherwise we have not been provided a string declaring the function name, so we will display an error
else {
	if(show_debug_messages) {
		show_debug_message(this_script_name+"()::ERROR: Function call is not a string, therefore it cannot be evaluated.");
		if(debug_message_verbosity == "INFO") {
			show_debug_message("╘═"+this_script_name+"()::INFO: Example usage: "+this_script_name+"(\"myFunc('some_string',15)\");");
		}
	}
	exit;
}

// search the functions array for an entry with the same text as the function name that we have parsed
for(var functions_array_index=0; functions_array_index < array_length_1d(functions); functions_array_index++) {
	if(functions[functions_array_index] == function_name) {

		// once we have found the function name in the array we will store the function_index, aka the user event to be called
		function_index = functions_array_index;
	}
}

// check and see if the function_index is still equal to the original value of -1.  If it is, this means that we did
//	not find the function in our functions array.  Spit out some debug text explaining this problem and exit script.
if(function_index == -1) {
	if(show_debug_messages) {
		show_debug_message(this_script_name+"()::ERROR: Function "+function_name+" not found.  Did you declare it in your Create Event -> functions array?");
		if(debug_message_verbosity == "INFO") {
			show_debug_message("╘═"+this_script_name+"()::INFO: Declared functions in functions array:");
			for(var functions_array_index=0; functions_array_index < array_length_1d(functions); functions_array_index++) {
				show_debug_message("╘══"+string(functions[functions_array_index])+" -> User Event "+string(functions_array_index));
			}
		}
	}
	exit;
}

switch(function_method) {

	case 1:
		// parse out the text between the open and close parenthesis.  This will give us a comma separated value list of arguments.
		var all_arguments_csv = string_copy(argument[0], open_parenthesis_index+1, close_parenthesis_index-open_parenthesis_index-1);

		// count the arguments by counting the commas
		var total_arguments = string_count(",",all_arguments_csv)+1;
		_argument_count = total_arguments;

		// if we are showing INFO level debug messages we will list out all of the args that were calculated
		if(show_debug_messages && debug_message_verbosity == "INFO") {
			show_debug_message(this_script_name+"()::INFO: Parsed argument values:");
		}
		// iterate through the arguments...
		for(var iterator_index=0; iterator_index < total_arguments; iterator_index++) {

			// on all arguments before the last argument we will be removing the text from the CSV string after extracting it
			if(iterator_index < total_arguments-1) {		
				var first_comma_location = string_pos(",", all_arguments_csv);
				var argument_text = string_copy(all_arguments_csv, 1, first_comma_location-1);
				all_arguments_csv = string_delete(all_arguments_csv, 1, first_comma_location);
			}
			// this is the final argument, so it has no commas and requires no further text deletion
			else {
				var argument_text = all_arguments_csv;
			}
		
			// check and see if the provided argument is a string by looking for opening and closing quotes
			var first_character = string_char_at(argument_text, 1);
			var last_character = string_char_at(argument_text, string_length(argument_text));
			if((first_character == "'" && last_character == "'") || (first_character == "\"" && last_character == "\"")) {
				// the item found is a string, so we remove the quotes, and set _argument# to the string value
				var cleaned_string = string_copy(argument_text, 2, string_length(argument_text)-2);
				variable_instance_set(self.id, "_argument"+string(iterator_index), cleaned_string);
				_argument[iterator_index] = cleaned_string;
			}
			// otherwise, if the argument is a variable that exists within the object, we will use the value of that variable
			else if(!is_undefined(variable_instance_get(self.id, argument_text))) {
				variable_instance_set(self.id, "_argument"+string(iterator_index), variable_instance_get(self.id, argument_text));
				_argument[iterator_index] = variable_instance_get(self.id, argument_text);
			}
			// if the argument is true or false, we will set it as a boolean value
			else if(string_lower(argument_text) == "true" || string_lower(argument_text) == "false") {
				if(string_lower(argument_text) == "true") {
					variable_instance_set(self.id, "_argument"+string(iterator_index), true);
					_argument[iterator_index] = true;
				}
				else {
					variable_instance_set(self.id, "_argument"+string(iterator_index), false);
					_argument[iterator_index] = false;
				}
			}
			// finally, whatever is leftover is converted into a real number
			else {
				variable_instance_set(self.id, "_argument"+string(iterator_index), real(argument_text));
				_argument[iterator_index] = real(argument_text);
			}
	
			// if we are debugging INFO level messages this will output the final value of this particular argument
			if(show_debug_messages && debug_message_verbosity == "INFO") {
				show_debug_message("╘═_argument"+string(iterator_index)+" -> "+string(variable_instance_get(self.id, "_argument"+string(iterator_index))));
			}
		}
		break;
	
	case 2:
		// store the array for referencing
		var temp_array = argument[1];

		// count the arguments by counting the size of the array passed into argument1
		var total_arguments = array_length_1d(temp_array);
		_argument_count = total_arguments;
		
		// if we are showing INFO level debug messages we will list out all of the args that were calculated
		if(show_debug_messages && debug_message_verbosity == "INFO") {
			show_debug_message(this_script_name+"()::INFO: Parsed argument values:");
		}
		
		
		// iterate through the arguments...
		for(var iterator_index=0; iterator_index < total_arguments; iterator_index++) {
			
			// set our custom arguments to the entries from the array
			variable_instance_set(self.id, "_argument"+string(iterator_index), temp_array[iterator_index]);
			_argument[iterator_index] = temp_array[iterator_index];
			
			// if we are debugging INFO level messages this will output the final value of this particular argument
			if(show_debug_messages && debug_message_verbosity == "INFO") {
				show_debug_message("╘═_argument"+string(iterator_index)+" -> "+string(variable_instance_get(self.id, "_argument"+string(iterator_index))));
			}
		}
		break;
		
	case 3:
		// count the arguments by removing the first entry from our argument list
		var total_arguments = argument_count - 1;
		_argument_count = total_arguments;
		
		// iterate through the arguments starting at 1...
		for(var iterator_index=1; iterator_index < total_arguments; iterator_index++) {
			
			// set our custom arguments to the entries from the array
			variable_instance_set(self.id, "_argument"+string(iterator_index), argument[iterator_index]);
			_argument[iterator_index] = argument[iterator_index];
			
			// if we are debugging INFO level messages this will output the final value of this particular argument
			if(show_debug_messages && debug_message_verbosity == "INFO") {
				show_debug_message("╘═_argument"+string(iterator_index)+" -> "+string(variable_instance_get(self.id, "_argument"+string(iterator_index))));
			}
		}
		break;
		
}

// call the user event
event_user(function_index);

// return the return value if the user event set it
if(!is_undefined(_return)) {
	if(show_debug_messages && debug_message_verbosity == "INFO") {
		show_debug_message(this_script_name+"()::INFO: Return value was set to: "+string(_return));
	}
	return _return;
}