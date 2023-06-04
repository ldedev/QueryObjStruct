module contracts

pub interface IToken {
mut:
	value string
	arguments []IArgument
	typ TypeToken
}
