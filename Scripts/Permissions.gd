class_name Discord_Permissions extends Resource
## Discord's API uses a bitfield to represent permissions. This class helps construct those permissions
## in a human-readable way.

var permissions : int = 0

const OVERWRITE_ROLE = 0
const OVERWRITE_USER = 1

const CREATE_INSTANT_INVITE : int = (1 << 0)
const KICK_MEMBERS : int = (1 << 1) 
const BAN_MEMBERS : int = (1 << 2) 
const ADMINISTRATOR : int = (1 << 3) 
const MANAGE_CHANNELS : int = (1 << 4) 
const MANAGE_GUILD : int = (1 << 5) 
const ADD_REACTIONS : int = (1 << 6)
const VIEW_AUDIT_LOG : int = (1 << 7)
const PRIORITY_SPEAKER : int = (1 << 8)
const STREAM : int = (1 << 9)
const VIEW_CHANNEL : int = (1 << 10)
const SEND_MESSAGES : int = (1 << 11)
const SEND_TTS_MESSAGES : int = (1 << 12)
const MANAGE_MESSAGES : int = (1 << 13) 
const EMBED_LINKS : int = (1 << 14)
const ATTACH_FILES : int = (1 << 15)
const READ_MESSAGE_HISTORY : int = (1 << 16)
const MENTION_EVERYONE : int = (1 << 17)
const USE_EXTERNAL_EMOJIS : int = (1 << 18)
const VIEW_GUILD_INSIGHTS : int = (1 << 19)
const CONNECT : int = (1 << 20)
const SPEAK : int = (1 << 21)
const MUTE_MEMBERS : int = (1 << 22)
const DEAFEN_MEMBERS : int = (1 << 23)
const MOVE_MEMBERS : int = (1 << 24)
const USE_VAD : int = (1 << 25)
const CHANGE_NICKNAME : int = (1 << 26)
const MANAGE_NICKNAMES : int = (1 << 27)
const MANAGE_ROLES : int = (1 << 28) 
const MANAGE_WEBHOOKS : int = (1 << 29) 
const MANAGE_GUILD_EXPRESSIONS : int = (1 << 30) 
const USE_APPLICATION_COMMANDS : int = (1 << 31)
const REQUEST_TO_SPEAK : int = (1 << 32)
const MANAGE_EVENTS : int = (1 << 33)
const MANAGE_THREADS : int = (1 << 34) 
const CREATE_PUBLIC_THREADS : int = (1 << 35)
const CREATE_PRIVATE_THREADS : int = (1 << 36)
const USE_EXTERNAL_STICKERS : int = (1 << 37)
const SEND_MESSAGES_IN_THREADS : int = (1 << 38)
const USE_EMBEDDED_ACTIVITIES : int = (1 << 39)
const MODERATE_MEMBERS : int = (1 << 40) 
const VIEW_CREATOR_MONETIZATION_ANALYTICS : int = (1 << 41) 
const USE_SOUNDBOARD : int = (1 << 42)
const CREATE_GUILD_EXPRESSIONS : int = (1 << 43)
const CREATE_EVENTS : int = (1 << 44)
const USE_EXTERNAL_SOUNDS : int = (1 << 45)
const SEND_VOICE_MESSAGES : int = (1 << 46)
const SET_VOICE_CHANNEL_STATUS : int = (1 << 48)
const SEND_POLLS : int = (1 << 49)
const USE_EXTERNAL_APPS : int = (1 << 50)
const PIN_MESSAGES : int = (1 << 51)
const BYPASS_SLOWMODE : int = (1 << 52)

func _init(permissions : int = 0) -> void:
	self.permissions = permissions

## Add a permission to the current bitfield. [br]
## Due to the properties of bit math, this can be any of the constants or another existing 
## permissions value. Just make sure you pass the [param permissions] parameter 
## and not the [Discord_Permissions] object.
func add_permissions(permissions_to_add : Array[int]) -> void:
	for perm in permissions_to_add:
		self.permissions = self.permissions | perm

