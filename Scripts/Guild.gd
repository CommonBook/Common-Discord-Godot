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

## Retrieves a list of [Discord_Channel]s present in a guild. All of them. Also gets the details of the channels.
## This has linear time complexity, so the larger the server, the longer it will take. 
func get_channels_in_guild() -> Array[Discord_Channel]:
	var id = self.guild_id
	var details = await Discord.discord_get(["guilds","channels"],[id])
	
	var return_list : Array[Discord_Channel]
	if details != []:
		for dict in details:
			if dict.has("id"):
				var chan_obj = await Discord_Channel.get_channel_from_id(dict["id"])
				# Skip if the response fails. 
				if chan_obj == null:
					continue
				return_list.append(chan_obj)
		return return_list
	else:
		# If the response contained nothing.
		return []

## Same bahavior as [method get_channels_in_guild] but returns the dictionary response from the server.
## Since the response is an array, it will be packaged in a dictionary under key [code]"response"[/code].
## [br][br]
## Set [param full_response] to true to get the full raw response from the server.
func get_channels_in_guild_raw(full_response : bool = false) -> Variant:
	var id = self.guild_id
	var details
	
	details = await Discord.discord_get(["guilds","channels"],[id]) if not full_response else await Discord.discord_get(["guilds","channels"],[id], true)
	
	if details is Dictionary and not full_response:
		push_error("Failed to retrieve list of channels.")
		return []
	
	if full_response:
		return details
	
	var return_list
	if details != []:
		return details
	else:
		# If the response failed.
		return []

## Retrieves a Discord guild using its id. If it fails, will return an empty [Discord_Guild] 
static func get_guild_by_id(guildID : String) -> Discord_Guild:
	var details = await Discord.discord_get("guilds", guildID)
	
	if details != {} and typeof(details) != TYPE_ARRAY:
		return Discord_Guild.new(details)
	else:
		# If the response failed.
		return

func _on_request_complete(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200 or response_code == 201:
		var json = JSON.parse_string(body.get_string_from_utf8())
		
		print(json)
