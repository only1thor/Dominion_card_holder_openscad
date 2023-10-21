// How tall the card holder should be.
card_holder_height = 25;//91;
// The distance each deck is offset from the ones next to it.
card_stack_offset = 10;
// Thickness of the walls. (i used the Fast setting on my slicer, it test the extrusion width to 0.2mm)
wall_thickness = 0.2;
// The thickness of the decks you want to store.
deck_sizes = [10,20,13.5,11];

// variables below this module will not be rendered for user manipulation
module __Customizer_Limit__ () {}
card_width = 60;


function sum_list(list, index = 0, total = 0) = 
    index < len(list) ? 
    sum_list(list, index + 1, total + list[index]) : 
    total;

function partial_list(sub_list,start,end) = 
	end == -1 ? [sub_list[0]] : [for (i = [start:end]) sub_list[i]];

module card_stack_body(stack_thickness,card_pluss_wall_width) {
    cube([card_pluss_wall_width, stack_thickness, card_holder_height]);
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
		cube([card_width/4,stack_length,card_holder_height]);
	}
}

cards_spaced(deck_sizes,wall_thickness);