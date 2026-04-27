class_name Discord_Guild extends Resource
## Stores informmation relevant to a discord guild.
##
## Does NOT store other objects. Only retrieves information.
## Internally, Discord servers are called guilds so as to disambiguate between them and the actual
## server that the app runs on.

var guild_id : String
var guild_name : String

## Takes a "guild object" returned by the discord API and constructs a [Discord_Guild] resource.
func _init(info : Dictionary) -> void:
	if not (info.has("id") and info.has("name")):
		return
	
	self.guild_id = info["id"]
	self.guild_name = info["name"]

static func get_guild_by_id(guildID : String) -> Discord_Guild:
	var details = await Discord.discord_get("guilds", guildID)
	if details != {} and typeof(details) != TYPE_ARRAY:
		return Discord_Guild.new(details)
	else:
		# details[1] is the response code.
		if details[1] != 200 and details[1] != 201:
			Discord.response_code_error(details[1])
		return

func _on_request_complete(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200 or response_code == 201:
		var json = JSON.parse_string(body.get_string_from_utf8())
		
		print(json)
