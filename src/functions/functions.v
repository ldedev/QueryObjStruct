module functions

import x.json2
import arrays
import contracts { IToken }

pub const builtin_functions = {
	'len': builtin_len
	'sum': builtin_sum
}

pub fn builtin_sum(json json2.Any, token IToken) json2.Any {
	json_work := json.arr()
	if json_work.len > 0 {
		numbers := json_work.map( it.as_map()[token.value].f32() )

		return json2.Any(arrays.sum(numbers) or { 0 })
	} else {
		return 0


	}
}

pub fn builtin_len(jso_obj json2.Any, token IToken) json2.Any {
	json := jso_obj.as_map()[token.value]

	if json is []json2.Any {
		return json.len
	} else if json is map[string]json2.Any {
		return json.len
	} else if json is string {
		return json.len_utf8()
	} else {
		return 0
	}
}
