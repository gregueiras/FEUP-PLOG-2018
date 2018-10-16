//Based on https://editor.p5js.org/Rito/sketches/BJ5D_KeTg

var hex_size = 30;
var map_radius = 4; // FIXME: This should be called map size, but I started with hexagons, and refactoring would be too hard
var origin;
var padding = 0;
var grid_type = "HEXAGON" // Change this value for different grid types (HEXAGON, TRIANGLE, PARRALELOGRAM, RECTANGLE)
var intersections = [];
var grid = [];
var pieces = [];

function setup() {
	createCanvas(650, 650);
	angleMode(RADIANS);
	origin = createVector(width / 2, height / 2);
	let count = 0;
	for (var q = -map_radius; q <= map_radius; q++) {
		var r1 = max(-map_radius, -q - map_radius);
		var r2 = min(map_radius, -q + map_radius);
		for (var r = r1; r <= r2; r++) {
			var x = (sqrt(3) * q + sqrt(3) / 2 * r) * (hex_size);
			var y = (0 * q + 3 / 2 * r) * hex_size;

			let R = r + 4;
			grid[count++] = {
				xC: x + origin.x,
				yC: y + origin.y,
				pX: (q + R) * 2,
				pY: r + 4
			};
		}
	}

	let resetB = createButton('Reset');
	resetB.position(10, height + 10);
	resetB.mousePressed(reset);

	let undoB = createButton('Undo');
	undoB.position(80, height + 10);
	undoB.mousePressed(undo);

	let outputB = createButton('Output');
	outputB.position(160, height + 10);
	outputB.mousePressed(output);
}

function reset() {
	pieces = [];
}

function undo() {
	pieces.splice(pieces.length - 1, 1);
}

function output() {
  let orderedG = JSON.parse(JSON.stringify(grid))
	orderedG.sort((a, b) => {
		if (a.pY < b.pY)
			return -1;
		else if (a.pY > b.pY)
			return 1;
		
		if (a.pX < b.pX)
			return -1;
		else if (a.pX > b.pX)
			return 1;
	})
	console.dir(orderedG);

	let string = "";
	orderedG.forEach(e => {
		let piece = null;
		switch (e.piece) {
			case "black":
				piece = "blackPiece";
				break;
			case "white":
				piece = "whitePiece";
				break;
			default:
			piece = "emptyCell";
				break;
		}
		string += `cell(${e.pX}, ${e.pY}, ${piece}),\n`
	});
	console.log(string);
}

function draw() {
	background(45);
	stroke(255);
	strokeWeight(1);
	let count = 0;

	//translate(300, 300);
	if (grid_type == "HEXAGON") {
		for (var q = -map_radius; q <= map_radius; q++) {
			var r1 = max(-map_radius, -q - map_radius);
			var r2 = min(map_radius, -q + map_radius);
			for (var r = r1; r <= r2; r++) {
				let center = hex_to_pixel(q, r);
				draw_hexagon(center, hex_size, q, r, false);
				textSize(15);
				textAlign(CENTER, CENTER);
				text(count, center.x + 1, center.y - 5);
				let c = grid[count++];
				text(`${c.pX} ${c.pY}`, center.x + 1, center.y + 12);
				//text(`${q} ${r}`, center.x + 1, center.y + 12);
			}
		}
	}
	strokeWeight(8);
	stroke(255, 180);
	for (var i = 0; i < intersections.length; i++) {
		point(intersections[i].x, intersections[i].y);
	}
	intersections = [];

	pieces.forEach(p => {
		strokeWeight(0.2);
		stroke(0);
		fill(p.color);
		ellipse(p.x, p.y, p.size, p.size);

	});
}

function pixel_to_hex(x, y) {
	q = (x * sqrt(3) / 3 - y / 3) / hex_size;
	r = (-x / 3 + sqrt(3) / 3 * y) / hex_size;
	return createVector(round(q), round(r));
}

function hex_to_pixel(q, r) {
	// This is basically a matrix multiplication between a hexagon orientation matrix 
	// and the vector {q; r}
	var x = (sqrt(3) * q + sqrt(3) / 2 * r) * (hex_size);
	var y = (0 * q + 3 / 2 * r) * hex_size;
	return createVector(x + origin.x, y + origin.y);
}


function draw_hexagon(center, size, q, r, drawCities = true) {
	points = [];
	for (var i = 0; i < 6; i++) {
		points.push(hex_corner(center, size - padding, i));
		var c = hex_corner(center, size, i);
		if (intersections_includes(c) == false && drawCities)
			intersections.push(c);

	}

	beginShape();
	for (i = 1; i <= 6; i++) {
		fill("#1cff60");
		point(points[i % 6].x, points[i % 6].y);
		vertex(points[i % 6].x, points[i % 6].y);
		line(points[i - 1].x, points[i - 1].y, points[i % 6].x, points[i % 6].y);
	}
	endShape();
	fill(255);

	/*
	textSize(10);
	textAlign(CENTER, CENTER);
	text(q + " " + r + " \n" + (-q-r), center.x + 1, center.y + 2)
	*/
}

function intersections_includes(c) {
	for (var i = 0; i < intersections.length; i++) {
		// I have to use approx because the padding rsults in the 
		// intersections not having the EXACT same location (and other things don't line up)
		if (approx(intersections[i].x, c.x) && approx(intersections[i].y, c.y)) {
			return true;
		}
	}
	return false;
}

epsilon = padding + 1;

function approx(a, b) {
	if (abs(a - b) < epsilon)
		return true;
	return false;
}

function hex_corner(center, size, i) {
	var angle_deg = 60 * i + 30
	var angle_rad = PI / 180 * angle_deg;
	return createVector(center.x + size * cos(angle_rad),
		center.y + size * sin(angle_rad));
}

function mousePressed() {
	grid.forEach(element => {
		if (dist(mouseX, mouseY, element.xC, element.yC) < (hex_size - padding - 3)) {

			let oldP = null;
			for (let p of pieces) {
				if (p.x === element.xC && p.y === element.yC) {
					oldP = p;
					break;
				}
			};

			let c = null;
			if (mouseButton === LEFT) {
				element.piece = "black";
				c = color(197, 0, 252);
			} else if (mouseButton === RIGHT) {
				element.piece = "white";
				c = color(255, 119, 0);
			} else if (mouseButton === CENTER) {
				element.piece = null;
				c = color("#1cff60");
			}

			if (!oldP) {
				let piece = {
					x: element.xC,
					y: element.yC,
					size: hex_size,
					color: c
				};        
        console.log(element.pX, element.pY);
				pieces.push(piece);
			} else {
				oldP.color = c;
			}

		}
	});
}

