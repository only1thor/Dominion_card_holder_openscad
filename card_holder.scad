// How tall the card holder should be. set to a bit less than the height of the cards so they leave a bit to be grabbed.
card_holder_height = 50;//91;
// The distance each deck is offset from the ones next to it. This is the staggering that makes it easier to grab the corner of a deck.
card_stack_offset = 20;
// Thickness of the walls. (i used the Fast setting on my slicer, it test the extrusion width to 0.2mm)
wall_thickness = 0.2;
// The thickness of the decks you want to store.
deck_sizes = [12,22,15];
// Names of the decks, to be embossed on the side.
deck_names = ["Rando","Copper","Silver"];

// enable beveled text allowing for text in vase mode print. requires heavy readering, enable when preview looks right.
enable_text = false;

// The width of the card (shortest lenght). If you have sleaved cards, you may want to increase this.
card_width = 61;


function sum_list(list, index = 0, total = 0) = 
    index < len(list) ? 
    sum_list(list, index + 1, total + list[index]) : 
    total;

function partial_list(sub_list,start,end) = 
	end == -1 ? [sub_list[0]] : [for (i = [start:end]) sub_list[i]];

module card_stack_body(stack_thickness,card_pluss_wall_width) {
    cube([card_pluss_wall_width, stack_thickness, card_holder_height]);
}

module card_text(stack_name,thickness,placement_x_y){
	font_size = thickness > 10 ? 10: thickness;
	translate([placement_x_y[0], placement_x_y[1], 2])
	rotate([90,-90,-90])
	if (enable_text){
       minkowski(){
		linear_extrude(height = 0.1)
		text(stack_name, font = "Arial:style=Bold", size = font_size, halign = "left", valign = "center");
		cylinder(h =0.5, r1=0.5,r2=0.05);
	   }
	}
	else {
		linear_extrude(height = 1)
		text(stack_name, font = "Arial:style=Bold", size = font_size, halign = "left", valign = "center");
	}
}


module cards_spaced(list_of_deck_thicknesses,names,wall_width){
	list = [for (i = list_of_deck_thicknesses) i+(wall_width*2) ];
	number = len(list);
    for ( i = [0:number-1]){
		if ( i == 0 ) {
				card_stack_body(list[i],card_width+wall_width*2);
				card_text(names[0],list[i]-2,[0,list[i]/2]);
		}	
		else {
			echo("Partial: ", partial_list(list,0,i-1));
			echo("Sum of partial: ",sum_list(partial_list(list,0,i-1)));
			if (i % 2 == 0) {
				translate([0, (sum_list(partial_list(list,0,i-1)))+wall_width*3*i,0]){
					card_stack_body(list[i],card_width+wall_width*2);
					card_text(names[i],list[i]-2,[0,list[i]/2]);
				}
			} else {
				translate([card_stack_offset,(sum_list(partial_list(list,0,i-1)))+wall_width*3*i,0]){
					card_stack_body(list[i],card_width+wall_width*2);
					card_text(names[i],list[i]-2,[0,list[i]/2]);
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

cards_spaced(deck_sizes,deck_names,wall_thickness);