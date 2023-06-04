module main

import x.json2
import vweb
import regex
import entities
import functions

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
	app.mount_static_folder_at('${@VMODROOT}/src/templates/assets', '/')
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

['/submit'; post]
fn (mut app App) submit() vweb.Result {
	resp_query := json2.decode[Query](app.req.data.str()) or { panic(err) }
	code := json2.raw_decode(resp_query.code) or { panic(err) }

	query := r'(?P<root>[$])|(?P<key>[a-zA-Z0-9 ]+)|(?P<keystupid>".*"+)|(?P<point>[.])|(?P<array>\[\s{0,}\d|[*]\s{0,}\])|(?P<func>[(][\\a-zA-Z0-9 ,.@"]+[)])|([*])'
	mut re := regex.regex_opt(query) or { panic(err) }
	re.match_string(resp_query.query)

	tokens_str := re.find_all_str(resp_query.query)

	dump(tokens_str)
	s := entities.clasify_tokens(tokens_str)
		.generate_code(code)

	return app.text(s)

}
