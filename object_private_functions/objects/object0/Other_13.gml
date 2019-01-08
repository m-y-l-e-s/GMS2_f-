/// @description check_if_equal(a,b)
/// This function checks if the supplied arguments are equal

if(_argument0 == _argument1) {
	_return = true;
}
else {
	_return = false;
}
/*
	Instead of the typical syntax of
		return my_variable;
	We will be **setting** a special variable
		_return
		
	In place of the typical
		argument0
		argument1
	We can instead use the special variables
		_argument0
		_argument1
	There are the expected 16 available arguments
*/