module main

import os

struct Point {
mut:
	x int
	y int
}

struct VisitState {
mut:
	initalized bool
	head       int
	tail       int
	start      bool
}

fn main() {
	mut world := map[string]VisitState{}
	lines := get_inputs().split('\n')
	mut head := Point{x:0, y:0}
	mut tail := Point{x:0, y:0}
	world['0,0'] = VisitState{true, 0, 0, true}
	mut lasthead := head
	for line in lines {
		parts := line.split(' ')
		direction := parts[0]
		length := parts[1].int()
		if direction == 'R' {
			for i := 0; i < length; i++ {
				lasthead = head
				head.x++
				move(mut tail, lasthead, mut head, mut world)
			}
		} else if direction == 'U' {
			for i := 0; i < length; i++ {
				lasthead = head
				head.y--
				move(mut tail, lasthead, mut head, mut world)
			}
		} else if direction == 'L' {
			for i := 0; i < length; i++ {
				lasthead = head
				head.x--
				move(mut tail, lasthead, mut head, mut world)
			}
		} else {
			for i := 0; i < length; i++ {
				lasthead = head
				head.y++
				move(mut tail, lasthead, mut head, mut world)
			}
		}
	}
	mut c := 1 // because start is visited too
	for p, value in world {
		if value.tail != 0 {
			c+=1
			println(p)
		}
		
	}
	println(c)
}


fn move(mut tail Point, lasthead Point, mut head Point, mut world map[string]VisitState) {
	increase_head(head, mut world)
	oldtail := tail
	tail = solve_coverage(head,lasthead,tail)
	if tail != oldtail {
		increase_tail(tail, mut world)
	}
}


fn solve_coverage(head Point, lasthead Point, tail Point) Point {
	if head.x == tail.x && head.y == tail.y {
		return tail
	}
	if !nearpoint(head, tail) {
		return lasthead
	}
	return tail
}

fn nearpoint(p1 Point, p2 Point) bool {
	if p1.x != p2.x - 1 && p1.x != p2.x && p1.x != p2.x +1 {
		return false
	}
	if p1.y != p2.y - 1 && p1.y != p2.y && p1.y != p2.y +1 {
		return false
	}
	return true
}

fn increase_head(point Point, mut world map[string]VisitState) {
	mut key := '${point.y},${point.x}'
	mut p := world[key]
	if !p.initalized {
		p.initalized = true
	}
	p.head += 1
	world[key] = p
}
fn increase_tail(point Point, mut world map[string]VisitState) {
	mut key := '${point.y},${point.x}'
	mut p := world[key]
	if !p.initalized {
		p.initalized = true
	}
	p.tail += 1
	world[key] = p
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
