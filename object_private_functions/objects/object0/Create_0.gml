/// @description !!README!! Declare our functions

//f() function declarations
functions = [
	"my_first_function", // this is entry 0 in the functions array (functions[0]) so it will correlate to User Event 0
	"my_second_function", // this is entry 1 in the functions array (functions[1]) so it will correlate to User Event 1
	"add_numbers", //this is entry 2 in the functions array (functions[2]) so it will correlate to User Event 2
	"check_if_equal", //this is entry 3 in the functions array (functions[3]) so it will correlate to User Event 3
];

USE_METHOD = 1; //1, 2, or 3
/*
	f() can simulate function calls in a few different ways.

		METHOD 1: f("my_custom_function('a string argument',1,2.532,true)");
			OR
		METHOD 2: f("my_custom_function",["a string argument",1,2.532,true]);
			OR
		METHOD 3: f("my_custom_function","a string argument",1,2.532,true);
	
	In each of the Key Press events I have set up a switch case that will run the
	same function in whichever method you have set up above.
*/