module main

import os

struct File {
	name string
	size int
}

struct Dir {
	parent &Dir
	name   string
mut:
	subdirs []&Dir
	files   []File
	size    int
}

struct Cmd {
	command string
	result  []string
}

fn main() {
	mut list := []Cmd{}
	mut lastcmd := ''
	mut result := []string{}
	lines := get_inputs().split('\n')
	for i, line in lines {
		if i == 0 { // ignore first `cd /` we know its there
			continue
		}
		if line[0].ascii_str() == '$' {
			if lastcmd != '' {
				list << Cmd{
					command: lastcmd
					result: result
				}
			}
			lastcmd = line[2..]
			result = []
		} else {
			result.prepend(line)
		}
	}
	list << Cmd{
		command: lastcmd
		result: result
	}

	mut dir := &Dir{0, '/', []&Dir{}, []File{}, 0}
	for c in list {
		parts := c.command.split(' ')
		if parts[0] == 'cd' && parts[1] == '..' {
			dir = dir.parent
		} else if parts[0] == 'cd' {
			mut found := false
			for e, d in dir.subdirs {
				if d.name == parts[1] {
					dir = dir.subdirs[e]
					found = true
					break
				}
			}
			if !found {
				mut de := &Dir{dir, parts[1], []&Dir{}, []File{}, 0}
				dir.subdirs << de
				dir = de
			}
		} else {
			// Must be ls
			for r in c.result {
				rparts := r.split(' ')
				if rparts[0] == 'dir' {
					de := &Dir{dir, rparts[1], []&Dir{}, []File{}, 0}
					dir.subdirs << de
				} else {
					s := rparts[0].int()
					dir.files << File{rparts[1], s}
					dir.size += s
					unsafe {
						// We added the size allready, no need to traver to nowhere :)
						if dir.parent == nil {
							continue
						}
					}
					mut tmp := dir
					for true {
						unsafe {
							if tmp.parent == nil {
								break
							}
						}
						tmp = tmp.parent
						tmp.size += s
					}
				}
			}
		}
	}

	for true {
		unsafe {
			if dir.parent == nil {
				break
			}
		}
		dir = dir.parent
	}
	println('sum of small directories => ' + count_tree(100000, dir).str())
	freeup := 30000000 - (70000000 - dir.size)
	println('We need: ${freeup}')
	println('smallest to delete: ' + find_smallest(freeup, dir, dir.size).str())
	println('')
}

fn count_tree(limit int, dir &Dir) int {
	mut c := 0
	for child in dir.subdirs {
		if child.size < limit {
			c += child.size
		}
		if child.subdirs.len != 0 {
			c += count_tree(limit, child)
		}
	}
	return c
}

fn find_smallest(min int, dir &Dir, smallest int) int {
	mut c := smallest
	for child in dir.subdirs {
		if child.size > min && c > child.size {
			c = child.size
		}
		if child.subdirs.len != 0 {
			c = find_smallest(min, child, c)
		}
	}
	return c
}

fn get_inputs() string {
	text := os.read_file('input.txt') or {
		eprintln('failed to read the file: ${err}')
		return ''
	}
	return text
}
