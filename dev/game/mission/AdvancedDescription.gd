extends Control

var _init := false
var text:String
@onready var label: RichTextLabel = find_child("RichTextLabel")

func init(_text:String) -> Control:
	_init = true
	text = _text
	return self
	
func _ready():
	assert(_init)
	assert(label != null)
	label.text = text
	
	
func _on_close_button_pressed():
	queue_free()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
