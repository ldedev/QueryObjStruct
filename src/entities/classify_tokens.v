module entities

import contracts { TypeToken, TypeArgument, IArgument }

fn get_type_argument(identifier string) TypeArgument {
	return if identifier.trim_space().starts_with("@") { TypeArgument.key } else { TypeArgument.literal }
}

fn insert_argument(mut arguments []IArgument, _identifier string) {
	mut identifier := _identifier.trim_string_left(" ")
	type_argument := get_type_argument(identifier)
	if type_argument == TypeArgument.key {
		identifier = identifier.after("@")
	}
	if identifier.starts_with('"') && identifier.ends_with('"') {
		identifier = identifier.find_between('"', '"')
	}

	arguments << Argument{
		name: identifier.trim_space(),
		typ: type_argument
	}
}

fn resolver_name_and_arguments_func(value string) (string, []IArgument) {
	name := value.before(" ")
	mut arguments := []IArgument{}

	if value.len_utf8() > name.len_utf8() {
		mut identifier := ""

		for chr in value.after_char(` `) {

			if chr == `,` {
				insert_argument(mut arguments, identifier)
				identifier = ""
				continue
			}

			identifier += chr.ascii_str()
		}

		if identifier.len_utf8() > 0 {
			insert_argument(mut arguments, identifier)
		}

	}


	return name, arguments
}

pub fn classify_token(value_token string) Token {
	mut token := Token{
		value: value_token
	}
	token.typ = if token.value == '$' {
		TypeToken.object_root
	} else if token.value == '.' {
		TypeToken.object
	} else if token.value.starts_with('[') && token.value.ends_with(']') {
		token.value = token.value.find_between('[', ']').trim_space()
		TypeToken.array_index
	} else if token.value == '*' {
		TypeToken.array_all_index
	} else if token.value.starts_with('(') && token.value.ends_with(')') {
		token.value, token.arguments = resolver_name_and_arguments_func(
			token.value.find_between('(', ')').trim_space()
		)

		TypeToken.function
	} else {
		if token.value.starts_with('"') && token.value.ends_with('"') {
			token.value = token.value.find_between('"', '"')
		}
		TypeToken.key
	}

	return token
}

pub fn clasify_tokens(tokens []string) []Token {
	return tokens.map(classify_token(it))
}
