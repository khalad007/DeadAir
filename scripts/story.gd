extends RefCounted

# Beat keys:
# speaker : name shown above the text ("" for narration)
# text    : the line (BBCode allowed, but NOT on lines that have "tune")
# portrait: caller name ("" hides the portrait)
# tune    : radio frequency the player must find to read the line
# clock   : wall clock text, e.g. "2:30 AM"
# sun     : 0.0 to 1.0, position of the sunrise marker
# fade    : true = the portrait fades out
# next    : id of the next beat
# choices : list of {text, next}
# records : list of {name, right, hint, next} (shows the record shelf)
# hint_speaker: who reacts when a wrong record is picked

const CALL1 := {
	"intro": {
		"speaker": "WREN",
		"portrait": "",
		"clock": "1:00 AM",
		"sun": 0.0,
		"text": "It's one in the morning. You're listening to Dead Air, the last voice on Route 9.",
		"next": "intro2",
	},
	"intro2": {
		"speaker": "WREN",
		"text": "I'm Wren. If you're awake, you're not alone. The phone lines are open, the records are spinning, and the sun is a long way off.",
		"next": "intro3",
	},
	"intro3": {
		"speaker": "",
		"text": "[i]Alder used to say that every night, before he retired. Three months in the chair, and you still aren't sure you're any good at this.[/i]",
		"next": "intro4",
	},
	"intro4": {
		"speaker": "",
		"text": "[i]The red light on line one starts blinking. The signal is a mess. Drag the knob, or use the arrow keys, until the voice comes clear.[/i]",
		"next": "h0",
	},
	"h0": {
		"speaker": "WREN",
		"portrait": "harold",
		"text": "Line one, you're on the air.",
		"next": "h1",
	},
	"h1": {
		"speaker": "HAROLD",
		"tune": 91.6,
		"text": "Evening. Or morning. I've lost track. Can you hear me okay? The signal keeps going funny.",
		"next": "h2",
	},
	"h2": {
		"speaker": "HAROLD",
		"text": "I'm trying to get home. My daughter's birthday dinner. I'm late. I'm always late.",
		"next": "h3",
	},
	"h3": {
		"speaker": "",
		"text": "[i]What do you say?[/i]",
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
		"next": "h5b",
	},
	"h5b": {
		"speaker": "",
		"text": "[i]The clock on your wall says 1:07. The second hand hasn't moved in a while.[/i]",
		"next": "h5c",
	},
	"h5c": {
		"speaker": "HAROLD",
		"text": "My radio only picks up you, you know. Every other station is just hiss. Maybe that's why I called.",
		"next": "h5d",
	},
	"h5d": {
		"speaker": "HAROLD",
		"text": "When I drive her to school, Maisie hums the same tune every day. Off-key, rumbly, like wheels going over a bridge. I never learned the name.",
		"next": "h6",
	},
	"h6": {
		"speaker": "",
		"text": "[i]You run a finger along the shelf. Which record sounds like home to him?[/i]",
		"hint_speaker": "HAROLD",
		"records": [
			{"name": "Truck Song", "right": true, "next": "h7"},
			{"name": "Neon Waltz", "hint": "Pretty. But Maisie would never hum that. It sounds like a nightclub."},
			{"name": "Rain Exit", "hint": "Too sad. It's her birthday. I'm not showing up with that playing."},
		],
	},
	"h7": {
		"speaker": "HAROLD",
		"text": "...That's the one. Maisie hums this. Off-key, every single time. I forgot I knew it.",
		"next": "h8",
	},
	"h8": {
		"speaker": "HAROLD",
		"text": "Wren. The road ahead of me is... there's no road. Just headlights, and they aren't moving.",
		"next": "h9",
	},
	"h9": {
		"speaker": "HAROLD",
		"text": "There was a bridge. And the rain. And this song was playing. Then it was just quiet, and I kept driving anyway.",
		"next": "h10",
	},
	"h10": {
		"speaker": "",
		"text": "[i]Your throat is tight. You can't tell him. You can only choose what to say.[/i]",
		"choices": [
			{"text": "You're not late, Harold.", "next": "h11a"},
			{"text": "Is there something you want her to know?", "next": "h11b"},
		],
	},
	"h11a": {
		"speaker": "HAROLD",
		"text": "Not late. Huh. First time anyone's said that to me.",
		"next": "h12",
	},
	"h11b": {
		"speaker": "HAROLD",
		"text": "Tell her I was coming. Tell her I was always coming.",
		"next": "h12",
	},
	"h12": {
		"speaker": "",
		"text": "[i]You say you'll find a way. You don't know how. You mean it anyway.[/i]",
		"next": "h13",
	},
	"h13": {
		"speaker": "HAROLD",
		"text": "The road's clear now. I can see my exit. Happy birthday, Maisie.",
		"next": "h14",
	},
	"h14": {
		"speaker": "",
		"text": "[i]The line clicks. Harold's headlights melt into the static.[/i]",
		"fade": true,
		"next": "h15",
	},
	"h15": {
		"speaker": "WREN",
		"text": "...Thanks for calling. Drive safe.",
		"next": "d0",
	},
}

