extends Node

var masks: Dictionary


#func _ready():
	#var mask = MaskData.new()
	#print("a")
	#mask.eyes = MaskComponent.EMOTIONS.SAD
	#assemble_mask(mask)




func assemble_mask(mask:MaskData) -> int:
	var id = ResourceUID.create_id()
	masks.set(id,mask)
	return id
	




func retrieve_mask(id:int) -> MaskData:
	return masks.get(id)
