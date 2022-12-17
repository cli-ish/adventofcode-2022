module main

import os

struct Point {
mut:
	x i32
	y i32
}

fn (p Point) + (p2 Point) Point {
	return Point{
		y: p.y + p2.y
		x: p.x + p2.x
	}
}

fn sign(n i32) i32 {
	if n < 0 {
		return -1
	} else if n > 0 {
		return 1
	}
	return 0
}

fn (p Point) step(p2 Point) Point {
	return Point{p.x + sign(p2.x - p.x), p.y + sign(p2.y - p.y)}
}

enum State as u8 {
	empty
	rock
	sand
}

enum Result as u8 {
	blocked
	abyss
	landed
	error
}

struct Simulation {
mut:
	space map[u64]State
}

fn (s Simulation) get(p Point) State {
	return s.space[u64(u64(p.x) << 32 | u64(p.y))]
}

fn (mut s Simulation) set(p Point, state State) {
	s.space[u64(u64(p.x) << 32 | u64(p.y))] = state
}

const (
	moves = [Point{0, 1}, Point{-1, 1}, Point{1, 1}]
)

fn (mut s Simulation) drop_sand(drop Point, abyss i32, floor i32) Result {
	mut pos := drop
	outer: for {
		for move in moves {
			new_pos := pos + move
			if (floor == 0 || new_pos.y < floor) && s.get(new_pos) == State.empty {
				if abyss != 0 && new_pos.y >= abyss {
					return Result.abyss
				}
				pos = new_pos
				continue outer
			}
		}

		if s.get(pos) != State.empty {
			return Result.blocked
		}

		s.set(pos, State.sand)
		return Result.landed
	}
	return Result.error
}

struct Input {
mut:
	paths [][]Point
	max_y i32
	drop  Point
}

fn (input Input) get_simulation() Simulation {
	mut result := Simulation{}
	for path in input.paths {
		mut pos := path[0]
		for segment in path[1..] {
			for pos != segment {
				result.set(pos, State.rock)
				pos = pos.step(segment)
			}
			result.set(pos, State.rock)
		}
	}
	return result
}

fn load_input() Input {
	mut result := Input{}
	lines := get_inputs().split('\n')
	for line in lines {
		segments := line.split(' -> ')
		mut paths := []Point{}
		for frag in segments {
			coords := frag.split(',')
			p := Point{
				x: coords[0].int()
				y: coords[1].int()
			}
			if p.y > result.max_y {
				result.max_y = p.y
			}
			paths << p
		}
		result.paths << paths
	}
	result.drop = Point{500, 0}
	return result
}

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-14 part-1')
		println('usage: ./day-14 part-2')
	} else {
		input := load_input()
		if os.args[1] == 'part-1' {
			println(solution_one(input))
		} else {
			println(solution_two(input))
		}
	}
}

fn solution_one(input Input) i32 {
	mut sim := input.get_simulation()
	mut result := 0
	for sim.drop_sand(input.drop, input.max_y + 1, 0) == Result.landed {
		result++
	}
	return result
}

fn solution_two(input Input) i32 {
	mut sim := input.get_simulation()
	mut result := 0
	for sim.drop_sand(input.drop, 0, input.max_y + 2) != Result.blocked {
		result++
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
