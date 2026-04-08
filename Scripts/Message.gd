class_name Discord_Message extends Resource
## Sends and constructs messages.
##
## By default, initializing this class will take a dictionary and assemble the
## resource from the info within. This means that the [method new] method simply
## parses the output from discord. [br]
## To write a message, use [method create_message].
## [br][br]
## When creating a new message, start with creating a reference.
## [codeblock]
## func _ready() -> void:
## 	var message = Discord_Message.create_message()
## [/codeblock]
## Then fill in the details.
## [codeblock]
## func _ready() -> void:
## 	var message = Discord_Message.create_message()
## 
## message.set_message_text("This is a message.")
## message.add_attachment("res://icon.png")
## [/codeblock]
## Then send it with [method send].
## [codeblock]
## message.send(<channel>)
## [/codeblock] [br]
## You can also manually set these using the exposed variable names, but the methods
## are best practice.

## The plaintext content of a message. The text.
var content : String
## A list of attachments.
## [br][br]
## When retrieved, contains the raw file data. [br]
## When sending, fill with a list of file paths. [br]
## Max file size is 25 MB.
var attachments : Array
## A list of embedded files.
var embeds : Array
## Discord's message ID for this particular message.
var msg_id : String
## The ID of the channel this message was sent in.
var channel_id : String

## Creates a new message. Use this empty message to send new messages to a channel
## with [method send]. [br]
## [color=yellow]Note: the empty message will have an empty ID and Channel Id.
static func create_message() -> Discord_Message:
	return Discord_Message.new({"content":"", "id":"", "channel_id":"", "attachments":[], "embeds":[]})


## Constructs a message resource from the information recieved from the discord api.
## If no information provided, throws an error. [br]
## To create a new message, use [method create_message].
func _init(body : Dictionary) -> void:
	if (not body.has("content") or not body.has("id") or not body.has("channel_id")) and body != {}:
		push_error("Failed to construct message. Malformed content.")
		return
	
	self.content = body["content"]
	self.attachments = body["attachments"]
	self.embeds = body["embeds"]
	self.msg_id = body["id"]
	self.channel_id = body["channel_id"]

## Returns the content of the message
func get_content() -> String:
	return self.content

## Returns the list of attachments on this message
func get_attachments() -> Array:
	return self.attachments

## Returns the list of embeds on this message
func get_embeds() -> Array:
	return self.embeds

## Returns the ID of this message
func get_msg_id() -> String:
	return self.msg_id

## Returns the ID of the channel this message was sent in
func get_channel_id() -> String:
	return self.channel_id

func set_message_text(text : String) -> void:
	self.content = text

func add_attachment(location : String) -> void:
	if location.is_absolute_path():
		attachments.append(location)

## Sends the message in a channel. 
## [color=yellow]Note: If this message already exists in another channel, that information will be overriden. Create a duplicate to avoid this.
func send(channel : Discord_Channel) -> Error:
	if self.attachments.size() > 0: # Call alternate method if attachments are present.
		return await _send_with_attachments(channel)
	
	# Create a new HTTPRequest for handling this exchange
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	bot_request.connect("request_completed", Callable(self, "_on_message_sent"))
	
	var message_url = Discord.BASE_URL+"/channels/%s/messages"
	var payload = {
		"content":self.content # The text content
	}
	
	var err = bot_request.request(message_url % channel.channel_id, Discord.headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err == (Error.OK):
		print("Message sent!")
	
	await bot_request.request_completed # Wait until request is completed
	bot_request.call_deferred("queue_free")
	
	return err

## Adds a field to a multipart data form.
func _multipart_add_field(body : PackedByteArray, type : String, name : String, value : String) -> void:
	# Exception for if this is the first field added to the message
	var field_content = ''
	if body.size() == 0:
		field_content = "\r\n"
	
	field_content += \
	"--boundary\r\n" + \
	"Content-Disposition: form-data; name=\"%s\"\r\n" % name + \
	"Content-Type: %s\r\n\r\n" % type + \
	value
	body.append_array(field_content.to_utf8_buffer())

## Adds a file to a multipart data form.
func _multipart_add_file(body: PackedByteArray, key: String, file: PackedByteArray, filename: String, content_type: String):
	var file_content = \
	"\r\n--boundary\r\n" + \
	"Content-Disposition: form-data; name=\"%s\"; filename=\"%s\"\r\n" % [key, filename] + \
	"Content-Type: %s\r\n\r\n" % content_type
	body.append_array(file_content.to_utf8_buffer())
	body.append_array(file)

## Adds the closing indicator to a multipart data form.
func _multipart_close(body : PackedByteArray) -> void:
	body.append_array('\r\n--boundary--\r\n'.to_utf8_buffer())

## @experimental
## Internal call for sending a message when attachments are present.
## [br][br]
## [i]This totally could work for sending a normal message I think, but it was just
## more sensible to seperate them for now. This may be deprecated in the future.[/i]
func _send_with_attachments(channel : Discord_Channel) -> Error:
	if not self.content:
		return Error.ERR_CANT_RESOLVE
	
	var headers : PackedStringArray = ([
		"Authorization: Bot " + Discord.TOKEN,
		"Content-Type: multipart/form-data; boundary=boundary",
		"User-Agent: " + Discord.userAgent
	])
	
	var message_url = Discord.BASE_URL+"/channels/%s/messages"
	var payload = {
		"content":self.content # The text content
	}
	
	var body : PackedByteArray = []
	# Format payload
	_multipart_add_field(body, "application/json", "payload_json", JSON.stringify(payload))
	
	# Format attachments
	for i in range(attachments.size()):
		var path = attachments[i]
		
		if not FileAccess.file_exists(path):
			continue
		
		var file = FileAccess.open(path, FileAccess.READ)
		var file_bytes = file.get_buffer(file.get_length())
		file.close()
		
		var type : String
		match path.get_extension():
			"png" : type = "image/png"
			"jpg" : type = "image/jpg"
			"gif" : type = "image/gif"
			"webp" : type = "image/webp"
			_:
				type = "application/octet-stream"
		
		var filename = path.get_file()
		_multipart_add_file(body, "files[%d]" % i, file_bytes, filename, type)
		
	
	_multipart_close(body)
	
	# Create the request
	var bot_request : HTTPRequest = HTTPRequest.new()
	Discord.add_child(bot_request)
	bot_request.connect("request_completed", Callable(self, "_on_message_sent"))
	bot_request.use_threads = true
	bot_request.timeout = 10
	
	var err = bot_request.request_raw(message_url % channel.channel_id, headers, HTTPClient.METHOD_POST, body)
	await bot_request.request_completed # Wait until request is completed
	
	bot_request.call_deferred("queue_free")
	
	if err != Error.OK:
		return err
	
	return Error.OK

## Handles the message response given by Discord when a message is sent
func _on_message_sent(result, response_code, headers, body) -> int:
	if response_code == 200 or response_code == 201:
		var json = JSON.parse_string(body.get_string_from_utf8())
		
		self.msg_id = json["id"]
		self.channel_id = json["channel_id"]
	
	return response_code
