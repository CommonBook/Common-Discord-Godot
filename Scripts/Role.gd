class_name Discord_Role extends Resource
## Stores information and methods relevant to Discord roles. 
##
## Does not store any other data or references. Will only retrieve information.

## The ID Discord uses to service this role.
var id : String
## The name of this role.
var role_name : String
## @deprecated 
## [color=red]Discord no longer uses integers to store colors.[/color][br][br]
## The color of this role.
var color : int
## Array of colors associated with this role. When a solid color, only the primary color will be valid.
## [br] Comes in a [Dictionary] that looks like this:
## [codeblock]
## "colors": {
##   "primary_color": 0,
##   "secondary_color": null,
##   "tertiary_color": null
## }
## [/codeblock]
var colors : Dictionary
## Whether the role is pinned in the user list.
var hoist : bool
## If one exists, the icon used for this role.
var icon : Texture2D
## Idfk
var unicode_emoji : String
## Position of this role in the hierarchy (roles with the same position are sorted by ID)
var position : int
## "Encoded" permission integer (bitfield). See [Discord_Permissions]
var permissions : String
## Whether an integration is managing this role. (I.E. your bot's role)
var managed : bool 
## Can this role be directly mentioned.
var mentionable : bool 
## Dictionary of tags associated with this role. Most roles will have nothing here.
var tags : Dictionary
## "Encoded" integer (bitfield) that contains the flags this role has. Currently there is only one possible
## flag for if the role is selectable in the onboarding prompt.
var flags : int

## On initializing, takes a dictionary and assembles an object with the data. 
func _init(data : Dictionary) -> void:
	self.id = data["id"]
	self.role_name = data["name"]
	self.color = data["color"]
	self.colors = data["colors"]
	self.hoist = data["hoist"]
	self.position = data["position"]
	self.permissions = data["permissions"]
	self.managed = data["managed"]
	self.mentionable = data["mentionable"]
	self.flags = data["flags"]
	
	self.icon = data["icon"] if data.has("icon") else null
	self.unicode_emoji = data["unicode_emoji"] if data.has("unicode_emoji") and data["unicode_emoji"] != null else "null"
	self.tags = data["tags"] if data.has("tags") else {}

## Get a specific role using its ID and the ID of the guild it belongs to.
func get_role_by_id(guild_id : String, role_id : String) -> Discord_Role:
	var role_data = await Discord.discord_get(["guilds", "roles"], [guild_id, role_id])
	var role = Discord_Role.new(role_data)
	
	return role

## Same behavior as [method get_role_by_id], but returns the full server response.
func get_role_by_id_raw(guild_id : String, role_id : String) -> Dictionary:
	var role_data = await Discord.discord_get(["guilds", "roles"], [guild_id, role_id], true)
	return role_data

## Return a list of all roles available in a guild.
static func get_guild_roles(guild_id : String) -> Array[Discord_Role]:
	var data = await Discord.discord_get(["guilds","roles"],[guild_id])
	
	var roles : Array[Discord_Role]
	if data is Array:
		for object in data:
			roles.append(Discord_Role.new(object))
	
	return roles

## Same behavior as [method get_guild_roles], but returns the full server response. 
static func get_guild_roles_raw(guild_id : String) -> Dictionary:
	return await Discord.discord_get(["guilds","roles"],[guild_id], true)
