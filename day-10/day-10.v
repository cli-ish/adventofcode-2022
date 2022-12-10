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
	mut x, mut c := 1, ''
	for line in lines {
		cycle, sum, c = run_cycle(cycle, sum, x)
		print(c)
		parts := line.split(' ')
		cmd := get_command_from_string(parts[0])
		if cmd == Command.noop {
			continue
		}
		cycle, sum, c = run_cycle(cycle, sum, x)
		print(c)
		x += parts[1].int()
	}
	println(sum)
}

fn run_cycle(cycle int, sum int, x int) (int, int, string) {
	c := cycle + 1
	return c, if (c - 20) % 40 == 0 {
		sum + c * x
	} else {
		sum
	}, if math.abs(x - (cycle % 40)) <= 1 {
		'#'
	} else {
		' '
	} + if c % 40 == 0 {
		'\n'
	} else {
		''
	}
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
