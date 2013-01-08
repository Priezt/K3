root = exports ? window

canvas = null
ctx = null
pad = null

sqrt3 = Math.sqrt 3
board = root.board
conf = root.conf
g = root.g

get_real_board_size = ->
	width = conf.radius * g.zoom * 1.5 * (conf.map_width - 1)
	height = conf.radius * g.zoom * sqrt3 * conf.map_height
	{
		'width': width,
		'height': height,
	}

initialize_board = ->
	board = []
	for x in [0...conf.map_width]
		column_length = conf.map_height
		column_length++ if x % 2 == 1
		board.push []
		for y in [0...column_length]
			#console.log "#{x}, #{y}"
			new_grid = new Grid x, y
			#console.log new_grid
			#console.log board
			#console.log board[-1..][0]
			board[-1..][0].push new_grid
	new_troop = new Troop("张飞")
	board[3][3].put new_troop
	new_troop = new Troop("关羽")
	board[4][4].put new_troop
	board[5][5].put board[4][4].pick()

go_through_board = (func) ->
	for column in board
		for grid in column
			#console.log "#{grid.x}, #{grid.y}"
			func(grid)

get_some_from_board = (func) ->
	for column in board
		for grid in column
			if func(grid)
				return grid
	return null
	
draw_grids = ->
	#console.log "draw_grids"
	go_through_board (grid) ->
		grid.draw(ctx)

redraw_board = ->
	# draw background
	ctx.fillStyle = "rgb(150,150,100)"
	ctx.fillRect 0, 0, canvas.width, canvas.height
	# draw board
	draw_grids()
	# draw selected troop
	draw_selected_troop()

draw_selected_troop = ->
	if g.selected_troop
		g.selected_troop.grid.draw_selected(ctx)

adjust_canvas_size = ->
	ctx.canvas.width = Math.round window.innerWidth * 0.90
	ctx.canvas.height = Math.round window.innerHeight * 0.90
	g.board_width = ctx.canvas.width
	g.board_height = ctx.canvas.height
	pad.adjust_position()
	redraw_board()

current_grid = ->
	if g.current_x < 0
		return null
	if g.current_y < 0
		return null
	board[g.current_x][g.current_y]

$ ->
	canvas = $("#game_board")[0]
	ctx = canvas.getContext? "2d"
	pad = new root.Pad()
	#console.log ctx
	#console.log canvas
	#console.log root
	window.onresize = -> adjust_canvas_size()
	initialize_board()
	adjust_canvas_size()
	$(canvas).mousedown (event) ->
		evt = window.event ? event
		evt.preventDefault()
		if evt.button == 1
			g.panning_start_x = evt.offsetX
			g.panning_start_y = evt.offsetY
			g.panning_start_center_x = g.center_x
			g.panning_start_center_y = g.center_y
			g.panning = true
		#console.log evt.button
	$(canvas).mouseup (event) ->
		evt = window.event ? event
		evt.preventDefault()
		g.panning = false
		if g.mode == 'normal'
			if evt.button == 0
				g.selected_troop = current_grid()?.troop
				console.log "#{g.selected_troop?.name} selected"
				redraw_board()
				if g.selected_troop
					pad.left.empty()
					pad.log g.selected_troop.name
				else
					pad.left.empty()
					pad.log "unselected"
	$(canvas).mousemove (event) ->
		evt = window.event ? event
		evt.preventDefault()
		if g.panning
			ofx = evt.offsetX - g.panning_start_x
			ofy = evt.offsetY - g.panning_start_y
			oang = Math.atan2 ofy, ofx
			oradius = Math.sqrt(Math.pow(ofx, 2) + Math.pow(ofy, 2))
			ofx = oradius * Math.cos(oang - g.angle * Math.PI / 180)
			ofy = oradius * Math.sin(oang - g.angle * Math.PI / 180)
			#console.log "#{ofx}, #{ofy}"
			{width, height} = get_real_board_size()
			#console.log "#{width}, #{height}"
			rx  = ofx / width
			ry  = ofy / height
			g.center_x = g.panning_start_center_x - rx
			g.center_y = g.panning_start_center_y - ry
			if g.center_x < 0
				g.center_x = 0
			if g.center_x > 1
				g.center_x = 1
			if g.center_y < 0
				g.center_y = 0
			if g.center_y > 1
				g.center_y = 1
			redraw_board()
		else
			grid = get_some_from_board (grid) ->
				grid.containing_cursor evt.offsetX, evt.offsetY
			if grid
				g.current_x = grid.x
				g.current_y = grid.y
				#console.log "#{grid.x}, #{grid.y}"
				pad.status "#{grid.x}, #{grid.y}"
				redraw_board()
			else
				g.current_x = -1
				g.current_y = -1
	$(canvas).bind 'contextmenu', (event) ->
		evt = window.event ? event
		evt.preventDefault()
	$(canvas).bind 'mousewheel', (event) ->
		evt = window.event ? event
		evt.preventDefault()
		if not g.panning
				if evt.altKey
					if evt.wheelDelta > 0
							g.angle += conf.angle_step
							if g.angle >= 360
								g.angle -= 360
					if evt.wheelDelta < 0
							g.angle -= conf.angle_step
							if g.angle < 0
								g.angle += 360
				else
					if evt.wheelDelta > 0
						if g.zoom < conf.max_zoom
							g.zoom += conf.zoom_step
					if evt.wheelDelta < 0
						if g.zoom > conf.min_zoom
							g.zoom -= conf.zoom_step
				redraw_board()

