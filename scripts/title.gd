extends Control

const Credits = preload("res://scripts/credits.gd")
const SfxScript = preload("res://scripts/sfx.gd")

const HOWTO := "HOW TO PLAY\n\nYou host a late-night radio show. Every caller needs your help.\n\nCONTINUE: click, Space or Enter. Press again while text is typing to show the full line.\n\nTUNE THE DIAL: drag the knob with the mouse, scroll the mouse wheel over it, or press the Left and Right arrow keys. The frequency shows under the knob.\n\nFIND THE SIGNAL: a new caller is scrambled and buried in static until you find their frequency. Turn slowly. When letters start to appear and the static thins, hold still for a moment and the line locks.\n\nCHOOSE WORDS: click one of the answers when they appear.\n\nPLAY A RECORD: pick the song that fits the caller. A wrong song gives you a hint, so you can try again.\n\nM: mute or unmute the sound."

var sfx
var fader: ColorRect
var menu: VBoxContainer
var credits_panel: PanelContainer
var howto_panel: PanelContainer
var start_btn: Button
var howto_btn: Button
var credits_btn: Button
var starting := false


func _ready() -> void:
	# Theme built in code, so no external files are needed.
	var t := Theme.new()
	t.default_font_size = 12
	theme = t

	sfx = SfxScript.new()
	add_child(sfx)
	sfx.start_loop("hum")

	var bg := TextureRect.new()
	bg.texture = load("res://art/booth_bg.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var shade := ColorRect.new()
	shade.color = Color(0.03, 0.05, 0.1, 0.65)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# ----- main menu -----
	menu = VBoxContainer.new()
	menu.add_theme_constant_override("separation", 8)
	center.add_child(menu)

	var title := Label.new()
	title.text = "DEAD AIR"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color("f0b060"))
	menu.add_child(title)

	var sub := Label.new()
	sub.text = "a late-night call-in show"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_color_override("font_color", Color("9aa4bd"))
	menu.add_child(sub)

	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 12)
	menu.add_child(gap)

	start_btn = _button("Start", _on_start)
	menu.add_child(start_btn)
	howto_btn = _button("How to Play", _on_howto)
	menu.add_child(howto_btn)
	credits_btn = _button("Credits", _on_credits)
	menu.add_child(credits_btn)
	if not OS.has_feature("web"):
		menu.add_child(_button("Quit", func(): get_tree().quit()))

	var hint := Label.new()
	hint.text = "Headphones recommended  |  M to mute"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 10)
	hint.add_theme_color_override("font_color", Color("8a93a8"))
	menu.add_child(hint)

	# ----- info panels -----
	howto_panel = _make_panel(HOWTO, 500, center)
	credits_panel = _make_panel(Credits.TEXT, 420, center)

	# ----- fader (on top of everything) -----
	fader = ColorRect.new()
	fader.color = Color.BLACK
	fader.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fader)
	fader.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	create_tween().tween_property(fader, "modulate:a", 0.0, 1.0)

	# gentle pulse on the title
	var pulse := create_tween().set_loops()
	pulse.tween_property(title, "modulate:a", 0.7, 1.4)
	pulse.tween_property(title, "modulate:a", 1.0, 1.4)

	start_btn.grab_focus()


func _button(text: String, cb: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(160, 24)
	b.pressed.connect(cb)
	return b


func _make_panel(text: String, width: int, parent: Control) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.visible = false

	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("0b1020dd")
	sb.set_border_width_all(2)
	sb.border_color = Color("f0b060")
	sb.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", sb)
	parent.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(width, 0)
	box.add_child(label)

	var back := _button("Back", _on_back)
	back.name = "BackButton"
	box.add_child(back)
	return panel


func _show_panel(panel: PanelContainer) -> void:
	menu.visible = false
	panel.visible = true
	(panel.find_child("BackButton", true, false) as Button).grab_focus()


func _on_start() -> void:
	if starting:
		return
	starting = true
	sfx.fade_to("hum", -60.0, 0.9)
	var tw := create_tween()
	tw.tween_property(fader, "modulate:a", 1.0, 0.9)
	await tw.finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_howto() -> void:
	_show_panel(howto_panel)


func _on_credits() -> void:
	_show_panel(credits_panel)


func _on_back() -> void:
	howto_panel.visible = false
	credits_panel.visible = false
	menu.visible = true
	start_btn.grab_focus()
