@tool

extends Control
class_name InventorySlot

@export var inventory_item_scene: PackedScene = preload("res://Items/InventoryItem.tscn")

@export var item: InventoryItem
@export var hint_item: InventoryItem = null

enum InventorySlotAction {
	SELECT, SPLIT, # for item selection
}

signal slot_input(which: InventorySlot, action: InventorySlotAction)
signal slot_hovered(which: InventorySlot, is_hovering: bool)

func _ready() -> void:
	add_to_group("inventory_slots")

# when slot is clicked
func _on_inventory_slot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			slot_input.emit(
				self, InventorySlotAction.SELECT
			)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			slot_input.emit(
				self, InventorySlotAction.SPLIT
			)

# when slot is mouse over and off
func _on_inventory_slot_mouse_entered() -> void:
	slot_hovered.emit(self, true)
func _on_inventory_slot_mouse_exited() -> void:
	slot_hovered.emit(self, false)

# Removes item from slot
func remove_item():
	if item:
		self.remove_child(item)
		item.free()
		item = null
		update_slot()

# removes item from slot, puts it on mouse
func select_item() -> InventoryItem:
	# get inventory
	var inventory = self.get_parent().get_parent()
	var tmp_item := self.item
	if tmp_item:
		tmp_item.reparent(inventory)
		self.item = null
		# place in front
		tmp_item.z_index = 128
	return tmp_item
	
# puts item on mouse into slot, reparents item in slot of present
func deselect_item(new_item: InventoryItem) -> InventoryItem:
	if not is_respecting_hint(new_item):
		return new_item
	# get inventory
	var inventory = self.get_parent().get_parent()
	# check if slot is empty
	# simply place if true
	if self.is_empty():
		new_item.reparent(self)
		self.item = new_item
		# place even with inventory
		self.item.z_index = 64
		return null
	else:
		# check if slot has same item as mouse
		# stack if they do
		if self.has_same_item(new_item):
			print("Has same item")
			self.item.amount += new_item.amount
			new_item.free()
			return null
		# if item in slot and on mouse are different, swap
		else:
			new_item.reparent(self)
			self.item.reparent(inventory)
			var tmp_item = self.item
			self.item = new_item
			# place even with inventory
			new_item.z_index = 64
			# place in front of inventory
			tmp_item.z_index = 128
			return tmp_item

# check if item selected matches hint item amount
func is_respecting_hint(new_item: InventoryItem, in_amount_as_well: bool = true) -> bool:
	# not hint item
	if not hint_item:
		return true
	if in_amount_as_well:
		return (new_item.item_name == self.hint_item.item_name 
		and new_item.amount >= self.hint_item.amount)
	else:
		return new_item.item_name == self.hint_item.item_name

# select only half of the items in stack
func split_item() -> InventoryItem:
	# slot is empty
	if self.is_empty():
		return null
	# get inventory
	var inventory = self.get_parent().get_parent()
	# stacks of 2 or more get split in half
	if self.item.amount > 1:
		var new_item: InventoryItem = inventory_item_scene.instantiate()
		new_item.set_data(
			self.item.item_name, 
			self.item.icon,
			self.item.is_stackable, 
			self.item.amount 
		)
		new_item.amount = self.item.amount / 2
		self.item.amount -= new_item.amount
		inventory.add_child(new_item)
		new_item.z_index = 128
		return new_item
	# one item gets picked up like normal
	elif self.item.amount == 1:
		return self.select_item()
	else:
		return null

# returns true if itemslot is empty
func is_empty():
	return self.item == null
	
# returns true if name of items are the same
func has_same_item(_item: InventoryItem):
	return _item.item_name == self.item.item_name

# updates value in inventory slot GUI
func update_slot():
	if item:
		if not self.get_children().has(item):
			add_child(item)
		#item.sprite.texture = item.icon
		#item.label.text = str(item.amount) + " - " + str(item.name)
		# if slot will be empty, make icon semi transparent
		if item.amount < 1:
			item.fade()
		# hint items are fake items to show player where to put an item
		if hint_item:
			if not self.get_children().has(hint_item):
				add_child(hint_item)
			hint_item.fade()

func set_item_hint(new_item_hint: InventoryItem):
	if self.hint_item:
		self.hint_item.free()
	self.hint_item = new_item_hint
	self.add_child(new_item_hint)
	update_slot()