const CALL2 := {
	"d0": {
		"speaker": "",
		"portrait": "dessa",
		"clock": "2:30 AM",
		"sun": 0.25,
		"text": "[i]You barely catch your breath before line two lights up.[/i]",
		"next": "d1",
	},
	"d1": {
		"speaker": "DESSA",
		"tune": 103.3,
		"text": "Hi! Hi, is this working? I'm calling from the gym. It's so loud in here I can barely hear myself think.",
		"next": "d2",
	},
	"d2": {
		"speaker": "DESSA",
		"text": "I need to request a song. For the last dance. Everyone keeps saying it's coming up, but the DJ won't tell me when.",
		"next": "d3",
	},
	"d3": {
		"speaker": "",
		"text": "[i]What do you say?[/i]",
		"choices": [
			{"text": "Who are you dancing with?", "next": "d4a"},
			{"text": "What's the song?", "next": "d4b"},
		],
	},
	"d4a": {
		"speaker": "DESSA",
		"text": "Nobody yet. Tyler said he'd come. But I don't mind. I've been practicing in my room for weeks.",
		"next": "d5",
	},
	"d4b": {
		"speaker": "DESSA",
		"text": "I don't know the name! It's slow, and it starts with just a piano. It was on the radio when mom drove me to my appointments. I mean errands.",
		"next": "d5",
	},
	"d5": {
		"speaker": "DESSA",
		"text": "I look okay, right? Mom altered the dress three times. It's a little big now.",
		"next": "d6",
	},
	"d6": {
		"speaker": "",
		"text": "[i]Behind her voice you hear a faint, steady beep and a soft hiss. It isn't gym music.[/i]",
		"next": "d7",
	},
	"d7": {
		"speaker": "DESSA",
		"text": "Is it cold in here? Funny. I'm not cold. I can't really feel my corsage either. It's my first one.",
		"next": "d8",
	},
	"d8": {
		"speaker": "",
		"text": "[i]What do you say?[/i]",
		"choices": [
			{"text": "Where exactly is the gym, Dessa?", "next": "d9a"},
			{"text": "Tell me about the dress.", "next": "d9b"},
		],
	},
	"d9a": {
		"speaker": "DESSA",
		"text": "Down the hall, past the nurses'... past the, um. The big doors. I keep getting lost. This school has so many hallways.",
		"next": "d10",
	},
	"d9b": {
		"speaker": "DESSA",
		"text": "Blue. Mom said it matches my eyes. We hung it on my door for months, just waiting.",
		"next": "d10",
	},
	"d10": {
		"speaker": "DESSA",
		"text": "I was supposed to go last spring. Then I got a little sick. Then more sick. But I'm here now, right? That counts.",
		"next": "d11",
	},
	"d11": {
		"speaker": "",
		"text": "[i]She wants the slow one that starts with a piano. Something made for two people swaying in a dim room.[/i]",
		"hint_speaker": "DESSA",
		"records": [
			{"name": "Last Dance", "right": true, "next": "d12"},
			{"name": "Night Drive", "hint": "Too fast! I'd trip over my own dress."},
			{"name": "Lullaby", "hint": "That one's for sleeping. I'm not ready to sleep yet."},
		],
	},
	"d12": {
		"speaker": "DESSA",
		"text": "That's it. That's the one. The piano... oh. I can hear it everywhere.",
		"next": "d13",
	},
	"d13": {
		"speaker": "DESSA",
		"text": "I never made it to the dance, did I? I've been waiting in the hallway this whole time.",
		"next": "d14",
	},
	"d14": {
		"speaker": "",
		"text": "[i]Your voice isn't steady. You choose carefully.[/i]",
		"choices": [
			{"text": "You're here now. That counts.", "next": "d15a"},
			{"text": "I'll dance with you. Right here, through the radio.", "next": "d15b"},
		],
	},
	"d15a": {
		"speaker": "DESSA",
		"text": "That counts. Mom said it would.",
		"next": "d16",
	},
	"d15b": {
		"speaker": "DESSA",
		"text": "You would? Okay. Okay! Hold on, I'm just fixing my hair.",
		"next": "d16",
	},
	"d16": {
		"speaker": "DESSA",
		"text": "Tell Mom the dress was perfect. And that it's okay to take it off the door now.",
		"next": "d17",
	},
	"d17": {
		"speaker": "DESSA",
		"text": "It isn't even sad anymore. Just slow, and warm. Thanks for the last dance, Wren.",
		"next": "d18",
	},
	"d18": {
		"speaker": "",
		"text": "[i]The piano fades out. Somewhere, a blue dress is finally lifted down from a door.[/i]",
		"fade": true,
		"next": "d19",
	},
	"d19": {
		"speaker": "",
		"text": "[i]You sit in the silence for a long time. The third line is already blinking.[/i]",
		"next": "i0",  # Step 8 connects this to Call 3
	},
}


static func all_beats() -> Dictionary:
	var d := {}
	d.merge(CALL1)
	d.merge(CALL2)
	d.merge(preload("res://scripts/story2.gd").beats())
	return d
