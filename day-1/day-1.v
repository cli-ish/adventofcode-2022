module main

import os
import arrays
import math

fn main() {
	lines := get_inputs().split('\n')
	mut calories_carried := [0]
	for i, line in lines {
		if line.len == 0 {
			if i != lines.len - 1 {
				calories_carried = arrays.concat[int](calories_carried, 0)
			}
			continue
		}
		calories_carried[calories_carried.len - 1] += line.int()
	}
	calories_carried.sort()
	calories_carried = calories_carried[calories_carried.len - 3..]
	total := arrays.sum[int](calories_carried)!
	for i := calories_carried.len -1; i >= 0; i-- {
		println('${math.abs(i - calories_carried.len)}: ${calories_carried[i]} calories')
	}
	println('total: ${total} calories')
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
