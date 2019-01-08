/// @description Run User Event 1

my_variable = 20;

switch(USE_METHOD) {
	case 1:
		var random_argument_returned = f("my_second_function('a',3,my_variable)");
		break;
		
	case 2:
		var random_argument_returned = f("my_second_function",["a",3,my_variable]);
		break;
		
	case 3:
		var random_argument_returned = f("my_second_function","a",3,my_variable);
		break;
}

show_debug_message("Return value from Key Press 1: "+string(random_argument_returned) );