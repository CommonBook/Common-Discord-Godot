class_name Discord_Channel extends Resource

var channel_id : String
var guild_id : String
var channel_name : String

func _init(body : Dictionary) -> void:
	self.channel_id = body["id"]
	if body.has("guild_id"):
		self.guild_id = body["guild_id"]
	else:
		self.guild_id = "null"
	
	if body.has("name"):
		self.channel_name = body["name"]
	else:
		self.channel_name = "unnamed"

## Returns this channel's ID
func get_id() -> String:
	return self.channel_id

## Returns the ID of the server this channel is in
func get_guild_id() -> String:
	return self.guild_id

## Returns the name of this channel
func get_channel_name() -> String:
	return self.channel_name

## Get the message history of a channel.
## Returns an array of the last 100 messages in this channel as [Discord_Message]s
func get_channel_messages(channelID : String = self.channel_id) -> Array:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	# URL extenstion for retrieving messages (with a limit of 100)
	var message_url = Discord.BASE_URL+"/channels/%s/messages?limit=100"
	
	var err = bot_request.request(message_url % channelID, Discord.headers, HTTPClient.METHOD_GET)
	if err != Error.OK:
		print("Retrieval Error: " + str(err))
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
## Static coroutine. Call with await. Returns a [Discord_Channel].
static func get_channel_from_id(channelID : String) -> Discord_Channel:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	
	var channels_url = Discord.BASE_URL+"/channels/%s"
	
	var err = bot_request.request(channels_url % channelID, Discord.headers, HTTPClient.METHOD_GET)
	
	var result = await bot_request.request_completed
	bot_request.call_deferred("queue_free")
	
	if err != Error.OK:
		print("Failed fetching channel: " + str(err))
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
