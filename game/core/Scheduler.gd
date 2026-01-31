@abstract
class_name  Scheduler

var queue = Array()

func _init(initQueue = Array()):
	queue = initQueue
	pass

@abstract
func Next()
