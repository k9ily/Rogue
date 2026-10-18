extends Node2D
## Рогалик для iPhone 15 Pro Max.
## Шаг 11: Дроп оружия/брони с врагов + экипировка из инвентаря.

const SCREEN_W := 430.0
const SCREEN_H := 932.0
const SAFE_TOP := 59.0
const SAFE_BOTTOM := 34.0
const TILE_SIZE := 40.0
const MAP_BASE := 20
const MAP_GROWTH := 4
const SWIPE_THRESHOLD := 40.0

const PLAYER_MAX_HP := 10
const PLAYER_DAMAGE := 1
const HEAL_AMOUNT := 3
const LOOT_GOLD_AMOUNT := 5
const LOOT_HEAL_AMOUNT := 2
const LOOT_GOLD_CHANCE := 0.6
const SHIELD_CHARGES := 3

# ─── Цвета ───
const COLOR_BG         := Color(0.02, 0.02, 0.05)
const COLOR_WALL_BASE  := Color(0.15, 0.18, 0.25)
const COLOR_WALL_BRICK := Color(0.22, 0.26, 0.35)
const COLOR_WALL_HL    := Color(0.35, 0.40, 0.50)
const COLOR_FLOOR_A    := Color(0.25, 0.22, 0.18)
const COLOR_FLOOR_B    := Color(0.20, 0.18, 0.15)
const COLOR_FLOOR_LINE := Color(0.12, 0.10, 0.08)
const COLOR_PLAYER     := Color(0.35, 0.95, 0.40)
const COLOR_PLAYER_HL  := Color(0.65, 1.00, 0.65)
const COLOR_PETRIFIED  := Color(0.55, 0.55, 0.60)
const COLOR_HEAL       := Color(0.30, 0.95, 0.55)
const COLOR_HEAL_DK    := Color(0.10, 0.45, 0.20)
const COLOR_LOOT       := Color(0.95, 0.75, 0.20)
const COLOR_LOOT_DK    := Color(0.55, 0.40, 0.05)
const COLOR_EXIT       := Color(1.00, 0.82, 0.20)
const COLOR_EXIT_DK    := Color(0.60, 0.45, 0.05)
const COLOR_TORCH      := Color(1.0, 0.6, 0.1)
const COLOR_TORCH_BOSS := Color(0.7, 0.2, 1.0)

# ─── Редкости оружия / брони ───
const RARITY_COLORS := {
	"common": Color(0.8, 0.8, 0.8),
	"rare":   Color(0.3, 0.6, 1.0),
	"epic":   Color(0.8, 0.3, 1.0),
	"mythic": Color(1.0, 0.5, 0.0),
	"secret": Color(1.0, 0.1, 0.3)
}

const WEAPON_ABILITIES := {
	"epic":   ["burn", "poison", "freeze", "weaken"],
	"mythic": ["lifesteal", "chain", "stun", "execute", "blind"],
	"secret": ["divine_shield", "absolute_zero", "soul_eater", "time_rift", "absolute_power"]
}

const ARMOR_STATS := {"light": 2, "sturdy": 5, "heavenly": 10}

const ARMOR_NAMES := {
	"light": ["Кожаный доспех", "Тканевая роба", "Лёгкий жилет"],
	"sturdy": ["Кольчуга", "Стальной нагрудник", "Чешуйчатый доспех"],
	"heavenly": ["Небесная броня", "Ангельский доспех", "Доспех богов"]
}

const ARMOR_RARITY_COLORS := {
	"light": Color(0.7, 0.7, 0.7),
	"sturdy": Color(0.3, 0.6, 1.0),
	"heavenly": Color(1.0, 0.85, 0.3)
}

const ENEMY_TYPES := {
	"skeleton": {"hp": 2, "damage": 1, "dodge": 0.0, "aggro": 6, "speed": 1,
		"color": Color(0.90, 0.90, 0.85), "color_dark": Color(0.40, 0.40, 0.35),
		"name": "Скелет", "unlock_level": 1},
	"goblin": {"hp": 2, "damage": 1, "dodge": 0.3, "aggro": 6, "speed": 1,
		"color": Color(0.30, 0.60, 0.20), "color_dark": Color(0.15, 0.30, 0.10),
		"name": "Гоблин", "unlock_level": 3},
	"bat": {"hp": 1, "damage": 1, "dodge": 0.15, "aggro": 7, "speed": 2,
		"color": Color(0.50, 0.20, 0.60), "color_dark": Color(0.20, 0.10, 0.30),
		"name": "Летучая мышь", "unlock_level": 5},
	"eye": {"hp": 2, "damage": 1, "dodge": 0.0, "aggro": 4, "speed": 0, "range": 4,
		"color": Color(0.90, 0.80, 0.30), "color_dark": Color(0.50, 0.40, 0.10),
		"name": "Глаз", "unlock_level": 7},
	"big_skeleton": {"hp": 4, "damage": 2, "dodge": 0.0, "aggro": 7, "speed": 1,
		"color": Color(0.85, 0.85, 0.80), "color_dark": Color(0.35, 0.35, 0.30),
		"name": "Большой скелет", "unlock_level": 9},
	"slime": {"hp": 3, "damage": 1, "dodge": 0.0, "aggro": 5, "speed": 1,
		"color": Color(0.40, 0.90, 0.60), "color_dark": Color(0.15, 0.40, 0.20),
		"name": "Слизь", "unlock_level": 11},
	"zombie": {"hp": 5, "damage": 2, "dodge": 0.0, "aggro": 5, "speed": 1,
		"color": Color(0.45, 0.60, 0.40), "color_dark": Color(0.20, 0.30, 0.15),
		"name": "Зомби", "unlock_level": 13},
}

const BOSS_CYCLE := [
	{"type": "cyclops", "name": "Циклоп", "hp": 12, "damage": 3,
		"color": Color(0.75, 0.60, 0.40), "color_dark": Color(0.40, 0.30, 0.15)},
	{"type": "medusa", "name": "Медуза", "hp": 16, "damage": 2, "petrify": 0.2,
		"color": Color(0.45, 0.85, 0.55), "color_dark": Color(0.15, 0.40, 0.20)},
	{"type": "minotaur", "name": "Минотавр", "hp": 20, "damage": 4, "speed": 2,
		"color": Color(0.60, 0.35, 0.20), "color_dark": Color(0.30, 0.15, 0.05)},
	{"type": "cerberus", "name": "Цербер", "hp": 24, "damage": 3, "speed": 2,
		"color": Color(0.40, 0.25, 0.15), "color_dark": Color(0.15, 0.10, 0.05)},
	{"type": "hydra", "name": "Гидра", "hp": 28, "damage": 4, "regen": 2,
		"color": Color(0.20, 0.65, 0.45), "color_dark": Color(0.05, 0.30, 0.15)},
]

# ─── Класс для отрисовки меча от первого лица ───
class PlayerOverlay extends Node2D:
	var swing_timer: float = 0.0

	func trigger_swing() -> void:
		swing_timer = 1.0

	func _process(delta: float) -> void:
		if swing_timer > 0:
			swing_timer -= delta * 5.0
			if swing_timer < 0: swing_timer = 0
			queue_redraw()

	func _draw() -> void:
		if swing_timer > 0:
			var vp := get_viewport().get_visible_rect().size
			var t := 1.0 - swing_timer
			var swing := sin(t * PI)
			var base_pos := Vector2(vp.x * 0.7, vp.y + 50)
			var angle := lerp(-PI / 3, PI / 4, swing)
			var length := 350.0
			var tip := base_pos + Vector2(sin(angle), -cos(angle)) * length
			draw_line(base_pos, tip, Color(0.8, 0.8, 0.9, 0.9), 20.0)
			draw_line(base_pos, tip, Color(1, 1, 1, 0.8), 6.0)
			var guard_pos := base_pos + Vector2(sin(angle), -cos(angle)) * 60
			var perp := Vector2(cos(angle), sin(angle))
			draw_line(guard_pos - perp * 30, guard_pos + perp * 30, Color(0.6, 0.4, 0.1), 12.0)
			draw_line(base_pos, guard_pos, Color(0.4, 0.2, 0.1), 10.0)

var rng := RandomNumberGenerator.new()
var floor_cells: Dictionary = {}
var wall_cells: Dictionary = {}
var rooms: Array[Rect2i] = []
var player_cell := Vector2i.ZERO

