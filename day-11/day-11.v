module main

import os
import math

struct Operation {
mut:
	left       i64
	isleftold  bool
	right      i64
	isrightold bool
	op         rune
}

fn (mut o Operation) init(input string) {
	for i in input {
		match i {
			`+`, `-`, `*` {
				o.op = i
				break
			}
			else {
				continue
			}
		}
	}
	parts := input.split(o.op.str())
	if parts[0] == 'old' {
		o.left = 0
		o.isleftold = true
	} else {
		o.left = parts[0].i64()
	}
	if parts[1] == 'old' {
		o.right = 0
		o.isrightold = true
	} else {
		o.right = parts[1].i64()
	}
}

fn (o Operation) calc(worry_level i64) i64 {
	match o.op {
		`+` {
			return if o.isleftold { worry_level } else { o.left } + if o.isrightold {
				worry_level
			} else {
				o.right
			}
		}
		`-` {
			return if o.isleftold { worry_level } else { o.left } - if o.isrightold {
				worry_level
			} else {
				o.right
			}
		}
		`*` {
			return if o.isleftold { worry_level } else { o.left } * if o.isrightold {
				worry_level
			} else {
				o.right
			}
		}
		else {
			println('not implemented')
			return 0
		}
	}
}

struct Monkey {
	id int
mut:
	items         []i64
	operation     Operation
	divisible     i64
	pass_true     int
	pass_false    int
	inspect_count i64
}

fn (mut m Monkey) init(input string) {
	lines := input.split('\n')
	m.items = lines[1].replace(' ', '').split(':')[1].split(',').map(it.i64())
	m.operation.init(lines[2].replace(' ', '').split('=')[1])
	m.divisible = lines[3].split(' ').last().i64()
	m.pass_true = lines[4].split(' ').last().int()
	m.pass_false = lines[5].split(' ').last().int()
}

fn (mut m Monkey) round(mut monkeys []Monkey, lcm i64, impl bool) {
	m.inspect_count += m.items.len
	for mut item in m.items {
		if impl {
			item = m.operation.calc(item) / 3
		} else {
			item = m.operation.calc(*item % lcm)
		}
		monkeys[m.pass_to_monkey(item)].items << item
	}
	m.items = []
}

fn (m Monkey) pass_to_monkey(item i64) int {
	return if item % m.divisible == 0 { m.pass_true } else { m.pass_false }
}

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-11 part-1')
		println('usage: ./day-11 part-2')
	} else {
		solution(os.args[1] == 'part-1')
	}
}

fn solution(solution_one bool) {
	monkeys_raw := get_inputs().split('\n\n')
	mut monkeys := []Monkey{}
	mut gcd_l := []i64{}
	for i, monkey_raw in monkeys_raw {
		mut m := Monkey{
			id: i
		}
		m.init(monkey_raw)
		monkeys << m
		gcd_l << m.divisible
	}
	mut lcm := i64(0)
	mut count := 20
	if !solution_one {
		count = 10000
		lcm = lcm_many(gcd_l)
	}
	for i := 0; i < count; i++ {
		for mut monkey in monkeys {
			monkey.round(mut monkeys, lcm, solution_one)
		}
	}
	mut active_list := []i64{}
	for monkey in monkeys {
		active_list << monkey.inspect_count
		println('Monkey ${monkey.id} inspected items ${monkey.inspect_count} times.')
	}
	active_list.sort(a > b)
	println(active_list[0] * active_list[1])
}

fn lcm_many(entries []i64) i64 {
	mut result := entries[0]
	for i := 1; i < entries.len; i++ {
		result = math.lcm(entries[i], result)
	}
	return result
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
