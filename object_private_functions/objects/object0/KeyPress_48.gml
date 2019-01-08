/// @description Run User Event 0

switch(USE_METHOD) {
	case 1:
		var total_argument_count = f("my_first_function(1,2,3,4,5,6,7)");
		break;
		
	case 2:
		var total_argument_count = f("my_first_function",[1,2,3,4,5,6,7]);
		break;
		
	case 3:
		var total_argument_count = f("my_first_function",1,2,3,4,5,6,7);
		break;
}

show_debug_message("Return value from Key Press 0: "+string(total_argument_count) );