# ─── Состояние игрока ───
var player_hp: float = PLAYER_MAX_HP
var player_max_hp: float = PLAYER_MAX_HP
var player_weapon: Dictionary = {}
var player_armor: Dictionary = {}
var player_shield: int = 0
var player_skip_turns: int = 0

var gold: int = 0
var exit_cell := Vector2i.ZERO
var enemies: Array[Dictionary] = []
var heal_zones: Array[Dictionary] = []
var loot_zones: Array[Dictionary] = []
var dropped_items: Array[Dictionary] = []
var level: int = 1
var busy: bool = false
var game_over: bool = false

# ─── ИНВЕНТАРЬ ───
var inventory: Array[Dictionary] = []
var inventory_open: bool = false
var ui_layer: CanvasLayer
var inventory_btn: Button
var inventory_panel: Control
var inventory_grid: GridContainer

var camera: Camera2D
var canvas_mod: CanvasModulate
var player_light: PointLight2D
var boss_ambient_light: PointLight2D
var torches: Array[Dictionary] = []
var torch_lights: Array[PointLight2D] = []
var cobwebs: Array[Vector2i] = []
var light_texture: GradientTexture2D
var hud: RichTextLabel
var game_over_label: Label
var message_label: Label
var message_timer: float = 0.0
var _touch_start := Vector2.ZERO
var _touch_active := false
var boss_room_rect: Rect2i = Rect2i()

var player_overlay: PlayerOverlay

func _ready() -> void:
	rng.randomize()
	_bind_debug_keys()
	_setup_visuals()
	_setup_camera()
	_setup_hud()
	_setup_ui()

	var weapon_layer := CanvasLayer.new()
	add_child(weapon_layer)
	player_overlay = PlayerOverlay.new()
	weapon_layer.add_child(player_overlay)

	_setup_starting_loadout()
	_start_level(1)

func _process(delta: float) -> void:
	if message_timer > 0:
		message_timer -= delta
		if message_timer <= 0 and message_label:
			message_label.visible = false

	var time := Time.get_ticks_msec() / 1000.0
	for i in range(torch_lights.size()):
		if is_instance_valid(torch_lights[i]):
			torch_lights[i].energy = 1.5 + sin(time * 5.0 + i) * 0.2
	if is_instance_valid(boss_ambient_light):
		boss_ambient_light.energy = 2.0 + sin(time * 3.0) * 0.4

	var needs_redraw := false
	for enemy in enemies:
		if enemy.get("anim_timer", 0.0) > 0:
			enemy["anim_timer"] = max(0.0, enemy["anim_timer"] - delta * 2.5)
			needs_redraw = true
	if needs_redraw:
		queue_redraw()

func _bind_debug_keys() -> void:
	_add_key("ui_right", KEY_D); _add_key("ui_left", KEY_A)
	_add_key("ui_up", KEY_W);    _add_key("ui_down", KEY_S)

func _add_key(action: StringName, keycode: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var ev := InputEventKey.new()
	ev.physical_keycode = keycode
	InputMap.action_add_event(action, ev)

func _setup_visuals() -> void:
	canvas_mod = CanvasModulate.new()
	canvas_mod.color = Color(0.2, 0.25, 0.35)
	add_child(canvas_mod)

	light_texture = GradientTexture2D.new()
	var gradient := Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 1))
	gradient.set_color(1, Color(1, 1, 1, 0))
	light_texture.gradient = gradient
	light_texture.fill = GradientTexture2D.FILL_RADIAL
	light_texture.width = 256
	light_texture.height = 256

	player_light = PointLight2D.new()
	player_light.texture = light_texture
	player_light.energy = 1.0
	player_light.color = Color(0.8, 1.0, 0.8)
	player_light.texture_scale = 2.0
	add_child(player_light)

func _setup_camera() -> void:
	camera = Camera2D.new()
	add_child(camera)
	camera.make_current()

func _setup_hud() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)

	hud = RichTextLabel.new()
	hud.bbcode_enabled = true
	hud.fit_content = true
	hud.scroll_active = false
	hud.position = Vector2(16, SAFE_TOP + 8)
	hud.size = Vector2(SCREEN_W - 120, 140)
	hud.add_theme_color_override("default_color", Color(1, 1, 1))
	hud.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	hud.add_theme_constant_override("outline_size", 4)
	hud.add_theme_font_size_override("normal_font_size", 20)
	layer.add_child(hud)

	message_label = Label.new()
	message_label.anchor_left = 0; message_label.anchor_right = 1
	message_label.anchor_top = 1;  message_label.anchor_bottom = 1
	message_label.offset_top = -SAFE_BOTTOM - 70
	message_label.offset_bottom = -SAFE_BOTTOM - 30
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", 20)
	message_label.add_theme_color_override("font_color", Color(1, 1, 0.5))
	message_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	message_label.add_theme_constant_override("outline_size", 4)
	message_label.visible = false
	layer.add_child(message_label)

	game_over_label = Label.new()
	game_over_label.anchor_left = 0; game_over_label.anchor_right = 1
	game_over_label.anchor_top = 0.5; game_over_label.anchor_bottom = 0.5
	game_over_label.offset_top = -60; game_over_label.offset_bottom = 60
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	game_over_label.add_theme_font_size_override("font_size", 30)
	game_over_label.add_theme_color_override("font_color", Color(1, 0.35, 0.35))
	game_over_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	game_over_label.add_theme_constant_override("outline_size", 6)
	game_over_label.text = "GAME OVER\nТапни для рестарта"
	game_over_label.visible = false
	layer.add_child(game_over_label)

# ─── UI ИНВЕНТАРЯ ──────────────────────────────

func _setup_ui() -> void:
	ui_layer = CanvasLayer.new()
	ui_layer.layer = 10
	add_child(ui_layer)

	inventory_btn = Button.new()
	inventory_btn.text = "INV"
	inventory_btn.add_theme_font_size_override("font_size", 22)
	inventory_btn.position = Vector2(SCREEN_W - 80, SAFE_TOP + 10)
	inventory_btn.size = Vector2(60, 60)
	inventory_btn.pressed.connect(_toggle_inventory)
	ui_layer.add_child(inventory_btn)

	inventory_panel = Control.new()
	inventory_panel.anchor_left = 0; inventory_panel.anchor_right = 1
	inventory_panel.anchor_top = 0; inventory_panel.anchor_bottom = 1
	inventory_panel.visible = false
	ui_layer.add_child(inventory_panel)

	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.85)
	bg.anchor_left = 0; bg.anchor_right = 1
	bg.anchor_top = 0; bg.anchor_bottom = 1
	inventory_panel.add_child(bg)

	var title := Label.new()
	title.text = "РЮКЗАК"
	title.add_theme_font_size_override("font_size", 36)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.anchor_left = 0; title.anchor_right = 1
	title.offset_top = SAFE_TOP + 20
	title.offset_bottom = SAFE_TOP + 70
	inventory_panel.add_child(title)

	inventory_grid = GridContainer.new()
	inventory_grid.columns = 3
	inventory_grid.anchor_left = 0.5; inventory_grid.anchor_right = 0.5
	inventory_grid.anchor_top = 0.5; inventory_grid.anchor_bottom = 0.5
	inventory_grid.offset_left = -150; inventory_grid.offset_right = 150
	inventory_grid.offset_top = -150; inventory_grid.offset_bottom = 150
	inventory_grid.add_theme_constant_override("h_separation", 15)
	inventory_grid.add_theme_constant_override("v_separation", 15)
	inventory_panel.add_child(inventory_grid)

	var close_btn := Button.new()
	close_btn.text = "ЗАКРЫТЬ"
	close_btn.add_theme_font_size_override("font_size", 24)
	close_btn.anchor_left = 0.5; close_btn.anchor_right = 0.5
	close_btn.anchor_top = 1.0; close_btn.anchor_bottom = 1.0
	close_btn.offset_left = -100; close_btn.offset_right = 100
	close_btn.offset_top = -SAFE_BOTTOM - 80
	close_btn.offset_bottom = -SAFE_BOTTOM - 30
	close_btn.pressed.connect(_toggle_inventory)
	inventory_panel.add_child(close_btn)

	_update_inventory_ui()

