root = exports ? window

sqrt3 = Math.sqrt 3

root.ctx = null
root.canvas = null
root.board = []
root.conf = {
	radius: 50,
	map_width: 9,
	map_height: 5,
	min_zoom: 0.8,
	first_zoom: 1.4,
	second_zoom: 2.2,
	max_zoom: 3,
	zoom_step: 0.2,
	angle_step: 10,
	grid_ratio: 0.95,
}
root.g = {
	current_x: -1,
	current_y: -1,
	board_width: 0,
	board_height: 0,
	angle: 0,
	zoom: 1.2,
	panning: false,
	panning_start_x: 0,
	panning_start_y: 0,
	panning_start_center_x: 0,
	panning_start_center_y: 0,
	center_x: 0.5,
	center_y: 0.5,
}

