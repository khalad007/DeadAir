extends Control

func _ready() -> void:
	%SpeakerLabel.text = "WREN"
	%DialogueText.text = "This is Dead Air. If you can hear me, you're not alone."
	%ClockLabel.text = "1:00 AM"
	%ChoicesPanel.visible = true
	%RecordShelf.visible = true  # temporary, only for this layout test
	print("Main ready, all nodes found")