func _toggle_inventory() -> void:
	inventory_open = not inventory_open
	inventory_panel.visible = inventory_open
	if inventory_open:
		_update_inventory_ui()

func _update_inventory_ui() -> void:
	if not inventory_grid: return
	for child in inventory_grid.get_children():
		child.queue_free()

	var max_slots := 9
	for i in range(max_slots):
		var slot := Panel.new()
		slot.custom_minimum_size = Vector2(85, 85)

		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.15, 0.15, 0.25, 0.9)
		style.border_width_left = 2; style.border_width_top = 2
		style.border_width_right = 2; style.border_width_bottom = 2
		style.border_color = Color(0.5, 0.5, 0.7)
		slot.add_theme_stylebox_override("panel", style)

		slot.gui_input.connect(_on_inv_slot_clicked.bind(i))

		var lbl := Label.new()
		lbl.anchor_right = 1; lbl.anchor_bottom = 1
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbl.add_theme_font_size_override("font_size", 12)

		if i < inventory.size():
			var item: Dictionary = inventory[i]
			lbl.text = item.get("name", "???")
			var col := Color.WHITE
			if item.get("is_armor", false):
				col = ARMOR_RARITY_COLORS.get(item.get("rarity", "light"), Color.WHITE)
			else:
				col = RARITY_COLORS.get(item.get("rarity", "common"), Color.WHITE)
			lbl.add_theme_color_override("font_color", col)
		else:
			lbl.text = "Пусто"
			lbl.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))

		slot.add_child(lbl)
		inventory_grid.add_child(slot)

func _on_inv_slot_clicked(event: InputEvent, idx: int) -> void:
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return
	if idx >= inventory.size(): return
	var item: Dictionary = inventory[idx]
	if item.get("is_armor", false):
		var old := player_armor
		player_armor = item
		inventory.remove_at(idx)
		if old.size() > 0: inventory.append(old)
		player_max_hp = float(PLAYER_MAX_HP + int(player_armor.get("hp", 0)))
		player_hp = minf(player_hp, player_max_hp)
		_flash_message("Надето: %s" % item["name"])
	else:
		var old := player_weapon
		player_weapon = item
		inventory.remove_at(idx)
		if old.size() > 0: inventory.append(old)
		_flash_message("Взято: %s" % item["name"])
	_update_inventory_ui()
	_update_hud()

# ─── СТАРТОВОЕ СНАРЯЖЕНИЕ ───

func _setup_starting_loadout() -> void:
	player_weapon = {
		"name": "Огненный клинок", "rarity": "epic",
		"damage": 1.0, "abilities": ["burn", "weaken"], "is_armor": false
	}
	player_armor = {
		"name": "Кожаный доспех", "rarity": "light", "hp": 2, "is_armor": true
	}
	player_max_hp = float(PLAYER_MAX_HP + int(player_armor["hp"]))
	player_hp = player_max_hp
	player_shield = 0

# ─── ОСТАЛЬНАЯ ЛОГИКА ────────────────────────────────────

func _flash_message(text: String) -> void:
	if message_label:
		message_label.text = text
		message_label.visible = true
		message_timer = 1.5

func _is_boss_level(lvl: int) -> bool:
	return lvl > 0 and lvl % 7 == 0

func _get_boss_for_level(lvl: int) -> Dictionary:
	var boss_index := (lvl / 7 - 1) % BOSS_CYCLE.size()
	var cycle := ((lvl / 7) - 1) / BOSS_CYCLE.size()
	var base: Dictionary = BOSS_CYCLE[boss_index].duplicate()
	base["hp"] = int(base["hp"] + cycle * 10)
	return base

func _start_level(new_level: int) -> void:
	level = new_level
	_generate_level(level)
	player_cell = rooms[0].get_center()
	exit_cell = rooms[rooms.size() - 1].get_center()
	if exit_cell == player_cell:
		var last := rooms[rooms.size() - 1]
		exit_cell = Vector2i(last.position.x + 1, last.position.y + 1)
	_populate_level()
	_update_camera()
	_update_hud()
	queue_redraw()

func _generate_level(lvl: int) -> void:
	floor_cells.clear(); wall_cells.clear(); rooms.clear()
	for light in torch_lights:
		if is_instance_valid(light): light.queue_free()
	torch_lights.clear()
	torches.clear()
	cobwebs.clear()
	if is_instance_valid(boss_ambient_light):
		boss_ambient_light.queue_free()
		boss_ambient_light = null
	boss_room_rect = Rect2i()

	var room_count := lvl + 1
	var map_size := MAP_BASE + lvl * MAP_GROWTH
	var attempts := 0
	while rooms.size() < room_count and attempts < 1000:
		attempts += 1
		var w := rng.randi_range(4, 7); var h := rng.randi_range(4, 7)
		var x := rng.randi_range(2, map_size - w - 2)
		var y := rng.randi_range(2, map_size - h - 2)
		var candidate := Rect2i(x, y, w, h)
		if _overlaps_any(candidate): continue
		rooms.append(candidate)
	while rooms.size() < room_count:
		var w := rng.randi_range(4, 7); var h := rng.randi_range(4, 7)
		var x := rng.randi_range(2, maxi(2, map_size - w - 2))
		var y := rng.randi_range(2, maxi(2, map_size - h - 2))
		rooms.append(Rect2i(x, y, w, h))
	for room in rooms:
		for rx in range(room.position.x, room.end.x):
			for ry in range(room.position.y, room.end.y):
				floor_cells[Vector2i(rx, ry)] = true
	for i in range(1, rooms.size()):
		var parent_idx := rng.randi_range(0, i - 1)
		_carve_corridor(rooms[i].get_center(), rooms[parent_idx].get_center())
	for cell in floor_cells.keys():
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				var n: Vector2i = cell + Vector2i(dx, dy)
				if not floor_cells.has(n): wall_cells[n] = true

	if _is_boss_level(lvl):
		boss_room_rect = rooms[rooms.size() - 1]
		boss_ambient_light = PointLight2D.new()
		boss_ambient_light.texture = light_texture
		boss_ambient_light.color = Color(1.0, 0.1, 0.1, 0.8)
		boss_ambient_light.energy = 2.0
		var room_center := Vector2(boss_room_rect.get_center()) * TILE_SIZE
		var max_dim := max(boss_room_rect.size.x, boss_room_rect.size.y) * TILE_SIZE
		boss_ambient_light.texture_scale = (max_dim / 128.0) * 1.5
		boss_ambient_light.position = room_center
		add_child(boss_ambient_light)

	for wall in wall_cells.keys():
		var adjacent_floors := 0
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				if floor_cells.has(wall + Vector2i(dx, dy)): adjacent_floors += 1
		if adjacent_floors > 0 and rng.randf() < 0.1:
			var is_boss_torch := false
			if boss_room_rect.size.x > 0:
				var expanded_rect := boss_room_rect.grow(1)
				if expanded_rect.has_point(wall): is_boss_torch = true
			torches.append({"pos": wall, "is_boss": is_boss_torch})
			var t_light := PointLight2D.new()
			t_light.texture = light_texture
			t_light.color = COLOR_TORCH_BOSS if is_boss_torch else COLOR_TORCH
			t_light.energy = 1.8 if is_boss_torch else 1.5
			t_light.texture_scale = 2.5
			t_light.position = Vector2(wall) * TILE_SIZE + Vector2(TILE_SIZE, TILE_SIZE) * 0.5
			add_child(t_light)
			torch_lights.append(t_light)
		elif adjacent_floors > 0 and rng.randf() < 0.2:
			cobwebs.append(wall)

func _overlaps_any(r: Rect2i) -> bool:
	var padded := Rect2i(r.position - Vector2i(2, 2), r.size + Vector2i(4, 4))
	for existing in rooms:
		if padded.intersects(existing): return true
	return false

func _carve_corridor(from: Vector2i, to: Vector2i) -> void:
	var cur := from
	while cur.x != to.x:
		floor_cells[cur] = true
		cur.x += sign(to.x - cur.x)
	while cur.y != to.y:
		floor_cells[cur] = true
		cur.y += sign(to.y - cur.y)
	floor_cells[cur] = true

