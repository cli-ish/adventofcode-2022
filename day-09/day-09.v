module main

import os
import math

enum Direction as u8 {
	right
	left
	up
	down
	wait
}

struct Point {
mut:
	x int
	y int
}

fn (mut p Point) move(direction Direction) {
	match direction {
		.right { p.x += 1 }
		.left { p.x -= 1 }
		.up { p.y += 1 }
		.down { p.y -= 1 }
		.wait {}
	}
}

fn (p Point) eq(p2 Point) bool {
	return p.x == p2.x && p.y == p2.y
}

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-09 part-1')
		println('usage: ./day-09 part-2')
	} else {
		if os.args[1] == 'part-1' {
			println(run_with_size(1))
		} else {
			println(run_with_size(9))
		}
	}
}

fn run_with_size(tail_length int) int {
	mut knots := []Point{len: tail_length}
	mut head := Point{
		x: 0
		y: 0
	}
	mut visited := map[string]bool{}
	visited['0,0'] = true
	lines := get_inputs().split('\n')
	for line in lines {
		parts := line.split(' ')
		direction := get_direction_from_string(parts[0])
		distance := parts[1].int()
		for dis := 0; dis < distance; dis++ {
			head.move(direction)
			for i, mut knot in knots {
				next := if i == 0 { head } else { knots[i - 1] }
				if !move_needed(knot, next) {
					continue
				}
				if knot.x != next.x && knot.y != next.y {
					knot.y += if next.y > knot.y { 1 } else { -1 }
					knot.x += if next.x > knot.x { 1 } else { -1 }
					tail := knots.last()
					if knot.eq(tail) {
						visited['${tail.x},${tail.y}'] = true
					}
				}
				for {
					if !move_needed(knot, next) {
						break
					}
					knot.move(get_direction(knot, next))
					tail := knots.last()
					if knot.eq(tail) {
						visited['${tail.x},${tail.y}'] = true
					}
				}
			}
		}
	}
	return visited.len
}

fn move_needed(p1 Point, p2 Point) bool {
	return math.abs(p1.x - p2.x) > 1 || math.abs(p1.y - p2.y) > 1
}

fn get_direction_from_string(dir string) Direction {
	return match dir {
		'R' { Direction.right }
		'L' { Direction.left }
		'U' { Direction.up }
		'D' { Direction.down }
		else { Direction.wait }
	}
}

fn get_direction(p Point, target Point) Direction {
	if p.x > target.x {
		return Direction.left
	} else if p.x < target.x {
		return Direction.right
	} else if p.y > target.y {
		return Direction.down
	} else if p.y < target.y {
		return Direction.up
	}
	return Direction.wait
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
