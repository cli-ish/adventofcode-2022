module main

import os

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-3 part-1')
		println('usage: ./day-3 part-2')
	} else {
		lines := get_inputs().split('\n')
		mut sum := 0
		if os.args[1] == 'part-1' {
			sum = solution_one(lines)
		} else {
			sum = solution_two(lines)
		}
		println(sum)
	}
}

fn solution_one(lines []string) int {
	mut sum := 0
	for line in lines {
		if line.len == 0 {
			continue
		}
		half := (line.len / 2)
		first := line[..half]
		last := line[half..]
		for c1 in first {
			ch := c1.ascii_str()
			if last.contains(ch) {
				sum += calc_score(ch[0])
				break
			}
		}
	}
	return sum
}

fn solution_two(lines []string) int {
	mut sum := 0
	for i := 0; i < lines.len; i += 3 {
		line1, line2, line3 := lines[i], lines[i + 1], lines[i + 2]
		for c1 in line1 {
			ch := c1.ascii_str()
			if line2.contains(ch) && line3.contains(ch) {
				sum += calc_score(ch[0])
				break
			}
		}
	}
	return sum
}

fn calc_score(c u8) int {
	if c > 90 {
		return c - 97 + 1
	} else {
		return c - 65 + 1 + 26
	}
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