func _populate_level() -> void:
	enemies.clear(); heal_zones.clear(); loot_zones.clear(); dropped_items.clear()
	if _is_boss_level(level):
		_spawn_boss()
		var minion_count := mini(level / 7, 3)
		for i in minion_count:
			var pos := _random_free_cell(3)
			if pos != Vector2i(-1, -1): _add_enemy(pos, "skeleton")
	else:
		var enemy_count := mini(1 + (level - 1) / 2, 6)
		for i in enemy_count:
			var pos := _random_free_cell(4)
			if pos == Vector2i(-1, -1): break
			_add_enemy(pos, _pick_enemy_type())
	var heal_chance := 0.60 if _is_boss_level(level) else 0.25
	if player_hp < float(PLAYER_MAX_HP) * 0.3 or rng.randf() < heal_chance:
		var pos := _random_free_cell(4)
		if pos != Vector2i(-1, -1): heal_zones.append({"pos": pos})
	if rng.randf() < 0.30:
		var pos := _random_free_cell(4)
		if pos != Vector2i(-1, -1): loot_zones.append({"pos": pos})

func _pick_enemy_type() -> String:
	var available: Array[String] = ["skeleton", "skeleton"]
	for type_name in ENEMY_TYPES:
		if type_name != "skeleton" and level >= ENEMY_TYPES[type_name]["unlock_level"]:
			available.append(type_name)
	return available[rng.randi() % available.size()]

# ─── ГЕНЕРАЦИЯ ОРУЖИЯ И БРОНИ ───

func _generate_random_weapon(lvl: int, forced_rarity: String = "") -> Dictionary:
	var rar := forced_rarity
	if rar == "":
		var roll := rng.randf()
		rar = "common"
		if lvl > 15 and roll < 0.05: rar = "secret"
		elif lvl > 10 and roll < 0.15: rar = "mythic"
		elif lvl > 5 and roll < 0.35: rar = "epic"
		elif lvl > 2 and roll < 0.60: rar = "rare"

	var dmg_bonus: float = {
		"common": 0.2, "rare": 0.6, "epic": 1.0, "mythic": 2.5, "secret": 5.0
	}.get(rar, 0.2)

	var is_magic := rng.randf() > 0.5
	var abils: Array = []
	if WEAPON_ABILITIES.has(rar):
		var pool: Array = WEAPON_ABILITIES[rar].duplicate()
		var count: int = {"epic": 1, "mythic": 2, "secret": 3}.get(rar, 0)
		for i in count:
			if pool.is_empty(): break
			abils.append(pool.pop_at(rng.randi() % pool.size()))

	return {
		"name": "Маг. оружие" if is_magic else "Физ. оружие",
		"rarity": rar, "damage": dmg_bonus, "abilities": abils,
		"is_armor": false
	}

func _generate_random_armor(lvl: int, forced_rarity: String = "") -> Dictionary:
	var rar := forced_rarity
	if rar == "":
		var roll := rng.randf()
		rar = "light"
		if lvl > 15 and roll < 0.05: rar = "heavenly"
		elif lvl > 8 and roll < 0.20: rar = "sturdy"
	var hp_bonus: int = ARMOR_STATS[rar]
	var names: Array = ARMOR_NAMES[rar]
	return {
		"name": names[rng.randi() % names.size()],
		"rarity": rar,
		"hp": hp_bonus,
		"is_armor": true
	}

func _drop_loot_from_enemy(enemy: Dictionary, pos: Vector2i) -> void:
	var is_boss: bool = enemy.get("is_boss", false)
	var difficulty := float(enemy["max_hp"]) + float(enemy["damage"]) * 1.5
	var weapon_chance := 1.0 if is_boss else clampf(0.10 + difficulty * 0.03, 0.10, 0.55)
	var armor_chance  := 0.7 if is_boss else clampf(0.05 + difficulty * 0.02, 0.05, 0.35)

	if rng.randf() < weapon_chance:
		var w: Dictionary
		if enemy.get("weapon", {}).size() > 0:
			w = enemy["weapon"].duplicate()
		else:
			w = _generate_random_weapon(level)
		w["is_armor"] = false
		dropped_items.append({"pos": pos, "item": w})

	if rng.randf() < armor_chance:
		var a := _generate_random_armor(level)
		dropped_items.append({"pos": pos, "item": a})

func _add_enemy(pos: Vector2i, type_name: String) -> void:
	var t: Dictionary = ENEMY_TYPES[type_name]
	var hp: float = float(t["hp"])
	if level > 10: hp += float((level - 10) / 5)

	var w_data := _generate_random_weapon(level)
	var enemy_weapon: Dictionary = w_data if rng.randf() < 0.3 else {}

	enemies.append({
		"pos": pos, "hp": hp, "max_hp": hp,
		"damage": t["damage"], "weapon": enemy_weapon,
		"type": type_name, "dodge": t["dodge"], "aggro": t["aggro"],
		"speed": t["speed"], "range": t.get("range", 1),
		"color": t["color"], "color_dark": t["color_dark"],
		"name": t["name"], "is_boss": false,
		"anim_timer": 0.0, "status": {}
	})

func _spawn_boss() -> void:
	var boss_data := _get_boss_for_level(level)
	var pos := Vector2i(-1, -1)
	if boss_room_rect.size.x > 0:
		for attempt in 30:
			var test_pos := Vector2i(
				rng.randi_range(boss_room_rect.position.x, boss_room_rect.end.x - 1),
				rng.randi_range(boss_room_rect.position.y, boss_room_rect.end.y - 1)
			)
			if test_pos != player_cell and test_pos != exit_cell and _enemy_index_at(test_pos) < 0:
				pos = test_pos
				break
	if pos == Vector2i(-1, -1): pos = _random_free_cell(6)

	var boss_rarity := "epic" if level < 14 else ("mythic" if level < 21 else "secret")
	var w_data := _generate_random_weapon(level, boss_rarity)

	enemies.append({
		"pos": pos, "hp": float(boss_data["hp"]), "max_hp": float(boss_data["hp"]),
		"damage": boss_data["damage"], "weapon": w_data, "type": boss_data["type"],
		"dodge": 0.0, "aggro": 30, "speed": boss_data.get("speed", 1),
		"range": 1, "color": boss_data["color"], "color_dark": boss_data["color_dark"],
		"name": boss_data["name"], "is_boss": true,
		"petrify": boss_data.get("petrify", 0.0), "regen": boss_data.get("regen", 0),
		"anim_timer": 0.0, "status": {}
	})
	_flash_message("БОСС: %s!" % boss_data["name"])

func _spawn_slime_split(pos: Vector2i) -> void:
	var count := 0
	for n in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		if count >= 2: break
		var new_pos: Vector2i = pos + n
		if floor_cells.has(new_pos) and new_pos != player_cell and _enemy_index_at(new_pos) < 0:
			enemies.append({
				"pos": new_pos, "hp": 1.0, "max_hp": 1.0, "damage": 1,
				"weapon": {}, "status": {},
				"type": "small_slime", "dodge": 0.0, "aggro": 5, "speed": 1,
				"range": 1, "color": Color(0.40, 0.90, 0.60),
				"color_dark": Color(0.15, 0.40, 0.20),
				"name": "Слизёнок", "is_boss": false,
				"anim_timer": 0.0
			})
			count += 1

func _random_free_cell(min_dist: int = 4) -> Vector2i:
	var keys := floor_cells.keys()
	for attempt in 80:
		var pos: Vector2i = keys[rng.randi() % keys.size()]
		if pos == player_cell or pos == exit_cell: continue
		if absi(pos.x - player_cell.x) + absi(pos.y - player_cell.y) < min_dist: continue
		if _enemy_index_at(pos) >= 0: continue
		if _zone_index_at(heal_zones, pos) >= 0: continue
		if _zone_index_at(loot_zones, pos) >= 0: continue
		return pos
	return Vector2i(-1, -1)

func _enemy_index_at(pos: Vector2i) -> int:
	for i in range(enemies.size()):
		if enemies[i]["pos"] == pos: return i
	return -1

func _zone_index_at(zones: Array, pos: Vector2i) -> int:
	for i in range(zones.size()):
		if zones[i]["pos"] == pos: return i
	return -1

func _unhandled_input(event: InputEvent) -> void:
	if game_over:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_reset_game()
		return

	if inventory_open:
		return

	if OS.has_feature("editor") or OS.has_feature("desktop"):
		if event.is_action_pressed("ui_right"): _try_step(Vector2i.RIGHT)
		elif event.is_action_pressed("ui_left"): _try_step(Vector2i.LEFT)
		elif event.is_action_pressed("ui_down"): _try_step(Vector2i.DOWN)
		elif event.is_action_pressed("ui_up"):   _try_step(Vector2i.UP)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_touch_start = event.position
			_touch_active = true
		elif _touch_active:
			_resolve_swipe(event.position)
			_touch_active = false

