extends RefCounted

# Same beat keys as story.gd, plus:
# black  : true = the screen fades to black over 3 seconds
# ending : text of the closing card (this beat is the last one)

const CALL3 := {
	"i0": {
		"speaker": "",
		"portrait": "ines",
		"clock": "3:50 AM",
		"sun": 0.55,
		"text": "[i]Line three is already ringing. You haven't even touched the dial.[/i]",
		"next": "i1",
	},
	"i1": {
		"speaker": "INES",
		"tune": 96.8,
		"text": "Hi. Sorry. I only have a few minutes on my break. I just need to hear somebody who isn't beeping.",
		"next": "i2",
	},
	"i2": {
		"speaker": "INES",
		"text": "Night shift, fourth floor. Twenty-two hours, I think? I stopped counting around the third coffee.",
		"next": "i3",
	},
	"i3": {
		"speaker": "",
		"text": "[i]What do you say?[/i]",
		"choices": [
			{"text": "Who's covering for you?", "next": "i4a"},
			{"text": "Have you eaten anything?", "next": "i4b"},
		],
	},
	"i4a": {
		"speaker": "INES",
		"text": "Nobody. That's the thing. If I leave, Room 9 doesn't get checked. Mrs. Okafor hates being alone in the dark.",
		"next": "i5",
	},
	"i4b": {
		"speaker": "INES",
		"text": "There's a granola bar in my pocket. It's been there since... Tuesday? Last week? I can't really tell.",
		"next": "i5",
	},
	"i5": {
		"speaker": "INES",
		"text": "Every time I try to clock out, the badge reader just blinks at me. Red. Red. Red. I've tried three times.",
		"next": "i6",
	},
	"i6": {
		"speaker": "",
		"text": "[i]Behind her you hear squeaking shoes, a closing door, a long fluorescent hum. No one else is on the ward.[/i]",
		"next": "i7",
	},
	"i7": {
		"speaker": "INES",
		"text": "Funny thing. I did my rounds. Twice. Room 9's bed was empty both times, the sheets all made. I think they went home weeks ago.",
		"next": "i8",
	},
	"i8": {
		"speaker": "",
		"text": "[i]What do you say?[/i]",
		"choices": [
			{"text": "Maybe you can go home too.", "next": "i9a"},
			{"text": "What do you need right now, Ines?", "next": "i9b"},
		],
	},
	"i9a": {
		"speaker": "INES",
		"text": "Home. I haven't been home in... I sat down on the stairs, you know. Just for a second. Five minutes, between rounds.",
		"next": "i10",
	},
	"i9b": {
		"speaker": "INES",
		"text": "Honestly? Five minutes. Five minutes where nobody needs me. Is that a terrible thing to say?",
		"next": "i10",
	},
	"i10": {
		"speaker": "INES",
		"text": "I think I'm just tired, Wren. The kind of tired coffee doesn't fix.",
		"next": "i11",
	},
	"i11": {
		"speaker": "",
		"text": "[i]She doesn't need a lullaby. She needs a song that sounds like the end of a long shift: sunlight on a parking lot, keys in a pocket.[/i]",
		"hint_speaker": "INES",
		"records": [
			{"name": "Day Shift", "right": true, "next": "i12"},
			{"name": "Overtime", "hint": "Please. Never say that word to me again."},
			{"name": "Heartbeat", "hint": "I've heard enough steady beeping tonight, thank you."},
		],
	},
	"i12": {
		"speaker": "INES",
		"text": "Oh. That sounds like the parking lot at seven in the morning. Cold air, orange sky. I love that part.",
		"next": "i13",
	},
	"i13": {
		"speaker": "INES",
		"text": "I'm still in the stairwell, aren't I? I'm not on my break. I'm just sitting here.",
		"next": "i14",
	},
	"i14": {
		"speaker": "",
		"text": "[i]You pick your words with care.[/i]",
		"choices": [
			{"text": "Yes. But you can rest now.", "next": "i15a"},
			{"text": "Room 9 is fine, Ines. They're all fine.", "next": "i15b"},
		],
	},
	"i15a": {
		"speaker": "INES",
		"text": "Rest. Okay. Nobody's said that to me in a long time.",
		"next": "i16",
	},
	"i15b": {
		"speaker": "INES",
		"text": "Mrs. Okafor got home. I keep telling myself that. Okay. Okay, I believe you.",
		"next": "i16",
	},
	"i16": {
		"speaker": "INES",
		"text": "I'm going to go clock out now. The reader's going to work this time, I can feel it.",
		"next": "i17",
	},
	"i17": {
		"speaker": "INES",
		"text": "Thank you for staying on the line. Get some sleep, Wren. You sound like you could use some too.",
		"next": "i18",
	},
	"i18": {
		"speaker": "",
		"text": "[i]A badge reader chirps, once, green. Footsteps go down a stairwell, getting lighter.[/i]",
		"fade": true,
		"next": "i19",
	},
	"i19": {
		"speaker": "",
		"text": "[i]The lights on lines one, two and three are dark. Then a fourth light, one you've never seen, begins to glow, soft and white.[/i]",
		"next": "a0",
	},
}

