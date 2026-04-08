# Common-Discord
A simple GDScript wrapper of the Discord HTTP API. <br>
![logo](icon.svg)

> [!WARNING]
> This plugin is feature incomplete and heavily work in progress. Expect breaking changes and missing features.

There are other projects out there, so why this one? <br>
Well, they didn't meet my needs. That's all. This is being developed alongside a private project, so any features that needs are prioritized first. 
<br><br>
This project is set apart by it's [b]object-oriented[/b] approach. The core is a singleton, but most operations are scripted using various objects with unique methods.

```
func _ready() -> void:
	var message = Discord_Message.create_message()
 
  message.set_message_text("This is a message.")
  message.add_attachment("res://icon.png")
  message.send(<channel>)
```
### Usage
Since this is not available on the AssetLib, clone this repository into or drag and drop it into the addons folder of your project, then enable it in the project settings. Finally, make sure the Discord autoload singleton was properly added to the project.
<br><br>
For each object type, do not invoke new(), instead invoke their static function for creating a new object. For example, for messages that's `Discord_Message.create_message()`<br>
There is no getting started page, but the in-engine documentation is fairly sound. Reference that for help.

### Capabilities
(🚧 = W.I.P)
- ✅️ Send messages in channels
- ✅️ Send messages in DMs 🚧
- ✅️ Attach files to messages
- ✅️ Read messages
- ✅️ Get channels
- ✅️ Create channels
- ❌️ Delete channels 🚧
- ❌️ Create Embeds 🚧
- ❌️ Edit messages 🚧
- ❌️ Delete messages 🚧
- ❌️ Reply to messages 🚧
- ❌️ Event loop
- ❌️ Threads functionality
- ❌️ Create polls
- ❌️ Slash commands
- ❌️ Make you a cake
