SLASH_ZIGIAURAS1 = "/za"
local frame = CreateFrame("FRAME", "ZigiAuras")

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")


local function updateData()
	local name, realm = UnitFullName("player")
	local _, class, _ = UnitClass("player")
	local faction,_ = UnitFactionGroup("player")
	local spec = GetSpecialization() or 0

	if ZA then
		-- Debug Mode
		ZA.DebugMode = false

		-- FormatShortNumber(number, siginifixant)
		function ZA.FormatShortNumber(number, significant)
			if type(number) ~= "number" then
				number = tonumber(number)
			end
			if not number then return end

			if type(significant) ~= "number" then
				significant = tonumber(significant)
			end
			significant = significant or 3

			local affixes = { "k", "m", "b", "t", }
			affixes[0] = ""

			local log, floor, max, abs = math.log, math.floor, math.max, math.abs

			local powerTen = floor(log(abs(number)) / log(10))
			powerTen = powerTen < 0 and 0 or powerTen
			local affix = floor(powerTen / 3)
			local divNum = number / 1000^affix
			local before = powerTen%3 + 1
			local after = max(0, significant - before)

			if number < 1000 then return number end
			return string.format(string.format("%%.%df%s", after, affixes[affix]), divNum)
		end

		-- Pet Icons
		ZA.PetIcons = {
			-- Vehicles
			["Mechashredder 5000"] = 134427,
			["Demolisher"] = 252173,
			["Upgraded Demolisher"] = 252173,
			["Krom'gar Demolisher"] = 252173,
			["Siege Engine"] = 252185,
			["Bravo Company Siege Tank"] = 252187,
			["Upgraded Siege Engine"] = 252185,
			["Damaged Catapult"] = 252172,
			["Glaive Thrower"] = 132330,
			["Hippogryph"] = 132265,
			["Wyvern"] = 773276,
			["Tiki Army"] = 135462,
			["Gilnean Mastiff"] = 877481,
			["Swiftclaw"] = 838683,
			["Bloodtalon Thrasher"] = 132193,
			["Forsaken Bat"] = 132182,
			["The Hotseat"] = 132244,
			["Bastia"] = 132225,
			["Raptor"] = 838683,
			["Reprogrammed Shredder"] = 894222,
			["Overloaded Harvest Golem"] = 133862,
			["King Greymane's Horse"] = 2143076,
			["Crowley's Horse"] = 2143075,
			["Rebel Cannon"] = 1373903,
			["Sethrak Cannon"] = 1373903,
			["Bilgewater Mortar"] = 1373903,
			["Emberstone Cannon"] = 1373903,
			["Mountain Horse"] = 2143066,
			["Razorgore the Untamed"] = 604450,
			["Emerald Drake"] = 236231,
			["Duke Hydraxis"] = 132315,
			["Champion Aquaclease"] = 132315,
			["Korl"] = 2743565,
			["Havenshire Stallion"] = 132261,
			["Havenshire Mare"] = 132261,
			["Havenshire Colt"] = 132261,
			["Acherus Deathcharger"] = 237534,
			["Scarlet Cannon"] = 135627,
			["Captured Riding Bat"] = 132182,
			["Riding Shotgun"] = 132244,
			["The Wolf"] = 136095,
			["Cleansed Sludge Belcher"] = 2492254,
			["Jed'hin Master"] = 236442,
			["Jed'hin Adept"] = 236442,
			["Forsaken Catapult"] = 252172,
			["Brazie the Botanist"] = 133939,
			["Master Caravan Kodo"] = 132243,
			["Brotherhood Flying Machine"] = 132240,
			["Climbing Tree"] = 136062,
			["Treetop"] = 136062,
			["Kaldorei Hippogryph"] = 2020396,
			["Avatar of Xuen"] = 611420,
			["Mobi"] = 656546,
			["Shado-Pan Kite"] = 656240,
			["Holding Winston"] = 612362,
			["Rusty Bomber"] = 132241,
			["Kalecgos"] = 797547,
			["Throwing Bottle"] = 237056,
			["Captured Lashtail Hatchling"] = 132193,
			["Lashtail Hatchling"] = 132193,
			["Child of Torcali"] = 2429953,
			["Make Loh Go!"] = 1738657,
			["Ol' Blasty"] = 252185,
			["Portable Ol' Blasty"] = 252185,
			["Bold Wind Rider"] = 298596,
			["Huln Highmountain"] = 1354243,
			["Bolas Launcher"] = 1786419,
			["Azerite Cannon"] = 1035038,
			["Vigil Hill Cannon"] = 1035038,
			["Riding Macaw"] = 1716282,
			["Galeheart"] = 773275,
			["Proudmoore Charger"] = 2143095,
			["Old Rotana"] = 840402,
			["Personal Arcane Assistant"] = 237228,
			["Unleashed Magic"] = 1391777,
			["Valormok Wind Rider"] = 298594,
			["Furious Wind Rider"] = 298594,
			["Whirling Vortex"] = 132845,
			["Large Daddy"] = 133151,
			["Lightforged Warframe"] = 1586383,
			["Lightforged Battery"] = 1586383,
			-- Class Pets
			["Water Elemental"] = 135862,
			["Primal Fire Elemental"] = 651081,
			["Primal Storm Elemental"] = 2065626,
			["Primal Earth Elemental"] = 136024,
			["Xuen"] = 620832,
			["Niuzao"] = 627607,
			["Chi-Ji"] = 877514,
			["Yu'lon"] = 877408,
		}

		-- Custom Hunter Pet Icons
		if name == "Appi" then
			ZA.PetIcons["Andy"] = 1504874
			ZA.PetIcons["Blep"] = 1390637
			ZA.PetIcons["Frank"] = 464160
			ZA.PetIcons["Toothpaste"] = 1570766
			ZA.PetIcons["Ravioli"] = 377270
		elseif name == "Apera" then
			ZA.PetIcons["Anna"] = 1392564
		elseif name == "Anna" then
			ZA.PetIcons["Apera"] = 132172
		elseif name == "Syrah" then
			ZA.PetIcons["Escoutatz"] = 1096090
		elseif name == "Karin" then
			ZA.PetIcons["Biscuit"] = 612362
		elseif name == "Zorp" then
			ZA.PetIcons["Steve"] = 1306097
			ZA.PetIcons["Glurg"] = 1508491
			ZA.PetIcons["Tiffany"] = 2027901
		elseif name == "Viktor" then
			ZA.PetIcons["Vanessa"] = 2027950
		elseif name == "Betty" then
			ZA.PetIcons["Bork"] = 2958711
		elseif name == "Linda" then
			ZA.PetIcons["Mondays"] = 2027886
		elseif name == "Leslie" then
			ZA.PetIcons["Ann"] = 1929247
			ZA.PetIcons["Jerry"] = 2399272
		elseif name == "Tim" then
			ZA.PetIcons["Boop"] = 2399272
		end


		-- Spell School Color Gradients
		ZA.SchoolGradients = {
			[0]   = "777063:c8bc9d", -- Unknown
			[1]   = "777063:c8bc9d", -- Physical
			[100] = "b5aca4:00c7ff", -- Ethereal (Physical)
			[101] = "6c4b4b:a32f2f", -- Light Bleed (Physical)
			[102] = "6a2323:aa2828", -- Heavy Bleed (Physical)
			[103] = "7b6f5e:ff7b4d", -- Enrage (Physical)
			[2]   = "ffba00:ffe098", -- Holy
			[200] = "0090ff:f8ff66", -- Azerite
			[201] = "f6810e:ffcf4b", -- Holy Fire
			[202] = "ce958c:edd7c5", -- Discipline (Holy)
			[3]   = "ffba00:e6e6e6", -- Holystrike (Holy + Physical)
			[4]   = "ed481c:ffc000", -- Fire (dynamic)
			[400] = "ed481c:ffc000", -- Fire
			[401] = "24bf00:f0ff00", -- Felfire
			[5]   = "ed481c:e6e6e6", -- Flamestrike (Fire + Physical)
			[6]   = "ed1c24:ffe98a", -- Holyfire (Holy + Fire)
			[8]   = "009e00:ffff96", -- Nature
			[800] = "86bcff:d9f5ff", -- Lightning (Nature)
			[801] = "2882bf:2dedc9", -- Water (Nature)
			[802] = "0aff9a:ffff96", -- Mist (Nature)
			[803] = "846230:ad894d", -- Earth (Nature)
			[804] = "008f00:6cff3f", -- Poison (Nature)
			[9]   = "6b8c9d:e0f5f7", -- Stormstrike (Nature + Physical)
			[10]  = "009e00:ffefd4", -- Holystorm (Nature + Holy)
			[12]  = "ed481c:ffff96", -- Firestorm (Nature + Fire)
			[16]  = "00b7ff:b5ffff", -- Frost
			[17]  = "666091:8ac7f7", -- Froststrike (Frost + Physical)
			[18]  = "ffc000:b5ffff", -- Holyfrost (Frost + Holy)
			[20]  = "ed481c:b5ffff", -- Frostfire (Frost + Fire)
			[24]  = "00b7ff:ffffc7", -- Froststorm (Frost + Nature)
			[28]  = "ffa200:be2cc3", -- Elemental (Frost + Nature + Fire)
			[32]  = "662d8c:ed1e79", -- Shadow
			[320] = "280d56:384cff", -- Void (Shadow)
			[321] = "5d0b3d:d31313", -- Blood (Shadow)
			[322] = "4f2d65:dc6822", -- Pain (Shadow)
			[323] = "662d8c:3e836d", -- Ghost (Shadow)
			[33]  = "696861:6e4a86", -- Shadowstrike (Shadow + Physical)
			[34]  = "662d8c:ffefd4", -- Twilight (Shadow + Holy)
			[36]  = "6b00b2:69ff46", -- Shadowflame (Shadow + Fire)
			[40]  = "967213:a1d82a", -- Plague (Shadow + Nature)
			[48]  = "93278f:00a99d", -- Shadowfrost (Shadow + Frost)
			[64]  = "b066fe:63e2ff", -- Arcane
			[65]  = "796e8e:63e2ff", -- Spellstrike (Arcane + Physical)
			[66]  = "b066fe:ffefd4", -- Divine (Arcane + Holy)
			[660] = "ff8000:ff3368", -- Legendary (Divine)
			[68]  = "b066fe:ffc000", -- Spellfire (Arcane + Fire)
			[72]  = "fca5f1:b5ffff", -- Astral (Arcane + Nature)
			[80]  = "b066fe:b5ffff", -- Spellfrost (Arcane + Frost)
			[96]  = "662d8c:63e2ff", -- Spellshadow (Arcane + Shadow)
			[124] = "d20055:ff001f", -- Chaos (Arcane + Shadow + Frost + Nature + Fire)
			[1240]= "856270:b7414f", -- Chaosstrike (Chaos)
			[126] = "d585ff:00ffee", -- Magic (Arcane + Shadow + Frost + Nature + Holy)
			[127] = "d20055:ff001f", -- Chaos (Arcane + Shadow + Frost + Nature + Fire + Holy + Physical)
			-- Resources
			["Mana"] = "305dc3:3c94d1",
			["Chi"] = "bcebdc:fffff6",
		}

		ZA.ClassGradients = {
			["DEATHKNIGHT"] = "a6172d:c62843",
			["DEMONHUNTER"] = "8325ab:a738cb",
			["DRUID"] = "e46008:ff8214",
			["HUNTER"] = "8cb758:aed678",
			["MAGE"] = "31a9cf:47c9ec",
			["MONK"] = "00e475:0aff9a",
			["PALADIN"] = "da6b9b:f591bd",
			["PRIEST"] = "e4e4e4:ffffff",
			["ROGUE"] = "e4da51:fff56f",
			["SHAMAN"] = "0056c1:0a76df",
			["WARLOCK"] = "6767d2:8c8cee",
			["WARRIOR"] = "a97c54:c9a074",
		}

		ZA.ClassGradient = ZA.ClassGradients[class or 0] or "6a5f50:998b7d" --Compatibility

		ZA.SchoolGradients["DEATHKNIGHT"] = ZA.ClassGradients["DEATHKNIGHT"]
		ZA.SchoolGradients["DEMONHUNTER"] = ZA.ClassGradients["DEMONHUNTER"]
		ZA.SchoolGradients["DRUID"] = ZA.ClassGradients["DRUID"]
		ZA.SchoolGradients["HUNTER"] = ZA.ClassGradients["HUNTER"]
		ZA.SchoolGradients["MAGE"] = ZA.ClassGradients["MAGE"]
		ZA.SchoolGradients["MONK"] = ZA.ClassGradients["MONK"]
		ZA.SchoolGradients["PALADIN"] = ZA.ClassGradients["PALADIN"]
		ZA.SchoolGradients["PRIEST"] = ZA.ClassGradients["PRIEST"]
		ZA.SchoolGradients["ROGUE"] = ZA.ClassGradients["ROGUE"]
		ZA.SchoolGradients["SHAMAN"] = ZA.ClassGradients["SHAMAN"]
		ZA.SchoolGradients["WARLOCK"] = ZA.ClassGradients["WARLOCK"]
		ZA.SchoolGradients["WARRIOR"] = ZA.ClassGradients["WARRIOR"]

		ZA.SelfSchoolGradients = ZA.SchoolGradients

		if class and class == "WARLOCK" and IsSpellKnown(101508) then
		    ZA.SelfSchoolGradients[4] = ZA.SchoolGradients[401] -- The Codex of Xerrath
		end

		ZA.IsHearthstone = {
			["Hearthstone"] = true,
			["The Innkeeper's Daughter"] = true,
			["Brewfest Reveler's Hearthstone"] = true,
			["Noble Gardener's Hearthstone"] = true,
			["Peddlefeet's Lovely Hearthstone"] = true,
			["Lunar Elder's Hearthstone"] = true,
			["Fire Eater's Hearthstone"] = true,
			["Headless Horseman's Hearthstone"] = true,
			["Greatfather Winter's Hearthstone"] = true,
			["Holographic Digitalization Hearthstone"] = true,
			["Mountebank's Colorful Cloak"] = true,
			["Eternal Traveler's Hearthstone"] = true,
		}

		ZA.IsAltHearthstone = {
			["Astral Recall"] = true,
			["Town Portal"] = true,
			["Ruby Slippers"] = true,
			["Ethereal Portal"] = true,
			["Dark Portal"] = true,
		}

		ZA.CastSchoolByName = {
			-- Class
			["Activating Specialization"] = class or 0,
			-- Physical
			["Bladestorm"] = 1,
			["Aimed Shot"] = 1,
			["Steady Shot"] = 1,
			["Barrage"] = 1,
			["Piercing Shot"] = 1,
			-- Ethereal
			["Eternal Traveler's Hearthstone"] = 100,
			["Hearthstone"] = 100,
			["Garrison Hearthstone"] = 0,
			["Dalaran Hearthstone"] = 0,
			["Wormhole"] = 100,
			["Wormhole Teleport"] = 100,
			["Gnomish Transporter"] = 100,
			["Toshley Station Transporter"] = 100,
			["Wormhole: Pandaria"] = 100,
			["Goblin Transporter"] = 100,
			["The Innkeeper's Daughter"] = 100,
			["Holographic Digitalization Hearthstone"] = 100,
			["Mountebank's Colorful Cloak"] = 100,
			["Garrison Hearthstone"] = 100,
			["Teleport to Shipyard"] = 100,
			["Dalaran Hearthstone"] = 100,
			["Teleport With Error"] = 100,
			["Incorporeal"] = 100,
			-- Light Bleed
			["Skinning"] = 101,
			-- Enrage
			["Killing Spree"] = 103,
			["Death Sweep"] = 103,
			["Rapid Fire"] = 103,
			["Taunka Rage"] = 103,
			-- Holy
			["Sanity Restoration Orb"] = 2,
			["Summon Warhorse"] = 2,
			["Summon Charger"] = 2,
			["Argent Charger"] = 2,
			["Summon Dawnforge Ram"] = 2,
			["Summon Darkforge Ram"] = 2,
			["Summon Exarch's Elekk"] = 2,
			["Summon Great Exarch's Elekk"] = 2,
			["Highlord's Golden Charger"] = 2,
			["Highlord's Valorous Charger"] = 2,
			["Highlord's Vengeful Charger"] = 2,
			["Highlord's Vigilant Charger"] = 2,
			["Teleport to Vindicaar"] = 2,
			["Guide Xe'ra"] = 2,
			-- Azerite
			["Empowering the Heart"] = 200,
			["Empower Heart of Azeroth"] = 200,
			["Empower Heart"] = 200,
			["Heart of Azeroth"] = 200,
			["Unleash Heart of Azeroth"] = 200,
			["Resonant Burst"] = 200,
			["Resonant Pulse"] = 200,
			["Resonant Cascade"] = 200,
			["Azerite Barrage"] = 200,
			["Azerite Effusion"] = 200,
			["Absorbing Azerite"] = 200,
			["The Crucible of Flame"] = 200,
			["Memory of Lucid Dreams"] = 200,
			["Artifice of Time"] = 200,
			["Conflict and Strife"] = 200,
			["Life-Binder's Invocation"] = 200,
			["Ripple in Space"] = 200,
			["The Ever-Rising Tide"] = 200,
			["The Well of Existance"] = 200,
			["Vision of Perfection"] = 200,
			["Vitality Conduit"] = 200,
			["Worldvein Resonance"] = 200,
			["Blood of the Enemy"] = 200,
			["Condensed Life-Force"] = 200,
			["Essence of the Focusing Iris"] = 200,
			["Purification Protocol"] = 200,
			["The Unbound Force"] = 200,
			["Spark of Inspiration"] = 200,
			["Breath of the Dying"] = 200,
			["The Formless Void"] = 200,
			["Unwavering Ward"] = 200,
			["Spirit of Preservation"] = 200,
			["Strength of the Warden"] = 200,
			["Touch of the Everlasting"] = 200,
			["Ancient Awakening"] = 200,
			["Azerite Shards"] = 200,
			["Breath of Everlasting Spirit"] = 200,
			["Sparks of Unwavering Strength"] = 200,
			-- Holy Fire
			["Smite"] = 201,
			["Wrath"] = 201,
			-- Discipline
			["First Aid"] = 202,
			["Mending Bandage"] = 202,
			["Penance"] = 202,
			["Brewfest Reveler's Hearthstone"] = 202,
			["Jump to Skyhold"] = 202,
			-- Fire
			["Fire Eater's Hearthstone"] = 400,
			["Headless Horseman's Hearthstone"] = 400,
			["Netherlord's Brimstone Wrathsteed"] = 400,
			["Signal Flare"] = 400,
			-- Felfire
			["Felfire"] = 401,
			["Fel Immolate"] = 401,
			["Fel Fireball"] = 401,
			["Fel Meteor"] = 401,
			["Wrath Bolt"] = 401,
			["Infernal Tempest"] = 401,
			-- Nature
			["Herb Gathering"] = 8,
			["One with Nature"] = 8,
			["Noble Gardener's Hearthstone"] = 8,
			["Deadly Poison"] = 8,
			["Wound Poison"] = 8,
			["Crippling Poison"] = 8,
			-- Air
			["Lightning Bolt"] = 800,
			["Lightning Discharge"] = 800,
			["Lightning Cloud"] = 800,
			["Lightning Lasso"] = 800,
			["Chain Lightning"] = 800,
			["Stormkeeper"] = 800,
			["Forked Lightning"] = 800,
			["Electric Discharge"] = 800,
			["Thunderstorm"] = 800,
			["Call Lightning"] = 800,
			["Wind Gust"] = 800,
			["Eye of the Storm"] = 800,
			["Cyclone"] = 800,
			["Nimbus Bolt"] = 800,
			["Bioelectric Blast"] = 800,
			["Shock Burst"] = 800,
			["Farseer's Raging Tempest"] = 800,
			["Air Blast"] = 800,
			["Burst of Air"] = 800,
			["Localized Windstorm"] = 800,
			-- Water
			["Fishing"] = 801,
			["Healing Surge"] = 801,
			["Healing Wave"] = 801,
			["Chain Heal"] = 801,
			["Healing Rain"] = 801,
			["Downpour"] = 801,
			["Wellspring"] = 801,
			["Deep Waters"] = 801,
			["Watersight"] = 801,
			["Spray Water"] = 801,
			["Extinguish Fire"] = 801,
			["Water Bolt"] = 801,
			["Wave Crash"] = 801,
			["Splash"] = 801,
			-- Mana
			["Potion of Replenishment"] = "Mana",
			-- Mist
			["Vivify"] = 802,
			["Soothing Mist"] = 802,
			["Enveloping Mist"] = 802,
			["Essence Font"] = 802,
			["Zen Meditation"] = 802,
			["Song of Chi-Ji"] = 802,
			["Surging Mist"] = 802,
			["Call of the Mists"] = 802,
			["Zen Pilgrimage"] = 802,
			["Invoke Yu'lon"] = 802,
			["Ban-Lu, Grandmaster's Companion"] = 802,
			["Crackling Jade Lightning"] = 802,
			["Zen Healing"] = 802,
			-- Earth
			["Earth Spike"] = 803,
			["Earthquake"] = 803,
			-- Poison
			["Bug Sprayer"] = 804,
			["Crippling Poison"] = 804,
			["Deadly Poison"] = 804,
			["Envenom"] = 804,
			["Poison"] = 804,
			["Poison Bolt"] = 804,
			["Poison Spit"] = 804,
			["Venom"] = 804,
			["Venom Spit"] = 804,
			["Venom Splash"] = 804,
			["Vile Impact"] = 804,
			["Wound Poison"] = 804,
			-- Frost
			["Greatfather Winter's Hearthstone"] = 16,
			["Frostflurry"] = 16,
			-- Elemental
			["Elemental Blast"] = 28,
			-- Shadow
			["Siphon of Acherus"] = 32,
			["Acherus Deathcharger"] = 32,
			["Crimson Deathcharger"] = 32,
			["Shadowblade's Baneful Omen"] = 32,
			["Shadowblade's Crimson Omen"] = 32,
			["Shadowblade's Lethal Omen"] = 32,
			["Shadowblade's Murderous Omen"] = 32,
			["Shadow Sight"] = 32,
			-- Void
			["Mind Blast"] = 320,
			["Mind Flay"] = 320,
			["Mind Sear"] = 320,
			["Void Eruption"] = 320,
			["Shadow Word: Void"] = 320,
			["Void Torrent"] = 320,
			["Dark Void"] = 320,
			["Distorting Reality"] = 320,
			["Open Vision"] = 320,
			["Void Bolt"] = 320,
			["Void Bolt Volley"] = 320,
			["Void Exhaust"] = 320,
			["Void Storm"] = 320,
			["Void Stream"] = 320,
			["Enter The Rift"] = 320,
			["Fragmented Halo"] = 320,
			["Void Beam"] = 320,
			["Netherlord's Accursed Wrathsteed"] = 320,
			["Summon Voidwalker"] = 320,
			["Unbound Darkness"] = 320,
			["Entropic Whirl"] = 320,
			["Reality Rend"] = 320,
			["The Dark is Rising"] = 320,
			["Crackling Void"] = 320,
			["Voidwrath"] = 320,
			-- Blood
			["Health Funnel"] = 321,
			["Blooddrinker"] = 321,
			["Vampiric Touch"] = 321,
			["Drain Life"] = 321,
			["Create Healthstone"] = 321,
			["Blood Ritual"] = 321,
			-- Pain
			["Havoc"] = 322,
			-- Ghost
			["Haunt"] = 323,
			["Mind Vision"] = 323,
			["Banish"] = 323,
			["Wraith Walk"] = 323,
			-- Shadowstrike
			["Running Wild"] = 33,
			-- Plague
			["Fling Filth"] = 40,
			-- Shadowfrost
			["Rune of Razorice"] = 48,
			-- Arcane
			["Lunar Elder's Hearthstone"] = 64,
			["Town Portal"] = 64,
			["Ruby Slippers"] = 64,
			["Ethereal Portal"] = 64,
			["Disenchant"] = 64,
			["Disenchanting"] = 64,
			["Disenchanting Carefully"] = 64,
			["Empower Golem"] = 64,
			["Scrying"] = 64,
			-- Spellstrike
			["Rune of the Stoneskin Gargoyle"] = 65,
			-- Divine
			["Peddlefeet's Lovely Hearthstone"] = 66,
			["Petting"] = 66,
			["Calming"] = 66,
			["Rescuing"] = 66,
			["Freeing"] = 66,
			["Rainbow Generator"] = 66,
			["Unspoken Gratitude"] = 66,
			-- Astral
			["Astral Recall"] = 72,
			["Far Sight"] = 72,
			-- Spellshadow
			["Rune of the Fallen Crusader"] = 96,
			-- Chaos
			["Dark Portal"] = 124,
			["Slayer's Felbroken Shrieker"] = 124,
			["Netherlord's Chaotic Wrathsteed"] = 124,
			["Fel Barrage"] = 124,
			["Eye Beam"] = 124,
			["Eye of Kilrogg"] = 124,
			["Summon Imp"] = 124,
			["Summon Fel Imp"] = 124,
			["Summon Felguard"] = 124,
			-- Chaosstrike
			["Blade Dance"] = 1240,
			-- Chi
			["Chi Burst"] = "Chi",
			["Fists of Fury"] = "Chi",
		}

		if class and class == "SHAMAN" and spec == 1 then
			ZA.CastSchoolByName["Farseer's Raging Tempest"] = 400
		elseif class and class == "SHAMAN" and spec == 3 then
			ZA.CastSchoolByName["Farseer's Raging Tempest"] = 801
		end

		ZA.CastSchoolByIcon = {
			-- Mount
			[1509824] = 2, -- High Priest's Lightsworn Seeker
			[1518632] = 100, -- High Priest's Lightsworn Seeker (Discipline)
			[1518633] = 2, -- High Priest's Lightsworn Seeker (Holy)
			[1518634] = 320, -- High Priest's Lightsworn Seeker (Shadow)
			[1516058] = 64, -- Archmage's Prismatic Disc (Arcane)
			[1517838] = 4, -- Archmage's Prismatic Disc (Fire)
			[1517839] = 16, -- Archmage's Prismatic Disc (Frost)
			[1518275] = 40, -- Deathlord's Vilebrood Vanquisher
			[1580440] = 321, -- Deathlord's Vilebrood Vanquisher (Blood)
			[1580441] = 16, -- Deathlord's Vilebrood Vanquisher (Frost)
			[1580442] = 40, -- Deathlord's Vilebrood Vanquisher (Unholy)
			-- Azerite
			[1869493] = 200, -- Heart of Azeroth
		}

		ZA.CastSchoolBySpellID = {
			-- Quest
			[93773] = 100,
			[66280] = 100,
			[70476] = 100,
			[70813] = 101,
			[255460] = 2,
			[252295] = 2,
			[248345] = 2,
			[4975] = 202,
			[4977] = 202,
			[4978] = 202,
			[248906] = 202,
			[77314] = 400,
			[71030] = 400,
			[245030] = 400,
			[70458] = 8,
			[68422] = 801,
			[75192] = 28,
			[78336] = 32,
			[80702] = 32,
			[80704] = 32,
			[62772] = 321,
			[63797] = 321,
		}

		ZA.AuraSchoolByName = {
			-- Physical
			["Slice and Dice"] = 1,
			["Broadside"] = 1,
			["Buried Treasure"] = 1,
			["Grand Melee"] = 1,
			["Ruthless Precision"] = 1,
			["Skull and Crossbones"] = 1,
			["True Bearing"] = 1,
			["Steady Focus"] = 1,
			["Shrapnel Bomb"] = 1,
			["Blade Flurry"] = 1,
			["Beast Cleave"] = 1,
			["Trick Shots"] = 1,
			["Sweeping Strikes"] = 1,
			["Brutal Haymaker"] = 1,
			["Colossus Smash"] = 1,
			["Whirlwind"] = 1,
			["Teachings of the Monastery"] = 1,
			["Precise Shots"] = 1,
			["Overpower"] = 1,
			["Tip of the Spear"] = 1,
			["Pulverize"] = 1,
			["Ironfur"] = 1,
			["Shield of the Righteous"] = 1,
			["Shield Block"] = 1,
			["Demon Spikes"] = 1,
			["Demoralizing Shout"] = 1,
			["Pain Suppression"] = 1,
			["Survival Instincts"] = 1,
			["Feint"] = 1,
			["Riposte"] = 1,
			["Evasion"] = 1,
			["Safeguard"] = 1,
			["Die by the Sword"] = 1,
			["Redoubt"] = 1,
			["Stalwart Navigation"] = 1,
			["Defense Matrix"] = 1,
			["Huddle"] = 1,
			["Tombstone"] = 1,
			["Sprint"] = 1,
			["Posthaste"] = 1,
			["Draenic Swiftness Potion"] = 1,
			["Bounding Stride"] = 1,
			["Spirit's Swiftness"] = 1,
			["Master Marksman"] = 1,
			-- Ethereal
			["Heroism"] = 100,
			["Trueshot"] = 100,
			["Lively Spirit"] = 100,
			["Spirit of Redemption"] = 100,
			["Rapture"] = 100,
			["Guardian Spirit"] = 100,
			["Ferocity of the Frostwolf"] = 100,
			["Might of the Blackrock"] = 100,
			["Zeal of the Burning Blade"] = 100,
			["Rictus of the Laughing Skull"] = 100,
			["Hyper Organic Light Originator"] = 100,
			-- Light Bleed
			["A Murder of Crows"] = 101,
			["Rake"] = 101,
			["Thrash"] = 101,
			["Garrote"] = 101,
			["Kill Command"] = 101,
			-- Heavy Bleed
			["Rupture"] = 102,
			["Rip"] = 102,
			["Internal Bleeding"] = 102,
			-- Enrage
			["Mongoose Fury"] = 103,
			["Frenzy"] = 103,
			["Alacrity"] = 103,
			["Drums of Rage"] = 103,
			["Drums of Fury"] = 103,
			["Drums of the Mountain"] = 103,
			["Drums of the Maelstrom"] = 103,
			["Primal Rage"] = 103,
			["Adrenaline Rush"] = 103,
			["Bestial Wrath"] = 103,
			["Unholy Strength"] = 103,
			["Coordinated Assault"] = 103,
			["Recklessness"] = 103,
			["Enrage"] = 103,
			["Unholy Frenzy"] = 103,
			["Tiger's Fury"] = 103,
			["Incite the Pack"] = 103,
			["Dance of Death"] = 103,
			["Clockwork Heart"] = 103,
			["In The Rhythm"] = 103,
			["Sharpened Claws"] = 103,
			["Opportunity"] = 103,
			["Lock and Load"] = 103,
			["Double Tap"] = 103,
			["Owlkin Frenzy"] = 103,
			["Revenge!"] = 103,
			["Sudden Death"] = 103,
			["Loaded Dice"] = 103,
			["Last Stand"] = 103,
			["Rallying Cry"] = 103,
			["Victorious"] = 103,
			["Stampeding Roar"] = 103,
			["War Machine"] = 103,
			["Berserker Rage"] = 103,
			["Master's Call"] = 103,
			["Battle Potion of Agility"] = 103,
			["Battle Potion of Strength"] = 103,
			["Potion of Bursting Blood"] = 103,
			["Potion of Deadly Grace"] = 103,
			["Potion of the Old War"] = 103,
			["Draenic Agility Potion"] = 103,
			["Draenic Strength Potion"] = 103,
			["Draenic Versatility Potion"] = 103,
			["Potion of Mogu Power"] = 103,
			["Virmen's Bite"] = 103,
			["Volcanic Power"] = 103,
			["Tol'vir Agility"] = 103,
			["Golem's Strength"] = 103,
			["Brawler's Battle Potion of Agility"] = 103,
			["Brawler's Battle Potion of Strength"] = 103,
			["Potion of Heroes"] = 103,
			["Insane Strength Potion"] = 103,
			["Mighty Rage"] = 103,
			["Saltwater Potion"] = 103,
			["Potion of Unbridled Fury"] = 103,
			["Potion of Focused Resolve"] = 103,
			["Superior Battle Potion of Strength"] = 103,
			["Superior Battle Potion of Agility"] = 103,
			["Drums of Speed"] = 103,
			["Ancient Hysteria"] = 103,
			["Blood Fury"] = 103,
			["Berserking"] = 103,
			["Barbarian"] = 103,
			-- Holy
			["Inquisition"] = 2,
			["Apotheosis"] = 2,
			["Holy Avenger"] = 2,
			["Avenging Crusader"] = 2,
			["Inspiring Vanguard"] = 2,
			["Judgment"] = 2,
			["Avenger's Valor"] = 2,
			["Surge of Light"] = 2,
			["Infusion of Light"] = 2,
			["Empyrean Power"] = 2,
			["Divine Purpose"] = 2,
			["Divine Protection"] = 2,
			["Ardent Defender"] = 2,
			["Guardian of Ancient Kings"] = 2,
			["Desperate Prayer"] = 2,
			["Aura Mastery"] = 2,
			["Aegis of Light"] = 2,
			["Bulwark of Light"] = 2,
			["Gift of the Naaru"] = 2,
			["Selfless Healer"] = 2,
			["Angelic Feather"] = 2,
			["Divine Steed"] = 2,
			["Archangel"] = 2,
			["Divine Hymn"] = 2,
			["Avenging Wrath"] = 2,
			["Blade of Wrath"] = 2,
			-- Azerite
			["Concentrated Flame"] = 200,
			["Azerite Energy"] = 200,
			["Azerite Empowered"] = 200,
			["Guardian of Azeroth"] = 200,
			["Reaping Flames"] = 200,
			["Memory of Lucid Dreams"] = 200,
			-- Holy Fire
			["Consecration"] = 201,
			["Holy Fire"] = 201,
			["Sunfire"] = 201,
			["Solar Empowerment"] = 201,
			["Heating Up"] = 201,
			["Shield of Vengeance"] = 201,
			-- Discipline
			["First Aid"] = 202,
			["Power Word: Barrier"] = 202,
			["Power Word: Shield"] = 202,
			["Body and Soul"] = 202,
			["Luminous Barrier"] = 202,
			["Blessing of Freedom"] = 202,
			["Focused Will"] = 202,
			["Ignore Pain"] = 202,
			["Dampen Harm"] = 202,
			["Sanctum"] = 202,
			["Levitate"] = 202,
			["Slow Fall"] = 202,
			["Mend Pet"] = 202,
			["Guard"] = 202,
			["Secret Infusion"] = 202,
			-- Fire
			["Immolate"] = 4,
			["Rain of Fire"] = 4,
			["Backdraft"] = 4,
			["Chaotic Inferno"] = 4,
			["Flametongue"] = 400,
			["Purge the Wicked"] = 400,
			["Explosive Shot"] = 400,
			["Breath of Fire"] = 400,
			["Living Bomb"] = 400,
			["Flame Shock"] = 400,
			["Combustion"] = 400,
			["Fireblood"] = 400,
			["Fire Elemental"] = 400,
			["Lava Surge"] = 400,
			["Hot Streak!"] = 400,
			["Blazing Barrier"] = 400,
			["Nitro Boosts"] = 400,
			["Frenetic Speed"] = 400,
			["Wildfire Bomb"] = 400,
			-- Felfire
			["Sigil of Flame"] = 401,
			["Immolation Aura"] = 401,
			["Reverse Entropy"] = 401,
			["Infernal"] = 401,
			["Spectral Sight"] = 401,
			["Fiery Brand"] = 401,
			["Anti-Magic Shell"] = 401,
			-- Nature
			["Efflorescence"] = 8,
			["Aspect of the Wild"] = 8,
			["Force of Nature"] = 8,
			["Predatory Swiftness"] = 8,
			["Camouflage"] = 8,
			["Barkskin"] = 8,
			["Aspect of the Turtle"] = 8,
			["Survival of the Fittest"] = 8,
			["Tranquility"] = 8,
			["Aspect of the Cheetah"] = 8,
			["The Sentinel's Eternal Refuge"] = 8,
			["Spiritwalker's Grace"] = 8,
			["Draenic Living Action Potion"] = 8,
			["Living Free Action"] = 8,
			["Free Action"] = 8,
			["Dash"] = 8,
			["Tiger Dash"] = 8,
			-- Lightning
			["Call Lightning"] = 800,
			["Slicing Maelstrom"] = 800,
			["Lightning Shield Overcharge"] = 800,
			["Xuen"] = 800,
			["Storm Elemental"] = 800,
			["Stormkeeper"] = 800,
			["Wind Rush"] = 800,
			["Wind Rush Totem"] = 800,
			["Skystep Potion"] = 800,
			["Potion of Light Steps"] = 800,
			["Lightfoot Potion"] = 800,
			["Embrace of Pa'ku"] = 800,
			["Crash Lightning"] = 800,
			["Gathering Storms"] = 800,
			-- Water
			["Tidal Waves"] = 801,
			["Undulation"] = 801,
			["Razor Coral"] = 801,
			["Swim Speed"] = 801,
			["Darkwater Potion"] = 801,
			["Murliver Oil"] = 801,
			["Potion of Replenishment"] = 801,
			-- Mist
			["Rushing Jade Wind"] = 802,
			["Refreshing Jade Wind"] = 802,
			["Misty Peaks"] = 802,
			["Lifecycles (Vivify)"] = 802,
			["Lifecycles (Enveloping Mist)"] = 802,
			["Fury of Xuen"] = 802,
			["Dance of Chi-Ji"] = 802,
			["Fortifying Brew"] = 802,
			["Zen Meditation"] = 802,
			["Life Cocoon"] = 802,
			["Tiger's Lust"] = 802,
			["Serenity"] = 802,
			["Potion of the Jade Serpent"] = 802,
			["Alpha Tiger"] = 802,
			["Chi Torpedo"] = 802,
			-- Earth
			["Earthquake"] = 803,
			["Avatar"] = 803,
			["Niuzao"] = 803,
			["Earth Elemental"] = 803,
			["Lava Shock"] = 803,
			["Tectonic Thunder"] = 803,
			["Earth Shield"] = 803,
			["Ironskin Brew"] = 803,
			["Harden Skin"] = 803,
			["Stoneform"] = 803,
			["Tremor Totem"] = 803,
			["Avalanche Elixir"] = 803,
			["Earthwarden"] = 803,
			-- Poison
			["Envenom"] = 804,
			["Deadly Poison"] = 804,
			["Serpent Sting"] = 804,
			["Nighrmare Corruption"] = 804,
			["Shiver Venom"] = 804,
			-- Stormstrike
			["Aspect of the Eagle"] = 9,
			["Gathering Storm"] = 9,
			-- Frost
			["Bone Chilling"] = 16,
			["Frost Fever"] = 16,
			["Remorseless Winter"] = 16,
			["Blizzard"] = 16,
			["Pillar of Frost"] = 16,
			["Icy Veins"] = 16,
			["Freezing Rain"] = 16,
			["Icefury"] = 16,
			["Fingers of Frost"] = 16,
			["Brain Freeze"] = 16,
			["Ice Block"] = 16,
			["Icebound Fortitude"] = 16,
			["Ice Barrier"] = 16,
			["Ice Floes"] = 16,
			-- Froststrike
			["Frostfire Reflector"] = 17,
			-- Elemental
			["Ascendance"] = 28,
			["Elemental Blast: Critical Strike"] = 28,
			["Elemental Blast: Haste"] = 28,
			["Elemental Blast: Mastery"] = 28,
			["Storm, Earth, and Fire"] = 28,
			["Master of the Elements"] = 28,
			-- Shadow
			["Shadow Dance"] = 32,
			["Frailty"] = 32,
			["Schism"] = 32,
			["Soul Reaper"] = 32,
			["Nightblade"] = 32,
			["Corruption"] = 32,
			["Twist of Fate"] = 32,
			["Dark Soul: Instability"] = 32,
			["Demon Soul"] = 32,
			["Symbols of Death"] = 32,
			["Soul Reaper"] = 32,
			["Dark Soul: Misery"] = 32,
			["Shadowfiend"] = 32,
			["Mindbender"] = 32,
			["Inevitable Demise"] = 32,
			["Shadowy Insight"] = 32,
			["Nightfall"] = 32,
			["Thought Harvester"] = 32,
			["Shroud of Concealment"] = 32,
			["Feed on the Weak"] = 32,
			["Doubting Mind"] = 32,
			["Cloak of Shadows"] = 32,
			["Anti-Magic Zone"] = 32,
			["Soul Barrier"] = 32,
			["Shadowstep"] = 32,
			["Death's Advance"] = 32,
			["Dreadstalkers"] = 32,
			["Sudden Doom"] = 32,
			-- Void
			["Surrender to Madness"] = 320,
			["Darkness"] = 320,
			["Entropic Embrace"] = 320,
			["Nether Portal"] = 320,
			["Spatial Rift"] = 320,
			-- Blood
			["Hemorrhage"] = 321,
			["Vampiric Touch"] = 321,
			["Blood Plague"] = 321,
			["Bloodlust"] = 321,
			["Vendetta"] = 321,
			["Mark of Doom"] = 321,
			["Hemostasis"] = 321,
			["Scent of Blood"] = 321,
			["Bloodtalons"] = 321,
			["Crimson Scourge"] = 321,
			["Mark of Blood"] = 321,
			["Hand of Sacrifice"] = 321,
			["Vampiric Blood"] = 321,
			["Dark Pact"] = 321,
			["Crimson Vial"] = 321,
			["Frenzied Regeneration"] = 321,
			["Vampiric Embrace"] = 321,
			["Enraged Regeneration"] = 321,
			["Bloodthirsty Coral"] = 321,
			["Dark Succor"] = 321,
			["Transfusion"] = 321,
			["Scent of Blood"] = 321,
			["Vampiric Speed"] = 321,
			["Death and Decay"] = 321,
			-- Pain
			["Shadow Word: Pain"] = 322,
			["Agony"] = 322,
			["Havoc"] = 322,
			["Festering Wound"] = 322,
			-- Ghost
			["Haunt"] = 323,
			["Phantom Singularity"] = 323,
			["Wandering Soul"] = 323,
			["Spirit Shift"] = 323,
			["Vanish"] = 323,
			["Cloaking"] = 323,
			["Dispersion"] = 323,
			["Fade"] = 323,
			["Greater Fade"] = 323,
			["Gloaming Powder"] = 323,
			["Twilight Powder"] = 323,
			["Obsidian Claw"] = 323,
			["Potion of Rising Death"] = 323,
			-- Shadowstrike
			["Dancing Rune Weapon"] = 33,
			["Empower Rune Weapon"] = 33,
			["Shadow Blades"] = 33,
			["Subterfuge"] = 33,
			["Rune Tap"] = 33,
			["Shadow Reflector"] = 33,
			["Darkflight"] = 33,
			-- Shadowflame
			["Vilefiend"] = 36,
			["Bilescourge Bombers"] = 36,
			-- Plague
			["Virulent Plague"] = 40,
			["Defile"] = 40,
			["Dark Transformation"] = 40,
			["Bone Shield"] = 40,
			-- Arcane
			["Nether Tempest"] = 64,
			["Moonfire"] = 64,
			["Time Warp"] = 64,
			["Arcane Power"] = 64,
			["Omnipotence"] = 64,
			["Mirror Image"] = 64,
			["Rune of Power"] = 64,
			["Lunar Empowerment"] = 64,
			["Galactic Guardian"] = 64,
			["Aura of the Blue Dragon"] = 64,
			["Potion of Prolonged Power"] = 64,
			["Prismatic Barrier"] = 64,
			-- Spellstrike
			["Spell Reflection"] = 65,
			["Mass Spell Reflection"] = 65,
			["Nether Ward"] = 65,
			["Battle Potion of Intellect"] = 65,
			["Draenic Intellect Potion"] = 65,
			["Brawler's Battle Potion of Intellect"] = 65,
			["Superior Battle Potion of Intellect"] = 65,
			["Lesser Invisibility"] = 65,
			["Greater Invisibility"] = 65,
			["Potion of Concealment"] = 65,
			["Potion of Minor Invisibility"] = 65,
			["Potion of Shrouding"] = 65,
			["Chrono Shift"] = 65,
			["Displacement Beacon"] = 65,
			["Shroud of Arcane Echoes"] = 65,
			-- Divine
			["Chi-Ji"] = 66,
			["Divine Shield"] = 66,
			["Blessing of Protection"] = 66,
			["Blessing of Spellwarding"] = 66,
			["Ray of Hope"] = 66,
			["Egg Rush!"] = 66,
			-- Legendary
			["Gift of the Titans"] = 660,
			["Draconic Empowerment"] = 660,
			["Steadfast Resolve"] = 660,
			["Draconic Descent"] = 660,
			-- Astral
			["Totem Mastery"] = 72,
			["Starlord"] = 72,
			["Stellar Flare"] = 72,
			["Starfall"] = 72,
			["Fury of Elune"] = 72,
			["Celestial Alignment"] = 72,
			["Ancestral Resonance"] = 72,
			["Feral Spirit"] = 72,
			["Guardian of Elune"] = 72,
			["Netherwalk"] = 72,
			["Invisibility"] = 72,
			["Invisible"] = 72,
			["Astral Shift"] = 72,
			["Diffuse Magic"] = 72,
			["Spirit Link Totem"] = 72,
			["Ancestral Guidance"] = 72,
			["Spirit Mend"] = 72,
			["Spirit Walk"] = 72,
			["Incarnation"] = 72,
			["Incarnation: Chosen of Elune"] = 72,
			-- Chaos
			["Metamorphosis"] = 124,
			["Deomic Tyrant"] = 124,
			["Darkglare"] = 124,
			["Felguard"] = 124,
			["Demonic Calling"] = 124,
			["Demonic Core"] = 124,
			-- Chaosstrike
			["Felstorm"] = 1240,
			["Burning Mirror"] = 1240,
			["Chaos Blades"] = 1240,
			["Unending Resolve"] = 1240,
			["Blur"] = 1240,
			["Man'ari Training Amulet"] = 1240,
			["Everlasting Hunt"] = 1240,
			["Touch of Death"] = 1240,
			-- Mana
			["Clearcasting"] = "Mana",
			["Innervate"] = "Mana",
			["Symbol of Hope"] = "Mana",
			-- Chi
			["Touch of Karma"] = "Chi",
			----------
			-- Enchants
			["Lord Blastington's Scope of Doom"] = 1,
		}

		ZA.AuraSchoolBySpellID = {
			-- Enrage
			[28507] = 103, -- Haste (Potion)
			[28508] = 103, -- Destruction (Potion)
			[306548] = 103, -- Frothing Frenzy (Potion)
			-- Spellstrike
			[53909] = 65, -- Wild Magic (Potion)
			----------
			-- Trinket - Classic
			[23271] = 202,
			[23723] = 64,
			[23733] = 2,
			[23734] = 8,
			[26481] = 64,
			[26166] = 64,
			[26168] = 103,
			[29602] = 103,
			[95880] = 103,
			[95879] = 804,
			[95881] = 103,
			[95227] = 103,
			[290032] = 103,
			[298717] = 103,
			[298722] = 801,
			[290028] = 64,
			[290033] = 103,
			[298719] = 103,
			-- Trinket - The Burning Crusade
			[26576] = 103,
			[26581] = 103,
			[26599] = 103,
			[26609] = 103,
			[26614] = 103,
			[33662] = 64,
			[33667] = 103,
			[32355] = 64,
			[39201] = 64,
			[39200] = 103,
			[39439] = 2,
			[40997] = 103,
			[41404] = 103,
			[40998] = 103,
			[41005] = 103,
			[40999] = 103,
			[41009] = 103,
			[41002] = 103,
			[39511] = 103,
			[39443] = 64,
			[32362] = 103,
			[144073] = 64,
			[144074] = 103,
			[41261] = 103,
			[41263] = 103,
			[32367] = 202,
			[35733] = 64,
			[35163] = 64,
			[35165] = 64,
			[35166] = 103,
			[36347] = 2,
			[60066] = 103,
			[36432] = 64,
			[35095] = 202,
			[34747] = 64,
			[34775] = 103,
			[37198] = 202,
			[37508] = 103,
			[37174] = 64,
			[38348] = 64,
			[42084] = 9,
			[37344] = 8,
			[40402] = 202,
			[37342] = 8,
			[37341] = 103,
			[37343] = 64,
			[45053] = 103,
			[46783] = 103,
			[46784] = 103,
			[31040] = 103,
			[31047] = 103,
			[33370] = 103,
			[33400] = 202,
			[34106] = 103,
			[234786] = 202,
			[34000] = 64,
			[33807] = 103,
			[34210] = 2,
			[34321] = 64,
			[35337] = 64,
			[40724] = 103,
			[40729] = 103,
			[40459] = 400,
			[40487] = 103,
			[40483] = 64,
			[40461] = 103,
			[40480] = 64,
			[40477] = 103,
			[40396] = 124,
			[37656] = 64,
			[45040] = 103,
			-- Trinket - Battle for Azeroth
			[300919] = 800, -- Highborne Compendium of Storms
			[303953] = 800, -- Shockbitten
		}

		ZA.ClassIcons = {
			["DEATHKNIGHT"] = 625998,
			["DEMONHUNTER"] = 1260827,
			["DRUID"] = 625999,
			["HUNTER"] = 626000,
			["MAGE"] = 626001,
			["MONK"] = 610018,
			["PALADIN"] = 626003,
			["PRIEST"] = 626004,
			["ROGUE"] = 626005,
			["SHAMAN"] = 626006,
			["WARLOCK"] = 626007,
			["WARRIOR"] = 626008,
		}

		ZA.CastIconByName = {
			-- Class Icon
			["Activating Specialization"] = ZA.ClassIcons[class] or 0,
			-- No Icon
			["Opening"] = 0,
			-- Learning
			["Learning"] = 135740,
			["A Compendium of the Herbs of Draenor"] = 135740,
			["Introduction to Cooking in Draenor"] = 135740,
			["Draenor Blacksmithing"] = 135740,
			["Draenor Jewelcrafting"] = 135740,
			["A Guide to Skinning in Draenor"] = 135740,
			["A Treatise on Mining in Draenor"] = 135740,
			-- Flight Path Toy
			["Walking Kalimdor with the Earthmother"] = 237388,
			["Surviving Kalimdor"] = 237388,
			["Provisioning Azeroth"] = 1064187,
			["7th Legion Scouting Map"] = 237387,
			-- Hearthstone
			["Holographic Digitalization Hearthstone"] = 2491049,
			-- Misc
			["Tinkering"] = 2915722,
		}

		ZA.CastIconBySpellID = {
			-- Mount
			[103195] = 2143066, -- Mountain Horse
			[103196] = 2143065, -- Swift Mountain Horse

			-- Quest
			[79450] = 237329,
			[21050] = 133942,
			[93773] = 133015,
			[77821] = 134709,
			[5316] = 132914,
			[5206] = 133849,
			[4975] = 135139,
			[4977] = 135139,
			[4978] = 135139,
			[69453] = 133841,
			[13714] = 133736,
			[14199] = 133736,
			[69743] = 133032,
			[62772] = 134719,
			[63797] = 134840,
			[65196] = 134749,
			[75192] = 135220,
			[80702] = 332402,
			[80704] = 332402,
			[70155] = 134228,
			[70458] = 133669,
			[252295] = 1112947,

			-- Cooking
				-- Kul Tiran Cuisine & Zandalari Cuisine
					-- Delicacies
					[314959] = 461132, -- Baked Voidfin
					[314961] = 237335, -- Dubious Delight
					[314962] = 237331, -- Ghastly Goulash
					[314963] = 237353, -- Grilled Gnasher
					[314960] = 461134, -- K'Bab
					-- Light Meals
					[303788] = 134042, -- Unagi Skewer
					[259435] = 2066018, -- Seasoned Loins (★★★)
					[259434] = 2066018, -- Seasoned Loins (★★)
					[259433] = 2066018, -- Seasoned Loins (★)
					[286381] = 2443145, -- Honey Potpie
					[259432] = 2066007, -- Grilled Catfish (★★★)
					[259431] = 2066007, -- Grilled Catfish (★★)
					[259430] = 2066007, -- Grilled Catfish (★)
					[280282] = 133199, -- Heartsbane Hexwurst
					-- Desserts
					[259413] = 2066009, -- Kul Tiramisu (★★★)
					[259412] = 2066009, -- Kul Tiramisu (★★)
					[259411] = 2066009, -- Kul Tiramisu (★)
					[259438] = 2066010, -- Loa Loaf (★★★)
					[259437] = 2066010, -- Loa Loaf (★★)
					[259436] = 2066010, -- Loa Loaf (★)
					[259444] = 2066014, -- Mon'Dazi (★★★)
					[259443] = 2066014, -- Mon'Dazi (★★)
					[259442] = 2066014, -- Mon'Dazi (★)
					[259426] = 2066016, -- Ravenberry Tarts (★★★)
					[259425] = 2066016, -- Ravenberry Tarts (★★)
					[259424] = 2066016, -- Ravenberry Tarts (★)
					[288029] = 2466573, -- Wild Berry Bread (★★★)
					[288028] = 2466573, -- Wild Berry Bread (★★)
					[288027] = 2466573, -- Wild Berry Bread (★)
					-- Large Meals
					[301392] = 134063, -- Mecha-Bytes
					[297086] = 133904, -- Abyssal-Fried Rissole (★★★)
					[297085] = 133904, -- Abyssal-Fried Rissole (★★)
					[297084] = 133904, -- Abyssal-Fried Rissole (★)
					[297083] = 651570, -- Baked Port Tato (★★★)
					[297082] = 651570, -- Baked Port Tato (★★)
					[297081] = 651570, -- Baked Port Tato (★)
					[297089] = 134004, -- Bil'Tong (★★★)
					[297088] = 134004, -- Bil'Tong (★★)
					[297087] = 134004, -- Bil'Tong (★)
					[297074] = 461136, -- Fragrant Kakavia (★★★)
					[297075] = 461136, -- Fragrant Kakavia (★★)
					[297077] = 461136, -- Fragrant Kakavia (★)
					[297080] = 1046262, -- Mech-Dowel's "Big Mech" (★★★)
					[297079] = 1046262, -- Mech-Dowel's "Big Mech" (★★)
					[297078] = 1046262, -- Mech-Dowel's "Big Mech" (★)
					[259416] = 2066008, -- Honey-Glazed Haunches (★★★)
					[259415] = 2066008, -- Honey-Glazed Haunches (★★★)
					[259414] = 2066008, -- Honey-Glazed Haunches (★★★)
					[259441] = 2066017, -- Sailor's Pie (★★★)
					[259440] = 2066017, -- Sailor's Pie (★★)
					[259439] = 2066017, -- Sailor's Pie (★)
					[288033] = 2466899, -- Seasoned Steak and Potatoes (★★★)
					[288032] = 2466899, -- Seasoned Steak and Potatoes (★★)
					[288030] = 2466899, -- Seasoned Steak and Potatoes (★)
					[259447] = 2066019, -- Spiced Snapper (★★★)
					[259446] = 2066019, -- Spiced Snapper (★★)
					[259445] = 2066019, -- Spiced Snapper (★)
					[259429] = 2066021, -- Swamp Fish 'n Chips (★★★)
					[259428] = 2066021, -- Swamp Fish 'n Chips (★★)
					[259427] = 2066021, -- Swamp Fish 'n Chips (★)
					[290473] = 133197, -- Boralus Blood Sausage (★★★)
					[290472] = 133197, -- Boralus Blood Sausage (★★)
					[290471] = 133197, -- Boralus Blood Sausage (★)
					-- Feasts
					[297107] = 456330, -- Famine Evaluator And Snack Table (★★★)
					[297106] = 456330, -- Famine Evaluator And Snack Table (★★)
					[297105] = 456330, -- Famine Evaluator And Snack Table (★)
					[259423] = 2066011, -- Bountiful Captain's Feast (★★★)
					[259422] = 2066011, -- Bountiful Captain's Feast (★★)
					[259421] = 2066011, -- Bountiful Captain's Feast (★)
					[287112] = 2451910, -- Sanguinated Feast (★★★)
					[287110] = 2451910, -- Sanguinated Feast (★★)
					[287108] = 2451910, -- Sanguinated Feast (★)
					[259420] = 2066013, -- Galley Banquet (★★★)
					[259419] = 2066013, -- Galley Banquet (★★)
					[259418] = 2066013, -- Galley Banquet (★)
				-- Food of the Broken Isles
					-- Snacks
					[201685] = 1387636, -- Crispy Bacon (★★★)
					[201684] = 1387636, -- Crispy Bacon (★★)
					[201683] = 1387636, -- Crispy Bacon (★)
					[230046] = 651570, -- Spiced Falcosaur Omelet
					[201560] = 1387641, -- Bear Tartare (★★★)
					[201540] = 1387641, -- Bear Tartare (★★)
					[201513] = 1387641, -- Bear Tartare (★)
					[201559] = 1387645, -- Dried Mackerel Strips (★★★)
					[201539] = 1387645, -- Dried Mackerel Strips (★★)
					[201512] = 1387645, -- Dried Mackerel Strips (★)
					[201561] = 1387649, -- Fighter Chow (★★★)
					[201541] = 1387649, -- Fighter Chow (★★)
					[201514] = 1387649, -- Fighter Chow (★)
					-- Light Meals
					[201545] = 1387644, -- Deep-Fried Mossgill (★★★)
					[201525] = 1387644, -- Deep-Fried Mossgill (★★)
					[201496] = 1387644, -- Deep-Fried Mossgill (★)
					[201547] = 1387647, -- Faronaar Fizz (★★★)
					[201527] = 1387647, -- Faronaar Fizz (★★)
					[201498] = 1387647, -- Faronaar Fizz (★)
					[201546] = 1387660, -- Pickled Stormray (★★★)
					[201526] = 1387660, -- Pickled Stormray (★★)
					[201497] = 1387660, -- Pickled Stormray (★)
					[201544] = 1387662, -- Salt and Pepper Shank (★★★)
					[201524] = 1387662, -- Salt and Pepper Shank (★★)
					[201413] = 1387662, -- Salt and Pepper Shank (★)
					[201548] = 1387664, -- Spiced Rib Roast (★★★)
					[201528] = 1387664, -- Spiced Rib Roast (★★)
					[201499] = 1387664, -- Spiced Rib Roast (★)
					-- Large Meals
					[201551] = 1387640, -- Barracuda Mrglgagh (★★★)
					[201531] = 1387640, -- Barracuda Mrglgagh (★★)
					[201502] = 1387640, -- Barracuda Mrglgagh (★)
					[201553] = 1387646, -- Drogbar-Style Salmon (★★★)
					[201533] = 1387646, -- Drogbar-Style Salmon (★★)
					[201504] = 1387646, -- Drogbar-Style Salmon (★)
					[201552] = 1387653, -- Koi-Scented Stormray (★★★)
					[201532] = 1387653, -- Koi-Scented Stormray (★★)
					[201503] = 1387653, -- Koi-Scented Stormray (★)
					[201549] = 1387656, -- Leybeque Ribs (★★★)
					[201529] = 1387656, -- Leybeque Ribs (★★)
					[201500] = 1387656, -- Leybeque Ribs (★)
					[201550] = 1387666, -- Suramar Surf and Turf (★★★)
					[201530] = 1387666, -- Suramar Surf and Turf (★★)
					[201501] = 1387666, -- Suramar Surf and Turf (★)
					-- Delicacies
					[201555] = 1387635, -- Azshari Salad (★★★)
					[201535] = 1387635, -- Azshari Salad (★★)
					[201506] = 1387635, -- Azshari Salad (★)
					[201558] = 1387650, -- Fishbrul Special (★★★)
					[201538] = 1387650, -- Fishbrul Special (★★)
					[201511] = 1387650, -- Fishbrul Special (★)
					[201556] = 1387659, -- Nightborne Delicacy Platter (★★★)
					[201536] = 1387659, -- Nightborne Delicacy Platter (★★)
					[201507] = 1387659, -- Nightborne Delicacy Platter (★)
					[201557] = 1387663, -- Seed-Battered Fish Plate (★★★)
					[201537] = 1387663, -- Seed-Battered Fish Plate (★★)
					[201508] = 1387663, -- Seed-Battered Fish Plate (★)
					[201554] = 1387667, -- The Hungry Magister (★★★)
					[201534] = 1387667, -- The Hungry Magister (★★)
					[201505] = 1387667, -- The Hungry Magister (★)
					-- Feasts
					[201562] = 1387652, -- Hearty Feast (★★★)
					[201542] = 1387652, -- Hearty Feast (★★)
					[201515] = 1387652, -- Hearty Feast (★)
					[201563] = 1387654, -- Lavish Suramar Feast (★★★)
					[201543] = 1387654, -- Lavish Suramar Feast (★★)
					[201516] = 1387654, -- Lavish Suramar Feast (★)
					[251258] = 237270, -- Feast of the Fishes
				-- Food of Draenor
					-- Feasts
					[173978] = 1053712, -- Feast of Blood
					[173979] = 1053713, -- Feast of the Waters
					-- Delicacies
					[160986] = 1046248, -- Blackrock Barbecue
					[160999] = 1046251, -- Calamari Crepes
					[160987] = 1046255, -- Frosty Stew
					[161000] = 1046256, -- Gorgrond Chowder
					[160989] = 1046261, -- Sleeper Surprise
					[160984] = 1046263, -- Talador Surf and Turf
					-- Meat Dishes
					[160962] = 1046249, -- Blackrock Ham
					[160968] = 1046250, -- Braised Riverbeast
					[160971] = 1046253, -- Clefthoof Sausages
					[160958] = 1046257, -- Hearty Elekk Steak
					[160966] = 1046259, -- Pan-Seared Talbuk
					[160969] = 1046260, -- Rylak Crepes
					[190788] = 1241154, -- Fel Eggs and Ham
					-- Fish Dishes
					[160981] = 1045937, -- Fat Sleeper Cakes
					[160982] = 1045938, -- Fiery Calamari
					[160978] = 1045939, -- Grilled Gulper
					[160983] = 1045952, -- Skulker Chowder
					[160973] = 1045950, -- Steamed Scorpion
					[160979] = 1045951, -- Sturgeon Stew
					[161002] = 1045940, -- Grilled Saberfish
					[161001] = 1045948, -- Saberfish Broth
					[180761] = 1045949, -- Buttered Sturgeon
					[180759] = 533422, -- Jumbo Sea Dog
					[180758] = 461138, -- Pickled Eel
					[180757] = 350561, -- Salty Squid Roll
					[180762] = 461137, -- Sleeper Sushi
					[180760] = 461132, -- Whiptail Fillet
				-- Pandaren Cuisine
					-- Way of the Grill
					[125141] = 651575, -- Banquet of the Grill
					[104300] = 651331, -- Black Pepper Ribs and Shrimp
					[145311] = 133948, -- Fluffy Silkfeather Omelet
					[125142] = 651585, -- Great Banquet of the Grill
					[104299] = 651568, -- Eternal Blossom Fish
					[104298] = 651597, -- Charbroiled Tiger Steak
					-- Way of the Wok
					[125594] = 651589, -- Banquet of the Wok
					[125595] = 651579, -- Great Banquet of the Wok
					[104303] = 651592, -- Sea Mist Rice Noodles
					[145305] = 646177, -- Seasoned Pomfruit Slices
					[104302] = 651599, -- Valley Stir Fry
					[104301] = 651591, -- Sauteed Carrots
					-- Way of the Pot
					[125596] = 651587, -- Banquet of the Pot
					[125597] = 651577, -- Great Banquet of the Pot
					[104306] = 651582, -- Mogu Fish Stew
					[145307] = 134210, -- Spiced Blossom Soup
					[104305] = 651567, -- Braised Turtle
					[104304] = 651596, -- Swiling Mist Soup
					-- Way of the Steamer
					[125598] = 651588, -- Banquet of the Steamer
					[145309] = 237331, -- Farmer's Delight
					[125599] = 651578, -- Great Banquet of the Steamer
					[104309] = 651595, -- Steamed Crab Surprise
					[104308] = 651569, -- Fire Spirit Salmon
					[104307] = 651593, -- Shrimp Dumplings
					-- Way of the Oven
					[125600] = 651586, -- Banquet of the Oven
					[104312] = 651594, -- Chun Tian Spring Rolls
					[125601] = 651576, -- Great Banquet of the Oven
					[145310] = 451162, -- Stuffed Lushrooms
					[104311] = 651598, -- Twin Fish Platter
					[104310] = 651600, -- Wildfowl Roast
					-- Way of the Brew
					[125602] = 651583, -- Banquet of the Brew
					[125603] = 651573, -- Great Banquet of the Brew
					[124054] = 461805, -- Mad Brewer's Breakfast
					[126655] = 132788, -- Banana Infused Rum
					[126654] = 651581, -- Four Senses Brew
					[124053] = 461804, -- Jade Witch Brew
					[124052] = 651571, -- Ginseng Tea
					-- Everyday Cooking
					[145061] = 879828, -- Deluxe Noodle Cart Kit
					[105194] = 651574, -- Great Pandaren Banquet
					[145308] = 895874, -- Mango Ice
					[145038] = 879826, -- Noodle Cart Kit
					[105190] = 651584, -- Pandaren Banquet
					[145062] = 879827, -- Pandaren Treasure Noodle Cart Kit
					[125120] = 350563, -- Spicy Salmon
					[125123] = 649817, -- Spicy Vegetable Chips
					[124032] = 237337, -- Krasarang Fritters
					[125122] = 650006, -- Rice Pudding
					[124029] = 134020, -- Viseclaw Soup
					[124233] = 651487, -- Blanched Needle Mushrooms
					[124229] = 655152, -- Red Bean Bun
					[124228] = 651538, -- Boiled Silkwork Pupa
					[124227] = 651488, -- Dried Needle Mushrooms
					[124226] = 134255, -- Dried Peaches
					[104297] = 651570, -- Fish Cake
					[104237] = 651572, -- Golden Carp Consomme
					[124231] = 655706, -- Green Curry Fish
					[124232] = 651358, -- Peach Pie
					[125080] = 132815, -- Pearl Milk Tea
					[125067] = 651997, -- Perfectly Cooked Instant Noodles
					[124223] = 571819, -- Pounded Rice Cake
					[125078] = 651601, -- Roasted Barley Tea
					[124234] = 651877, -- Skewered Peanut Chicken
					[125117] = 646177, -- Sliced Peaches
					[124230] = 655708, -- Tangy Yogurt
					[124225] = 651276, -- Toasted Fish Jerky
					[125121] = 651489, -- Wildfowl Ginseng Soup
					[124224] = 650635, -- Yak Cheese Curds
				-- Cataclysm Recipes
					-- Everyday Cooking
					[88011] = 134055, -- Broiled Dragon Feast
					[88019] = 460881, -- Fortune Cookie
					[88036] = 350559, -- Seafood Magnifique Feast
					[88003] = 351500, -- Baked Rockfish
					[88004] = 133973, -- Basilisk Liverdog
					[88005] = 350565, -- Beer-Basted Crocolisk
					[88034] = 351506, -- Blackbelly Sushi
					[88014] = 350567, -- Crocolisk Au Gratin
					[88016] = 351503, -- Delicious Sagefish Tail
					[88020] = 237335, -- Grilled Dragon
					[88025] = 351499, -- Lavascale Minestrone
					[88031] = 350558, -- Mushroom Sauce Mudfish
					[88039] = 351505, -- Severed Sagefish Head
					[88042] = 351508, -- Skewered Eel
					[88013] = 237363, -- Chocolate Cookie
					[88018] = 134044, -- Fish Fry
					[96133] = 461136, -- Scalding Murglesnout
					[88021] = 350560, -- Hearty Seafood Soup
					[88033] = 351507, -- Pickled Guppy
					[88046] = 350562, -- Tender Baked Turtle
					[88012] = 351504, -- Broiled Mountain Trout
					[88024] = 351501, -- Lavascale Fillet
					[88028] = 351502, -- Lightly Fried Lurker
					[88030] = 350562, -- Lurker Lunch
					[88035] = 237299, -- Salted Eye
					[88037] = 133708, -- Seasoned Crab
					[88047] = 350559, -- Whitecrest Gumbo
					[88006] = 133962, -- Blackened Surprise
					-- Delightful Drinks
					[88044] = 443395, -- South Island Iced Tea
					[88022] = 132813, -- Highland Spirits
					[88045] = 132802, -- Starfire Espresso
					[88015] = 135999, -- Darkbrew Lager
					-- Lures
					[88017] = 135992, -- Feathered Lure
				-- Recipes of the Cold North
					-- Everyday Cooking
					[57423] = 237303, -- Fish Feast
					[58528] = 132184, -- Small Feast
					[58527] = 132184, -- Gigantic Feast
					[57441] = 237355, -- Blackened Dragonfin
					[57438] = 134040, -- Blackened Worg Steak
					[57435] = 134044, -- Critter Bites
					[57439] = 237346, -- Cuttlesteak
					[57442] = 134031, -- Dragonfin Filet
					[45568] = 237354, -- Firecracker Salmon
					[57436] = 237329, -- Hearty Rhino
					[45570] = 237334, -- Imperial Manta Steak
					[45555] = 133962, -- Mega Mammoth Meal
					[45559] = 134022, -- Mighty Rhino Dogs
					[45567] = 134033, -- Poached Northern Sculpin
					[57434] = 134003, -- Rhinolicious Wormsteak
					[57437] = 237342, -- Snapper Extreme
					[57440] = 237336, -- Spiced Mammoth Treats
					[45557] = 134021, -- Spiced Worm Burger
					[45571] = 237352, -- Spicy Blue Nettlefish
					[57433] = 134034, -- Spicy Fried Herring
					[45556] = 237335, -- Tender Shoveltusk Steak
					[57443] = 134041, -- Tracker Snacks
					[45558] = 134016, -- Very Burnt Worg
					[64358] = 134438, -- Black Jelly
					[62350] = 134027, -- Worg Tartare
					[45554] = 132184, -- Great Feast
					[45569] = 237353, -- Baked Manta Ray
					[58065] = 133780, -- Dalaran Clam Chowder
					[45563] = 134035, -- Grilled Sculpin
					[45549] = 237330, -- Mammoth Meal
					[45566] = 134032, -- Pickled Fangtooth
					[45565] = 237351, -- Poached Nettlefish
					[45553] = 134009, -- Rhino Dogs
					[45552] = 134042, -- Roasted Worg
					[45550] = 134045, -- Shoveltusk Steak
					[45564] = 237343, -- Smoked Salmon
					[45551] = 237337, -- Worm Delight
					[53056] = 132808, -- Kungaloosh
					[58523] = 134431, -- Bad Clams
					[45561] = 237356, -- Grilled Bonescale
					[58525] = 237317, -- Haunted Herring
					[58521] = 237328, -- Last Week's Mammoth
					[57421] = 237331, -- Northern Stew
					[45562] = 237338, -- Sauteed Goby
					[45560] = 237344, -- Smoked Rockfin
					[58512] = 135457, -- Tasty Cupcake
				-- Outlandish Dishes
					-- Everyday Cooking
					[42302] = 134044, -- Fisherman's Feast
					[42305] = 134032, -- Hot Buttered Trout
					[33296] = 133902, -- Spicy Crawdad
					[38868] = 134044, -- Crunchy Serpent
					[38867] = 134004, -- Mok'Nathal Shortribs
					[33295] = 133904, -- Golden Fish Sticks
					[43772] = 134005, -- Kibler's Bits
					[33287] = 134016, -- Roasted Clefthoof
					[33289] = 134040, -- Talbuk Steak
					[33288] = 134021, -- Warp Burger
					[33293] = 134034, -- Grilled Mudfish
					[33294] = 134032, -- Poached Bluefish
					[33286] = 134042, -- Blackened Basilisk
					[43707] = 134019, -- Skullfish Soup
					[43765] = 134040, -- Spicy Hot Talbuk
					[42296] = 134020, -- Stewed Trout
					[33292] = 134035, -- Blackened Sporefish
					[33290] = 134033, -- Blackened Trout
					[43761] = 133915, -- Broiled Bloodfin
					[33279] = 134041, -- Buzzard Bites
					[36210] = 133983, -- Clam Bar
					[33291] = 134030, -- Feltail Delight
					[33284] = 134009, -- Ravager Dog
					[43758] = 134047, -- Stormchops
				-- Old World Recipes
					-- Everyday Cooking
					[18247] = 133906, -- Baked Salmon
					[25659] = 134021, -- Dirge's Kickin' Chimaerok Chops
					[18245] = 132804, -- Lobster Stew
					[18246] = 134003, -- Mightfish Steak
					[22761] = 134019, -- Runn Tum Tuber Surprise
					[24801] = 134020, -- Smoked Desert Dumplings
					[18242] = 133889, -- Hot Smoked Bass
					[46684] = 134024, -- Charred Bear Kabobs
					[46688] = 134021, -- Juicy Bear Burger
					[18243] = 132804, -- Nightfin Soup
					[18244] = 133905, -- Poached Sunscale Salmon
					[64054] = 134433, -- Clamlette Magnifique
					[18239] = 134301, -- Cooked Glossy Mightfish
					[18241] = 133892, -- Filet of Redgill
					[15933] = 133948, -- Monster Omelet
					[15915] = 134004, -- Spiced Chili Crab
					[22480] = 134003, -- Tender Wolf Steak
					[20626] = 132804, -- Unddermine Clam Chowder
					[185705] = 351502, -- Fancy Darkmoon Feast
					[18240] = 133899, -- Grilled Squid
					[18238] = 133887, -- Spotted Yellowtail
					[15910] = 132806, -- Heavy Kodo Stew
					[15863] = 134005, -- Carrion Surprise
					[7213] = 132386, -- Giant Clam Scorcho
					[15856] = 134004, -- Hot Wolf Ribs
					[15861] = 132804, -- Jungle Stew
					[20916] = 133888, -- Mithril Head Trout
					[15865] = 132806, -- Mystery Stew
					[15855] = 134006, -- Roast Raptor
					[25954] = 133907, -- Sagefish Delight
					[21175] = 134022, -- Spider Sausage
					[7828] = 133890, -- Rockscale Cod
					[4094] = 133974, -- Barbecued Buzzard Wing
					[3400] = 133748, -- Soothing Turtle Bisque
					[3398] = 133974, -- Hot Lion Chops
					[13028] = 132802, -- Goldthorn Tea
					[3376] = 132835, -- Curiously Tasty Omelet
					[15853] = 134003, -- Lean Wolf Steak
					[3373] = 133748, -- Crocolisk Gumbo
					[24418] = 134020, -- Heavy Crocolisk Stew
					[3399] = 133970, -- Tasty Lion Steak
					[3377] = 133952, -- Gooey Spider Cake
					[6419] = 134343, -- Lean Venison
					[7755] = 133916, -- Bristle Whisker Catfish
					[6418] = 133973, -- Crispy Lizard Tail
					[2549] = 133972, -- Seasoned Wolf Kabob
					[2547] = 133748, -- Redridge Goulash
					[6501] = 134712, -- Clam Chowder
					[6417] = 133748, -- Dig Rat Stew
					[3372] = 133748, -- Murloc Fin Soup
					[2548] = 133972, -- Succulent Pork Ribs
					[6500] = 134431, -- Goblin Deviled Clams
					[185708] = 1045940, -- Sugar-Crusted Fish Feast
					[2545] = 133708, -- Cooked Crab Claw
					[3370] = 134003, -- Crocolisk Steak
					[25704] = 133906, -- Smoked Sagefish
					[2543] = 133748, -- Westfall Stew
					[3371] = 134005, -- Blood Sausage
					[28267] = 134044, -- Crunchy Spider Surprise
					[33278] = 134042, -- Bat Bites
					[2542] = 133952, -- Goretusk Liver Pie
					[7754] = 134712, -- Loch Frenzy Delight
					[7753] = 133918, -- Longjaw Mud Snapper
					[7827] = 133913, -- Rainbow Fin Albacore
					[6416] = 133748, -- Strider Stew
					[2546] = 134004, -- Dry Pork Ribs
					[8607] = 133969, -- Smoked Bear Meat
					[2544] = 133950, -- Crab Cake
					[6414] = 134016, -- Roasted Kodo Meat
					[2795] = 134004, -- Beer Basted Boar Ribs
					[6413] = 133952, -- Scorpid Surprise
					[6499] = 134432, -- Boiled Clams
					[2541] = 134021, -- Coyote Steak
					[6415] = 133891, -- Fillet of Frenzy
					[185704] = 134034, -- Lemon Herb Fillet
					[43779] = 133783, -- Delicious Chocolate Cake
					[7751] = 133893, -- Brilliant Smallfish
					[2538] = 133974, -- Charred Wolf Meat
					[15935] = 134002, -- Crispy Bat Wing
					[8604] = 132834, -- Herb Baked Egg
					[33276] = 134003, -- Lynx Steak
					[2540] = 133974, -- Roasted Boar Meat
					[33277] = 134016, -- Roasted Moongraze Tenderloin
					[7752] = 133910, -- Slitherskin Mackerel
					[93741] = 133969, -- Venison Jerky
					[6412] = 134024, -- Kaldorei Spider Kabob
					[2539] = 134021, -- Spiced Wolf Meat
					[3397] = 134003, -- Big Bear Steak
					[37836] = 134051, -- Spice Bread
					-- Holiday Cooking
					[45022] = 132810, -- Hot Apple Cider
					[62051] = 250625, -- Candied Sweet Potato (Alliance)
					[66034] = 250625, -- Candied Sweet Potato (Horde)
					[62049] = 250622, -- Cranberry Chutney (Alliance)
					[66035] = 250622, -- Cranberry Chutney (Horde)
					[62045] = 250626, -- Slow-Roasted Turkey (Alliance)
					[66037] = 250626, -- Slow-Roasted Turkey (Horde)
					[62044] = 250623, -- Pumpkin Pie (Alliance)
					[66036] = 250623, -- Pumpkin Pie (Horde)
					[66038] = 250624, -- Spice Bread Stuffing (Aliance)
					[62050] = 250624, -- Spice Bread Stuffing (Horde)
					[21144] = 132791, -- Winter Veil Egg Nog
					[21143] = 134018, -- Gingerbread Cookie
					[65454] = 307567, -- Bread of the Dead
					-- Unusual Delights
					[15906] = 132804, -- Dragonbreath Chili
					[8238] = 134302, -- Savory Deviate Delight
					[9513] = 132819, -- Thistle Tea
					[45695] = 132790, -- Captain Rumsey's Lager

			-- Engineering
				-- Kul Tiran Engineering & Zandalari Engineering
					-- Belt Attachments
					[255936] = 136243, -- Belt Enchant: Holographic Horror Projector
					[269123] = 136243, -- Belt Enchant: Miniaturized Plasma Shield
					[255940] = 136243, -- Belt Enchant: Personal Space Amplifier
					-- Bombs
					[255394] = 2115301, -- F.R.I.E.D. (★★★)
					[255393] = 2115301, -- F.R.I.E.D. (★★)
					[255392] = 2115301, -- F.R.I.E.D. (★)
					[255409] = 2115304, -- Organic Discombobulation Grenade (★★★)
					[255408] = 2115304, -- Organic Discombobulation Grenade (★★)
					[255407] = 2115304, -- Organic Discombobulation Grenade (★)
					[255397] = 2115303, -- Thermo-Accelerated Plague Spreader (★★★)
					[255396] = 2115303, -- Thermo-Accelerated Plague Spreader (★★)
					[255395] = 2115303, -- Thermo-Accelerated Plague Spreader (★)
					-- Devices
					[298930] = 133015, -- Blingtron 7000
					[299105] = 2000841, -- Wormhole Generator: Kul Tiras
					[299106] = 2000840, -- Wormhole Generator: Zandalar
					[283916] = 2115322, -- Unstable Temporal Time Shifter (★★★)
					[283915] = 2115322, -- Unstable Temporal Time Shifter (★★)
					[283914] = 2115322, -- Unstable Temporal Time Shifter (★)
					[256156] = 2115311, -- Deployable Attire Rearranger (★★★)
					[256155] = 2115311, -- Deployable Attire Rearranger (★★)
					[256154] = 2115311, -- Deployable Attire Rearranger (★)
					[256072] = 2115312, -- Electroshock Mount Motivator (★★★)
					[256071] = 2115312, -- Electroshock Mount Motivator (★★)
					[256070] = 2115312, -- Electroshock Mount Motivator (★)
					[256084] = 2115316, -- Interdimensional Companion Repository (★★★)
					[256082] = 2115316, -- Interdimensional Companion Repository (★★)
					[256080] = 2115316, -- Interdimensional Companion Repository (★)
					[256075] = 2115323, -- XA-1000 Surface Skimmer (★★★)
					[256074] = 2115323, -- XA-1000 Surface Skimmer (★★)
					[256073] = 2115323, -- XA-1000 Surface Skimmer (★)
					[280734] = 2115317, -- Magical Intrusion Dampener (★★★)
					[280733] = 2115317, -- Magical Intrusion Dampener (★★)
					[280732] = 2115317, -- Magical Intrusion Dampener (★)
					-- Cloth Goggles
					[305945] = 1041266, -- A-N0M-A-L0U5 Synthetic Specs
					[299005] = 1041266, -- A5C-3N-D3D Synthetic Specs
					[299004] = 1041266, -- Abyssal Synthetic Specs
					[299006] = 1041266, -- Charged A5C-3N-D3D Synthetic Specs
					[305943] = 1041266, -- Paramount Synthetic Specs
					[305944] = 1041266, -- Superior Synthetic Specs
					[272058] = 1041266, -- AZ3-R1-T3 Synthetic Specs (★★★)
					[272057] = 1041266, -- AZ3-R1-T3 Synthetic Specs (★★)
					[272056] = 1041266, -- AZ3-R1-T3 Synthetic Specs (★)
					[286875] = 1041266, -- Charged SP1-R1-73D Synthetic Specs
					[286874] = 1041266, -- SP1-R1-73D Synthetic Specs
					[286873] = 1041266, -- Surging Synthetic Specs
					[291090] = 1041266, -- Emblazoned Synthetic Specs
					[291089] = 1041266, -- Imbued Synthetic Specs
					-- Leather Goggles
					[305942] = 1041266, -- A-N0M-A-L0U5 Gearspun Goggles
					[299008] = 1041266, -- A5C-3N-D3D Gearspun Goggles
					[299007] = 1041266, -- Abyssal Gearspun Goggles
					[299009] = 1041266, -- Charged A5C-3N-D3D Gearspun Goggles
					[305940] = 1041266, -- Paramount Gearspun Goggles
					[305941] = 1041266, -- Superior Gearspun Goggles
					[272061] = 1041266, -- AZ3-R1-T3 Gearspun Goggles (★★★)
					[272060] = 1041266, -- AZ3-R1-T3 Gearspun Goggles (★★)
					[272059] = 1041266, -- AZ3-R1-T3 Gearspun Goggles (★)
					[286869] = 1041266, -- Charged SP1-R1-73D Gearspun Goggles
					[286868] = 1041266, -- SP1-R1-73D Gearspun Goggles
					[286867] = 1041266, -- Surging Gearspun Goggles
					[291092] = 1041266, -- Emblazoned Gearspun Goggles
					[291091] = 1041266, -- Imbued Gearspun Goggles
					-- Mail Goggles
					[305951] = 1041266, -- A-N0M-A-L0U5 Bionic Bifocals
					[299011] = 1041266, -- A5C-3N-D3D Bionic Bifocals
					[299010] = 1041266, -- Abyssal Bionic Bifocals
					[299012] = 1041266, -- Charged A5C-3N-D3D Bionic Bifocals
					[305949] = 1041266, -- Paramount Bionic Bifocals
					[305950] = 1041266, -- Superior Bionic Bifocals
					[272064] = 1041266, -- AZ3-R1-T3 Bionic Bifocals (★★★)
					[272063] = 1041266, -- AZ3-R1-T3 Bionic Bifocals (★★)
					[272062] = 1041266, -- AZ3-R1-T3 Bionic Bifocals (★)
					[286866] = 1041266, -- Charged SP1-R1-73D Bionic Bifocals
					[286865] = 1041266, -- SP1-R1-73D Bionic Bifocals
					[286864] = 1041266, -- Surging Bionic Bifocals
					[291094] = 1041266, -- Emblazoned Bionic Bifocals
					[291093] = 1041266, -- Imbued Bionic Bifocals
					-- Plate Goggles
					[305948] = 1041266, -- A-N0M-A-L0U5 Orthogonal Optics
					[299014] = 1041266, -- A5C-3N-D3D Orthogonal Optics
					[299013] = 1041266, -- Abyssal Orthogonal Optics
					[299015] = 1041266, -- Charged A5C-3N-D3D Orthogonal Optics
					[305946] = 1041266, -- Paramount Orthogonal Optics
					[305947] = 1041266, -- Superior Orthogonal Optics
					[272067] = 1041266, -- AZ3-R1-T3 Orthogonal Optics (★★★)
					[272066] = 1041266, -- AZ3-R1-T3 Orthogonal Optics (★★)
					[272065] = 1041266, -- AZ3-R1-T3 Orthogonal Optics (★)
					[286872] = 1041266, -- Charged SP1-R1-73D Orthogonal Optics
					[286871] = 1041266, -- SP1-R1-73D Orthogonal Optics
					[286870] = 1041266, -- Surging Orthogonal Optics
					[291096] = 1041266, -- Emblazoned Orthogonal Optics
					[291095] = 1041266, -- Imbued Orthogonal Optics
					-- Weapons
					[294786] = 1992345, -- Notorious Combatant's Discombobulator (★★★)
					[294785] = 1992345, -- Notorious Combatant's Discombobulator (★★)
					[294784] = 1992345, -- Notorious Combatant's Discombobulator (★)
					[294789] = 1777844, -- Notorious Combatant's Stormsteel Destroyer (★★★)
					[294788] = 1777844, -- Notorious Combatant's Stormsteel Destroyer (★★)
					[294787] = 1777844, -- Notorious Combatant's Stormsteel Destroyer (★)
					[305861] = 1992345, -- Uncanny Combatant's Discombobulator (★★★)
					[305862] = 1992345, -- Uncanny Combatant's Discombobulator (★★)
					[305863] = 1992345, -- Uncanny Combatant's Discombobulator (★)
					[305858] = 1992345, -- Uncanny Combatant's Stormsteel Destroyer (★★★)
					[305859] = 1992345, -- Uncanny Combatant's Stormsteel Destroyer (★★)
					[305860] = 1992345, -- Uncanny Combatant's Stormsteel Destroyer (★)
					[255459] = 1773651, -- Finely-Tuned Stormsteel Destroyer (★★★)
					[255458] = 1773651, -- Finely-Tuned Stormsteel Destroyer (★★)
					[255457] = 1773651, -- Finely-Tuned Stormsteel Destroyer (★)
					[253152] = 1992345, -- Precision Attitude Adjuster (★★★)
					[253151] = 1992345, -- Precision Attitude Adjuster (★★)
					[253150] = 1992345, -- Precision Attitude Adjuster (★)
					[282808] = 1992345, -- Sinister Combatant's Discombobulator (★★★)
					[282807] = 1992345, -- Sinister Combatant's Discombobulator (★★)
					[282806] = 1992345, -- Sinister Combatant's Discombobulator (★)
					[282811] = 1778299, -- Sinister Combatant's Stormsteel Destroyer (★★★)
					[282810] = 1778299, -- Sinister Combatant's Stormsteel Destroyer (★★)
					[282809] = 1778299, -- Sinister Combatant's Stormsteel Destroyer (★)
					[269726] = 1992345, -- Honorable Combatant's Discombobulator (★★★)
					[269725] = 1992345, -- Honorable Combatant's Discombobulator (★★)
					[269724] = 1992345, -- Honorable Combatant's Discombobulator (★)
					[269729] = 1778299, -- Honorable Combatant's Stormsteel Destroyer (★★★)
					[269728] = 1778299, -- Honorable Combatant's Stormsteel Destroyer (★★)
					[269727] = 1778299, -- Honorable Combatant's Stormsteel Destroyer (★)
					[253122] = 1992345, -- Magnetic Discombobulator
					-- Scopes & Ammo
					[264962] = 2115310, -- Crow's Nest Scope (★★★)
					[264961] = 2115310, -- Crow's Nest Scope (★★)
					[264960] = 2115310, -- Crow's Nest Scope (★)
					[265102] = 2115313, -- Frost-Laced Ammunition (★★★)
					[265101] = 2115313, -- Frost-Laced Ammunition (★★)
					[265100] = 2115313, -- Frost-Laced Ammunition (★)
					[265099] = 2115315, -- Incendiary Ammunition (★★★)
					[265098] = 2115315, -- Incendiary Ammunition (★★)
					[265097] = 2115315, -- Incendiary Ammunition (★)
					[264967] = 2115319, -- Monelite Scope of Alacrity (★★★)
					[264966] = 2115319, -- Monelite Scope of Alacrity (★★)
					[264964] = 2115319, -- Monelite Scope of Alacrity (★)
					-- Mounts & Pets
					[256132] = 2115321, -- Super-Charged Engine
					[274621] = 2011128, -- Mecha-Mogul Mk2
					[286478] = 1511262, -- Mechantula
					-- Conversions
					[287279] = 1020349, -- Aqueous Thermo-Degradation
					[286647] = 876915, -- Sanguinated Thermo-Degradation
					-- Follower Equipment
					[278411] = 133872, -- Makeshift Azerite Detector
					[278413] = 133878, -- Monelite Fish Finder
					-- Focus
					[307220] = 3072251, -- Void Focus
					-- Tools of the Trade
					[298255] = 133031, -- Ub3r-Module: P.O.G.O.
					[298256] = 1336885, -- Ub3r-Module: Scrap Cannon
					[298257] = 133866, -- Ub3r-Module: Ub3r-Coil
					[282975] = 2735955, -- The Ub3r-SPanner
					[283399] = 133712, -- Ub3r-Module: Short-Fused Bomb Bots
					[283401] = 1113014, -- Ub3r-Module: Ub3r S3ntry Mk. X8.0
					[283403] = 1405820, -- Ub3r-Module: Ub3r-Improved Target Dummy
				-- Legion Engineering
					-- Goggles
					[235755] = 1391897, -- Chain Skullblasters
					[199011] = 1391897, -- Double-Barreled Cranial Cannon (★★★)
					[198997] = 1391897, -- Double-Barreled Cranial Cannon (★★)
					[198970] = 1391897, -- Double-Barreled Cranial Cannon (★)
					[235756] = 1391897, -- Heavy Skullblasters
					[199012] = 1391897, -- Ironsight Cranial Cannon (★★★)
					[198998] = 1391897, -- Ironsight Cranial Cannon (★★)
					[198971] = 1391897, -- Ironsight Cranial Cannon (★)
					[235754] = 1391897, -- Rugged Skullblasters
					[199010] = 1391897, -- Sawed-Off Cranial Cannon (★★★)
					[198996] = 1391897, -- Sawed-Off Cranial Cannon (★★)
					[198969] = 1391897, -- Sawed-Off Cranial Cannon (★)
					[199009] = 1391897, -- Semi-Automagic Cranial Cannon (★★★)
					[198995] = 1391897, -- Semi-Automagic Cranial Cannon (★★)
					[198968] = 1391897, -- Semi-Automagic Cranial Cannon (★)
					[235753] = 1391897, -- Tailored Skullblasters
					[199005] = 1391897, -- Blink-Trigger Headgun (★★★)
					[198991] = 1391897, -- Blink-Trigger Headgun (★★)
					[198939] = 1391897, -- Blink-Trigger Headgun (★)
					[199007] = 1391897, -- Bolt-Action Headgun (★★★)
					[198993] = 1391897, -- Bolt-Action Headgun (★★)
					[198966] = 1391897, -- Bolt-Action Headgun (★)
					[199008] = 1391897, -- Reinforced Headgun (★★★)
					[198994] = 1391897, -- Reinforced Headgun (★★)
					[198967] = 1391897, -- Reinforced Headgun (★)
					[199006] = 1391897, -- Tactical Headgun (★★★)
					[198992] = 1391897, -- Tactical Headgun (★★)
					[198965] = 1391897, -- Tactical Headgun (★)
					-- Combat Tools
					[199013] = 1405805, -- Deployable Bullet Dispenser (★★★)
					[198999] = 1405805, -- Deployable Bullet Dispenser (★★)
					[198972] = 1405805, -- Deployable Bullet Dispenser (★)
					[199014] = 1405808, -- Gunpowder Charge (★★★)
					[199000] = 1405808, -- Gunpowder Charge (★★)
					[198973] = 1405808, -- Gunpowder Charge (★)
					[199015] = 1405816, -- Pump-Action Bandage Gun (★★★)
					[199001] = 1405816, -- Pump-Action Bandage Gun (★★)
					[198974] = 1405816, -- Pump-Action Bandage Gun (★)
					-- Devices
					[198981] = 1336885, -- Trigger
					[199017] = 1405803, -- Auto-Hammer (★★★)
					[199003] = 1405803, -- Auto-Hammer (★★)
					[198976] = 1405803, -- Auto-Hammer (★)
					[198980] = 1405804, -- Blingtron's Circuit Design Tutorial
					[199018] = 1405806, -- Failure Detection Pylon (★★★)
					[199004] = 1405806, -- Failure Detection Pylon (★★)
					[198977] = 1405806, -- Failure Detection Pylon (★)
					[199016] = 1405807, -- Gunpack (★★★)
					[199002] = 1405807, -- Gunpack (★★)
					[198975] = 1405807, -- Gunpack (★)
					[247744] = 237560, -- Wormhole Generator: Argus
					[247717] = 1686571, -- Gravitational Reduction Slippers
					[198978] = 1405809, -- Gunshoes
					[198979] = 1405810, -- Intra-Dalaran Wormhole Generator
					[209645] = 1405811, -- Leystone Buoy
					[209646] = 1405813, -- Mecha-Bond Imprint Matrix
					-- Relics
					[209501] = 133010, -- "The Felic"
					[209502] = 136099, -- Shockinator
					-- Robotics
					[235775] = 1405815, -- Rechargeable Reaves Battery
					[198989] = 1405817, -- Reaves Module: Bling Mode
					[198985] = 1405817, -- Reaves Module: Failure Detection Mode
					[198987] = 1405817, -- Reaves Module: Fireworks Display Mode
					[198990] = 1405817, -- Reaves Module: Piloted Combat Mode
					[198984] = 1405817, -- Reaves Module: Repair Mode
					[198988] = 1405817, -- Reaves Module: Snack Distribution Mode
					[198983] = 1405817, -- Reaves Module: Wormhole Generator Mode
					[200466] = 1405819, -- Sonic Environment Enhancer
					[198982] = 1405815, -- Reaves Battery
				-- Draenor Engineering
					-- Reagents and Research
					[182120] = 986486, -- Primal Welding
					[169080] = 986486, -- Gearspring Parts
					[177054] = 133740, -- Secrets of Draenor Engineering
					-- Goggles
					[162195] = 1041266, -- Cybernetic Mechshades
					[162196] = 1041266, -- Night-Vision Mechshades
					[162197] = 1041266, -- Plasma Mechshades
					[162198] = 1041266, -- Razorguard Mechshades
					-- Devices
					[187496] = 465878, -- Advanced Muzzlesprocket
					[187497] = 1029587, -- Bi-Directional Fizzle Reducer
					[169078] = 133860, -- Didi's Delicate Assembly
					[162205] = 986490, -- Findle's Loot-a-Rang
					[173289] = 463556, -- Hemets Heartseeker
					[187521] = 1029587, -- Infrablue-Blocker Lenses
					[463878] = 986487, -- Linkgrease Locksprocket
					[162203] = 252174, -- Megawatt Filament
					[162202] = 133003, -- Oglethorpe's Missile Splitter
					[162214] = 645203, -- Personal Hologram
					[162199] = 960906, -- Shrediron's Shredder
					[162217] = 308321, -- Swapblaster
					[187520] = 465878, -- Taladite Firing Pin
					[177363] = 237288, -- True Iron Trigger
					[162208] = 237296, -- Ultimate Gnomish Army Knife (Uncommon)
					[169140] = 237296, -- Ultimate Gnomish Army Knife (Rare)
					[162206] = 133867, -- World Shrinker
					[162216] = 892831, -- Wormhole Centrifuge
					[162204] = 133632, -- Goblin Glider Kit
					[173308] = 133032, -- Mecha-Blast Rocket
					[173309] = 986488, -- Shieldtronic Shield
					[162207] = 465877, -- Stealthman 54
					-- Robotics
					[162218] = 1005279, -- Blingtron 5000
					[162210] = 463878, -- Lifelike Mechanical Frostboar
					[162209] = 132598, -- Mechanical Axebeak
					[176732] = 986492, -- Mechanical Scorpid
					-- Fireworks
					[171072] = 134282, -- Alliance Firework
					[171073] = 134285, -- Horde Firework
					[171074] = 537022, -- Snake Firework
				-- Pandaria Engineering
					-- Schematic
					[143743] = 133741, -- Schematic: Chief Engineer Jard's Journal
					-- Explosives
					[127128] = 133837, -- Goblin Dragon Gun, Mark II
					[127127] = 622095, -- G91 Landshark
					[127124] = 133715, -- Locksmith's Powderkeg
					-- Fireworks
					[131256] = 134275, -- Autumn Flower Firework
					[128260] = 134275, -- Celestial Firework
					[128261] = 134273, -- Grand Celebration Firework
					[131258] = 134275, -- Jade Blossom Firework
					[131353] = 538566, -- Pandaria Fireworks
					[128262] = 134271, -- Serpent's Heart Firework
					-- Devices
					[139197] = 798061, -- Advanced Refrigeration Unit
					[139196] = 798062, -- Pierre
					[143714] = 876476, -- Rascal-Bot
					[127129] = 294476, -- Blingtron 4000
					[127135] = 236473, -- Mechanical Pandaren Dragonling
					[127132] = 651094, -- Wormhole Generator: Pandaria
					[127134] = 134156, -- Ghost Iron Dragonling
					[127131] = 136241, -- Thermal Anvil
					[126392] = 136243, -- Goblin Glider
					[109099] = 136243, -- Watergliding Jets
					-- Reagents
					[139176] = 132488, -- Jard's Peculiar Energy Source
					[131563] = 133875, -- Tinker's Kit
					[127113] = 633439, -- Ghost Iron Bolts
					[127114] = 635469, -- High-Explosive Gunpowder
					-- Goggles
					[127118] = 644269, -- Agile Retinal Armor
					[127119] = 644269, -- Camouflage Retinal Armor
					[127120] = 644269, -- Deadly Retinal Armor
					[127121] = 644269, -- Energized Retinal Armor
					[127117] = 644269, -- Lightweight Retinal Armor
					[127130] = 133149, -- Mist-Piercing Goggles
					[127123] = 644269, -- Reinforced Retinal Armor
					[127122] = 644269, -- Specialized Retinal Armor
					-- Guns
					[127137] = 344803, -- Long-Range Trillium Sniper
					[127136] = 527580, -- Big Game Hunter
					-- Scopes
					[127115] = 463556, -- Lord Blastington's Scope of Doom
					[127116] = 463555, -- Mirror Scope
					-- Mounts
					[139192] = 894222, -- Sky Golem
					[127138] = 657936, -- Depleted-Kyparium Rocket
					[127139] = 657937, -- Geosynchronous World Spinner
					-- Cogwheels
					[131211] = 237293, -- Flashing Tinker's Gear
					[131212] = 237293, -- Fractured Tinker's Gear
					[131213] = 237293, -- Precise Tinker's Gear
					[131214] = 237293, -- Quick Tinker's Gear
					[131215] = 237293, -- Rigid Tinker's Gear
					[131216] = 237293, -- Smooth Tinker's Gear
					[131217] = 237293, -- Sparkling Tinker's Gear
					[131218] = 237293, -- Subtle Tinker's Gear
				-- Cataclysm Engineering
					-- Tinkers
					[84425] = 136243, -- Cardboard Assassin
					[84427] = 136243, -- Grounded Plasma Shield
					[84424] = 136243, -- Invisibility Field
					[82200] = 136243, -- Spinal Healing Injector
					-- Reagents
					[94748] = 465875, -- Electrified Ether
					[84403] = 465836, -- Handful of Obsidium Bolts
					-- Explosives
					[95707] = 465879, -- Big Daddy
					[84409] = 133715, -- Volatile Seaforium Blastpack
					-- Goggles
					[81722] = 133023, -- Agile Bio-Optic Killshades
					[81724] = 351457, -- Camouflage Bio-Optic Killshades
					[81716] = 133023, -- Deadly Bio-Optic Killshades
					[81720] = 133023, -- Energized Bio-Optic Killshades
					[81725] = 133023, -- Lightweight Bio-Optic Killshades
					[81714] = 133023, -- Reinforced Bio-Optic Killshades
					[81715] = 133023, -- Specialized Bio-Optic Killshades
					[84406] = 133149, -- Authentic Jr. Engineer Goggles
					-- Devices
					[84418] = 134156, -- Elementium Dragonling
					[84416] = 465841, -- Elementium Toolbox
					[95705] = 133880, -- Gnomish Gravity Well
					[84421] = 986491, -- Loot-a-Rang
					[84429] = 237030, -- Goblin Barbecue
					[84430] = 135811, -- Heat-Treated Spinning Lure
					[84413] = 466036, -- De-Weaponized Mechanical Companion
					[84412] = 254109, -- Personal World Destroyer
					[84415] = 466035, -- Lure Master Tackle Box
					[95703] = 465876, -- Electrostatic Condenser
					-- Weapons
					[100687] = 347429, -- Extreme-Impact Hole Puncher
					[84420] = 394796, -- Finely-Tuned Throat Needler
					[84432] = 347429, -- Kickback 5000
					[84431] = 354436, -- Overpowered Chicken Splitter
					[84417] = 346991, -- Volatile Thunderstick
					[84411] = 134536, -- High-Powered Bolt Gun
					-- Scopes
					[100587] = 463556, -- Flintlocke's Woodchucker
					[84428] = 463555, -- Gnomish X-Ray Scope
					[84408] = 463888, -- R19 Threatfinder
					[84410] = 465878, -- Safety Catch Removal Kit
				-- Northrend Engineering
					-- Tinkers
					[67839] = 136243, -- Mind Amplification Dish
					[55016] = 136243, -- Nitro Boosts
					[54736] = 136243, -- EMP Generator
					[55002] = 136243, -- Flexweave Underlay
					[54793] = 136243, -- Frag Belt
					-- Reagents
					[56471] = 237291, -- Froststeel Tube
					[56464] = 237290, -- Overcharged Capacitor
					[53281] = 133862, -- Volatile Blasting Trigger
					[56349] = 237292, -- Handful of Cobalt Bolts
					-- Explosives
					[56514] = 133035, -- Global Thermal Sapper Charge
					[56468] = 132761, -- Box of Bombs
					[56463] = 132311, -- Explosive Decoy
					[56460] = 237294, -- Cobalt Frag Bomb
					-- Goggles
					[56480] = 133023, -- Armored Titanium Goggles
					[56483] = 133023, -- Charged Titanium Specs
					[56487] = 133023, -- Electroflux Sight Enhancers
					[56486] = 133023, -- Greensight Gogs
					[56574] = 133023, -- Truesight Ice Blinders
					[62271] = 133023, -- Unbreakable Healing Amplifiers
					[56484] = 133023, -- Visage Liquification Goggles
					[56481] = 133023, -- Weakness Spectralizers
					[61482] = 133023, -- Mechanized Snow Goggles (Mail)
					[61483] = 133023, -- Mechanized Snow Goggles (Plate)
					[56465] = 133023, -- Mechanized Snow Goggles (Cloth)
					[61481] = 133023, -- Mechanized Snow Goggles (Leather)
					[56473] = 667398, -- Gnomish X-Ray Specs
					-- Devices
					[68067] = 254097, -- Jeeves
					[67920] = 135778, -- Wormhole Generator: Northrend
					[56462] = 237296, -- Gnomish Army Knife
					[56467] = 133014, -- Noise Machine
					[56466] = 133014, -- Sonic Booster
					[56469] = 136050, -- Gnomish Lightning Generator
					[30349] = 133877, -- Titanium Toolbox
					[56472] = 463542, -- MOLL-E
					[56477] = 132998, -- Mana Injector Kit
					[67326] = 136028, -- Goblin Beam Welder
					[56476] = 132999, -- Healing Injector Kit
					[55252] = 133872, -- Scapbot Construction Kit
					[56459] = 134710, -- Hammer Pick
					[56461] = 134709, -- Bladed Pickaxe
					-- Weapons
					[56479] = 135627, -- Armor Plated Combat Shotgun
					[60874] = 135615, -- Nesingwary 4000
					[54353] = 135617, -- Mark "S" Boomstick
					-- Mounts
					[60866] = 134240, -- Mechano-Hog (Horde)
					[60867] = 134248, -- Mekgineer's Chopper (Alliance)
					-- Scopes
					[56478] = 134441, -- Heartseeker Scope
					[56470] = 134442, -- Sun Scope
					[61471] = 236201, -- Diamond-cut Refractor Scope
				-- Outland Engineering
					-- Reagents
					[30309] = 133012, -- Felsteel Stabilizer
					[30307] = 133016, -- Hardened Adamantite Tube
					[30308] = 133018, -- Khorium Power Core
					[39971] = 133873, -- Icy Blasting Primers
					[30306] = 133004, -- Adamantite Frame
					[30303] = 133593, -- Elemental Blasting Powder
					[30304] = 133010, -- Fel Iron Casing
					[30305] = 133008, -- Handful or Fel Iron Bolts
					-- Explosives
					[39973] = 237294, -- Frost Grenade
					[30547] = 136152, -- Elemental Seaforium Charge
					[30560] = 133035, -- Super Sapper Charge
					[30311] = 133716, -- Adamantite Grenade
					[30558] = 133036, -- The Bigger One
					[30310] = 133009, -- Fel Iron Bomb
					-- Goggles
					[46111] = 133023, -- Annihilator Holo-Gogs
					[46115] = 133023, -- Hard Khorium Goggles
					[46109] = 133023, -- Hyper-Magnified Moon Specs
					[46107] = 133023, -- Justicebringer 3000 Specs
					[46112] = 133023, -- Lightning Etched Specs
					[46114] = 133023, -- Mayhem Projection Goggles
					[46108] = 133023, -- Powerheal 9000 Lens
					[46110] = 133023, -- Primal-Attuned Goggles
					[46116] = 133023, -- Quad Deathblow X44 Goggles
					[46106] = 133023, -- Wonderheal XT68 Shades
					[41317] = 133023, -- Deathblow X11 Goggles
					[41320] = 133023, -- Destruction Holo-gogs
					[40274] = 133023, -- Furious Gizmatic Goggles
					[41315] = 133023, -- Gadgetstorm Goggles
					[41311] = 133023, -- Justicebringer 2000 Specs
					[41316] = 133023, -- Living Replicator Specs
					[41319] = 133023, -- Magnified Moon Specs
					[41321] = 133023, -- Powerheal 4000 Lens
					[41314] = 133023, -- Surestrike Goggles v2.0
					[41312] = 133023, -- Tankatronic Goggles
					[41318] = 133023, -- Wonderheal XT40 Shades
					[30325] = 133023, -- Hyper-Vision Goggles
					[30575] = 133023, -- Gnomish Battle Goggles
					[30574] = 133149, -- Gnomish Power Goggles
					[30318] = 133023, -- Ultra-Spectropic Detection Goggles
					[30316] = 133023, -- Cogspinner Goggles
					[30317] = 133023, -- Power Amplification Goggles
					[46113] = 133023, -- Surestrike Goggles v3.0
					-- Devices
					[44391] = 133859, -- Field Repair Bot 110G
					[30565] = 133162, -- Foreman's Enchanted Helmet
					[30566] = 133162, -- Foreman's Reinforced Helmet
					[30556] = 133029, -- Rocket Boots Xtreme
					[46697] = 133029, -- Rocket Boots Xtreme Lite
					[30570] = 132516, -- Nigh-Invulnerability Belt
					[36954] = 133865, -- Dimensional Ripper - Area 52
					[36955] = 321487, -- Ultrasafe Transporter - Toshley's Station
					[30569] = 133864, -- Gnomish Pultryizer
					[30563] = 133032, -- Goblin Rocket Launcher
					[30552] = 134796, -- Mana Potion Injector
					[30568] = 133013, -- Gnomish Flame Turret
					[30337] = 134231, -- Crashin' Thrashin' Robot
					[30551] = 134795, -- Healing Potion Injector
					[30348] = 133876, -- Fel Iron Toolbox
					[30548] = 133037, -- Zapthrottle Mote Extractor
					-- Weapons
					[30315] = 135612, -- Ornate Khorium Rifle
					[30314] = 135613, -- Felsteel Boomstick
					[41307] = 135621, -- Gyro-balanced Khorium Destroyer
					[30313] = 135613, -- Adamantite Rifle
					[30312] = 135613, -- Fel Iron Musket
					-- Scopes
					[30334] = 134441, -- Stabilized Eternium Scope
					[30332] = 134441, -- Khorium Scope
					[30329] = 134441, -- Adamantite Scope
					-- Mounts
					[44157] = 132241, -- Turbo-Charged Flying Machine
					[44155] = 132240, -- Flying Machine
					-- Fireworks
					[30344] = 134283, -- Green Smoke Flare
					[32814] = 134284, -- Purple Smoke Flare
					[30341] = 134286, -- White Smoke Flare
				-- Engineering
					-- Parts
					[19815] = 133001, -- Delicate Arcanite Converter
					[19791] = 132998, -- Thorium Widget
					[19795] = 133027, -- Thorium Tube
					[39895] = 134065, -- Fused Wiring
					[23071] = 135155, -- Truesilver Transformer
					[133587] = 133587, -- Dense Blasting Powder
					[12599] = 133021, -- Mithril Casing
					[12591] = 132488, -- Unstable Trigger
					[12589] = 134535, -- Mithril Tube
					[3961] = 134377, -- Gyrochronatom
					[12715] = 134939, -- Goblin Rocket Fuel Recipe
					[12895] = 134941, -- Inlaid Mithril Cylinder Plans
					[12585] = 134380, -- Solid Blasting Powder
					[3953] = 133006, -- Bronze Framework
					[12584] = 132489, -- Gold Power Core
					[3952] = 133001, -- Minor Recombobulator
					[3958] = 135128, -- Iron Strut
					[3942] = 132996, -- Whirring Bronze Gizmo
					[3938] = 133024, -- Bronze Tube
					[3945] = 133853, -- Heavy Blasting Powder
					[3973] = 133218, -- Silver Contact
					[3929] = 133849, -- Coarse Blasting Powder
					[3922] = 134068, -- Handful of Copper Bolts
					[3918] = 133848, -- Rough Blasting Powder
					-- Explosives
					[19831] = 136173, -- Arcane Bomb
					[19799] = 133713, -- Dark Iron Bomb
					[19790] = 133716, -- Thorium Grenade
					[23080] = 136152, -- Powerful Seaforium Charge
					[12908] = 135812, -- Goblin Dragon Gun
					[12619] = 133715, -- Hi-Explosive Bomb
					[12754] = 133712, -- The Big One
					[12755] = 133000, -- Goblin Bomb Dispenser
					[23070] = 133714, -- Dense Dynamite
					[12603] = 133710, -- Mithril Frag Bomb
					[12716] = 134535, -- Goblin Mortar
					[12760] = 135826, -- Goblin Sapper Charge
					[3972] = 134514, -- Large Seaforium Charge
					[3968] = 134954, -- Goblin Land Mine
					[3967] = 133709, -- Big Iron Bomb
					[8243] = 133581, -- Flash Bomb
					[23069] = 133711, -- EZ-Thro Dynamite II
					[3962] = 133716, -- Iron Grenade
					[3960] = 134535, -- Portable Bronze Mortar
					[3955] = 136071, -- Explosive Sheep
					[12586] = 133714, -- Solid Dynamite
					[3950] = 133713, -- Big Bronze Bomb
					[3941] = 133717, -- Small Bronze Bomb
					[3933] = 134514, -- Small Seaforium Charge
					[3937] = 133709, -- Large Copper Bomb
					[3946] = 133714, -- Heavy Dynamite
					[8339] = 133714, -- EZ-Thro Dynamite
					[3931] = 133714, -- Coarse Dynamite
					[3923] = 133717, -- Rough Copper Bomb
					[3919] = 133714, -- Rough Dynamite
					-- Goggles
					[24356] = 133149, -- Bloodvine Goggles
					[24357] = 133146, -- Bloodvine Lens
					[19825] = 133149, -- Master Engineer's Goggles
					[19794] = 133149, -- Spellpower Goggles Xtreme Plus
					[12622] = 133146, -- Green Lens
					[12618] = 133149, -- Rose Colored Goggles
					[12615] = 133149, -- Spellpower Goggles Xtreme
					[12607] = 133149, -- Catseye Ultra Goggles
					[12897] = 133149, -- Gnomish Goggles
					[12594] = 133149, -- Fire Goggles
					[3966] = 133146, -- Craftsman's Monocle
					[12587] = 133149, -- Bright-Eye Goggles
					[3956] = 133149, -- Green Tinted Goggles
					[3940] = 133149, -- Shadow Goggles
					[3934] = 133149, -- Flying Tiger Goggles
					-- Devices
					[23486] = 133873, -- Dimensional Ripper - Everlook
					[22704] = 132836, -- Field Repair Bot 74A
					[23489] = 133870, -- Ultrasafe Transporter - Gadgetzan
					[19830] = 134156, -- Arcanite Dragonling
					[22797] = 135741, -- Force Reactive Disk
					[23081] = 133862, -- Hyper-Radiant Flame Reflector
					[23082] = 133874, -- Ultra-Flash Shadow Reflector
					[19819] = 133282, -- Voice Amplification Modulator
					[19814] = 132762, -- Masterwork Target Dummy
					[23078] = 133869, -- Goblin Jumper Cables XL
					[23077] = 133860, -- Gyrofreeze Ice Reflector
					[19793] = 134301, -- Lifelike Mechanical Toad
					[26011] = 132189, -- Tranquil Mechanical Yeti
					[23079] = 133867, -- Major Recombobulator
					[63750] = 134442, -- High-powered Flashlight
					[12624] = 134155, -- Mithril Mechanical Dragonling
					[28327] = 133015, -- Steam Tonk Controller
					[23096] = 133859, -- Gnomish Alarm-o-Bot
					[12758] = 133151, -- Goblin Rocket Helmet
					[12759] = 133002, -- Gnomish Death Ray
					[12907] = 133151, -- Gnomish Mind Control Cap
					[12617] = 133151, -- Deepdive Helmet
					[12906] = 135996, -- Gnomish Battle Chicken
					[23129] = 133866, -- World Enlarger
					[12905] = 132536, -- Gnomish Rocket Boots
					[8895] = 133029, -- Goblin Rocket Boots
					[12616] = 133763, -- Parachute Cloak
					[12903] = 132495, -- Gnomish Harm Prevention Belt
					[12902] = 134325, -- Gnomish Net-o-Matic Projector
					[12899] = 133003, -- Gnomish Shrink Ray
					[12718] = 133162, -- Goblin Construction Helmet
					[12717] = 133127, -- Goblin Mining Helmet
					[3971] = 132995, -- Gnomish Cloaking Device
					[3969] = 134153, -- Mechanical Dragonling
					[15255] = 132997, -- Mechanical Repair Kit
					[21940] = 135863, -- Snowmaster 9000
					[3965] = 132765, -- Advanced Target Dummy
					[3963] = 133076, -- Compact Harvest Reaper Kit
					[15633] = 294476, -- Lil' Smoky
					[15628] = 133712, -- Pet Bombling
					[9273] = 133868, -- Goblin Jumper Cables
					[3959] = 134441, -- Discombobulator Ray
					[3957] = 132995, -- Ice Deflector
					[6458] = 134440, -- Ornate Spyglass
					[3944] = 132995, -- Flame Deflector
					[9269] = 134376, -- Gnomish Universal Remote
					[9271] = 133982, -- Aquadynamic Fish Attractor
					[3932] = 132766, -- Target Dummy
					[3928] = 132761, -- Mechanical Squirrel Box
					[8334] = 132594, -- Clockwork Box
					-- Guns & Bows
					[22795] = 135614, -- Core Marksman Rifle
					[19833] = 135612, -- Flawless Arcanite Rifle
					[19796] = 135617, -- Dark Iron Rifle
					[19792] = 135616, -- Thorium Rifle
					[12614] = 135616, -- Mithril Heavy-bore Rifle
					[12595] = 135616, -- Mithril Blunderbuss
					[3954] = 135615, -- Moonsight Rifle
					[3949] = 135616, -- Silver-plated Shotgun
					[3939] = 135616, -- Lovingly Crafted Boomstick
					[3936] = 135616, -- Deadly Blunderbuss
					[3925] = 135612, -- Rough Boomstick
					-- Scopes
					[22793] = 134441, -- Biznicks 247x128 Accurascope
					[12620] = 134441, -- Sniper Scope
					[12597] = 134441, -- Deadly Scope
					[3979] = 134441, -- Accurate Scope
					[3978] = 134441, -- Standard Scope
					[3977] = 134441, -- Crude Scope
					-- Fireworks
					[26443] = 133861, -- Cluster Launcher
					[26426] = 134276, -- Large Blue Rocket Cluster
					[26427] = 134277, -- Large Green Rocket Cluster
					[26428] = 134279, -- Large Red Rocket Cluster
					[23507] = 135920, -- Snake Burst Firework
					[26442] = 134538, -- Firework Launcher
					[26423] = 134288, -- Blue Rocket Cluster
					[26424] = 134289, -- Green Rocket Cluster
					[26425] = 134291, -- Red Rocket Cluster
					[26420] = 134270, -- Large Blue Rocket
					[26421] = 134271, -- Large Green Rocket
					[26422] = 134273, -- Large Red Rocket
					[23067] = 135989, -- Blue Firework
					[23068] = 136006, -- Green Firework
					[23066] = 135808, -- Red Fireworks
					[26416] = 134282, -- Small Blue Rocket
					[26417] = 134283, -- Small Green Rocket
					[26418] = 134285, -- Small Red Rocket
					-- Tools
					[12590] = 134429, -- Gyromatic Micro-Adjustor
					[7430] = 134520, -- Arclight Spanner

			-- Inscription
				-- Kul Tiran Inscription & Zandalari Inscription
				[298929] = 3007458, -- Marron Ink
				[264777] = 2178489, -- Crimson Ink
				[264776] = 2178529, -- Ultramarine Ink

			-- Mining
				-- Pandaria Mining
				[102167] = 612063, -- Smelt Trillium
				[102165] = 538438, -- Smelt Ghost Iron
				-- Cataclysm Mining
				[74529] = 466846, -- Smelt Pyrite
				[74537] = 463522, -- Smelt Hardened Elementium
				[74530] = 463549, -- Smelt Elementium
				[84038] = 135241, -- Smelt Obsidium
				-- Northrend Mining
				[49258] = 237049, -- Smelt Saronite
				[55211] = 237045, -- Smelt Titanium
				[55208] = 237046, -- Smelt Titansteel
				[49252] = 133228, -- Smelt Cobalt
				-- Outland Mining
				[35750] = 132838, -- Earth Sunder
				[35751] = 132839, -- Fire Sunder
				[46353] = 133235, -- Smelt Hardened Khorium
				[29361] = 133223, -- Smelt Khorium
				[29686] = 133226, -- Smelt Hardened Adamantite
				[29360] = 133231, -- Smelt Felsteel
				[29359] = 133225, -- Smelt Eternium
				[29358] = 133224, -- Smelt Adamantite
				[29356] = 133230, -- Smelt Fel Iron
				-- Mining
				[14891] = 133233, -- Smelt Dark Iron
				[22967] = 133235, -- Smelt Enchanted Elementium
				[70524] = 133229, -- Enchanted Thorium Bar
				[16153] = 133221, -- Smelt Thorium
				[10098] = 133222, -- Smelt Truesilver
				[10097] = 133220, -- Smelt Mithril
				[3308] = 133217, -- Smelt Gold
				[3307] = 133232, -- Smelt Iron
				[3569] = 133234, -- Smelt Steel
				[2659] = 133227, -- Smelt Bronze
				[2658] = 133215, -- Smelt Silver
				[3304] = 133219, -- Smelt Tin
				[2657] = 133216, -- Smelt Copper
		}
	end
end


local function eventHandler(self, event)
	if event == "VARIABLES_LOADED" then
		-- Make sure defaults are set
		if not ZA then ZA = { } end
		updateData()
	else
		updateData()
	end
end

frame:SetScript("OnEvent", eventHandler)

function SlashCmdList.ZIGIAURAS(msg, editbox)
	if ZA then
		if not ZA.DebugMode then
			ZA.DebugMode = true
			print("ZA Debug Mode is now ON until end of session")
		else
			ZA.DebugMode = false
			print("ZA Debug Mode is now OFF")
		end
	else
		print("ZA not initialized")
	end
end