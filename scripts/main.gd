extends Control

const Story = preload("res://scripts/story.gd")
const SfxScript = preload("res://scripts/sfx.gd")
const Credits = preload("res://scripts/credits.gd")
const CHARS_PER_SEC := 40.0
const GLYPHS := "#%&*+=?/|~^"
const FREQ_MIN := 88.0
const FREQ_MAX := 108.0
const DIAL_LIMIT := 135.0

var nodes: Dictionary = {}
var current_id := ""
var typing := false
var waiting_choice := false
var ending_active := false
var type_tween: Tween
var fade_tween: Tween
var clock_tween: Tween
var black_tween: Tween

# Dial and signal
var dial_angle := 0.0
var dragging := false
var target_freq := 98.0
var garbled := false
var locked := false
var lock_timer := 0.0
var garble_timer := 0.0
var static_strength := 0.0
var static_mat: ShaderMaterial

# Sound
var sfx
var blip_timer := 0.0
var last_tick_step := 0

# Black fader (made in code so the scene stays untouched)
var fader: ColorRect


func _ready() -> void:
	%ChoicesPanel.visible = false
	%RecordShelf.visible = false
	%StaticOverlay.visible = false
	$DialoguePanel.visible = false
	static_mat = %StaticOverlay.material as ShaderMaterial
	if static_mat == null:
		push_error("StaticOverlay has no ShaderMaterial. Check Step 5, section 2, point 4.")
	for i in %ChoicesBox.get_child_count():
		var btn := %ChoicesBox.get_child(i) as Button
		btn.pressed.connect(_on_choice_pressed.bind(i))
	for i in %RecordShelf.get_child_count():
		var rbtn := %RecordShelf.get_child(i) as Button
		rbtn.clip_text = true
		rbtn.pressed.connect(_on_record_pressed.bind(i))

	# The fader sits just under the dialogue UI, so text stays readable on black.
	fader = ColorRect.new()
	fader.color = Color.BLACK
	fader.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fader)
	fader.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var idx := mini(%ChoicesPanel.get_index(), mini(%RecordShelf.get_index(), $DialoguePanel.get_index()))
	move_child(fader, idx)

	sfx = SfxScript.new()
	add_child(sfx)
	sfx.start_loop("hum")
	sfx.start_loop("static")

	set_dial(0.0)
	set_clock("1:00 AM", 0.0, true)

	# Fade in from black, then start the show.
	fader.modulate.a = 1.0
	%FreqLabel.modulate.a = 0.0
	var tw := create_tween().set_parallel(true)
	tw.tween_property(fader, "modulate:a", 0.0, 1.5)
	tw.tween_property(%FreqLabel, "modulate:a", 1.0, 1.5)
	await tw.finished
	$DialoguePanel.visible = true
	start_conversation(Story.all_beats(), "intro")
	# QUICK TEST: replace "intro" above with "a17" to jump to the ending choice.


# ---------------- Clock ----------------

func set_clock(text: String, frac: float, instant := false) -> void:
	%ClockLabel.text = text
	var x := 38.0 + 556.0 * clampf(frac, 0.0, 1.0)
	if clock_tween:
		clock_tween.kill()
	if instant:
		%SunMarker.position.x = x
	else:
		clock_tween = create_tween()
		clock_tween.tween_property(%SunMarker, "position:x", x, 2.0).set_trans(Tween.TRANS_SINE)


# ---------------- Dial ----------------

func get_freq() -> float:
	return lerpf(FREQ_MIN, FREQ_MAX, (dial_angle + DIAL_LIMIT) / (DIAL_LIMIT * 2.0))


func get_clarity() -> float:
	var dist := absf(get_freq() - target_freq)
	return clampf(1.0 - (dist - 0.8) / 5.0, 0.0, 1.0)


func set_dial(angle: float) -> void:
	dial_angle = clampf(angle, -DIAL_LIMIT, DIAL_LIMIT)
	%Knob.rotation_degrees = dial_angle
	%FreqLabel.text = "%.1f FM" % get_freq()
	var step := int(floorf(dial_angle / 5.0))
	if step != last_tick_step:
		last_tick_step = step
		if sfx != null:
			sfx.play("tick")


func dial_from_mouse(guard: bool) -> void:
	var center: Vector2 = %Knob.global_position + %Knob.size * 0.5
	var d: Vector2 = get_global_mouse_position() - center
	if d.length() < 4.0:
		return
	var a := rad_to_deg(atan2(d.x, -d.y))  # 0 = straight up, clockwise positive
	if guard and absf(a - dial_angle) > 150.0:
		return  # ignore jumps across the dead zone at the bottom
	set_dial(a)


# ---------------- Garble / static ----------------

func garble(src: String, clarity: float) -> String:
	var out := ""
	for ch in src:
		if ch == " " or ch in ".,!?'":
			out += ch
		elif randf() > clarity:
			out += GLYPHS[randi() % GLYPHS.length()]
		else:
			out += ch
	return out


