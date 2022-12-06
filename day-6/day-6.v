module main

import os

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-6 part-1')
		println('usage: ./day-6 part-2')
	} else {
		text := get_inputs()
		mut count := 14
		if os.args[1] == 'part-1' {
			count = 4
		}
		res := solution_fn(text, count)
		println('Result: ${res}')
	}
}

fn solution_fn(text string, count int) int {
	for i := count; i < text.len; i++ {
		res := text[(i - count)..i]
		mut matchx := false
		outer: for i1, x in res {
			for i2 := i1 + 1; i2 < res.len; i2++ {
				if res[i2] == x {
					matchx = true
					break outer
				}
			}
		}
		if !matchx {
			return i
		}
	}
	return -1
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
