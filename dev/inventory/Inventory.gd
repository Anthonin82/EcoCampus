extends Resource
class_name Inventory

signal update
signal close

@export var items: Array[InventoryItem]
@export var archivedItems: Array[InventoryItem]

var alreadyLoaded := false

func insert(itemName: String) -> void:
	var itemPath = "res://inventory/items/"+itemName+".tres"
	if not ResourceLoader.exists(itemPath):
		push_error("Item path does not exist, cannot add item")
		return
	var item: InventoryItem = load(itemPath)
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			update.emit()
			return 
	push_error("Inventory is already full, cannot add item")

func insertArchived(itemName: String) -> void:
	var itemPath = "res://inventory/items/"+itemName+".tres"
	if not ResourceLoader.exists(itemPath):
		push_error("Item path does not exist, cannot add item")
		return
	var item: InventoryItem = load(itemPath)
	for i in range(archivedItems.size()):
		if archivedItems[i] == null:
			archivedItems[i] = item
			update.emit()
			return 
	push_error("Archived is already full, cannot add item")

func remove(itemName: String) -> void:
	for i in range(items.size()):
		if items[i] != null and items[i].name == itemName:
			items[i] = null
			update.emit()
			return
	push_error("Item not found in inventory, cannot remove item")

func moveToArchived(itemName: String) -> void:
	var firstFreeIndex = -1
	for i in range(archivedItems.size()):
		if archivedItems[i] == null:
			firstFreeIndex = i 
			break 
	push_error("Archived Inventory is already full, cannot add item")
	for i in range(items.size()):
		if items[i] != null and items[i].name == itemName:
			archivedItems[firstFreeIndex] = items[i]
			items[i] = null
			update.emit()
			return
	push_error("Item not found in inventory, cannot remove item")

# return array of items name
func itemToNameArray(array: Array) -> Array:
	var namesArray = []
	for item in array:
		if item != null:
			namesArray.append(item.name)
	return namesArray

func save():
	var itemsNames = itemToNameArray(items)
	var archItemsNames = itemToNameArray(archivedItems)
	SaveManager.setElement("Player",{"inventory":[itemsNames,archItemsNames]})

func loadInv():
	if !alreadyLoaded: # For some reason the Player's ready function is called 2 times 
		if SaveManager.getElement("Player","inventory") != null: 
			for item in SaveManager.getElement("Player","inventory")[0]:
				insert(item)
			for item in SaveManager.getElement("Player","inventory")[1]:
				insertArchived(item)
			alreadyLoaded = true
