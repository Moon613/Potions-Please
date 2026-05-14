extends Control
class_name Inventory

signal JournalOpen
signal OrdersOpen
# create a String : Item dictionary
# add add_item to any increase to item
@onready var invConvert: Dictionary[String, Item] = {
	"dewdrops": $DewdropItem,
	"acorns": $AcornItem,
	"mandrake": $MandrakeItem,
	"eggs": $EggItem,
	"sap": $SapItem,
	"salts": $SaltsItem,
	"milk": $MilkItem,
	"lavender": $LavenderItem,
	"ginger": $GingerItem,
	"honey": $HoneyItem,
	"garlic": $GarlicItem,
	"wings": $WingsItem,
	"moss": $MossItem,
	
	"energy": $EnergyPotion,
	"sleep": $SleepPotion,
	"strength": $StrengthPotion,
	"healing": $HealingPotion,
	"shrink": $ShrinkPotion,
	"burnt": $BurntPotion
};

var inventory_item_scene = preload("res://Items/InventoryItem.tscn")

@export var rows: int = 4
@export var cols: int = 6

@export var inventory_grid: GridContainer

@export var inventory_slot_scene: PackedScene
var slots: Array[InventorySlot]

@export var tooltip: Tooltip

static var selected_item: Item = null


func _ready():
	inventory_grid.columns = cols
	for i in range(rows * cols):
		var slot = inventory_slot_scene.instantiate()
		slots.append(slot)
		inventory_grid.add_child(slot)
		slot.slot_input.connect(self._on_slot_input)
		slot.slot_hovered.connect(self._on_slot_hovered)
	tooltip.visible = false
	SaveManager.LoadInventory.connect(_on_load_inv);
	OrdersOpen.connect(GameInfo._on_quest_open);
	
func _input(event):
	# This layer is made visible in GameInfo._input and GameInfo._on_inventory_button_pressed
	if ((Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("inventory"))) and visible:
		visible = false;
		get_viewport().set_input_as_handled();

# moves selected item with mouse
func _process(_delta):
	tooltip.global_position = get_global_mouse_position() - Vector2(0, tooltip.size.y/2)
	if selected_item:
		tooltip.visible = false
		selected_item.global_position = get_global_mouse_position()
	$"PlayerPanel/VBoxContainer/Reputation Bar".value = GameInfo.reputation;
	$"PlayerPanel/VBoxContainer/Stamina Bar".value = GameInfo.energy;

# selects or deselects item
func _on_slot_input(which: InventorySlot, action: InventorySlot.InventorySlotAction):
	print(action)
	if not selected_item:
		if action == InventorySlot.InventorySlotAction.SELECT:
			selected_item = which.select_item()
		elif action == InventorySlot.InventorySlotAction.SPLIT:
			selected_item = which.split_item()
	else:
		selected_item = which.deselect_item(selected_item)

# when hovering over item
func _on_slot_hovered(which: InventorySlot, is_hovering: bool):
	if which.item:
		tooltip.set_text(which.item.item_name)
		tooltip.visible = is_hovering
	elif which.hint_item:
		tooltip.set_text(which.hint_item.item_name)
		tooltip.visible = is_hovering

# removes item from world and adds it to inventory
func add_item(item_name: String, amount: int) -> void:
	# convert string to Item
	
	print("adding " + str(amount) + " of " + item_name)
	var item: Item = invConvert[item_name]
	var _item: InventoryItem = inventory_item_scene.instantiate()
	_item.set_data(
		item.item_name, item.icon, item.is_stackable, amount
	)
	if item.is_stackable:
		for slot in slots:
			if slot.item and slot.item.item_name == _item.item_name: # if item and is of same type
				slot.item.amount += _item.amount
				if slot.item.amount <= 0:
					slot.remove_item()
				return
	for slot in slots:
		if slot.item == null and slot.is_respecting_hint(_item):
			slot.item = _item
			slot.update_slot()
			return

# remove item from inventory and return if it exists
func retrieve_item(_item_name: String) -> Item:
	for slot in slots:
		if slot.item and slot.item.item_name == _item_name:
			var copy_item := Item.new()
			copy_item.item_name = slot.item.item_name
			copy_item.name = copy_item.item_name
			copy_item.icon = slot.item.icon
			copy_item.is_stackable = slot.item.is_stackable
			if slot.item.amount > 1:
				slot.item.amount -= 1
			else:
				slot.remove_item()
			return copy_item
	return null

# get all items in inventory
func all_items() -> Array[Item]:
	var items: Array[Item] = []
	for slot in slots:
		if slot.item:
			items.append(slot.item)
	return items

# returns all items of a particular type
func all(_name: String) -> Array[Item]:
	var items: Array[Item] = []
	for slot in slots:
		if slot.item and slot.item.item_name == _name:
			items.append(slot.item)
	return items

# removes all items of a particular type
func remove_all(_name: String) -> void:
	for slot in slots:
		if slot.item and slot.item.item_name == _name:
			slot.remove_item()

# removes all items from inventory
func clear_inventory() -> void:
	print("clearing inventory")
	for slot in slots:
		print("clearing slot " + str(slot.name))
		slot.remove_item()

func _on_load_inv():
	#add items from game reasources
	var res = GameInfo.resources
	for item in res:
		var amount = res[item]
		if amount > 0:
			add_item(item,amount);
	var pot = GameInfo.potions
	for item in pot:
		var amount = pot[item]
		if amount > 0:
			add_item(item,amount);

func _on_journal_button_up() -> void:
	JournalOpen.emit()

func _on_orders_button_up() -> void:
	OrdersOpen.emit();
	
func set_items():
	print("setting items")
	var res = GameInfo.resources
	for item in res:
		var amount = res[item]
		if amount > 0 and (item == GameInfo.ACORNS or item == GameInfo.DEWDROPS or 
						   item == GameInfo.MANDRAKE or item == GameInfo.EGGS or item == GameInfo.SAP):
			add_item(item,amount);
	var pot = GameInfo.potions
	for item in pot:
		var amount = pot[item]
		if amount > 0:
			add_item(item,amount);
	pass

func _on_visibility_changed() -> void:
	if GameInfo.seenPotionBookFirstTime:
		print("panel visibility " + str(visible))
		if visible:
			set_items()
		else:
			clear_inventory()
