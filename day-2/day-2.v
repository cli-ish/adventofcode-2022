module main

import os

fn main() {
	mut solution := false
	if os.args.len != 2 {
		println('usage: ./day-2 part-1')
		println('usage: ./day-2 part-2')
	} else {
		solution = os.args[1] == 'part-1'
	}
	lines := get_inputs().split('\n')
	mut score := 0
	for line in lines {
		enemy := line[0]
		suggested := line[2]
		if solution {
			score += calc_score_one(enemy, suggested)
		} else {
			score += calc_score_two(enemy, suggested)
		}
	}
	println('score: ${score}')
}

/**
 * used for part 1
 * returns int (-1 lost,0 draw, 1 won)
*/
fn calc_score_one(enemy u8, move u8) int {
	movep := move - 88 + 1
	enemyp := enemy - 65 + 1
	if movep == enemyp {
		return 3 + movep
	}
	if (enemyp == 1 && movep != 2) || (enemyp == 2 && movep != 3) || (enemyp == 3 && movep != 1) {
		return 0 + movep
	}
	return 6 + movep
}

/**
 * used for part 2
 * returns int (-1 lost,0 draw, 1 won)
*/
fn calc_score_two(enemy u8, move u8) int {
	movep := move - 88 + 1
	enemyp := enemy - 65 + 1
	if movep == 2 {
		return 3 + enemyp
	}
	mut movec := 0
	if movep == 3 {
		movec = 2 // by default we assume we get rock so we play paper an get 2 points
		if enemyp == 2 {
			movec = 3 // we play sissor or we lose
		}
		if enemyp == 3 {
			movec = 1 // we play rock
		}
		return 6 + movec
	}
	movec = 3 // by default we assume we get rock so we play sissor an get 3 points
	if enemyp == 2 {
		movec = 1 // we play rock
	}
	if enemyp == 3 {
		movec = 2 // we play paper
	}
	return 0 + movec
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
