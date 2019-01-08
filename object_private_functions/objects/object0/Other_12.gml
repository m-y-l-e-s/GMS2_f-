/// @description add_numbers(a ... max)
/// This function will add all supplied values together

var final_value = 0;

for(var i=0; i<_argument_count; i++) {
	final_value += _argument[i];
}

_return = final_value;
/*
	Instead of the typical syntax of
		return my_variable;
	We will be **setting** a special variable
		_return
		
	The expected scripting variable
		argument_count
	will be replaced with our special variable
		_argument_count
		
	In scripting you can use
		argument[INDEX]
	to access argument values.  We will use
	the special variable
		_argument[INDEX]
*/