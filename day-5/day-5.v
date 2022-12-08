module main

import os

fn main() {
	mut solution_one := true
	if os.args.len != 2 {
		println('usage: ./day-5 part-1')
		println('usage: ./day-5 part-2')
	} else {
		solution_one = os.args[1] == 'part-1'
		parts := get_inputs().split('\n\n')
		lines := parts[1].split('\n')
		mut tanks := get_tanks(parts[0])
		for line in lines {
			lpart := line.split(' ')
			count, from, to := lpart[1].int(), lpart[3].int(), lpart[5].int()
			if solution_one {
				move_tanks_one(mut tanks, from, to, count)
			} else {
				move_tanks_two(mut tanks, from, to, count)
			}
		}
		for row in tanks {
			print('${row.last()}')
		}
		println('')
	}
}

fn move_tanks_two(mut tanks [][]string, from int, to int, count int) {
	stuff := tanks[from - 1][(tanks[from - 1].len - count)..]
	for i := 0; i < count; i++ {
		tanks[to - 1] << stuff[i]
		tanks[from - 1].pop()
	}
}

fn move_tanks_one(mut tanks [][]string, from int, to int, count int) {
	for i := 0; i < count; i++ {
		tanks[to - 1] << tanks[from - 1].pop()
	}
}

fn get_tanks(part string) [][]string {
	mut tanks := [][]string{}
	lines := part.split('\n')
	sizestr := lines.last().split(' ')
	size := sizestr[sizestr.len - 2].int()
	for i := 0; i < size; i++ {
		mut tanksl := []string{}
		tanks << tanksl
	}
	for a, line in lines {
		if a == lines.len - 1 {
			break
		}
		mut c := 0
		for i, _ in line.runes() {
			if i % 4 != 0 {
				continue
			}
			ch := line.runes()[i + 1].str()
			if ch != ' ' {
				tanks[c].insert(0, ch)
			}
			c++
		}
	}
	return tanks
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