func _resolve_swipe(end_pos: Vector2) -> void:
	var delta := end_pos - _touch_start
	if delta.length() < SWIPE_THRESHOLD: return
	var dir: Vector2i
	if abs(delta.x) > abs(delta.y):
		dir = Vector2i(1 if delta.x > 0 else -1, 0)
	else:
		dir = Vector2i(0, 1 if delta.y > 0 else -1)
	_try_step(dir)

func _try_step(dir: Vector2i) -> void:
	if busy or game_over or inventory_open: return
	if player_skip_turns > 0:
		player_skip_turns -= 1
		_flash_message("Окаменел!")
		_end_player_turn()
		return
	var target := player_cell + dir
	var idx := _enemy_index_at(target)
	if idx >= 0:
		_player_attack(idx)
		return
	if not floor_cells.has(target): return
	player_cell = target
	_apply_tile_effect()
	_update_camera()
	queue_redraw()
	if player_cell == exit_cell:
		_advance_level()
		return
	_end_player_turn()

func _player_attack(idx: int) -> void:
	if idx < 0 or idx >= enemies.size(): return
	var enemy := enemies[idx]
	if rng.randf() < enemy.get("dodge", 0.0):
		_flash_message("%s уклонился!" % enemy["name"])
		_end_player_turn()
		return

	player_overlay.trigger_swing()

	var abilities: Array = player_weapon.get("abilities", [])
	var total_dmg: float = float(PLAYER_DAMAGE) + player_weapon.get("damage", 0.0)

	if "execute" in abilities and enemy["hp"] < enemy["max_hp"] * 0.2:
		total_dmg *= 2.0

	if "absolute_power" in abilities and rng.randf() < 0.05:
		total_dmg = 999.0
		_flash_message("💥 АБСОЛЮТНАЯ МОЩЬ!")

	if "absolute_zero" in abilities:
		enemy["status"]["freeze"] = maxi(enemy["status"].get("freeze", 0), 3)

	enemy["hp"] -= total_dmg

	if not enemy["status"].has("shield"):
		for ab in abilities:
			match ab:
				"burn":
					enemy["status"]["burn"] = 2
				"poison":
					enemy["status"]["poison"] = 3
				"freeze":
					enemy["status"]["freeze"] = 1
				"weaken":
					enemy["status"]["weaken"] = 2
				"stun":
					enemy["status"]["freeze"] = 2
				"blind":
					enemy["status"]["blind"] = 2
				"lifesteal":
					player_hp = minf(player_hp + 1.0, player_max_hp)
				"soul_eater":
					if enemy["hp"] <= 0:
						player_hp = minf(player_hp + 3.0, player_max_hp)
				"time_rift":
					for e in enemies:
						e["status"]["freeze"] = maxi(e["status"].get("freeze", 0), 1)
				"divine_shield":
					player_shield = SHIELD_CHARGES
				"chain":
					pass
				"execute", "absolute_zero", "absolute_power":
					pass

	if enemy["hp"] <= 0:
		var was_slime: bool = enemy["type"] == "slime"
		var was_boss: bool = enemy.get("is_boss", false)
		var pos: Vector2i = enemy["pos"]
		_drop_loot_from_enemy(enemy, pos)
		enemies.remove_at(idx)
		if was_slime: _spawn_slime_split(pos)
		if was_boss:
			player_hp = minf(player_hp + 5.0, player_max_hp)
			_flash_message("Босс повержен! +5 HP")
	_update_hud()
	queue_redraw()
	_end_player_turn()

func _apply_tile_effect() -> void:
	for i in range(heal_zones.size() - 1, -1, -1):
		if heal_zones[i]["pos"] == player_cell:
			player_hp = minf(player_hp + HEAL_AMOUNT, player_max_hp)
			heal_zones.remove_at(i); break
	for i in range(loot_zones.size() - 1, -1, -1):
		if loot_zones[i]["pos"] == player_cell:
			if rng.randf() < LOOT_GOLD_CHANCE: gold += LOOT_GOLD_AMOUNT
			else: player_hp = minf(player_hp + LOOT_HEAL_AMOUNT, player_max_hp)
			loot_zones.remove_at(i); break

	for i in range(dropped_items.size() - 1, -1, -1):
		if dropped_items[i]["pos"] == player_cell:
			var item: Dictionary = dropped_items[i]["item"]
			if inventory.size() < 9:
				inventory.append(item)
				_flash_message("Подобрано: %s" % item["name"])
				dropped_items.remove_at(i)
			else:
				_flash_message("Инвентарь полон!")
				break

func _end_player_turn() -> void:
	busy = true
	_update_hud()
	await get_tree().create_timer(0.1).timeout
	_move_enemies()
	busy = false
	_update_hud()
	queue_redraw()

func _move_enemies() -> void:
	for i in range(enemies.size() - 1, -1, -1):
		if i >= enemies.size(): continue
		var enemy: Dictionary = enemies[i]

		if enemy["status"].get("burn", 0) > 0:
			enemy["hp"] -= 1.0
			enemy["status"]["burn"] -= 1
		if enemy["status"].get("poison", 0) > 0:
			enemy["hp"] -= 1.0
			enemy["status"]["poison"] -= 1

		if enemy["hp"] <= 0:
			_drop_loot_from_enemy(enemy, enemy["pos"])
			enemies.remove_at(i)
			queue_redraw()
			continue

		if enemy["status"].get("freeze", 0) > 0:
			enemy["status"]["freeze"] -= 1
			continue

		if enemy.get("regen", 0) > 0:
			enemy["hp"] = minf(enemy["hp"] + enemy["regen"], enemy["max_hp"])

		var diff: Vector2i = player_cell - enemy["pos"]
		var dist := absi(diff.x) + absi(diff.y)
		var aggro: int = enemy["aggro"]

		var e_dmg: float = float(enemy["damage"])
		var wpn: Dictionary = enemy.get("weapon", {})
		if wpn.size() > 0:
			e_dmg += float(wpn.get("damage", 0.0))
		if enemy["status"].get("weaken", 0) > 0:
			e_dmg = maxf(0.5, e_dmg / 2.0)
			enemy["status"]["weaken"] -= 1

		var miss := false
		if enemy["status"].get("blind", 0) > 0:
			enemy["status"]["blind"] -= 1
			if rng.randf() < 0.5: miss = true

		if enemy["type"] == "eye" and dist > 0 and dist <= enemy.get("range", 4):
			enemy["anim_timer"] = 0.4
			if miss:
				_flash_message("%s промахнулся!" % enemy["name"])
			else:
				_damage_player(e_dmg, enemy)
			if game_over: return
			continue

		if dist <= 1:
			enemy["anim_timer"] = 0.4
			if miss:
				_flash_message("%s промахнулся!" % enemy["name"])
			else:
				_damage_player(e_dmg, enemy)
			if game_over: return
			continue

		if dist > aggro: continue
		_move_enemy_toward(enemy, enemy["speed"])

func _damage_player(amount: float, enemy: Dictionary) -> void:
	if player_shield > 0:
		player_shield -= 1
		_flash_message("🛡️ Щит поглотил удар! (%d)" % player_shield)
		return

	player_hp -= amount
	if enemy.get("petrify", 0.0) > 0 and rng.randf() < enemy["petrify"]:
		player_skip_turns = 1
		_flash_message("%s окаменил(а)!" % enemy.get("name", "Враг"))
	if player_hp <= 0:
		player_hp = 0
		game_over = true
		game_over_label.visible = true

func _move_enemy_toward(enemy: Dictionary, steps: int) -> void:
	for s in steps:
		var diff: Vector2i = player_cell - enemy["pos"]
		if diff == Vector2i.ZERO: return
		var dir: Vector2i
		if absi(diff.x) > absi(diff.y): dir = Vector2i(sign(diff.x), 0)
		else: dir = Vector2i(0, sign(diff.y))
		var target: Vector2i = enemy["pos"] + dir
		if floor_cells.has(target) and target != player_cell and _enemy_index_at(target) < 0:
			enemy["pos"] = target
		else:
			return

