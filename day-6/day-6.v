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
		res := solution(text, count)
		println('Result: ${res}')
	}
}

fn solution(text string, count int) int {
	mut res := ''
	for i := 0; i < text.len; i++ {
		if i > count {
			mut matchx := false
			outer: for i1, x in res.runes() {
				for i2, y in res.runes() {
					if y == x && i1 != i2 {
						matchx = true
						break outer
					}
				}
			}
			if !matchx {
				return i
			}
		}
		if res.len > count - 1 {
			res = res[1..]
		}
		res += text[i].ascii_str()
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
