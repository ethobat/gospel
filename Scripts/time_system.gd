extends Node

var users = []

var playing = false

# Registers a user of the time system,
# which will have its _time_process, _on_time_play, and _on_time_pause methods called.
func register_user(user):
	users.append(user)

func _physics_process(delta):
	if not playing: return
	for user in users:
		if user.has_method("_time_process"):
			user._time_process(delta)
	
func begin_playing():
	if playing:
		print("WARNING: Tried to play time when it was already playing")
		return
	playing = true
	for user in users:
		if user.has_method("_on_time_play"):
			user._on_time_play()

func stop_playing():
	if not playing:
		print("WARNING: Tried to pause time when it was already pause")
		return
	playing = false
	for user in users:
		if user.has_method("_on_time_pause"):
			user._on_time_pause()
