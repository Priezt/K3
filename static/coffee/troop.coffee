root = exports ? window

type_name_map = {
	'footman': '步兵',
}

class root.Troop
	constructor: (@name) ->
		@amount = 1000
		@type = "footman"

	typename: ->
		type_name_map[@type]
