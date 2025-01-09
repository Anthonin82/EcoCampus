extends Control

@onready var game = find_parent("Game")
@onready var invRes: Inventory = preload("res://inventory/playerInventory.tres")
@onready var slots: Array = %Inventory.get_children()
@onready var archivedSlots: Array = %ArchivedInventory.get_children()

func _ready():
	invRes.update.connect(updateSlots)
	invRes.close.connect(close)
	self.visible = false
	updateSlots()


func updateSlots():
	for i in range(min(invRes.items.size(), slots.size())):
		slots[i].update(invRes.items[i])
	for i in range(min(invRes.archivedItems.size(), archivedSlots.size())):
		archivedSlots[i].update(invRes.archivedItems[i])


func _process(_delta: float) -> void:
	if Input.is_action_just_released("inventory") and !game.optionsOpened and Dialogic.current_timeline == null:
		toggleInventory()


func toggleInventory() -> void:
	self.visible = !self.visible
	game.pause() if self.visible else game.unpause()
	game.inventoryOpened = self.visible


func close():
	game.unpause()
	self.visible = false


func _on_close_button_pressed() -> void:
	close()