func _process(delta: float) -> void:
	var target_static := 0.0
	if garbled:
		var c := get_clarity()
		target_static = 1.0 - c
		if c >= 0.95:
			lock_timer += delta
			if lock_timer >= 0.4:
				finish_tune()
		else:
			lock_timer = 0.0
		garble_timer += delta
		if garbled and garble_timer >= 0.1:
			garble_timer = 0.0
			%DialogueText.text = garble(nodes[current_id].get("text", ""), c)
	static_strength = move_toward(static_strength, target_static, delta * 3.0)
	%StaticOverlay.visible = %CallerPortrait.visible and static_strength > 0.01
	if static_mat:
		static_mat.set_shader_parameter("strength", static_strength)

	if sfx != null:
		# Static hiss follows the on-screen static.
		sfx.volume("static", linear_to_db(maxf(static_strength * 0.35, 0.0001)))
		# Typing blips on spoken lines only (not narration).
		if typing and nodes.has(current_id) and nodes[current_id].get("speaker", "") != "":
			blip_timer += delta
			if blip_timer >= 0.07:
				blip_timer = 0.0
				sfx.play("blip", randf_range(0.9, 1.15))
		else:
			blip_timer = 0.0


func finish_tune() -> void:
	garbled = false
	locked = true
	sfx.play("lock")
	var n: Dictionary = nodes[current_id]
	%SpeakerLabel.text = n.get("speaker", "")
	start_typing(n)


# ---------------- Portrait / black ----------------

func fade_portrait() -> void:
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(%CallerPortrait, "modulate:a", 0.0, 2.5)
	fade_tween.finished.connect(func(): %CallerPortrait.visible = false)


func fade_to_black() -> void:
	if black_tween:
		black_tween.kill()
	black_tween = create_tween().set_parallel(true)
	black_tween.tween_property(fader, "modulate:a", 1.0, 3.0)
	black_tween.tween_property(%FreqLabel, "modulate:a", 0.0, 3.0)
	sfx.fade_to("hum", -45.0, 4.0)


# ---------------- Dialogue ----------------

func start_conversation(data: Dictionary, start_id: String) -> void:
	# duplicate(): we add temporary beats ("_play", "_hint") to this copy
	nodes = data.duplicate()
	show_node(start_id)


func show_node(id: String) -> void:
	if id == "" or not nodes.has(id):
		end_conversation()
		return

	current_id = id
	var n: Dictionary = nodes[id]
	waiting_choice = false
	garbled = false
	typing = false
	%ChoicesPanel.visible = false
	%RecordShelf.visible = false
	if type_tween:
		type_tween.kill()

	if n.has("portrait"):
		var p: String = n["portrait"]
		if fade_tween:
			fade_tween.kill()
		%CallerPortrait.modulate.a = 1.0
		if p == "":
			%CallerPortrait.visible = false
		else:
			%CallerPortrait.texture = load("res://art/caller_%s.png" % p)
			%CallerPortrait.visible = true
			sfx.play("ring")

	if n.has("clock"):
		set_clock(n["clock"], n.get("sun", 0.0))
	if n.get("fade", false):
		fade_portrait()
		sfx.play("hangup")
	if n.get("black", false):
		fade_to_black()
	if n.has("sfx"):
		sfx.play(n["sfx"])

	# A beat with "tune" starts scrambled until the player finds the frequency.
	if n.has("tune"):
		target_freq = n["tune"]
		garbled = true
		locked = false
		lock_timer = 0.0
		garble_timer = 0.0
		%SpeakerLabel.text = "%s   (turn the dial to tune in)" % n.get("speaker", "")
		%DialogueText.text = garble(n.get("text", ""), get_clarity())
		%DialogueText.visible_ratio = 1.0
		return

	%SpeakerLabel.text = n.get("speaker", "")
	start_typing(n)


func start_typing(n: Dictionary) -> void:
	%DialogueText.text = n.get("text", "")
	%DialogueText.visible_ratio = 0.0
	typing = true
	if type_tween:
		type_tween.kill()
	var duration := maxf(0.3, float(%DialogueText.text.length()) / CHARS_PER_SEC)
	type_tween = create_tween()
	type_tween.tween_property(%DialogueText, "visible_ratio", 1.0, duration)
	type_tween.finished.connect(_on_typing_done)


func _on_typing_done() -> void:
	typing = false
	var n: Dictionary = nodes[current_id]
	if n.has("choices"):
		show_choices(n["choices"])
	elif n.has("records"):
		show_records(n["records"])


func show_choices(choices: Array) -> void:
	waiting_choice = true
	for i in %ChoicesBox.get_child_count():
		var btn := %ChoicesBox.get_child(i) as Button
		if i < choices.size():
			btn.text = choices[i]["text"]
			btn.visible = true
		else:
			btn.visible = false
	%ChoicesPanel.visible = true
	%ChoicesPanel.reset_size.call_deferred()