const CALL4 := {
	"a0": {
		"speaker": "",
		"portrait": "alder",
		"clock": "5:20 AM",
		"sun": 0.85,
		"text": "[i]There has never been a fourth line. You've sat in this chair three months. You'd know.[/i]",
		"next": "a1",
	},
	"a1": {
		"speaker": "",
		"text": "[i]The dial drifts a little on its own, then stops. At the very edge of the band there's a voice you almost recognize.[/i]",
		"next": "a2",
	},
	"a2": {
		"speaker": "ALDER",
		"tune": 89.9,
		"text": "Evening, Wren. Or morning, I suppose. It's a good voice you've got. Better than mine ever was.",
		"next": "a3",
	},
	"a3": {
		"speaker": "ALDER",
		"text": "I used to sit in that chair. Thirty-one years. Same lamp, same microphone, same terrible coffee.",
		"next": "a4",
	},
	"a4": {
		"speaker": "",
		"text": "[i]What do you say?[/i]",
		"choices": [
			{"text": "Alder? You're retired.", "next": "a5a"},
			{"text": "How are you calling me?", "next": "a5b"},
		],
	},
	"a5a": {
		"speaker": "ALDER",
		"text": "Retired. That's what they told you, wasn't it? It's a gentle word. I always liked it.",
		"next": "a6",
	},
	"a5b": {
		"speaker": "ALDER",
		"text": "The same way they all did. The last voice on Route 9 never really hangs up.",
		"next": "a6",
	},
	"a6": {
		"speaker": "ALDER",
		"text": "Do you remember how you got here, Wren? Your first night? The rain on the road?",
		"next": "a7",
	},
	"a7": {
		"speaker": "",
		"text": "[i]You reach for it, and for the first time you find it. Headlights on wet asphalt. A turn taken too fast. A radio still playing in the dark. The station was ten minutes away.[/i]",
		"next": "a8",
	},
	"a8": {
		"speaker": "ALDER",
		"text": "You never made it to your first shift, kid. That was three months ago. And every night since, you've sat in my chair and answered everyone else's calls.",
		"next": "a9",
	},
	"a9": {
		"speaker": "",
		"text": "[i]What do you say?[/i]",
		"choices": [
			{"text": "...I didn't know.", "next": "a10a"},
			{"text": "Then why did the phones keep ringing?", "next": "a10b"},
		],
	},
	"a10a": {
		"speaker": "ALDER",
		"text": "Nobody does. That's what this station is for. It catches people in the static and keeps them company until they remember.",
		"next": "a11",
	},
	"a10b": {
		"speaker": "ALDER",
		"text": "Because somebody has to answer. That's the job. It was mine for thirty-one years. It became yours the moment you picked up.",
		"next": "a11",
	},
	"a11": {
		"speaker": "ALDER",
		"text": "You did that job beautifully tonight. Harold, Dessa, Ines. Every one of them walked out because you listened.",
		"next": "a12",
	},
	"a12": {
		"speaker": "ALDER",
		"text": "Now it's your turn to be listened to. One song, and then you decide.",
		"next": "a13",
	},
	"a13": {
		"speaker": "",
		"text": "[i]He wants the station's closing song. It's on the shelf. You know exactly which one, though you've never played it.[/i]",
		"hint_speaker": "ALDER",
		"records": [
			{"name": "Sign-Off", "right": true, "next": "a14"},
			{"name": "Truck Song", "hint": "Harold's already home. Let's not keep him."},
			{"name": "Last Dance", "hint": "That one belongs to Dessa. Find your own."},
		],
	},
	"a14": {
		"speaker": "ALDER",
		"text": "There it is. The old sign-off theme. I haven't heard that in a very long time.",
		"next": "a15",
	},
	"a15": {
		"speaker": "ALDER",
		"text": "The sun's nearly up. When it clears the hills, this station goes quiet, and whoever's in the chair goes with it. Or stays.",
		"next": "a16",
	},
	"a16": {
		"speaker": "ALDER",
		"text": "I won't tell you which is right. I'll only say the next caller won't wait forever, and neither will the morning.",
		"next": "a17",
	},
	"a17": {
		"speaker": "",
		"text": "[i]You look at the sunrise creeping along the strip. At line one. At the empty chair.[/i]",
		"choices": [
			{"text": "Sign off. Go home.", "next": "ea1"},
			{"text": "Stay. Somebody has to answer.", "next": "eb1"},
		],
	},
}

