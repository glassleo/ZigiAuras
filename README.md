# ZigiAuras

A helper addon for World of Warcraft that adds dynamic custom global tables and functions for use in WeakAuras or other addons. It does not display anything on its own and has a very tiny footprint.

Due to the frequency of updates for this addon as well as its obscure use case I will not be providing neat released packages. You'll have to [download it manually](https://github.com/glassleo/ZigiAuras/archive/refs/heads/master.zip) (just plop the ``!ZigiAuras`` folder into your AddOns folder) if you want to use it.

It somewhat depends on [Media_Newsom](https://github.com/glassleo/Media_Newsom) so I recommend you grab that as well if you're going to use this.

The addon includes:

- A few useful Lua functions
- Tables of mostly color related data
- Some slash commands mostly for debugging (althouth the keystone one can be pretty useful!)

Everything is stored in a global table named ``ZA``.

## Lua functions

### ZA.Transliterate(string)

Transliterates Cyrillic characters to Latin. Useful if you can't read Cyrillic (or your font does not support it). Does nothing with Latin characters so it's safe to use on pretty much all text.

Based on [LibTranslit 1.0 by Vardex](https://github.com/Vardex/LibTranslit).

Returns a transliterated string.

### ZA.AH(alliance, horde)

Returns the value of the ``alliance`` or ``horde`` parameter back to you depending on which faction the player character belongs to. Defaults to ``alliance`` for neutral characters.

### ZA.GetGradient(id, name, icon)

Logic for determining the best gradient from ``ZA.Gradients`` using provided spell ID, spell name and spell icon. All paramteres are optional.

Returns a color gradient.

### ZA.GetIcon(id, name, icon)

Logic for determining which icon texture to use (using ``ZA.Icons``) using provided spell ID, spell name and spell icon. All parameters are optional.

Returns a texture.

### ZA.GradientRGB(gradient)

Converts a gradient hex string into decimal color values.

Returns 6 decimal values.

### ZA.HexToRGB(hex)

Converts a color hex string to decimal color values.

Returns 3 decimal values.

### ZA.PlayerPrimaryStat(abbrev)

Returns the player's primary stat ("Agility", "Intellect" or "Strength"), based class and current spec. Set ``abbrev`` to ``true`` for an abbreviated 3 letter string.

## Tables

### ZA.IconColors

A table for custom icon border colors for OPie. See uncommented fix if you want to implement this into OPie.

### ZA.People

A table used for coloring mail sender text.

### ZA.Colors

Named colors. Includes Blizzard blue, World Marker colors, item quality colors, class colors, covenant colors, debuff type colors and reaction/reputation status colors.

### ZA.PowerTypes

A table with Power type IDs and corresponding gradients.

### ZA.Text

A table with replacement spell name text.

### ZA.Gradients

A table with gradient hex strings for each spell school, resource, reputation/reaction and class.

### ZA.Vehicles

A talbe with vehicle names and corresponding gradients.

### ZA.VehicleIcons

A table with replacement icons for vehicles depending on vehicle name.

### ZA.Hearhstones

A table with all known Hearthstones and corresponding replacement text.

### ZA.AutoSpells

Dynamically generated table that includes the spell school for all spells the user has seen this session.

### ZA.Spells

A table with override gradients depending on spell id, name and icon.

### ZA.Icons

A table with override spell icons.

### ZA.EnchantIcons

A table with icons depending on temporary weapon enchant ID.

## Slash Commands

### ``/za enchant``

Outputs the temporary weapon enchant IDs that your equipped weapon(s) are enchanted with currently.

### ``/za map``

Outputs the current Map ID.

### ``/za a <atlas>``

Prints the provided named atlas in your chat at size 24x24.

### ``/za q <id>``

Check if you have completed a quest using its Quest ID.

### ``/za time``

Outputs the remaining time until the daily reset to yourself.

### ``/za !time``

Outputs the remaining time until the daily reset to your group if you are in one or yourself if not.

### ``/za key``

Links your Mythic Keystone(s) to yourself.

### ``/za !key``

Links your Mythic Keystone(s) to your party if you are in one or yourself if not.

### ``/za research <id>``

Outputs research info for a GarrTalent ID.
