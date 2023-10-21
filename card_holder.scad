// Define the dimensions of the card
card_width = 59;
card_length = 91;
card_thickness = 1;

// Define the dimensions of the card's face
face_width = 51;
face_length = 83;
face_thickness = (card_thickness/4);

letter_size = 10;

module card_body() {
    cube([card_width, card_length, card_thickness]);
}

module card_face() {
    translate([(card_width - face_width) / 2, (card_length - face_length) / 2, (face_thickness*3.01)])
        cube([face_width, face_length, face_thickness]);
}

module card_text(in_text){
	translate([card_width/2, card_length/2, card_thickness])
	linear_extrude(height = 1)
	rotate(45)
	text(in_text, font = "Arial:style=Bold", size = letter_size, halign = "center", valign = "center");
}

difference() {
    card_body();
    card_face();
}

card_text("Dominion");