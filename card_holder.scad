// The thickness of the decks you want to store. (I find that number of cards *0.35 gives a stug fit, add an additional 1 or 2 for a slightly looser fit)
deck_card_count = [60,40,30,24,12,12,30,7];
deck_sizes = [for (i = deck_card_count) round(i*0.35+1.4)];
// Names of the decks, to be embossed on the side. (To skip naming a deck name it: "")
deck_names = ["Copper","Silver", "Gold", "Estate", "Duchy", "Province", "Curse","Blank"];
// Thickness of the walls. (I used the "0.20mm SPEED" setting on my slicer, so i set the wall thickness to 0.2)
wall_thickness = 0.2;
// The distance each deck is offset from the ones next to it. This is the staggering that makes it easier to grab the corner of a deck.
card_stack_offset = 20;
// enable beveled text allowing for text in vase mode print. requires heavy readering, enable when preview looks right.
enable_text = true;
// How tall the card holder should be. set to a bit less than the height of the cards so they leave a bit to be grabbed.
card_holder_height = 50;

// The width of the card (shortest lenght). If you have sleaved cards, or cards with non standard sizes, you may want to increase this.
card_width = 61;

// helper function to get the length of all decks stacked
function sum_list(list, index = 0, total = 0) = 
    index < len(list) ? 
    sum_list(list, index + 1, total + list[index]) : 
    total;

// helper function to get a portion of the entire list of decks
function partial_list(sub_list,start,end) = 
	end == -1 ? [sub_list[0]] : [for (i = [start:end]) sub_list[i]];

// module to create a deck
module card_stack_body(stack_thickness,card_pluss_wall_width) {
    cube([card_pluss_wall_width, stack_thickness, card_holder_height]);
}

// module to create text on the side of a deck
module card_text(stack_name,thickness,placement_x_y){
	font_size = thickness > 10 ? 10: thickness;
	color("lightblue")
	translate([placement_x_y[0], placement_x_y[1], 2])
	rotate([90,-90,-90])
	// minkowski is really tought to run, so enable it only when ready for final render.
	if (enable_text){
       minkowski(){
		linear_extrude(height = 0.1)
		text(stack_name, font = "Arial:style=Bold", size = font_size, halign = "left", valign = "center");
		cylinder(h =0.5, r1=0.25,r2=0.01);
	   }
	}
	else {
		linear_extrude(height = 1)
		text(stack_name, font = "Arial:style=Bold", size = font_size, halign = "left", valign = "center");
	}
}

// module to generate the model.
module cards_spaced(list_of_deck_thicknesses,names,wall_width){
	// create a list of deck thicknesses that account for wall thickness
	list = [for (i = list_of_deck_thicknesses) i+(wall_width*2) ];
	number = len(list);
    for ( i = [0:number-1]){
		// First run should not get partial list. since i=0, and 0-1 is out of bounds of the list.
		if ( i == 0 ) {
				card_stack_body(list[i],card_width+wall_width*2);
				card_text(names[0],list[i]-2,[0,list[i]/2]);
		}	
		else {
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
	echo("Total length: ", stack_length);
}

// Use the module to actually gererate the model. 
cards_spaced(deck_sizes,deck_names,wall_thickness);