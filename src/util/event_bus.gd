extends Node

# UI
signal ui_ready()
signal item_hovered(item_def)
signal item_unhovered(item_def)

# Portraits
signal portrait_changed(data)
signal reset_portrait()

# Inventory
signal item_picked_up(item_def, callback)
signal item_dropped(item_def)
