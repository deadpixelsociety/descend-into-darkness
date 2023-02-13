extends Node

# UI
signal ui_ready()

# Portraits
signal portrait_changed(data)
signal reset_portrait()

# Heroes
signal hero_health_changed(hero, max, current)

# Inventory
signal item_picked_up(item_def, callback)
signal item_dropped(item_def)
