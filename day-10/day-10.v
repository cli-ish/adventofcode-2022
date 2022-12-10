module main

import os
import math

enum Command as u8 {
	addx
	noop
}

fn main() {
	lines := get_inputs().split('\n')
	mut cycle, mut sum := 0, 0
	mut x := 1
	mut ui := [][]rune{len: 6, init: []rune{len: 40, init: ` `}}
	for line in lines {
		cycle, sum = run_cycle(cycle, sum, x, mut ui)
		parts := line.split(' ')
		cmd := get_command_from_string(parts[0])
		if cmd == Command.noop {
			continue
		}
		cycle, sum = run_cycle(cycle, sum, x, mut ui)
		x += parts[1].int()
	}
	for row in ui {
		println(row.string())
	}
	println(sum)
}

fn run_cycle(cycle int, sum int, x int, mut ui [][]rune) (int, int) {
	ui[cycle / 40][cycle%40] = if math.abs(x-(cycle%40))<=1 {`#`} else {` `}
	c := cycle +1 
	if (c - 20) % 40 == 0 {
		return c, sum + c * x
	}
	return c, sum 
}

fn get_command_from_string(dir string) Command {
	return match dir {
		'addx' { Command.addx }
		'noop' { Command.noop }
		else { Command.noop } // maybe dumb.
	}
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}