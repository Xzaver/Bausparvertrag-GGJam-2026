class_name CustomerData

static var EMPTY_MASK_ID = -1

var id : int
var maskID : int

var cult : int
var sprite : int

func _init(initial_id : int, initialMaskID : int,  initial_sprite : int ,initial_cult : int):
	id = initial_id
	maskID = initialMaskID
	sprite = initial_sprite
	cult = initial_cult
	
