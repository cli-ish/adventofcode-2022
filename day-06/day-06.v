module main

import os

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-06 part-1')
		println('usage: ./day-06 part-2')
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
	for i := count; i < text.len; i++ {
		// Destinct string took from https://www.geeksforgeeks.org/efficiently-check-string-duplicates-without-using-additional-data-structure/
		mut abort := true
		mut m := u32(0)
		for e := i - count; e < i; e++ {
			val := u32(1 << text[e] - 0x61)
			if m & val > 0 {
				abort = false
				break
			}
			m |= val
		}
		if abort {
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
