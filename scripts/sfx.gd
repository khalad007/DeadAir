extends Node

const NAMES := ["hum", "static", "tick", "blip", "hangup", "lock", "ring", "wrong", "record"]
const VOLUMES := {
	"hum": -20.0, "static": -80.0, "tick": -16.0, "blip": -18.0, "hangup": -10.0,
	"lock": -8.0, "ring": -10.0, "wrong": -8.0, "record": -8.0,
}

var players := {}


func _ready() -> void:
	for n in NAMES:
		var s := _find(n)
		if s == null:
			push_warning("Missing sound: " + n)
			continue
		if n == "hum" or n == "static":
			s = _make_loop(s)
		var p := AudioStreamPlayer.new()
		p.stream = s
		p.volume_db = VOLUMES[n]
		add_child(p)
		players[n] = p


func _find(n: String) -> AudioStream:
	for ext in ["wav", "ogg", "mp3"]:
		var path := "res://audio/%s.%s" % [n, ext]
		if ResourceLoader.exists(path):
			return load(path) as AudioStream
	return null


func _make_loop(s: AudioStream) -> AudioStream:
	if s is AudioStreamWAV:
		var w := s.duplicate() as AudioStreamWAV
		var bytes := 1
		if w.format == AudioStreamWAV.FORMAT_16_BITS:
			bytes = 2
		if w.stereo:
			bytes *= 2
		w.loop_mode = AudioStreamWAV.LOOP_FORWARD
		w.loop_begin = 0
		w.loop_end = int(w.data.size() / float(bytes))
		return w
	if "loop" in s:
		var c = s.duplicate()
		c.loop = true
		return c
	return s


func play(n: String, pitch := 1.0) -> void:
	var p = players.get(n)
	if p == null:
		return
	p.pitch_scale = pitch
	p.play()


func start_loop(n: String) -> void:
	var p = players.get(n)
	if p != null and not p.playing:
		p.play()


func volume(n: String, db: float) -> void:
	var p = players.get(n)
	if p != null:
		p.volume_db = db


func fade_to(n: String, db: float, sec: float) -> void:
	var p = players.get(n)
	if p != null:
		create_tween().tween_property(p, "volume_db", db, sec)


func _unhandled_input(event: InputEvent) -> void:
	# M toggles mute everywhere
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_M:
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
