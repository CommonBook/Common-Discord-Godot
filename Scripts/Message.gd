class_name Discord_Message extends Resource
## Contains all the relevant information for a discord message.

## The plaintext content of a message. What was said.
var content : String
## A list of attachments.
var attachments : Array
## A list of embedded attachments.
var embeds : Array
## Discord's message ID for this particular message.
var msg_id : String
## The ID of the channel this message was sent in.
var channel_id : String

## Constructs a message resource from the information recieved from the discord api. 
func _init(body : Dictionary) -> void:
	if not body.has("content") or not body.has("id") or not body.has("channel_id"):
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