## Remove a permission from the current bitfield. [br]
## Due to the properties of bit math, this can be any of the constants or another existing 
## permissions value. Just make sure you pass the [param permissions] parameter 
## and not the [Discord_Permissions] object.
func remove_permissions(permissions_to_remove : Array[int]) -> void:
	for perm in permissions_to_remove:
		self.permissions = self.permissions & ~perm

## Exports the list of permissions as an array of human readable names.
func get_readable() -> Array[String]:
	var list : Array[String] = []
	
	# Does ANYONE know a better way to do this?
	if self.permissions & CREATE_INSTANT_INVITE:
		list.append("CREATE_INSTANT_INVITE")
	if self.permissions & KICK_MEMBERS:
		list.append("KICK_MEMBERS")
	if self.permissions & BAN_MEMBERS:
		list.append("BAN_MEMBERS")
	if self.permissions & ADMINISTRATOR:
		list.append("ADMINISTRATOR")
	if self.permissions & MANAGE_CHANNELS:
		list.append("MANAGE_CHANNELS")
	if self.permissions & MANAGE_GUILD:
		list.append("MANAGE_GUILD")
	if self.permissions & ADD_REACTIONS:
		list.append("ADD_REACTIONS")
	if self.permissions & VIEW_AUDIT_LOG:
		list.append("VIEW_AUDIT_LOG")
	if self.permissions & PRIORITY_SPEAKER:
		list.append("PRIORITY_SPEAKER")
	if self.permissions & STREAM:
		list.append("STREAM")
	if self.permissions & VIEW_CHANNEL:
		list.append("VIEW_CHANNEL")
	if self.permissions & SEND_MESSAGES:
		list.append("SEND_MESSAGES")
	if self.permissions & SEND_TTS_MESSAGES:
		list.append("SEND_TTS_MESSAGES")
	if self.permissions & MANAGE_MESSAGES:
		list.append("MANAGE_MESSAGES")
	if self.permissions & EMBED_LINKS:
		list.append("EMBED_LINKS")
	if self.permissions & ATTACH_FILES:
		list.append("ATTACH_FILES")
	if self.permissions & READ_MESSAGE_HISTORY:
		list.append("READ_MESSAGE_HISTORY")
	if self.permissions & MENTION_EVERYONE:
		list.append("MENTION_EVERYONE")
	if self.permissions & USE_EXTERNAL_EMOJIS:
		list.append("USE_EXTERNAL_EMOJIS")
	if self.permissions & VIEW_GUILD_INSIGHTS:
		list.append("VIEW_GUILD_INSIGHTS")
	if self.permissions & CONNECT:
		list.append("CONNECT")
	if self.permissions & SPEAK:
		list.append("SPEAK")
	if self.permissions & MUTE_MEMBERS:
		list.append("MUTE_MEMBERS")
	if self.permissions & DEAFEN_MEMBERS:
		list.append("DEAFEN_MEMBERS")
	if self.permissions & MOVE_MEMBERS:
		list.append("MOVE_MEMBERS")
	if self.permissions & USE_VAD:
		list.append("USE_VAD")
	if self.permissions & CHANGE_NICKNAME:
		list.append("CHANGE_NICKNAME")
	if self.permissions & MANAGE_NICKNAMES:
		list.append("MANAGE_NICKNAMES")
	if self.permissions & MANAGE_ROLES:
		list.append("MANAGE_ROLES")
	if self.permissions & MANAGE_WEBHOOKS:
		list.append("MANAGE_WEBHOOKS")
	if self.permissions & MANAGE_GUILD_EXPRESSIONS:
		list.append("MANAGE_GUILD_EXPRESSIONS")
	if self.permissions & USE_APPLICATION_COMMANDS:
		list.append("USE_APPLICATION_COMMANDS")
	if self.permissions & REQUEST_TO_SPEAK:
		list.append("REQUEST_TO_SPEAK")
	if self.permissions & MANAGE_EVENTS:
		list.append("MANAGE_EVENTS")
	if self.permissions & MANAGE_THREADS:
		list.append("MANAGE_THREADS")
	if self.permissions & CREATE_PUBLIC_THREADS:
		list.append("CREATE_PUBLIC_THREADS")
	if self.permissions & CREATE_PRIVATE_THREADS:
		list.append("CREATE_PRIVATE_THREADS")
	if self.permissions & USE_EXTERNAL_STICKERS:
		list.append("USE_EXTERNAL_STICKERS")
	if self.permissions & SEND_MESSAGES_IN_THREADS:
		list.append("SEND_MESSAGES_IN_THREADS")
	if self.permissions & USE_EMBEDDED_ACTIVITIES:
		list.append("USE_EMBEDDED_ACTIVITIES")
	if self.permissions & MODERATE_MEMBERS:
		list.append("MODERATE_MEMBERS")
	if self.permissions & VIEW_CREATOR_MONETIZATION_ANALYTICS:
		list.append("VIEW_CREATOR_MONETIZATION_ANALYTICS")
	if self.permissions & USE_SOUNDBOARD:
		list.append("USE_SOUNDBOARD")
	if self.permissions & CREATE_GUILD_EXPRESSIONS:
		list.append("CREATE_GUILD_EXPRESSIONS")
	if self.permissions & CREATE_EVENTS:
		list.append("CREATE_EVENTS")
	if self.permissions & USE_EXTERNAL_SOUNDS:
		list.append("USE_EXTERNAL_SOUNDS")
	if self.permissions & SEND_VOICE_MESSAGES:
		list.append("SEND_VOICE_MESSAGES")
	if self.permissions & SET_VOICE_CHANNEL_STATUS:
		list.append("SET_VOICE_CHANNEL_STATUS")
	if self.permissions & SEND_POLLS:
		list.append("SEND_POLLS")
	if self.permissions & USE_EXTERNAL_APPS:
		list.append("USE_EXTERNAL_APPS")
	if self.permissions & PIN_MESSAGES:
		list.append("PIN_MESSAGES")
	if self.permissions & BYPASS_SLOWMODE:
		list.append("BYPASS_SLOWMODE")
	
	return list

