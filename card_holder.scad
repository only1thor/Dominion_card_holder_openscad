// Define the dimensions of the card
card_width = 60;
card_height = 25;//91;

card_stack_offset = 10;

//(w,d,h)
//(x,y,z)

function sum_list(list, index = 0, total = 0) = 
    index < len(list) ? 
    sum_list(list, index + 1, total + list[index]) : 
    total;

function partial_list(sub_list,start,end) = 
	end == -1 ? [sub_list[0]] : [for (i = [start:end]) sub_list[i]];

module card_stack_body(stack_thickness,card_pluss_wall_width) {
    cube([card_pluss_wall_width, stack_thickness, card_height]);
}

module cards_spaced(list_of_deck_thicknesses,wall_width){
	list = [for (i = list_of_deck_thicknesses) i+(wall_width*2) ];
	number = len(list);
    for ( i = [0:number-1]){
		if ( i == 0 ) {
				card_stack_body(list[i],card_width+wall_width*2);
		}	
		else {
			echo("Partial: ", partial_list(list,0,i-1));
			echo("Sum of partial: ",sum_list(partial_list(list,0,i-1)));
			if (i % 2 == 0) {
				translate([0, (sum_list(partial_list(list,0,i-1)))+wall_width*3*i,0]){
					card_stack_body(list[i],card_width+wall_width*2);
				}
			} else {
				translate([card_stack_offset,(sum_list(partial_list(list,0,i-1)))+wall_width*3*i,0]){
					card_stack_body(list[i],card_width+wall_width*2);
				}
			}
		}
    }
	
	stack_length= sum_list(list) + wall_width*(len(list)-1)*3;
	center_offset = card_width/2 + card_stack_offset/2 - card_width/8;
	translate([center_offset, 0, 0]){
		cube([card_width/4,stack_length,card_height]);
	}
}

cards_spaced([10,20,13.5,11],0.35);