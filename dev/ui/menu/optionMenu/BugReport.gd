extends Control


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	if meta=="mail":
		OS.shell_open("mailto:contact-project+dpuzenat-ecogame-57899008-issue-@incoming.gitlab.com")
	elif meta=="copy":
		DisplayServer.clipboard_set("contact-project+dpuzenat-ecogame-57899008-issue-@incoming.gitlab.com")
	else:
		assert(false, "unkown meta attribute : " + meta)
