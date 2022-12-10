module main

import os

fn main() {
	lines := get_inputs().split('\n')
	mut contained, mut overlaped := 0, 0
	for line in lines {
		half := line.split(',')
		one, two := half[0].split('-'), half[1].split('-')
		n11, n12 := one[0].int(), one[1].int()
		n21, n22 := two[0].int(), two[1].int()
		if (n11 <= n21 && n12 >= n22) || (n11 >= n21 && n12 <= n22) {
			contained += 1
		}
		if ((n11 >= n21 && n11 <= n22) || (n12 >= n21 && n12 <= n22))
			|| ((n21 >= n11 && n21 <= n12) || (n22 >= n11 && n22 <= n12)) {
			overlaped += 1
		}
	}
	println('contain: ${contained}, overlap: ${overlaped}')
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
