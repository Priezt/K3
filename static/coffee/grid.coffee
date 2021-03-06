root = exports ? window

sqrt3 = Math.sqrt 3

class root.Grid
	constructor: (@x, @y) ->

	put: (troop) ->
		@troop = troop
		troop.grid = this

	pick: ->
		picked = @troop
		@troop.grid = null
		@troop = null
		picked

	get_center: ->
		rx = @x / (conf.map_width - 1) - g.center_x
		if @x % 2 == 1
			ry = @y / conf.map_height - g.center_y
		else
			ry = (@y + 0.5) / conf.map_height - g.center_y
		rx *= conf.radius * g.zoom * 1.5 * (conf.map_width - 1)
		ry *= conf.radius * g.zoom * sqrt3 * conf.map_height
		r = Math.sqrt(rx * rx + ry * ry)
		ang = Math.atan2(ry, rx)
		ang += g.angle * Math.PI / 180
		ax = parseInt g.board_width * 0.5 + r * Math.cos(ang)
		ay = parseInt g.board_height * 0.5 + r * Math.sin(ang)
		{
			x: ax,
			y: ay,
		}

	containing_cursor: (mx, my) ->
		{x, y} = @get_center()
		#console.log "#{x}, #{y}"
		range = conf.radius * g.zoom * 0.5 * sqrt3
		#console.log range
		return false if Math.abs(x - mx) > range
		return false if Math.abs(y - my) > range
		return false if Math.sqrt(Math.pow(x - mx, 2) + Math.pow(y - my, 2)) > range
		return true

	draw_troop: (ctx) ->
		{x, y} = @get_center()
		ctx.save()
		ctx.translate x, y
		ctx.font = "bold 18px MS Gothic"
		ctx.textAlign = "center"
		ctx.textBaseline = "middle"
		ctx.fillStyle = "#000"
		#console.log @troop.name + ":" + x + "," + y
		ctx.fillText @troop.name, 0, 0
		if g.zoom >= conf.first_zoom
			ctx.save()
			ctx.font = "bold 14px MS Gothic"
			ctx.textAlign = "center"
			ctx.textBaseline = "middle"
			ctx.fillStyle = "#FFF"
			tx = 0
			ty = -conf.radius * 0.5 * sqrt3 * conf.grid_ratio * g.zoom * 0.5
			ctx.fillText "#{@troop.amount}", tx, ty
			tx = 0
			ty = conf.radius * 0.5 * sqrt3 * conf.grid_ratio * g.zoom * 0.5
			ctx.fillText "#{@troop.typename()}", tx, ty
			ctx.restore()
		if g.zoom >= conf.second_zoom
			ctx.save()
			ctx.restore()
		ctx.restore()

	draw_hexagon: (ctx, radius_ratio) ->
		ctx.save()
		{x, y} = @get_center()
		ctx.translate x, y
		ctx.rotate g.angle * Math.PI / 180
		for n in [1..6]
			ctx.beginPath()
			ctx.moveTo -conf.radius * 0.5 * radius_ratio * g.zoom, -conf.radius * 0.5 * sqrt3 * radius_ratio * g.zoom
			ctx.lineTo conf.radius * 0.5 * radius_ratio * g.zoom, -conf.radius * 0.5 * sqrt3 * radius_ratio * g.zoom
			ctx.closePath()
			ctx.stroke()
			ctx.rotate 60 * Math.PI / 180
		ctx.restore()

	draw_selected: (ctx) ->
		ctx.save()
		ctx.strokeStyle = "rgb(255,255,0)"
		@draw_hexagon ctx, conf.selected_grid_ratio
		ctx.restore()

	draw: (ctx) ->
		ctx.save()
		if @x == g.current_x and @y == g.current_y
			ctx.strokeStyle = "rgb(0,255,0)"
		@draw_hexagon ctx, conf.grid_ratio
		ctx.restore()
		if @troop
			@draw_troop ctx

