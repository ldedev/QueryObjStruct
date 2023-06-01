module entities

import contracts { TypeToken }

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
	} else if token.value.starts_with('{') && token.value.ends_with('}') {
		token.value = token.value.find_between('{', '}').trim_space()
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
