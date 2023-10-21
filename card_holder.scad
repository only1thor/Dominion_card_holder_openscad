// Define the dimensions of the card
card_width = 59;
card_length = 91;


//(w,d,h)
//(x,y,z)

function sum_list(list, index = 0, total = 0) = 
    index < len(list) ? 
    sum_list(list, index + 1, total + list[index]) : 
    total;

function partial_list(list,start,end) = [for (i = [start:end]) list[i]];

module card_stack_body(card_thickness) {
    cube([card_width, card_thickness, card_length]);
}

module cards_spaced(list){
	number = len(list);
    for ( i = [0:number-1]){
		echo("Partial: ", partial_list(list,0,i-1));
		echo("Sum of partial: ",sum_list(partial_list(list,0,i-1)));
        if (i % 2 == 0) {
            translate([0, (sum_list(partial_list(list,0,i-1)))+2*i,0]){
                card_stack_body(list[i]);
            }
        } else {
            translate([5, (sum_list(partial_list(list,0,i-1)))+2*i,0]){
                card_stack_body(list[i]);
            }
        }
    }
}
cards_spaced([4,1,8,2,9,4,6,10,2,21]);