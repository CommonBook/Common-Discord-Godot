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
@onready var TOKEN = FileAccess.open("user://BOT_TOKEN.txt", FileAccess.READ).get_as_text().strip_edges() if FileAccess.file_exists("user://BOT_TOKEN.txt") else ""
## Numeric string with the API version. Tested on version 9, version 10 supported. Any other, good luck.
var API_VER : String = "9"

var userAgent : String = "GodotDiscordBot" :
	set(value):
		userAgent = value
		
		_update_headers()

## Each API call starts with this url string. v10 is untested, but might still work.
var BASE_URL : String = "https://discord.com/api/v%s" % API_VER

## These headers are passed along with the http request to inform discord who you are.
## Feel free to change [param User-Agent]. 
@onready var headers : PackedStringArray = ([
	"Authorization: Bot %s" % TOKEN,
	"Content-Type: application/json",
	"User-Agent: %s" % userAgent
])

signal operation_complete

func _update_headers() -> void:
	headers.clear()
	
	headers = ([
	"Authorization: Bot %s" % TOKEN,
	"Content-Type: application/json",
	"User-Agent: %s" % userAgent
	])

## Bot will self-destruct if it has no token.
func _ready() -> void:
	if TOKEN == "":
		push_error("No token. Bot calls will fail. Destroying autoload.")
		self.queue_free()

## Send a direct message to a user. [param Content] is the text of the message and [param userID]
## is the discord user id of the user to message.
func send_dm(content : String, userID : String) -> void:
	var dm_channel = await Discord_Channel.get_user_channel_from_id(userID)
	send_message(content, dm_channel)

## @deprecated 
## Replaced by the [Discord_Message]'s [method send]. [br]
## Sends a message in a specified channel on discord.
## [param Content] is the message body. The channel is a [Discord_Channel] with a valid
## channel ID.
func send_message(content : String, channel : Discord_Channel) -> void:
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	add_child(bot_request)
	
	var message_url = BASE_URL+"/channels/%s/messages"
	var payload = {
		"content":content # The text content
	}
	
	var err = bot_request.request(message_url % channel.channel_id, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	
	await bot_request.request_completed # Wait until request is completed
	bot_request.call_deferred("queue_free")

func send_message_attachment(message : Discord_Message, channel : Discord_Channel):
	pass

func _url_determine(url_extension : Variant, ID : Variant) -> String:
	var get_url : String = ""
	match typeof(url_extension):
		TYPE_STRING:
			# API/extension/ID
			get_url = Discord.BASE_URL+"/%s/%s" % [url_extension, ID]
		TYPE_ARRAY:
			# API/extention_1/ID_1/extension_2/ID_2/...
			get_url = Discord.BASE_URL + "/"
			var i = 0
			while i < url_extension.size() or i < ID.size()-1:
				if not i > url_extension.size()-1:
					get_url = get_url + url_extension[i] + "/"
				if not i > ID.size()-1:
					get_url = get_url + ID[i] + "/"
				i+=1
			get_url = get_url.rstrip("/")
	return get_url

## Takes a unique URL extension and an ID and makes a get request to Discord. Returns the raw object
## from Discord. [br]
## [param url_extension] and [param ID] can be a [String] or an [Array] of strings.
## [br][br]
## Different behavior will be exhibited based on whether the values are [String]s or [Array]s.
## If they are different, the call will be aborted. [br]
## If [String]s are provided, the request will be sent to the url matching [param API_URL]/extension/ID
## 
## [codeblock]
## func _ready() -> void:
## 	 Discord.API_VER = "9"
## 	 Discord.discord_get("channels", "1234567890")
## 	 # will send a GET request to 'https://discord.com/api/v9/channels/1234567890'
## [/codeblock][br]
##
## If [Array]s are provided, they will be appended to the [param API_URL] in alternating order, extension
## first. If one array is longer, it will continue to be appended until it is also empty. Along the 
## lines of API/extention_1/ID_1/extension_2/ID_2/...
## 
## [codeblock]
## func _ready() -> void:
## 	 Discord.API_VER = "9"
## 	 Discord.discord_get(["channels","messages"], ["1234567890","0987654321"])
## 	 # will send a GET request to 'https://discord.com/api/v9/channels/1234567890/messages/0987654321'
## [/codeblock][br]
## By default, this returns the body of the request response, but [param full_response] will cause 
## the output to include the full response. 
## The full response will be output regardless if the request fails.[br]
## Typically returns a dictionary, but may return an [Array] if that is what the response body contains.
func discord_get(url_extension : Variant, ID : Variant, full_response : bool = false):
	if typeof(url_extension) != typeof(ID):
		push_error("Invalid type. Both parameters must match types")
		return {}
	
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	
	var get_url = _url_determine(url_extension, ID)
	
	var err = bot_request.request(get_url, Discord.headers, HTTPClient.METHOD_GET)
	var result = await bot_request.request_completed
	
	bot_request.call_deferred("queue_free")
	
	if err != Error.OK:
		push_error("GET failed: " + error_string(err))
		return result
	# result[1] is the response code.
	if result[1] != 200 and result[1] != 201:
		Discord.response_code_error(result[1])
		return result
	
	return JSON.parse_string(result[3].get_string_from_utf8()) if not full_response else result

func discord_put(url_extension : Variant, ID : Variant, payload : Dictionary, full_response : bool = false):
	if typeof(url_extension) != typeof(ID):
		push_error("Invalid type. Both parameters must match types")
		return {}
	
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	
	var get_url = _url_determine(url_extension, ID)
	
	var err = bot_request.request(get_url, Discord.headers, HTTPClient.METHOD_PUT, JSON.stringify(payload))
	var result = await bot_request.request_completed
	
	bot_request.call_deferred("queue_free")
	
	if err != Error.OK:
		push_error("PUT failed: " + error_string(err))
		return result
	# result[1] is the response code.
	if result[1] != 200 and result[1] != 204:
		Discord.response_code_error(result[1])
		return result
	
	if result[1] != 204: 
		return JSON.parse_string(result[3].get_string_from_utf8()) if not full_response else result
	elif result[1] == 204:
		return

func discord_delete(url_extension : Variant, ID : Variant, full_response : bool = false):
	if typeof(url_extension) != typeof(ID):
		push_error("Invalid type. Both parameters must match types")
		return {}
	
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	
	var get_url = _url_determine(url_extension, ID)
	
	var err = bot_request.request(get_url, Discord.headers, HTTPClient.METHOD_DELETE)
	var result = await bot_request.request_completed
	
	bot_request.call_deferred("queue_free")
	
	if err != Error.OK:
		push_error("DELETE failed: " + error_string(err))
		return result
	# result[1] is the response code.
	if result[1] != 200 and result[1] != 201:
		Discord.response_code_error(result[1])
		return result
	
	return JSON.parse_string(result[3].get_string_from_utf8()) if not full_response else result

## @experimental
## Currently a skeleton.
## Handles the response code and pushes an appropriate error.
func response_code_error(response_code) -> void:
	push_error("Response failed. Code: " + str(response_code))
