root = exports ? window

board = root.board
conf = root.conf
g = root.g

class root.Pad
	constructor: ->
		@left = $ "#left_pad"
		@right = $ "#right_pad"
		@bottom = $ "#bottom_pad"
		@left.empty()
		@right.empty()
		@bottom.empty()

	adjust_position: ->
		w = $("#game_board").width()
		h = $("#game_board").height()
		offset = $("#game_board").offset()
		offset.left += conf.pad_margin
		offset.top += conf.pad_margin
		@left.offset offset
		@left.width conf.pad_width
		@left.height h - 3 * conf.pad_margin - conf.bottom_height
		offset = $("#game_board").offset()
		offset.left += w - conf.pad_width - conf.pad_margin
		offset.top += conf.pad_margin
		@right.offset offset
		@right.width conf.pad_width
		@right.height h - 3 * conf.pad_margin - conf.bottom_height
		offset = $("#game_board").offset()
		offset.left += conf.pad_margin
		offset.top += h - conf.pad_margin - conf.bottom_height
		@bottom.offset offset
		@bottom.width w - 2 * conf.pad_margin
		@bottom.height conf.bottom_height

	text: (place, msg) ->
		this[place].append $("<div>")
			.text(msg)
			.addClass("pad_text")

	log: (msg) ->
		@text "right", msg

	status: (msg) ->
		@bottom.empty()
		@text "bottom", msg

