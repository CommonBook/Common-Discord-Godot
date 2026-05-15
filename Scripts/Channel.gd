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

const TYPE_GUILD_TEXT : int = 0
const TYPE_DM : int = 1
const TYPE_GUILD_VOICE : int = 2
const TYPE_GROUP_DM : int = 3
const TYPE_GUILD_CATEGORY : int = 4
const TYPE_GUILD_ANNOUNCEMENT : int = 5
const TYPE_ANNOUNCEMENT_THREAD : int = 10
const TYPE_PUBLIC_THREAD : int = 11
const TYPE_PRIVATE_THREAD : int = 12
const TYPE_GUILD_STAGE_VOICE : int = 13
const TYPE_GUILD_DIRECTORY : int = 14
const TYPE_GUILD_FORUM : int = 15
const TYPE_GUILD_MEDIA : int = 16

## ID of this channel if it exists.
var channel_id : String
## The integer representing the type of channel this is.
var type : int
## ID of the server this channel exists in.
var guild_id : String
## ID of the channel parent. Usually the category that it belongs to.
var parent_id : String
## Name of the channel when it was retrieved. (1-100 characters)
var channel_name : String
## Type of channel. [url=https://docs.discord.com/developers/resources/channel#channel-object-channel-types]More info.[/url]
var channel_type : float
## Position of the channel in the order.
var position : int 

# Following entiries are copied straight from Discord.
## explicit permission overwrites for members and roles
var permission_overwrites : Array
## the channel topic (0-4096 characters for GUILD_FORUM and GUILD_MEDIA channels, 0-1024 characters for all others)
var topic : String
## whether the channel is age-restricted
var nsfw : bool
## the id of the last message sent in this channel (or thread for GUILD_FORUM or GUILD_MEDIA channels) (may not point to an existing or valid message or thread)
var last_message_id : String
## the bitrate (in bits per second) of the voice channel
var bitrate : int
## the user limit of the voice channel
var user_limit : int
## amount of seconds a user has to wait before sending another message (0-21600); bots, as well as users with the permission BYPASS_SLOWMODE, are unaffected
var rate_limit_per_user : int
## the recipients of the DM
var recipients : Array[Dictionary]
## icon hash of the group DM
var icon : String
## id of the creator of the group DM or thread
var owner_id : String
## application id of the group DM creator if it is bot-created
var application_id : String
## for group DM channels: whether the channel is managed by an application via the gdm.join OAuth2 scope
var managed : bool
## when the last pinned message was pinned. This may be null in events such as GUILD_CREATE when a message is not pinned.
var last_pin_timestamp : String
## voice region id for the voice channel, automatic when set to null
var rtc_region : String
## the camera video quality mode of the voice channel, 1 when not present
var video_quality_mode : int
## number of messages (not including the initial message or deleted messages) in a thread.
var message_count : int
## an approximate count of users in a thread, stops counting at 50
var member_count : int
## thread-specific fields not needed by other channels
var thread_metadata : Dictionary
## thread member object for the current user, if they have joined the thread, only included on certain API endpoints
var member : Dictionary
## default duration, copied onto newly created threads, in minutes, threads will stop showing in the channel list after the specified period of inactivity, can be set to: 60, 1440, 4320, 10080
var default_auto_archive_duration : int
## computed permissions for the invoking user in the channel, including overwrites, only included when part of the resolved data received on an interaction. This does not include implicit permissions, which may need to be checked separately
var permissions : String
## channel flags combined as a bitfield
var flags : int
## number of messages ever sent in a thread, it’s similar to message_count on message creation, but will not decrement the number when a message is deleted
var total_message_sent : int
## the set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel
var available_tags : Array[Dictionary]
## the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel
var applied_tags : Array[String]
## the emoji to show in the add reaction button on a thread in a GUILD_FORUM or a GUILD_MEDIA channel
var default_reaction_emoji : Dictionary
## the initial rate_limit_per_user to set on newly created threads in a channel. this field is copied to the thread at creation time and does not live update.
var default_thread_rate_limit_per_user : int
## the default sort order type used to order posts in GUILD_FORUM and GUILD_MEDIA channels. Defaults to null, which indicates a preferred sort order hasn’t been set by a channel admin
var default_sort_order : int
## the default forum layout view used to display posts in GUILD_FORUM channels. Defaults to 0, which indicates a layout view has not been set by a channel admin
var default_forum_layout : int

