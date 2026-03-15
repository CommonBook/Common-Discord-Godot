@tool
extends EditorPlugin

func _enable_plugin() -> void:
	add_autoload_singleton("Discord", "Scripts/DiscordBot.gd")

func _disable_plugin():
	remove_autoload_singleton("Discord")
