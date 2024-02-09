extends Node3D

var astar: AStar3D

@onready var gm_floor: GridMap = $GridMapFloor
@onready var gm_wall: GridMap = $GridMapWall

var map: Dictionary # true means there is a wall

func _ready():
	build_navigation_map()
	build_astar()

func build_navigation_map():
	var vecs: Array[Vector3i] = gm_wall.get_used_cells()
	var xmin = 9223372036854775807
	var ymin = 9223372036854775807
	var zmin = 9223372036854775807
	var xmax = -9223372036854775808
	var ymax = -9223372036854775808
	var zmax = -9223372036854775808
	for v in vecs:
		xmin = min(xmin,v.x)
		ymin = min(ymin,v.y)
		zmin = min(zmin,v.z)
		xmax = max(xmax,v.x)
		ymax = max(ymax,v.y)
		zmax = max(zmax,v.z)
	map = Dictionary()
	for x in range(xmin,xmax+1):
		for y in range(ymin,ymax+1):
			for z in range(zmin,zmax+1):
				map[Vector3i(x,y,z)] = false
	for vec in vecs:
		map[vec] = true
		
func build_astar():
	astar = AStar3D.new()
	for vec in map.keys():
		if not map[vec]: # if this location is passable:
			astar.add_point(astar.get_available_point_id(), vec)
	for id in astar.get_point_ids():
		var point: Vector3i = astar.get_point_position(id)
		for neighbor in [point+Vector3i(1,0,0), point+Vector3i(-1,0,0),point+Vector3i(0,0,1),point+Vector3i(0,0,-1)]:
			if map.has(neighbor) and not map[neighbor]:
				astar.connect_points(id, astar.get_closest_point(neighbor))