func _advance_level() -> void:
	busy = true
	queue_redraw()
	await get_tree().create_timer(0.25).timeout
	_start_level(level + 1)
	busy = false

func _reset_game() -> void:
	gold = 0; level = 1
	player_skip_turns = 0
	game_over = false; busy = false
	inventory_open = false
	inventory_panel.visible = false
	game_over_label.visible = false
	inventory.clear()
	dropped_items.clear()
	_setup_starting_loadout()
	_start_level(1)

func _update_camera() -> void:
	var target_pos := Vector2(player_cell) * TILE_SIZE + Vector2(TILE_SIZE, TILE_SIZE) * 0.5
	camera.global_position = target_pos
	if player_light: player_light.position = target_pos

func _update_hud() -> void:
	if not hud: return
	var boss_alive := false
	for e in enemies:
		if e.get("is_boss", false): boss_alive = true; break
	var prefix := "⚠ БОСС " if _is_boss_level(level) and boss_alive else ""

	var w_info := "Кулаки"
	if player_weapon.size() > 0:
		var r_color: String = RARITY_COLORS[player_weapon["rarity"]].to_html(false)
		w_info = "[color=#%s]%s[/color]" % [r_color, player_weapon["name"]]

	var a_info := "Нет"
	if player_armor.size() > 0:
		var a_color: String = ARMOR_RARITY_COLORS[player_armor["rarity"]].to_html(false)
		a_info = "[color=#%s]%s[/color]" % [a_color, player_armor["name"]]

	var shield_info := ""
	if player_shield > 0:
		shield_info = "  [color=#66ccff]🛡 x%d[/color]" % player_shield

	hud.text = "%sУровень %d\nHP: %d/%d   Золото: %d%s\n⚔ %s   🛡 %s" % [
		prefix, level, int(ceil(player_hp)), int(ceil(player_max_hp)),
		gold, shield_info, w_info, a_info
	]

# ─── Отрисовка мира ──────────────────────────────────────

func _draw() -> void:
	for cell in floor_cells.keys():
		_draw_floor_tile(cell)
	for cell in wall_cells.keys():
		_draw_wall_tile(cell)
	for cell in cobwebs:
		_draw_cobweb(cell)
	for torch_data in torches:
		_draw_torch(torch_data)

	var epos := Vector2(exit_cell) * TILE_SIZE
	draw_rect(Rect2(epos + Vector2(4, 4), Vector2(TILE_SIZE - 8, TILE_SIZE - 8)), COLOR_EXIT_DK)
	draw_rect(Rect2(epos + Vector2(8, 8), Vector2(TILE_SIZE - 16, TILE_SIZE - 16)), COLOR_EXIT)
	draw_circle(epos + Vector2(TILE_SIZE, TILE_SIZE) * 0.5, 4.0, Color.WHITE)

	for z in heal_zones:
		var zpos := Vector2(z["pos"]) * TILE_SIZE
		draw_rect(Rect2(zpos + Vector2(4, 4), Vector2(TILE_SIZE - 8, TILE_SIZE - 8)), COLOR_HEAL_DK)
		var cx := zpos + Vector2(TILE_SIZE, TILE_SIZE) * 0.5
		draw_rect(Rect2(cx + Vector2(-3, -10), Vector2(6, 20)), COLOR_HEAL)
		draw_rect(Rect2(cx + Vector2(-10, -3), Vector2(20, 6)), COLOR_HEAL)

	for z in loot_zones:
		var zpos := Vector2(z["pos"]) * TILE_SIZE
		draw_rect(Rect2(zpos + Vector2(4, 4), Vector2(TILE_SIZE - 8, TILE_SIZE - 8)), COLOR_LOOT_DK)
		draw_rect(Rect2(zpos + Vector2(8, 10), Vector2(TILE_SIZE - 16, TILE_SIZE - 20)), COLOR_LOOT)
		draw_rect(Rect2(zpos + Vector2(8, TILE_SIZE - 14), Vector2(TILE_SIZE - 16, 4)), COLOR_LOOT_DK)

	for d in dropped_items:
		_draw_dropped_item(d)

	for e in enemies:
		if not e.get("is_boss", false): _draw_enemy(e)
	for e in enemies:
		if e.get("is_boss", false): _draw_enemy(e)

	var pcol := COLOR_PETRIFIED if player_skip_turns > 0 else COLOR_PLAYER
	var ppos := Vector2(player_cell) * TILE_SIZE
	draw_rect(Rect2(ppos + Vector2(8, 6), Vector2(24, 28)), pcol)
	draw_rect(Rect2(ppos + Vector2(8, 6), Vector2(24, 28)), COLOR_PLAYER_HL, false, 2.0)
	draw_rect(Rect2(ppos + Vector2(12, 10), Vector2(16, 6)), COLOR_PLAYER_HL)
	draw_rect(Rect2(ppos + Vector2(14, 18), Vector2(4, 4)), Color.BLACK)
	draw_rect(Rect2(ppos + Vector2(22, 18), Vector2(4, 4)), Color.BLACK)

func _draw_dropped_item(d: Dictionary) -> void:
	var dpos := Vector2(d["pos"]) * TILE_SIZE
	var item: Dictionary = d["item"]
	var col: Color
	if item.get("is_armor", false):
		col = ARMOR_RARITY_COLORS.get(item.get("rarity", "light"), Color.WHITE)
	else:
		col = RARITY_COLORS.get(item.get("rarity", "common"), Color.WHITE)
	var center := dpos + Vector2(TILE_SIZE, TILE_SIZE) * 0.5
	var pts := PackedVector2Array([
		center + Vector2(0, -11),
		center + Vector2(11, 0),
		center + Vector2(0, 11),
		center + Vector2(-11, 0),
		center + Vector2(0, -11)
	])
	draw_colored_polygon(pts, col)
	draw_polyline(pts, Color.BLACK, 2.0)

func _draw_floor_tile(cell: Vector2i) -> void:
	var pos: Vector2 = Vector2(cell) * TILE_SIZE
	var base_col := COLOR_FLOOR_A if (cell.x * 3 + cell.y) % 2 == 0 else COLOR_FLOOR_B
	draw_rect(Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE)), base_col)
	draw_rect(Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE)), COLOR_FLOOR_LINE, false, 2.0)
	draw_rect(Rect2(pos + Vector2(2, 2), Vector2(TILE_SIZE - 4, TILE_SIZE - 4)), base_col.lightened(0.15), false, 1.0)

func _draw_wall_tile(cell: Vector2i) -> void:
	var pos: Vector2 = Vector2(cell) * TILE_SIZE
	draw_rect(Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE)), COLOR_WALL_BASE)
	var b_w := TILE_SIZE / 2.0
	var b_h := TILE_SIZE / 2.0
	for i in 2:
		for j in 2:
			var b_pos := pos + Vector2(i * b_w, j * b_h)
			draw_rect(Rect2(b_pos + Vector2(1, 1), Vector2(b_w - 2, b_h - 2)), COLOR_WALL_BRICK)
			draw_line(b_pos + Vector2(1, 1), b_pos + Vector2(b_w - 1, 1), COLOR_WALL_HL, 1.5)
			draw_line(b_pos + Vector2(1, 1), b_pos + Vector2(1, b_h - 1), COLOR_WALL_HL, 1.5)
			draw_line(b_pos + Vector2(b_w - 1, 1), b_pos + Vector2(b_w - 1, b_h - 1), COLOR_WALL_BASE, 1.5)
			draw_line(b_pos + Vector2(1, b_h - 1), b_pos + Vector2(b_w - 1, b_h - 1), COLOR_WALL_BASE, 1.5)

func _draw_torch(torch_data: Dictionary) -> void:
	var cell: Vector2i = torch_data["pos"]
	var is_boss: bool = torch_data.get("is_boss", false)
	var pos: Vector2 = Vector2(cell) * TILE_SIZE
	var cx := pos + Vector2(TILE_SIZE * 0.5, TILE_SIZE * 0.5)
	draw_rect(Rect2(cx + Vector2(-2, -2), Vector2(4, 12)), Color(0.3, 0.15, 0.05))
	draw_rect(Rect2(cx + Vector2(-6, 8), Vector2(12, 4)), Color(0.15, 0.15, 0.15))
	if is_boss:
		draw_circle(cx + Vector2(0, -6), 8.0, Color(0.6, 0.1, 0.9, 0.6))
		draw_circle(cx + Vector2(0, -6), 5.0, Color(0.8, 0.3, 1.0, 0.8))
		draw_circle(cx + Vector2(0, -6), 2.5, Color.WHITE)
	else:
		draw_circle(cx + Vector2(0, -6), 8.0, Color(1.0, 0.3, 0.0, 0.6))
		draw_circle(cx + Vector2(0, -6), 5.0, Color(1.0, 0.7, 0.0, 0.8))
		draw_circle(cx + Vector2(0, -6), 2.5, Color.WHITE)

