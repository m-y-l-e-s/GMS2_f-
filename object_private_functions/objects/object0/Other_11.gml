/// @description my_second_function()
/// This function will return a random argument it received

var which_argument = irandom(_argument_count-1);

_return = _argument[which_argument];
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