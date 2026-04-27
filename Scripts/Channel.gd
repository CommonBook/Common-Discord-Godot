class_name Discord_Channel extends Resource
## Creates and constructs channels.
##
## By default, initializing this class will take a dictionary and assemble the
## resource from the info within. This means that the [method new] method simply
## parses the output from discord. [br]
## To make a new channel, use [method create_channel].
## [br][br]
## When creating a new message, start with creating a reference.
## [codeblock]
## func _ready() -> void:
## 	var channel = Discord_Channel.create_channel()
## [/codeblock]
## This method takes a number of parameters and immediately adds a channel to a discord channel. 
## No need to apply it. It will return an object that stands in for that channel unless it fails. 
## It can be modified using a variety of non-static methods.

## ID of this channel if it exists.
var channel_id : String
## ID of the server this channel exists in.
var guild_id : String
## ID of the channel parent. Usually the category that it belongs to.
var parent_id : String
## Name of the channel when it was retrieved.
var channel_name : String
## Type of channel. [url=https://docs.discord.com/developers/resources/channel#channel-object-channel-types]More info.[/url]
var channel_type : float
## Position of the channel in the order.
var position : int 

func _init(body : Dictionary) -> void:
	# Sets the variables according to passed dictionary.
	
	self.channel_id = body["id"]
	
	# Guild ID
	if body.has("guild_id"):
		self.guild_id = body["guild_id"]
	else:
		self.guild_id = "null"
	
	# Parent ID (Category)
	if body.has("parent_id"):
		self.parent_id = parent_id
	else:
		self.parent_id = "null"
	
	# Channel name
	if body.has("name"):
		self.channel_name = body["name"]
	else:
		self.channel_name = "unnamed"
	
	self.position = body["position"]

## Creates a channel in a discord server given the server's guild ID.
## Returns a reference to the channel it creates.
static func create_channel(channel_name : String, guild_id : String) -> Discord_Channel:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	
	# Prepare channel	
	var message_url = Discord.BASE_URL+"/guilds/%s/channels"
	var payload = {
		"name":channel_name, # Name of the channel
		"permission_overwrites": [], # Specific permissions to be added for this channel
		"type": 0 # 0 is for text channels
	}
	
	# Post errors
	var err = bot_request.request(message_url % guild_id, Discord.headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != Error.OK:
		push_error("Failure creating channel: " + str(err))
		return
	
	var result = await bot_request.request_completed
	# Remove the request from the scene tree once it is done being used
	bot_request.call_deferred("queue_free")
	
	# Parse
	var body = result[3].get_string_from_utf8()
	body = JSON.parse_string(body)
	
	return Discord_Channel.new(body)

## Returns this channel's ID
func get_id() -> String:
	return self.channel_id

## Returns the ID of the server this channel is in
func get_guild_id() -> String:
	return self.guild_id

## Returns the name of this channel
func get_channel_name() -> String:
	return self.channel_name

## Updates the position of a channel locally and on Discord.
## [br] Note: To maintain the correct order, you should update all of the channels in a server.
## Otherwise, you may end up with channels who have the same position. Those are then ordered by their
## ID. This routine does not do that for you.
## [br][br]
## Must have a valid channel ID and guild ID.
## [br][br]
## To move between categories you will need to update the [param parent_id] of this channel.
## Channels are ordered within their categories.
func set_channel_position(new_position : int) -> void:
	if not self.channel_id:
		return
	if not self.guild_id:
		return
	
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	
	bot_request.connect("request_completed",Callable(self, "_on_request_complete"))
	
	# Prepare payload
	var patch_url = Discord.BASE_URL+"/guilds/%s/channels" % self.guild_id
	var payload = {
		"id":self.channel_id,
		"position":new_position
	}
	
	var err = bot_request.request(patch_url, Discord.headers, HTTPClient.METHOD_PATCH, JSON.stringify(payload))
	if err != Error.OK:
		push_error("Failed to update channel position: " + error_string(err))
		return
	
	var result = await bot_request.request_completed
	bot_request.call_deferred("queue_free")

## Get the message history of a channel.
## Returns an array of the last 100 messages in this channel as [Discord_Message]s
func get_channel_messages(channelID : String = self.channel_id) -> Array:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	# URL extenstion for retrieving messages (with a limit of 100)
	var message_url = Discord.BASE_URL+"/channels/%s/messages?limit=100"
	
	var err = bot_request.request(message_url % channelID, Discord.headers, HTTPClient.METHOD_GET)
	if err != Error.OK:
		push_error("Retrieval Error: " + error_string(err))
		return []
	var result = await bot_request.request_completed
	# Remove the request from the scene tree once it is done being used
	bot_request.call_deferred("queue_free")
	
	var body = result[3].get_string_from_utf8()
	body = JSON.parse_string(body)
	
	if typeof(body) == 4:
		body = [body]
	
	var messages : Array[Discord_Message]
	for message in body:
		if message is Dictionary:
			messages.append(Discord_Message.new(message))
	
	return messages

## Get a reference for a particular channel using its channel ID as a parameter.
## Static coroutine. Call with await.
static func get_channel_from_id(channelID : String) -> Discord_Channel:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	
	var channels_url = Discord.BASE_URL+"/channels/%s"
	
	var err = bot_request.request(channels_url % channelID, Discord.headers, HTTPClient.METHOD_GET)
	
	var result = await bot_request.request_completed
	bot_request.call_deferred("queue_free")
	
	if err != Error.OK:
		push_error("Failed fetching channel: " + str(err))
		print("Unable to get channel details using ID")
		return
	
	var details = JSON.parse_string(result[3].get_string_from_utf8())
	
	return Discord_Channel.new(details)

## Gets a [Discord_Chanel] used for direct messaging a user by using their user ID.
## [Discord_Channel]s constructed with this method are unnamed and have an empty guild id. 
## Static coroutine. Call with await.
static func get_user_channel_from_id(userID : String) -> Discord_Channel:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	# Url used for getting the channel ID for sending a DM
	var user_dm_url = Discord.BASE_URL+"/users/@me/channels"
	var payload = {
		"recipient_id": userID
	}
	
	var err = bot_request.request(user_dm_url, Discord.headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != Error.OK:
		print("Request Error: " + str(err))
		print("Unable to get user channel ID")
		return
	
	var result = await bot_request.request_completed
	bot_request.call_deferred("queue_free")
	
	# Extract the body
	var content = result[3]
	content = JSON.parse_string(content.get_string_from_utf8())
	
	return Discord_Channel.new(content)

func _on_request_complete(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200 or response_code == 201:
		var json = JSON.parse_string(body.get_string_from_utf8())
		
		print(json)
