class_name Discord_Bot extends Node
## Master class for controlling a discord bot.. [br][br]
##
## This script acts as a reference of the bot itself. Currently there is no event loop.
## Anything a bot can do, this object should handle. When the plugin is enabled, it will be
## added as an autoload singleton and can be accessed as "Discord". [br][br]
##
## Capabilities include: [br]
##   -   Send messages in channels.
##   -   Send messages to users.
##   -   Create channels.

## Your bot's token. Get it from the [url=https://discord.com/developers]discord developer portal.[/url]
## [br][br]
## [b]
## NOTE: Compiled apps may still have this token exposed. Use this method only for testing. 
## Research token obfuscation to find alternatives and edit this script. Do NOT publish any
## code containing an un-obfuscated discord token.
@onready var TOKEN = FileAccess.open("user://BOT_TOKEN.txt", FileAccess.READ).get_as_text().strip_edges()

## Each API call starts with this url string. v10 is untested, but might still work.
const BASE_URL : String = "https://discord.com/api/v9"

## These headers are passed along with the http request to inform discord who you are.
## Feel free to change [param User-Agent]. 
@onready var headers : PackedStringArray = ([
	"Authorization: Bot " + TOKEN,
	"Content-Type: application/json",
	"User-Agent: GodotDiscordBot"
])

func _ready() -> void:
	pass

## Send a direct message to a user. [param Content] is the text of the message and [param userID]
## is the discord user id of the user to message.
func send_dm(content : String, userID : String) -> void:
	var dm_channel = await Discord_Channel.get_user_channel_from_id(userID)
	send_message(content, dm_channel)

## Sends a message in a specified channel on discord.
## [param Content] is the message body. The channel is a [Discord_Channel] with a valid
## chanel ID.
func send_message(content : String, channel : Discord_Channel) -> void:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	add_child(bot_request)
	
	var message_url = BASE_URL+"/channels/%s/messages"
	var payload = {
		"content":content # The text content
	}
	
	var err = bot_request.request(message_url % channel.channel_id, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	print(err)
	await bot_request.request_completed # Wait until request is completed
	bot_request.call_deferred("queue_free")

## Creates a channel in a discord server given the server's guild ID.
## Returns a reference to the channel it creates.
func create_channel(channel_name : String, guild_id : String) -> Discord_Channel:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	
	var message_url = BASE_URL+"/guilds/%s/channels"
	var payload = {
		"name":channel_name, # Name of the channel
		"permission_overwrites": [], # Specific permissions to be added for this channel
		"type": 0 # 0 is for text channels
	}
	
	var err = bot_request.request(message_url % guild_id, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != Error.OK:
		print("Failure creating channel: " + str(err))
		return
	
	var result = await bot_request.request_completed
	# Remove the request from the scene tree once it is done being used
	bot_request.call_deferred("queue_free")
	
	# Parse
	var body = result[3].get_string_from_utf8()
	body = JSON.parse_string(body)
	
	return Discord_Channel.new(body)
