extends Node

var masks: Dictionary


#func _ready():
	#var mask = MaskData.new()
	#print("a")
	#mask.eyes = MaskComponent.EMOTIONS.SAD
	#assemble_mask(mask)




func save_mask(mask:MaskData) -> int:
	var id = ResourceUID.create_id()
	masks.set(id,mask)
	return id
	

func set_mask(id:int,mask:MaskData):
	if masks.has(id):
		masks.set(id, mask)
	else:
		print("Mask with ID "+str(id)+" not found")


func fetch_mask(id:int) -> MaskData:
	
	if masks.has(id):
		return masks.get(id)
	else:
		print("Mask with ID "+str(id)+" not found")
		return null
