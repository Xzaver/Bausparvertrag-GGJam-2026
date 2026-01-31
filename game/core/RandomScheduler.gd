class_name  RandomScheduler
extends Scheduler

func Next():
	var rnd : int = rand_int(0, queue.size() - 1)
	return queue[rnd]

func rand_int(min_val: int, max_val: int) -> int:
	return min_val + (randi() % (max_val - min_val + 1))
