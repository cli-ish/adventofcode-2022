module main

import os

struct Operation {
mut:
	left       int
	isleftold  bool
	right      int
	isrightold bool
	op         rune
}

fn (o Operation) calc(worry_level int) int {
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
		`/` {
			return if o.isleftold { worry_level } else { o.left } / if o.isrightold {
				worry_level
			} else {
				o.right
			}
		}
		else {
			println('not implemented')
			return -99
		}
	}
}

fn (mut o Operation) init(input string) {
	for i in input {
		match i {
			`+`, `-`, `*`, `/` {
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
		o.left = -1
		o.isleftold = true
	} else {
		o.left = parts[0].int()
	}
	if parts[1] == 'old' {
		o.right = -1
		o.isrightold = true
	} else {
		o.right = parts[1].int()
	}
}

struct Item {
mut:
	worry_level int
}

struct Monkey {
mut:
	id            int
	items         []Item
	operation     Operation
	divisible     int
	pass_true     int
	pass_false    int
	inspect_count int
}

fn (mut m Monkey) round(mut monkeys []Monkey) {
	for mut item in m.items {
		m.inspect_count++
		item.worry_level = m.operation.calc(item.worry_level) / 3
		monkeys[m.pass_to_monkey(item)].items << item
	}
	m.items = []
}

fn (m Monkey) pass_to_monkey(item Item) int {
	return if item.worry_level % m.divisible == 0 { m.pass_true } else { m.pass_false }
}

fn (mut m Monkey) init(id int, input string) {
	m.id = id
	lines := input.split('\n')
	itemsraw := lines[1].replace(' ', '').split(':')[1].split(',').map(it.int())
	for ritem in itemsraw {
		m.items << Item{
			worry_level: ritem
		}
	}
	m.operation.init(lines[2].replace(' ', '').split(':')[1].split('=')[1])
	m.divisible = lines[3].split(' ').last().int()
	m.pass_true = lines[4].split(' ').last().int()
	m.pass_false = lines[5].split(' ').last().int()
}

fn main() {
	monkeys_raw := get_inputs().split('\n\n')
	mut monkeys := []Monkey{}
	for i, monkey_raw in monkeys_raw {
		mut m := Monkey{}
		m.init(i, monkey_raw)
		monkeys << m
	}
	for i := 0; i < 20; i++ {
		for mut monkey in monkeys {
			monkey.round(mut monkeys)
		}
	}
	mut active_list := []int{}
	for monkey in monkeys {
		active_list << monkey.inspect_count
		println('Monkey ${monkey.id} inspected items ${monkey.inspect_count} times.')
	}
	active_list.sort(a > b)
	println('${active_list[0] * active_list[1]}')
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
