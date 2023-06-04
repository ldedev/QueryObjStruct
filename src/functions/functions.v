module functions

import x.json2
import arrays
import contracts { IToken }

pub const builtin_functions = {
	'len': builtin_len
	'sum': builtin_sum
	'sequal': builtin_sequal
	'eequal': builtin_eequal
}


pub fn builtin_sequal(json json2.Any, token IToken) json2.Any {
	if token.arguments.len < 2 {
		return json2.encode({
			'error': "function 'sequal' requires 2 arguments"
		})
	}

	if json is []json2.Any {

		mut json_work := []json2.Any{}
		for it_json in json {
			if it_json is map[string]json2.Any {
				key := token.arguments.filter(it.typ == .key).first().name
				literal := token.arguments.filter(it.typ == .literal).first().name.to_lower()
				literal_json := it_json[key].str().to_lower()

				if literal_json.starts_with(literal) {
					json_work << it_json
				}
			}
		}

		return json_work
	} else {
		return json
	}
}

pub fn builtin_eequal(json json2.Any, token IToken) json2.Any {
	if token.arguments.len < 2 {
		return json2.encode({
			'error': "function 'eequal' requires 2 arguments"
		})
	}

	if json is []json2.Any {

		mut json_work := []json2.Any{}
		for it_json in json {
			if it_json is map[string]json2.Any {
				key := token.arguments.filter(it.typ == .key).first().name
				literal := token.arguments.filter(it.typ == .literal).first().name.to_lower()
				literal_json := it_json[key].str().to_lower()

				if literal_json.ends_with(literal) {
					json_work << it_json
				}
			}
		}

		return json_work
	} else {
		return json
	}
}


pub fn builtin_sum(json json2.Any, token IToken) json2.Any {
	if json !is []json2.Any { return json }

	json_work := json.arr()
	if json_work.len > 0 {
		numbers := json_work.map( it.as_map()[token.arguments[0].name].f32() )

		return arrays.sum(numbers) or { 0 }
	} else {
		return 0
	}
}

pub fn builtin_len(json_obj json2.Any, token IToken) json2.Any {

	dump(json_obj)
	dump(token)
	json := if token.arguments.len == 0 { json_obj } else { json_obj.as_map()[token.arguments[0].name] }

	if json is []json2.Any {
		return json.len
	} else if json is map[string]json2.Any {
		return json.len
	} else {
		return json.str().len_utf8()
	}
}
