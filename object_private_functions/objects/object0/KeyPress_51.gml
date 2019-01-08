/// @description Run User Event 3

my_variable = "apples";
my_next_variable = "bananas";

switch(USE_METHOD) {
	case 1:
		var compared_result = f("check_if_equal(my_variable,my_next_variable)");
		break;
	
	case 2:
		var compared_result = f("check_if_equal",[my_variable,my_next_variable]);
		break;
		
	case 3:
		var compared_result = f("check_if_equal",my_variable,my_next_variable);
		break;
}

show_debug_message("Return value from Key Press 3: "+string(compared_result) );



my_variable = "tomato";
my_next_variable = "tomato";

switch(USE_METHOD) {
	case 1:
		var compared_result = f("check_if_equal(my_variable,my_next_variable)");
		break;
	
	case 2:
		var compared_result = f("check_if_equal",[my_variable,my_next_variable]);
		break;
		
	case 3:
		var compared_result = f("check_if_equal",my_variable,my_next_variable);
		break;
}

show_debug_message("Return value from Key Press 3: "+string(compared_result) );