func _on_choice_pressed(i: int) -> void:
	var choices: Array = nodes[current_id]["choices"]
	if i >= choices.size():
		return
	waiting_choice = false
	%ChoicesPanel.visible = false
	show_node(choices[i].get("next", ""))


# ---------------- Record shelf ----------------

func show_records(records: Array) -> void:
	waiting_choice = true
	for i in %RecordShelf.get_child_count():
		var btn := %RecordShelf.get_child(i) as Button
		if i < records.size():
			btn.text = records[i]["name"]
			btn.visible = true
		else:
			btn.visible = false
	%RecordShelf.visible = true


func _on_record_pressed(i: int) -> void:
	var beat_id := current_id
	var beat: Dictionary = nodes[beat_id]
	var records: Array = beat["records"]
	if i >= records.size():
		return
	var rec: Dictionary = records[i]
	waiting_choice = false
	%RecordShelf.visible = false

	var after := ""
	if rec.get("right", false):
		after = rec.get("next", "")
		sfx.play("record")
	else:
		# Wrong record: the caller reacts, then we return to this same beat.
		sfx.play("wrong")
		nodes["_hint"] = {
			"speaker": beat.get("hint_speaker", "CALLER"),
			"text": rec.get("hint", "..."),
			"next": beat_id,
		}
		after = "_hint"

	nodes["_play"] = {
		"speaker": "",
		"text": "[i]~ Now playing: %s ~[/i]" % rec["name"],
		"next": after,
	}
	show_node("_play")


# ---------------- Flow ----------------

func advance() -> void:
	if nodes.is_empty() or garbled:
		return
	if typing:
		type_tween.kill()
		%DialogueText.visible_ratio = 1.0
		_on_typing_done()
		return
	var n: Dictionary = nodes[current_id]
	if n.has("choices") or n.has("records"):
		return
	if n.has("ending"):
		show_ending(n["ending"])
		return
	show_node(n.get("next", ""))


func show_ending(text: String) -> void:
	nodes = {}
	current_id = ""
	typing = false
	waiting_choice = false
	garbled = false
	ending_active = true
	$DialoguePanel.visible = false
	%ChoicesPanel.visible = false
	%RecordShelf.visible = false

	var center := CenterContainer.new()
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center.modulate.a = 0.0
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	center.add_child(box)

	var card := Label.new()
	card.text = text
	card.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.add_theme_font_size_override("font_size", 22)
	card.add_theme_color_override("font_color", Color("f0b060"))
	box.add_child(card)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	box.add_child(row)

	var again := Button.new()
	again.text = "Play Again"
	again.custom_minimum_size = Vector2(110, 24)
	again.pressed.connect(func(): get_tree().reload_current_scene())
	row.add_child(again)

	var menu := Button.new()
	menu.text = "Main Menu"
	menu.custom_minimum_size = Vector2(110, 24)
	menu.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/title.tscn"))
	row.add_child(menu)

	var credit := Label.new()
	credit.text = Credits.SHORT
	credit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credit.add_theme_font_size_override("font_size", 10)
	credit.add_theme_color_override("font_color", Color("8a93a8"))
	box.add_child(credit)

	var tw := create_tween()
	tw.tween_property(center, "modulate:a", 1.0, 2.0)
	tw.finished.connect(func(): again.grab_focus())
	print("ENDING: ", text.replace("\n", " - "))


func end_conversation() -> void:
	nodes = {}
	current_id = ""
	typing = false
	waiting_choice = false
	garbled = false
	locked = false
	%ChoicesPanel.visible = false
	%RecordShelf.visible = false
	print("Conversation ended")


# ---------------- Input ----------------

func _input(event: InputEvent) -> void:
	# Dial: mouse drag, wheel, arrow keys
	if event is InputEventMouseButton:
		var over_knob: bool = %Knob.get_global_rect().has_point(get_global_mouse_position())
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and over_knob:
				dragging = true
				dial_from_mouse(false)
				get_viewport().set_input_as_handled()
				return
			elif not event.pressed and dragging:
				dragging = false
				get_viewport().set_input_as_handled()
				return
		elif event.pressed and over_knob:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				set_dial(dial_angle + 6.0)
				get_viewport().set_input_as_handled()
				return
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				set_dial(dial_angle - 6.0)
				get_viewport().set_input_as_handled()
				return
	elif event is InputEventMouseMotion and dragging:
		dial_from_mouse(true)
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("ui_left"):
		set_dial(dial_angle - 4.0)
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_right"):
		set_dial(dial_angle + 4.0)
		get_viewport().set_input_as_handled()
		return

	# Dialogue advance (not while choosing, tuning, fading in, or on the ending screen)
	if waiting_choice or garbled or ending_active or nodes.is_empty():
		return
	var pressed := false
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = true
	elif event.is_action_pressed("ui_accept"):
		pressed = true
	if pressed:
		get_viewport().set_input_as_handled()
		advance()
