/// @description Run User Event 2

my_variable = 3;
my_next_variable = 5;

switch(USE_METHOD) {
	case 1:
		var added_value = f("add_numbers(my_variable,my_next_variable,2)");
		break;
	
	case 2:
		var added_value = f("add_numbers",[my_variable,my_next_variable,2]);
		break;
		
	case 3:
		var added_value = f("add_numbers",my_variable,my_next_variable,2);
		break;
}

show_debug_message("Return value from Key Press 2: "+string(added_value) );