func _draw_cobweb(cell: Vector2i) -> void:
	var pos: Vector2 = Vector2(cell) * TILE_SIZE
	var c := Color(0.8, 0.8, 0.9, 0.3)
	var corner := rng.randi() % 4
	var origin := pos
	if corner == 0: origin = pos + Vector2(0, 0)
	elif corner == 1: origin = pos + Vector2(TILE_SIZE, 0)
	elif corner == 2: origin = pos + Vector2(0, TILE_SIZE)
	else: origin = pos + Vector2(TILE_SIZE, TILE_SIZE)
	draw_line(origin, origin + Vector2(15, 15), c, 1.0)
	draw_line(origin, origin + Vector2(25, 5), c, 1.0)
	draw_line(origin, origin + Vector2(5, 25), c, 1.0)
	draw_line(origin + Vector2(10, 10), origin + Vector2(18, 4), c, 1.0)
	draw_line(origin + Vector2(10, 10), origin + Vector2(4, 18), c, 1.0)

# ─── Отрисовка врагов с анимациями ───────────────────────

func _draw_enemy(enemy: Dictionary) -> void:
	var base_pos := Vector2(enemy["pos"]) * TILE_SIZE
	var anim: float = enemy.get("anim_timer", 0.0)
	var draw_pos := base_pos

	if anim > 0:
		var p := anim / 0.4
		var ext := sin(p * PI)
		var target_pos := Vector2(player_cell) * TILE_SIZE + Vector2(20, 20)
		var my_pos := base_pos + Vector2(20, 20)
		var dir := (target_pos - my_pos).normalized()
		draw_pos += dir * (ext * 15.0)

	if enemy.get("is_boss", false):
		_draw_boss_visual(enemy, draw_pos, anim)
	else:
		_draw_regular_visual(enemy, draw_pos, anim)

	if enemy["hp"] < enemy["max_hp"]:
		_draw_hp_bar(base_pos, enemy["hp"], enemy["max_hp"])

func _draw_regular_visual(enemy: Dictionary, pos: Vector2, anim: float) -> void:
	var color: Color = enemy["color"]
	var color_dark: Color = enemy["color_dark"]
	var t: String = enemy["type"]
	var cx := pos + Vector2(20, 20)
	var p := anim / 0.4
	var ext := sin(p * PI) if anim > 0 else 0.0
	var target_pos := Vector2(player_cell) * TILE_SIZE + Vector2(20, 20)
	var dir_to_player := (target_pos - cx).normalized()

	match t:
		"skeleton":
			draw_rect(Rect2(cx + Vector2(-10, -12), Vector2(20, 16)), Color(0.9, 0.9, 0.85))
			draw_rect(Rect2(cx + Vector2(-6, -8), Vector2(4, 6)), Color.BLACK)
			draw_rect(Rect2(cx + Vector2(2, -8), Vector2(4, 6)), Color.BLACK)
			for i in 3:
				draw_rect(Rect2(cx + Vector2(-8, 6 + i * 4), Vector2(16, 2)), Color(0.8, 0.8, 0.75))
			draw_rect(Rect2(cx + Vector2(-14, 4), Vector2(4, 12)), Color(0.9, 0.9, 0.85))
			draw_rect(Rect2(cx + Vector2(10, 4), Vector2(4, 12)), Color(0.9, 0.9, 0.85))
			if anim > 0:
				var bone_tip := cx + dir_to_player * 30 * ext
				draw_line(cx + Vector2(10, 4), bone_tip, Color.WHITE, 4.0)
				draw_circle(bone_tip, 5, Color.WHITE)

		"big_skeleton":
			draw_rect(Rect2(cx + Vector2(-14, -14), Vector2(28, 20)), Color(0.95, 0.95, 0.9))
			draw_rect(Rect2(cx + Vector2(-8, -10), Vector2(6, 8)), Color.RED)
			draw_rect(Rect2(cx + Vector2(2, -10), Vector2(6, 8)), Color.RED)
			for i in 3:
				draw_rect(Rect2(cx + Vector2(-10, 8 + i * 4), Vector2(20, 3)), Color(0.85, 0.85, 0.8))
			draw_rect(Rect2(cx + Vector2(-18, 6), Vector2(6, 14)), Color(0.95, 0.95, 0.9))
			draw_rect(Rect2(cx + Vector2(12, 6), Vector2(6, 14)), Color(0.95, 0.95, 0.9))
			if anim > 0:
				var hit_tip := cx + dir_to_player * 35 * ext
				draw_line(cx + Vector2(12, 6), hit_tip, Color.WHITE, 6.0)

		"goblin":
			draw_rect(Rect2(cx + Vector2(-14, -14), Vector2(28, 28)), color_dark)
			draw_rect(Rect2(cx + Vector2(-8, -8), Vector2(16, 14)), color)
			draw_rect(Rect2(cx + Vector2(-18, -6), Vector2(6, 4)), color)
			draw_rect(Rect2(cx + Vector2(12, -6), Vector2(6, 4)), color)
			draw_rect(Rect2(cx + Vector2(-6, -4), Vector2(4, 4)), Color.YELLOW)
			draw_rect(Rect2(cx + Vector2(2, -4), Vector2(4, 4)), Color.YELLOW)
			draw_rect(Rect2(cx + Vector2(-4, -2), Vector2(2, 2)), Color.BLACK)
			draw_rect(Rect2(cx + Vector2(4, -2), Vector2(2, 2)), Color.BLACK)
			draw_line(cx + Vector2(12, 4), cx + Vector2(18, -6), Color(0.4, 0.2, 0.1), 4.0)
			draw_rect(Rect2(cx + Vector2(16, -10), Vector2(6, 8)), Color(0.5, 0.3, 0.15))
			if anim > 0:
				var club_tip := cx + dir_to_player * 30 * ext
				draw_line(cx + Vector2(12, 4), club_tip, Color(0.4, 0.2, 0.1), 6.0)

		"bat":
			draw_rect(Rect2(cx + Vector2(-6, -6), Vector2(12, 12)), color)
			draw_rect(Rect2(cx + Vector2(-18, -4), Vector2(12, 8)), color_dark)
			draw_rect(Rect2(cx + Vector2(6, -4), Vector2(12, 8)), color_dark)
			draw_line(cx + Vector2(-18, -4), cx + Vector2(-6, 2), color, 1.0)
			draw_line(cx + Vector2(18, -4), cx + Vector2(6, 2), color, 1.0)
			draw_rect(Rect2(cx + Vector2(-4, -2), Vector2(3, 3)), Color.RED)
			draw_rect(Rect2(cx + Vector2(1, -2), Vector2(3, 3)), Color.RED)
			draw_rect(Rect2(cx + Vector2(-4, -10), Vector2(3, 4)), color_dark)
			draw_rect(Rect2(cx + Vector2(1, -10), Vector2(3, 4)), color_dark)
			if anim > 0:
				var bite_pos := cx + dir_to_player * 20 * ext
				draw_circle(bite_pos, 5, Color.RED)

		"eye":
			draw_rect(Rect2(cx + Vector2(-14, -14), Vector2(28, 28)), color)
			draw_rect(Rect2(cx + Vector2(-6, -6), Vector2(12, 12)), Color.RED)
			draw_rect(Rect2(cx + Vector2(-3, -3), Vector2(6, 6)), Color.BLACK)
			draw_line(cx + Vector2(-14, -14), cx + Vector2(-18, -18), color_dark, 2.0)
			draw_line(cx + Vector2(14, -14), cx + Vector2(18, -18), color_dark, 2.0)
			draw_line(cx + Vector2(-14, 14), cx + Vector2(-18, 18), color_dark, 2.0)
			draw_line(cx + Vector2(14, 14), cx + Vector2(18, 18), color_dark, 2.0)
			if anim > 0:
				var tgt := Vector2(player_cell) * TILE_SIZE + Vector2(20, 20)
				draw_line(cx, tgt, Color(1, 0, 0, ext), 3.0)

		"slime", "small_slime":
			var base_s := 10 if t == "small_slime" else 14
			var s := base_s + 6 * ext
			var sh := base_s - 6 * ext
			draw_rect(Rect2(cx + Vector2(-s, -sh / 2), Vector2(s * 2, sh)), color)
			draw_rect(Rect2(cx + Vector2(-s + 4, -sh / 2 - 4), Vector2(s * 2 - 8, 4)), color)
			draw_rect(Rect2(cx + Vector2(-s + 4, -sh / 2 + 2), Vector2(4, 4)), Color(1, 1, 1, 0.6))
			draw_rect(Rect2(cx + Vector2(-6, 0), Vector2(4, 4)), Color.BLACK)
			draw_rect(Rect2(cx + Vector2(2, 0), Vector2(4, 4)), Color.BLACK)

		"zombie":
			draw_rect(Rect2(cx + Vector2(-12, -14), Vector2(24, 24)), color)
			draw_rect(Rect2(cx + Vector2(-8, -8), Vector2(6, 6)), color_dark)
			draw_rect(Rect2(cx + Vector2(4, -4), Vector2(8, 4)), color_dark)
			draw_rect(Rect2(cx + Vector2(-6, -4), Vector2(4, 4)), Color.RED)
			draw_rect(Rect2(cx + Vector2(2, -4), Vector2(4, 4)), Color.RED)
			draw_rect(Rect2(cx + Vector2(-16, 4) + dir_to_player * 15 * ext, Vector2(8, 6)), color)
			draw_rect(Rect2(cx + Vector2(8, 4) + dir_to_player * 15 * ext, Vector2(8, 6)), color)

		_:
			draw_rect(Rect2(cx + Vector2(-10, -10), Vector2(20, 20)), color)

