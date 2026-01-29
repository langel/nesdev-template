
let tohex = (x) => Math.floor(x).toString(16).padStart(2, '0'); 

let tohex_signed = (x) => {
	if (x < 0) x += 256;
	return Math.floor(x).toString(16).padStart(2, '0');
}

let atan_table = 'atan_table:';
let log2_table = 'log2_table:';


for (let i = 0; i < 256; i++) {
	if (i % 16 == 0) {
		atan_table += "\n\thex ";
		log2_table += "\n\thex ";
	}
	atan_table += tohex((Math.atan(2**(i/32))*128/Math.PI)-0x20);
	log2_table += tohex(Math.log2(i)*32);
}

console.log(atan_table);
console.log(log2_table);


let velocity_lo = 'arctan_velocity_lo:';
let velocity_hi = 'arctan_velocity_hi:';
let speed = 1.875;
;speed = 0.999;

for (let i = 0; i < 64; i++) {
	if (i % 16 == 0) {
		velocity_lo += "\n\thex ";
		velocity_hi += "\n\thex ";
	}
	let dist = speed * Math.cos(i * 5.625 * Math.PI / 180);
	//if (dist < 0.0001) dist = 0;
	//dist = dist.toFixed(8);
	let byte_hi = Math.floor(dist);
	let byte_lo = Math.floor((dist - byte_hi) * 256);
	velocity_lo += tohex(byte_lo);
	velocity_hi += tohex_signed(byte_hi);
}

console.log(velocity_lo);
console.log(velocity_hi);
