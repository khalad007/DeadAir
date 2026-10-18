extends RefCounted

# Each entry is one "beat" of conversation.
# speaker : name shown above the text
# text    : the line (BBCode allowed, e.g. [i]italic[/i])
# portrait: caller name to show (matches art/caller_NAME.png), "" hides it
# next    : id of the next beat
# choices : list of {text, next}, used instead of "next"

const TEST := {
	"start": {
		"speaker": "WREN",
		"portrait": "",
		"text": "You're listening to Dead Air. It's one in the morning, and the road is empty.",
		"next": "s2",
	},
	"s2": {
		"speaker": "WREN",
		"text": "Line one is blinking. Hello, you're on the air.",
		"portrait": "harold",
		"next": "h1",
	},
	"h1": {
		"speaker": "HAROLD",
		"text": "Evening. Or morning. I've lost track. Can you hear me okay? The signal keeps going funny.",
		"next": "h2",
	},
	"h2": {
		"speaker": "HAROLD",
		"text": "I'm trying to get home. My daughter's birthday dinner. I'm late. I'm always late.",
		"next": "h3",
	},
	"h3": {
		"speaker": "WREN",
		"text": "[i](What do you say?)[/i]",
		"choices": [
			{"text": "Tell me about her.", "next": "h4a"},
			{"text": "How long have you been driving?", "next": "h4b"},
		],
	},
	"h4a": {
		"speaker": "HAROLD",
		"text": "Maisie. Eight years old, and sharper than me already. She draws trucks on everything. Even the walls.",
		"next": "h5",
	},
	"h4b": {
		"speaker": "HAROLD",
		"text": "Hours. Days, maybe. The highway's long, and it all looks the same after dark.",
		"next": "h5",
	},
	"h5": {
		"speaker": "HAROLD",
		"text": "Funny. I can't remember the last gas station I passed.",
		"next": "",
	},
}