func _draw_boss_visual(enemy: Dictionary, pos: Vector2, anim: float) -> void:
	var color: Color = enemy["color"]
	var color_dark: Color = enemy["color_dark"]
	var t: String = enemy["type"]
	var cx := pos + Vector2(20, 20)
	var p := anim / 0.4
	var ext := sin(p * PI) if anim > 0 else 0.0
	var target_pos := Vector2(player_cell) * TILE_SIZE + Vector2(20, 20)
	var dir_to_player := (target_pos - cx).normalized()

	var size := 36
	draw_rect(Rect2(cx + Vector2(-size / 2, -size / 2), Vector2(size, size)), color)
	draw_rect(Rect2(cx + Vector2(-size / 2, -size / 2), Vector2(size, size)), color_dark, false, 2.0)

	match t:
		"cyclops":
			draw_rect(Rect2(cx + Vector2(-8, -6), Vector2(16, 12)), Color.WHITE)
			draw_rect(Rect2(cx + Vector2(-4, -4), Vector2(8, 8)), Color.RED)
			draw_rect(Rect2(cx + Vector2(-2, -2), Vector2(4, 4)), Color.BLACK)
			draw_rect(Rect2(cx + Vector2(-8, 8), Vector2(16, 2)), Color.BLACK)
			draw_rect(Rect2(cx + Vector2(-16, -18), Vector2(6, 10)), Color(0.9, 0.9, 0.8))
			draw_rect(Rect2(cx + Vector2(10, -18), Vector2(6, 10)), Color(0.9, 0.9, 0.8))
			if anim > 0:
				var fist_pos := cx + dir_to_player * 20 * ext
				draw_rect(Rect2(fist_pos + Vector2(-10, -10), Vector2(20, 20)), color)
				draw_rect(Rect2(fist_pos + Vector2(-10, -10), Vector2(20, 20)), color_dark, false, 2.0)

		"medusa":
			for i in 5:
				var angle := -PI + i * (PI / 4)
				draw_line(cx + Vector2(0, -10), cx + Vector2(cos(angle), sin(angle)) * 18, color_dark, 3.0)
			draw_rect(Rect2(cx + Vector2(-10, -4), Vector2(20, 16)), color)
			draw_rect(Rect2(cx + Vector2(-6, 0), Vector2(4, 4)), Color.RED)
			draw_rect(Rect2(cx + Vector2(2, 0), Vector2(4, 4)), Color.RED)
			if anim > 0:
				var tgt := Vector2(player_cell) * TILE_SIZE + Vector2(20, 20)
				draw_line(cx + Vector2(-6, 0), tgt, Color(0, 1, 0, ext), 3.0)
				draw_line(cx + Vector2(6, 0), tgt, Color(0, 1, 0, ext), 3.0)

		"minotaur":
			draw_rect(Rect2(cx + Vector2(-12, -10), Vector2(24, 24)), color)
			draw_rect(Rect2(cx + Vector2(-4, 2), Vector2(8, 6)), color_dark)
			draw_rect(Rect2(cx + Vector2(-8, -6), Vector2(4, 4)), Color.RED)
			draw_rect(Rect2(cx + Vector2(4, -6), Vector2(4, 4)), Color.RED)
			draw_rect(Rect2(cx + Vector2(-18, -18), Vector2(8, 10)), Color(0.95, 0.95, 0.9))
			draw_rect(Rect2(cx + Vector2(10, -18), Vector2(8, 10)), Color(0.95, 0.95, 0.9))
			if anim > 0:
				draw_circle(cx, 25 * ext, Color(1, 0, 0, ext * 0.5))

		"cerberus":
			for x in [-12, 0, 12]:
				draw_rect(Rect2(cx + Vector2(x - 6, -10), Vector2(12, 14)), color)
				draw_rect(Rect2(cx + Vector2(x - 4, -6), Vector2(3, 3)), Color.RED)
				draw_rect(Rect2(cx + Vector2(x + 1, -6), Vector2(3, 3)), Color.RED)
				draw_rect(Rect2(cx + Vector2(x - 6, -14), Vector2(4, 4)), color_dark)
				draw_rect(Rect2(cx + Vector2(x + 2, -14), Vector2(4, 4)), color_dark)
			if anim > 0:
				var bite_pos := cx + dir_to_player * 25 * ext
				draw_circle(bite_pos, 10, Color.RED)

		"hydra":
			draw_line(cx + Vector2(-10, 10), cx + Vector2(-16, -14), color, 4.0)
			draw_line(cx + Vector2(0, 10), cx + Vector2(0, -18), color, 4.0)
			draw_line(cx + Vector2(10, 10), cx + Vector2(16, -14), color, 4.0)
			draw_rect(Rect2(cx + Vector2(-22, -18), Vector2(12, 10)), color)
			draw_rect(Rect2(cx + Vector2(-6, -22), Vector2(12, 10)), color)
			draw_rect(Rect2(cx + Vector2(10, -18), Vector2(12, 10)), color)
			for h_pos in [Vector2(-18, -16), Vector2(-2, -20), Vector2(14, -16)]:
				draw_rect(Rect2(cx + h_pos, Vector2(3, 3)), Color.RED)
				draw_rect(Rect2(cx + h_pos + Vector2(4, 0), Vector2(3, 3)), Color.RED)
			if anim > 0:
				var tgt := Vector2(player_cell) * TILE_SIZE + Vector2(20, 20)
				draw_line(cx, tgt, Color(0.2, 1.0, 0.2, ext), 6.0)
				draw_line(cx, tgt, Color(1.0, 1.0, 0.2, ext), 2.0)

		_:
			draw_rect(Rect2(cx + Vector2(-10, -10), Vector2(20, 20)), Color.WHITE)

func _draw_hp_bar(pos: Vector2, hp: float, max_hp: float) -> void:
	var bar_pos := pos + Vector2(4, -6)
	var w := TILE_SIZE - 8
	draw_rect(Rect2(bar_pos, Vector2(w, 4)), Color.BLACK)
	var ratio := clampf(hp / max_hp, 0.0, 1.0)
	var bar_color := Color(0.9, 0.2, 0.2)
	draw_rect(Rect2(bar_pos, Vector2(w * ratio, 4)), bar_color)
	draw_rect(Rect2(bar_pos, Vector2(w, 4)), Color(0, 0, 0), false, 1.0)
