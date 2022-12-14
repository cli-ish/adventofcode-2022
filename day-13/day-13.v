module main

import os

struct Item {
mut:
	has_value  bool
	value      int
	list       []Item
}

fn parse(line string, start_pos int) (Item, int) {
	mut pos := start_pos
	if line[pos] == `[` {
		mut result, mut tmp := Item{}, Item{}
		pos++
		for line[pos] != `]` {
			tmp, pos = parse(line, pos)
			result.list << tmp
			if line[pos] == `,` {
				pos++
			}
		}
		return result, pos + 1
	}
	for line[pos] >= `0` && line[pos] <= `9` {
		pos++
	}
	return Item{
		has_value: true
		value: line[start_pos..pos].int()
	}, pos
}

fn sign(v int) int {
	if v < 0 {
		return -1
	} else if v > 0 {
		return 1
	}
	return 0
}

fn compare(left Item, right Item) int {
	if left.has_value {
		if right.has_value {
			return sign(left.value - right.value)
		}
		return compare(Item{ list: [left] }, right)
	}
	if right.has_value {
		return compare(left, Item{ list: [right] })
	}
	for i := 0; i < left.list.len && i < right.list.len; i++ {
		v := compare(left.list[i], right.list[i])
		if v != 0 {
			return v
		}
	}
	return sign(left.list.len - right.list.len)
}

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-13 part-1')
		println('usage: ./day-13 part-2')
	} else {
		mut items := []Item{}
		lines := get_inputs().split('\n')
		for line in lines {
			if line.len == 0 {
				continue
			}
			item, _ := parse(line, 0)
			items << item
		}
		if os.args[1] == 'part-1' {
			println(solution_one(items))
			return
		} else {
			println(solution_two(items))
			return
		}
	}
}

fn solution_one(items []Item) int {
	mut sum := 0
	for i := 0; i < items.len; i += 2 {
		if compare(items[i], items[i + 1]) < 0 {
			sum += i / 2 + 1
		}
	}
	return sum
}

fn solution_two(items []Item) int {
	mut divs, mut index_list := []Item{}, []int{}
	for i, v in [2, 6] {
		divs << Item{
			list: [
				Item{
					list: [Item{
						has_value: true
						value: v
					}]
				},
			]
		}
		index_list << i
	}
	for item in items {
		for i, div in divs {
			if compare(item, div) < 0 {
				index_list[i]++
			}
		}
	}
	mut product := 1
	for i in index_list {
		product *= i + 1
	}
	return product
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
