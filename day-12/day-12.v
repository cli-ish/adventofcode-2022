module main

import os

struct Point {
mut:
	y i16
	x i16
}

fn (p Point) plus(p2 Point) Point {
	return Point{
		y: p.y + p2.y
		x: p.x + p2.x
	}
}

fn (p Point) eq(p2 Point) bool {
	return p.x == p2.x && p.y == p2.y
}

fn (p Point) fit(size_y int, size_x int) bool {
	return p.y < 0 || p.x < 0 || p.y >= size_y || p.x >= size_x
}

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-12 part-1')
		println('usage: ./day-12 part-2')
	} else {
		world, start, end := read_world()
		if os.args[1] == 'part-1' {
			println(solution_one(world, start, end))
		} else {
			println(solution_two(world, start, end))
		}
	}
}

fn read_world() ([][]u8, Point, Point) {
	lines := get_inputs().split('\n')
	mut start := Point{
		y: 0
		x: 0
	}
	mut end := Point{
		y: 0
		x: 0
	}
	mut world := [][]u8{len: lines.len}
	for y, line in lines {
		for x, r in line {
			match r {
				`S` {
					start.y, start.x = i16(y), i16(x)
					world[y] << 0
				}
				`E` {
					end.y, end.x = i16(y), i16(x)
					world[y] << 25
				}
				else {
					world[y] << r - 0x61
				}
			}
		}
	}
	return world, start, end
}

fn solution_one(world [][]u8, start Point, end Point) i16 {
	return search_world(world, start, end)
}

fn solution_two(world [][]u8, start Point, end Point) i16 {
	mut min := i16(32767)
	for y, yline in world {
		for x, v in yline {
			if v != 0 {
				continue
			}
			tmp := search_world(world, Point{ y: i16(y), x: i16(x) }, end)
			if tmp < min {
				min = tmp
			}
		}
	}
	return min
}

fn search_world(world [][]u8, start Point, end Point) i16 {
	mut p, mut n := start, Point{}
	mut visit := [][]i16{len: world.len, init: []i16{len: world[0].len, init: -1}}
	visit[p.y][p.x] = 0
	mut queue := [p]
	directions := [Point{
		y: 0
		x: 1
	}, Point{
		y: 0
		x: -1
	}, Point{
		y: 1
		x: 0
	}, Point{
		y: -1
		x: 0
	}]
	for queue.len > 0 {
		p, queue = queue[0], queue[1..]
		for move in directions {
			n = p.plus(move)
			if n.fit(world.len, world[0].len) || visit[n.y][n.x] != -1
				|| world[n.y][n.x] - world[p.y][p.x] > 1 {
				continue
			}
			visit[n.y][n.x] = visit[p.y][p.x] + 1
			if n.eq(end) {
				return visit[n.y][n.x]
			}
			queue << n
		}
	}
	return 32767
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