const ENDINGS := {
	# Ending 1: sign off
	"ea1": {
		"speaker": "WREN",
		"text": "This has been Dead Air. I'm Wren, and I'm signing off.",
		"next": "ea2",
	},
	"ea2": {
		"speaker": "",
		"clock": "6:00 AM",
		"sun": 1.0,
		"fade": true,
		"text": "[i]You switch off the red lamp. The booth fills with a soft gold light you've never seen from this window.[/i]",
		"next": "ea3",
	},
	"ea3": {
		"speaker": "ALDER",
		"text": "Thank you, kid. Sleep well.",
		"next": "ea4",
	},
	"ea4": {
		"speaker": "",
		"black": true,
		"text": "[i]Outside, the empty highway has headlights on it now. A long line of them, all going home.[/i]",
		"next": "ea5",
	},
	"ea5": {
		"sfx": "record",
		"speaker": "",
		"text": "[i]The last thing you hear is the old theme, playing for no one, and for everyone.[/i]",
		"ending": "ENDING 1 OF 2\nSIGN OFF",
	},
	# Ending 2: stay
	"eb1": {
		"speaker": "WREN",
		"text": "I'll stay. For the ones who are still on the road.",
		"next": "eb2",
	},
	"eb2": {
		"speaker": "ALDER",
		"text": "I was hoping you'd say that. And hoping you wouldn't. Both at once. That's how you know it's love, or the coffee.",
		"next": "eb3",
	},
	"eb3": {
		"speaker": "",
		"clock": "6:00 AM",
		"sun": 1.0,
		"fade": true,
		"text": "[i]Dawn climbs over the hills. Alder's voice dissolves into the hiss, warm, and not alone.[/i]",
		"next": "eb4",
	},
	"eb4": {
		"sfx": "ring",
		"speaker": "",
		"text": "[i]The light on line one starts to blink. The second hand on your wall clock takes its first step in three months.[/i]",
		"next": "eb5",
	},
	"eb5": {
		"speaker": "WREN",
		"black": true,
		"text": "Line one, you're on the air.",
		"next": "eb6",
	},
	"eb6": {
		"speaker": "",
		"text": "[i]Somewhere out on Route 9, someone is listening.[/i]",
		"ending": "ENDING 2 OF 2\nSTAY ON THE AIR",
	},
}


static func beats() -> Dictionary:
	var d := {}
	d.merge(CALL3)
	d.merge(CALL4)
	d.merge(ENDINGS)
	return d
