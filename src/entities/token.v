module entities

import x.json2
import contracts { IToken, TypeToken }
import functions

pub struct Token {
pub mut:
	value string
	typ   TypeToken = .undefined
}

pub fn (tokens []Token) generate_code(json json2.Any) string {
	mut json_work := json
	mut current_path := ''
	add_path := fn [mut current_path] (name_path string) {
		current_path += if current_path.starts_with('.') {
			'${name_path}'
		} else {
			'.${name_path}'
		}
	}
	get_path := fn [mut current_path] () string {
		return current_path.replace_once('.', '')
	}

	if json.as_map().len == 0 {
		return '{}'
	} else {
		mut i := 0
		for {
			i++
			if i >= tokens.len {
				break
			}
			token := tokens[i]

			if token.typ == .object_root {
				continue
			} else if token.typ == .key {
				if token.value in json_work.as_map() {
					add_path(token.value)
					json_work = json_work.as_map()[token.value] or { return 'err: {}' }
				} else {
					return json2.encode({
						'path':  get_path()
						'error': "key '${token.value}' not found"
					})
				}
			} else if token.typ == .array_index {
				arr := json_work.arr()
				if arr.len > token.value.int() {
					add_path(token.value)
					json_work = arr[token.value.int()]
				} else {
					return json2.encode({
						'path':  get_path()
						'error': "index '${token.value}' not found"
					})
				}
			} else if token.typ == .array_all_index {
				arr := json_work.arr()

				if tokens.len >= i + 2 {
					if next_token := tokens[i + 2..tokens.len][0] {
						if next_token.typ == .function {
							json_work = arr
							continue
						}

						i += 2
						add_path(next_token.value)

						mut temp := []json2.Any{}

						for index in arr {
							if item := index.as_map()[next_token.value] {
								temp << item
							}
						}

						json_work = temp
					} else {
						json_work = arr
					}
				}
			} else if token.typ == .function {
				if token.value in functions.builtin_functions {
					add_path(token.value)
					if tokens.len >= i + 2 {
						if next_token := tokens[i + 2..tokens.len][0] {
							i += 2
							func := functions.builtin_functions[token.value]
							json_work = func(json_work, &next_token)
						}
					}
				} else {
					return json2.encode({
						'path':  get_path()
						'error': "function '${token.value}' not found"
					})
				}
			}
		}

		// println('Depois: ')
		// dump(json_work)
	}

	return json_work.str()
}