func _init(data : Dictionary) -> void:
	# Sets the variables according to passed dictionary.
	self.channel_id = data["id"]
	self.type = data["type"]
	
	# yeah.
	# All scrap fields that can be absent are here.
	if data.has("guild_id") and data["guild_id"] != null:
		self.guild_id = data["guild_id"]
	if data.has("position") and data["position"] != null:
		self.position = data["position"]
	if data.has("permission_overwrites") and data["permission_overwrites"] != null:
		self.permission_overwrites = data["permission_overwrites"]
	if data.has("name") and data["name"] != null:
		self.channel_name = data["name"]
	if data.has("topic") and data["topic"] != null:
		self.topic = data["topic"]
	if data.has("nsfw") and data["nsfw"] != null:
		self.nsfw = data["nsfw"]
	if data.has("last_message_id") and data["last_message_id"] != null:
		self.last_message_id = data["last_message_id"]
	if data.has("bitrate") and data["bitrate"] != null:
		self.bitrate = data["bitrate"]
	if data.has("user_limit") and data["user_limit"] != null:
		self.user_limit = data["user_limit"]
	if data.has("rate_limit_per_user") and data["rate_limit_per_user"] != null:
		self.rate_limit_per_user = data["rate_limit_per_user"]
	if data.has("recipients") and data["recipients"] != null:
		self.recipients = data["recipients"]
	if data.has("icon") and data["icon"] != null:
		self.icon = data["icon"]
	if data.has("owner_id") and data["owner_id"] != null:
		self.owner_id = data["owner_id"]
	if data.has("application_id") and data["application_id"] != null:
		self.application_id = data["application_id"]
	if data.has("managed") and data["managed"] != null:
		self.managed = data["managed"]
	if data.has("parent_id") and data["parent_id"] != null:
		self.parent_id = data["parent_id"] 
	if data.has("last_pin_timestamp") and data["last_pin_timestamp"] != null:
		self.last_pin_timestamp = data["last_pin_timestamp"]
	if data.has("rtc_region") and data["rtc_region"] != null:
		self.rtc_region = data["rtc_region"]
	if data.has("video_quality_mode") and data["video_quality_mode"] != null:
		self.video_quality_mode = data["video_quality_mode"]
	if data.has("message_count") and data["message_count"] != null:
		self.message_count = data["message_count"]
	if data.has("member_count") and data["member_count"] != null:
		self.member_count = data["member_count"]
	if data.has("thread_metadata") and data["thread_metadata"] != null:
		self.thread_metadata = data["thread_metadata"]
	if data.has("member") and data["member"] != null:
		self.member = data["member"]
	if data.has("default_auto_archive_duration") and data["default_auto_archive_duration"] != null:
		self.default_auto_archive_duration = data["default_auto_archive_duration"]
	if data.has("permissions") and data["permissions"] != null:
		self.permissions = data["permissions"]
	if data.has("flags") and data["flags"] != null:
		self.flags = data["flags"]
	if data.has("total_message_sent") and data["total_message_sent"] != null:
		self.total_message_sent = data["total_message_sent"]
	if data.has("available_tags") and data["available_tags"] != null:
		self.available_tags = data["available_tags"]
	if data.has("applied_tags") and data["applied_tags"] != null:
		self.applied_tags = data["applied_tags"]
	if data.has("default_reaction_emoji") and data["default_reaction_emoji"] != null:
		self.default_reaction_emoji = data["default_reaction_emoji"]
	if data.has("default_thread_rate_limit_per_user") and data["default_thread_rate_limit_per_user"] != null:
		self.default_thread_rate_limit_per_user = data["default_thread_rate_limit_per_user"]
	if data.has("default_sort_order") and data["default_sort_order"] != null:
		self.default_sort_order = data["default_sort_order"]
	if data.has("default_forum_layout") and data["default_forum_layout"] != null:
		self.default_forum_layout = data["default_forum_layout"]

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

func set_permission_ovewrite(overwrite : Discord_Permissions.Permission_Overwrite) -> void:
	var payload = {
		"allow" : overwrite.allow,
		"deny" : overwrite.deny,
		"type" : overwrite.type
	}
	
	var output = await Discord.discord_put(["channels","permissions"],[self.channel_id,overwrite.id], payload)
	

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
	var payload = [{
		"id":self.channel_id,
		"position":new_position
	}]
	
	var err = bot_request.request(patch_url, Discord.headers, HTTPClient.METHOD_PATCH, JSON.stringify(payload))
	if err != Error.OK:
		push_error("Failed to update channel position: " + error_string(err))
		return
	
	var result = await bot_request.request_completed
	bot_request.call_deferred("queue_free")

## Get the message history of a channel.
## Returns an array of the last messages in this channel as [Discord_Message]s up to [param limit]
## messages. The limit tops out at 100 because of Discord api limitations.
func get_channel_messages(channelID : String = self.channel_id, limit : int = 100) -> Array:
	limit = min(limit, 100)
	
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	# URL extenstion for retrieving messages (with a limit of 100)
	var message_url = Discord.BASE_URL+("/channels/%s/messages?limit=%s" % limit)
	
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
	var details = await Discord.discord_get("channels", channelID)
	
	# Catch errors. Error responses become arrays, but channels are always a dictionary.
	if details is Array:
		var info = JSON.parse_string(details[3].get_string_from_utf8())
		if info.has("message") and info.has("code"):
			push_error(info["message"] + " | Code: " + info["code"])
			return
	
	var channel = Discord_Channel.new(details)
	return channel

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

## Deletes the associated channel and free's this resource. Remove reference after use.
func delete() -> Discord_Channel:
	var details = await Discord.discord_delete("channels", self.get_id())
	
	# Catch errors. Error responses become arrays, but channels are always a dictionary.
	if details is Array:
		var info = JSON.parse_string(details[3].get_string_from_utf8())
		if info.has("message") and info.has("code"):
			push_error(info["message"] + " | Code: " + info["code"])
			return
	
	self.free()
	
	var channel = Discord_Channel.new(details)
	return channel

## Static version of [method delete] which takes an ID.
static func delete_channel_from_id(channelID : String) -> Discord_Channel:
	var details = await Discord.discord_delete("channels", channelID)
	
	# Catch errors. Error responses become arrays, but channels are always a dictionary.
	if details is Array:
		var info = JSON.parse_string(details[3].get_string_from_utf8())
		if info.has("message") and info.has("code"):
			push_error(info["message"] + " | Code: " + info["code"])
			return
	
	var channel = Discord_Channel.new(details)
	return channel

func _on_request_complete(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200 or response_code == 201:
		var json = JSON.parse_string(body.get_string_from_utf8())
		
		print(json)
