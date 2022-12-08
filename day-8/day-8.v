module main

import os

fn main() {
	if os.args.len != 2 {
		println('usage: ./day-8 part-1')
		println('usage: ./day-8 part-2')
	} else {
		mut solution := os.args[1] == 'part-1'
		lines := get_inputs().split('\n')
		mut trees := [][]int{}
		for line in lines {
			mut tmp := []int{}
			for row in line {
				tmp << (row - 48)
			}
			trees << tmp
		}
		mut score := 0
		for y := 0; y < trees.len; y++ {
			for x := 0; x < trees.len; x++ {
				if solution {
					if is_visible(x, y, trees) {
						score++
					}
				} else {
					if x == 0 || y == 0 {
						continue
					}
					tmp := calc_score(x, y, trees)
					if tmp > score {
						score = tmp
					}
				}
			}
		}
		println('Result: ${score}')
	}
}

fn calc_score(x int, y int, trees [][]int) int {
	mut size_curr := trees[y][x]
	mut up := 0
	mut left := 0
	mut down := 0
	mut right := 0
	for i := y - 1; i >= 0; i-- {
		up++
		if trees[i][x] >= size_curr {
			break
		}
	}
	for i := x - 1; i >= 0; i-- {
		left++
		if trees[y][i] >= size_curr {
			break
		}
	}
	for i := y + 1; i < trees.len; i++ {
		down++
		if trees[i][x] >= size_curr {
			break
		}
	}
	for i := x + 1; i < trees.len; i++ {
		right++
		if trees[y][i] >= size_curr {
			break
		}
	}
	return up * down * right * left
}

fn is_visible(x int, y int, trees [][]int) bool {
	mut left := true
	mut top := true
	mut bottom := true
	mut right := true
	tree := trees[y][x]
	for i := 0; i < trees.len; i++ {
		if y > i && tree <= trees[i][x] {
			top = false
		}
		if y < i && tree <= trees[i][x] {
			bottom = false
		}
		if x > i && tree <= trees[y][i] {
			left = false
		}
		if x < i && tree <= trees[y][i] {
			right = false
		}
	}
	return left || top || bottom || right
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
