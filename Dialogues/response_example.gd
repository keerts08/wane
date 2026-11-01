extends Button

const ICONS = {
	"knowledge": preload("res://icons/knowledge.png"),
	"health": preload("res://icons/health.png"),
	"speed": preload("res://icons/speed.png"),
	"shootspeed": preload("res://icons/shootspeed.png")
}

var response: Variant:
	set(value):
		text = value.text
		var tag = value.get_tag_value("icon")
		icon = ICONS.get(tag, icon)
