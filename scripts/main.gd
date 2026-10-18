extends Control

const Story = preload("res://scripts/story.gd")
const CHARS_PER_SEC := 40.0

var nodes: Dictionary = {}
var current_id := ""
var typing := false
var waiting_choice := false
var type_tween: Tween


func _ready() -> void:
	%ChoicesPanel.visible = false
	%RecordShelf.visible = false
	# Hook up the three choice buttons. bind(i) tells us which one was pressed.
	for i in %ChoicesBox.get_child_count():
		var btn := %ChoicesBox.get_child(i) as Button
		btn.pressed.connect(_on_choice_pressed.bind(i))
	start_conversation(Story.TEST, "start")


func start_conversation(data: Dictionary, start_id: String) -> void:
	nodes = data
	show_node(start_id)


func show_node(id: String) -> void:
	if id == "" or not nodes.has(id):
		end_conversation()
		return

	current_id = id
	var n: Dictionary = nodes[id]
	waiting_choice = false
	%ChoicesPanel.visible = false

	# Portrait: only changes when the beat has a "portrait" key.
	if n.has("portrait"):
		var p: String = n["portrait"]
		if p == "":
			%CallerPortrait.visible = false
		else:
			%CallerPortrait.texture = load("res://art/caller_%s.png" % p)
			%CallerPortrait.visible = true

	%SpeakerLabel.text = n.get("speaker", "")
	%DialogueText.text = n.get("text", "")
	%DialogueText.visible_ratio = 0.0

	# Typewriter effect.
	typing = true
	if type_tween:
		type_tween.kill()
	var duration: float = max(0.3, %DialogueText.text.length() / CHARS_PER_SEC)
	type_tween = create_tween()
	type_tween.tween_property(%DialogueText, "visible_ratio", 1.0, duration)
	type_tween.finished.connect(_on_typing_done)


func _on_typing_done() -> void:
	typing = false
	var n: Dictionary = nodes[current_id]
	if n.has("choices"):
		show_choices(n["choices"])


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


func advance() -> void:
	if nodes.is_empty():
		return
	if typing:
		# Skip the typewriter: show the whole line now.
		type_tween.kill()
		%DialogueText.visible_ratio = 1.0
		_on_typing_done()
		return
	var n: Dictionary = nodes[current_id]
	if n.has("choices"):
		return
	show_node(n.get("next", ""))


func end_conversation() -> void:
	nodes = {}
	current_id = ""
	typing = false
	waiting_choice = false
	%ChoicesPanel.visible = false
	print("Conversation ended")


func _input(event: InputEvent) -> void:
	if waiting_choice:
		return
	var pressed := false
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = true
	elif event.is_action_pressed("ui_accept"):
		pressed = true
	if pressed:
		get_viewport().set_input_as_handled()
		advance()
