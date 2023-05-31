module main

import x.json2
import vweb
import regex

struct App {
	vweb.Context
}

struct Query {
pub:
	query string
	code  string
}

fn main() {
	mut app := &App{}

	app.mount_static_folder_at('${@VMODROOT}/src/templates/', '/')
	app.mount_static_folder_at('${@VMODROOT}/src/templates/ace-builds', '/ace-builds')
	app.mount_static_folder_at('${@VMODROOT}/src/templates/pico', '/pico')
	app.mount_static_folder_at('${@VMODROOT}/src/templates/css_custom', '/css_custom')
	vweb.run[App](app, 8093)
}

fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

fn (mut app App) clicked() vweb.Result {
	return app.text('clicked')
}

enum TypeToken {
	undefined
	key
	object
	object_root
	array_index
	function
}

struct Token {
pub mut:
	value string
	typ   TypeToken = .undefined
}

fn classify_token(value_token string) Token {
	mut token := Token{
		value: value_token
	}
	token.typ = if token.value == '$' {
		TypeToken.object_root
	} else if token.value == '.' {
		TypeToken.object
	} else if token.value.starts_with('[') && token.value.ends_with(']') {
		token.value = token.value.find_between('[', ']').replace(' ', '')
		TypeToken.array_index
	} else if token.value == '{' {
		TypeToken.function
	} else {
		TypeToken.key
	}

	return token
}

fn clasify_tokens(tokens []string) []Token {
	return tokens.map(classify_token(it))
}

fn (tokens []Token) generate_code(json map[string]json2.Any) string {
	mut json_work := json.clone()

	if json.len == 0 {
		return '{}'
	} else {
		for token in tokens {
			if token.typ == .object_root {
				continue
			} else if token.typ == .key && token.value in json_work {
				json_work = json_work[token.value] as map[string]json2.Any
			} else if token.typ == .array_index
				&& typeof(json_work) == typeof[[]map[string]json2.Any]() {
				json_work = json_work as []map[string]json2.Any
			}
		}
	}

	return '{}'
}

['/submit'; post]
fn (mut app App) submit() vweb.Result {
	resp_query := json2.decode[Query](app.req.data.str()) or { panic(err) }
	code := json2.raw_decode(resp_query.code) or { panic(err) } as map[string]json2.Any

	query := r'(?P<root>[$])|(?P<name>[a-z]+)|(?P<point>[.])|(?P<array>\[\s{0,}\d\s{0,}\])|(?P<func>[{][a-z]+[}])'
	mut re := regex.regex_opt(query) or { panic(err) }
	re.match_string(resp_query.query)

	tokens_str := re.find_all_str(resp_query.query)

	s := clasify_tokens(tokens_str)
		.generate_code(code)

	return app.text(s)
}
