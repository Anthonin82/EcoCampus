extends Panel

@onready var itemDisplay: Sprite2D = %ItemDisplay

func update(item : InventoryItem):
	if !item:
		itemDisplay.visible = false
	else:
		itemDisplay.visible = true
		itemDisplay.texture = item.texture