## Object for channel permission overwrites.
class Permission_Overwrite :
	var allow : int = 0
	var deny : int = 0
	var id = ""
	var type = 0
	
	func _init(id : String, type : int) -> void:
		self.id = id
		self.type = type
	
	func set_allow(perm : Discord_Permissions) -> void:
		self.allow = perm.permissions
	
	func set_deny(perm : Discord_Permissions) -> void:
		self.deny = perm.permissions
	
	## Returns a human-readable list of the enabled permissions.
	func get_readable() -> Dictionary:
		var allowed = Discord_Permissions.new(self.allow)
		var denied = Discord_Permissions.new(self.deny)
		return {"allowed" : allowed.get_readable(), "denied" : denied.get_readable()}

## Create an empty permission overwrite object. use [method] and [method] to apply your permissions.
## [br] [param id] is the ID of the user or role that this overwrite is for. [param overwrite_type]
## tells Discord which of the two that ID is. Can only be 1 or 2. Use [member Discord_Permissions.OVERWRITE_ROLE] 
## or [member Discord_Permissions.OVERWRITE_USER] for clarity. 
static func create_permission_overwrite(id : String, overwrite_type : int) -> Permission_Overwrite:
	var overwrite = Discord_Permissions.Permission_Overwrite.new(id, overwrite_type)
	return overwrite

## Sets the allowed permissions of an overwrite. Somewhat redundant though.
static func overwrite_allow(overwrite : Permission_Overwrite, permissions_to_allow : Discord_Permissions) -> void:
	overwrite.set_allow(permissions_to_allow)

## Sets the denied permissions of an overwrite. Somewhat redundant though.
static func overwrite_deny(overwrite : Permission_Overwrite, permissions_to_deny : Discord_Permissions) -> void:
	overwrite.set_deny(permissions_to_deny)
