SLASH_ZIGIAURAS1 = "/za"
local frame = CreateFrame("FRAME", "ZigiAuras")

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


--zzz
--: Zone IDs

--! The Shadowlands: 1550
-------------------------
-- Oribos: g411
-- Bastion: 1533,1569,1813,1690,1711,1713,1714
	-- Elysian Hold: g418,2018
	-- Path of Ascension: 1711
-- Maldraxxus: 1536,1689,1741,1814,1649,1650,1651,1652,1724,1725
	-- Seat of the Primus: 1698
-- Ardenweald: 1565,1603,1643,1709,1739,1740,1816,1818,1819,1824,1825,1826,1827,1829
	-- Heart of the Forest: g417
	-- Queen's Conservatory: 1662
-- Revendreth: 1525,1688
	-- Sinfall: g416
	-- Ember Court: 1644
-- The Maw: 1543,1648
-- Korthia: 1961,2006,2007

-- Instances:
	-- De Other Side: g413
	-- Halls of Atonement: g409
	-- Mists of Tirna Scithe: 1669
	-- Plaguefall: g415
	-- Sanguine Depths: g412
	-- Spires of Ascension: g419
	-- Tazavesh, the Veiled Market: g423
	-- The Necrotic Wake: g410
	-- Theater of Pain: g414
-- All Shadowlands Instances: g413,g409,1669,g415,g412,g419,g423,g410,g414

-- All Shadowlands Outdoor Zones:
-- 2018,1961,2006,2007,1550,g411,1533,1569,1813,1690,1711,1713,1714,g418,1536,1689,1741,1814,1649,1650,1651,1652,1724,1725,1698,1565,1603,1643,1709,1739,1740,1816,1818,1819,1824,1825,1826,1827,1829,g417,1662,1525,1688,g416,1644,1543,1648

-------------------------


local function updateData()
	local name, realm = UnitFullName("player")
	local _, class, _ = UnitClass("player")
	local faction,_ = UnitFactionGroup("player")
	local spec = GetSpecialization() or 0
	local level = UnitLevel("player") or 1
	local covenant = C_Covenants and C_Covenants.GetActiveCovenantID() or 0
	-- 1 Kyrian
	-- 2 Venthyr
	-- 3 Night Fae
	-- 4 Necrolord

	local role = "dps"
	if (class == "DEATHKNIGHT" and spec == 1) or (class == "DEMONHUNTER" and spec == 2) or (class == "DRUID" and spec == 3) or (class == "MONK" and spec == 1) or (class == "PALADIN" and spec == 2) or (class == "WARRIOR" and spec == 3) then
		role = "tank"
	elseif (class == "DRUID" and spec == 4) or (class == "MONK" and spec == 2) or (class == "PALADIN" and spec == 1) or (class == "PRIEST" and spec ~= 3) or (class == "SHAMAN" and spec == 3) then
		role = "healer"
	end

	local primary = "int"
	if (class == "DEMONHUNTER") or (class == "DRUID" and (spec == 2 or spec == 3)) or (class == "HUNTER") or (class == "MONK" and spec ~= 2) or (class == "ROGUE") or (class == "SHAMAN" and spec == 2) then
		primary = "agi"
	elseif (class == "DEATHKNIGHT") or (class == "WARRIOR") or (class == "PALADIN" and spec ~= 1) then
		primary = "str"
	end
	

	if ZA then
		-- Debug Mode
		ZA.DebugMode = false

		ZA.MyOutgoingMD = ""

		function ZA.dump(o)
			if type(o) == 'table' then
				local s = '{ '
				for k,v in pairs(o) do
					if type(k) ~= 'number' then k = '"'..k..'"' end
					s = s .. '['..k..'] = ' .. ZA.dump(v) .. ','
				end
				return s .. '} '
			else
				return tostring(o)
			end
		end

		-- FormatShortNumber(number, siginifixant)
		function ZA.FormatShortNumber(number, significant)
			if type(number) ~= "number" then
				number = tonumber(number)
			end
			if not number then return end

			if type(significant) ~= "number" then
				significant = tonumber(significant)
			end
			significant = significant or 2

			local affixes = { "K", "M", "B", "T", }
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

		function ZA.AH(alliance, horde)
			local faction = UnitFactionGroup("player")

			if faction == "Horde" then
				return horde
			else
				return alliance
			end
		end

		-- Pet Icons
		ZA.PetIcons = {
			-- Class Pets
			["Chi-Ji"] = 877514,
			["Niuzao"] = 627607,
			["Xuen"] = 620832,
			["Yu'lon"] = 877408,
			["Primal Earth Elemental"] = 136024,
			["Primal Fire Elemental"] = 651081,
			["Primal Storm Elemental"] = 2065626,
			["Water Elemental"] = 135862,
		}

		-- Custom Hunter Pet Icons
		if name == "Appi" then
			ZA.PetIcons["Andy"] = 1504874
			ZA.PetIcons["Blep"] = 1390637
			ZA.PetIcons["Frank"] = 464160
			ZA.PetIcons["Toothpaste"] = 1570766
			ZA.PetIcons["Ravioli"] = 377270
		elseif name == "Gizzard" then
			ZA.PetIcons["Infinity"] = 236177
			ZA.PetIcons["Wah"] = 1819857
			ZA.PetIcons["Crookedile"] = 1387705
		elseif name == "Apera" then
			ZA.PetIcons["Anna"] = 1392564
		elseif name == "Anna" then
			ZA.PetIcons["Apera"] = 132172
		elseif name == "Syrah" then
			ZA.PetIcons["Escoutatz"] = 1096090
		elseif name == "Karin" then
			ZA.PetIcons["Biscuit"] = 612362
		elseif name == "Zorp" then
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
		elseif name == "Aldous" then
			ZA.PetIcons["Zoey"] = 1861689
		elseif name == "Claire" then
			ZA.PetIcons["Daisy"] = 2027853
		end


		-- Spell School Color Gradients
		ZA.SchoolGradients = {
			[0]   = "8e8981:c6c2b9", -- Unknown
			[999] = "3b3b3b:6e6d59", -- Fatigue

			--ccc
			-- Physical
			[1]   = "8e8981:c6c2b9", -- Physical | Unknown
			[100] = "a89f94:7be2ff", -- Mechanical | Engineering
			[112] = "9d9eb1:e58c8c", -- Strike, Red
			[107] = "9d9eb1:f4bc85", -- Strike, Orange | Cleave
			[108] = "9d9eb1:f4e885", -- Strike, Yellow | Swipe
			[109] = "9d9eb1:b7f485", -- Strike, Green
			[110] = "9d9eb1:90afe6", -- Strike, Blue | Armor | Thrown
			[113] = "9d9eb1:ba9de6", -- Strike, Purple | Slam | Tailoring
			[101] = "877f71:8f4646", -- Bleed | Skinning
			[102] = "755c56:a51a10", -- Heavy Bleed
			[106] = "b05642:dda082", -- Strength
			[104] = "edc716:fef972", -- Alacrity | Speed
			[111] = "efff65:dcffeb", -- Sonic | Sound
			[103] = "ffa894:ff7225", -- Enrage
			[105] = "c80034:ff8258", -- Bloodlust

			-- Fire
			[4]   = "ff3600:ffc000", -- Fire (Dynamic)
			[400] = "ff3600:ffc000", -- Fire | Cooking
			[5]   = "d45e3e:ffd262", -- Flamestrike | Smelting
			[12]  = "780033:ff7920", -- Magma | Lava
			[402] = "ca0000:ff5e2c", -- Hellfire
			[20]  = "97cdff:ff9d41", -- Frostfire | Steam
			[68]  = "ff3883:ffba00", -- Spellfire | Phoenixfire
			
			-- Fel
			[401] = "3dec00:fff94f", -- Felfire
			[127] = "00575a:96ff30", -- Chaos
			[427] = "355859:73a640", -- Felstrike

			-- Holy
			[2]   = "ffc539:ffffcb", -- Holy
			[200] = "ffa500:fff58a", -- Holy Light | Gold
			[3]   = "bccccf:ffd76b", -- Holystrike | Flash
			[6]   = "ff6c00:ffd42a", -- Holy Fire | Solar
			[201] = "00baff:fff9de", -- Ethereal | Kyrian
			[600] = "134cff:00baff", -- Ethereal Flame
			[202] = "ce958c:fff1d6", -- Discipline | Bandage | Brewing | Inscription
			[203] = "ffffff:82aab4", -- Hyperlight | Hallow | Broker
			[204] = "0090ff:f8ff66", -- Azerite

			-- Divine
			[66]  = "ff769c:fff7c4", -- Divine | Chi-Ji
			[660] = "ff2d63:ff905a", -- Legendary
			[661] = "ff5484:ffd7f9", -- Love

			-- Frost
			[16]  = "21a4fd:d0fffe", -- Frost
			[160] = "7ed5d6:e8fbff", -- Ice | Snow
			[17]  = "3d5992:afc2df", -- Froststrike
			[24]  = "008aac:b0fff5", -- Froststorm
			[80]  = "8d5ce6:88eaff", -- Spellfrost
			[18]  = "72f1e1:fffad3", -- Holyfrost

			-- Elemental
			[28]  = "ff8400:c263ff", -- Elemental
			[280] = "afe446:7eceff", -- Natural | Spiritual
			[281] = "c9de57:7cb700", -- Chemical | Alchemy

			-- Nature
			[8]   = "3bb53b:beff72", -- Nature | Herbalism
			[900] = "609f5f:cff3a5", -- Naturestrike | Web
			[10]  = "8ee858:e5ffb2", -- Life | Wild
			[805] = "803aff:21d3ff", -- Fey | Night Fae

			-- Poison
			[806] = "00f139:aeff00", -- Poison | Venom | Slime
			[906] = "1d7211:55bf38", -- Poisonstrike

			-- Air
			[811] = "90a3ab:f8ffff", -- Wind | Air
			[911] = "5d6a8c:ccdbdb", -- Storm
			[800] = "4f64ff:a6f2ff", -- Lightning | Thunder
			[9]   = "95b2bc:9497ff", -- Stormstrike

			-- Water
			[801] = "2882bf:2dedc9", -- Water | Sea | Fishing
			[901] = "2c5c7c:76c6b8", -- Waterstrike

			-- Mist
			[802] = "0aff9a:ffff96", -- Mist
			[902] = "007b6e:a0ff90", -- Jade | Yu'lon
			[807] = "00c99d:d6ffc0", -- Jade Lightning
			[907] = "004eb8:aafff8", -- Chi | Xuen

			-- Earth
			[803] = "91622d:f9c265", -- Earth | Mud
			[903] = "85704f:dcbc85", -- Earthstrike | Leatherworking
			[809] = "4e556c:b6b8c9", -- Stone | Rock
			[909] = "6c6f7b:dcdce1", -- Stonestrike | Metal | Salt | Blacksmithing | Mining
			[804] = "b68640:ffea96", -- Sand | Ash
			[810] = "b44c00:ffc243", -- Amber

			-- Gem
			[808] = "8362a2:ffe4ce", -- Crystal | Glass | Jewelcrafting
			[812] = "e2ddd1:daebf5", -- Diamond | Prismatic | White
			[813] = "72449d:e598f3", -- Amethyst | Purple
			[814] = "3c5bb3:45d0ff", -- Sapphire | Blue
			[815] = "25c669:b1ff87", -- Emerald | Green
			[816] = "e4b915:fffe91", -- Citrine | Yellow
			[817] = "f2510d:ffae57", -- Topaz | Orange
			[818] = "92151b:f56760", -- Ruby | Red
			[819] = "382c44:5f6e5b", -- Onyx | Obsidian | Black

			-- Arcane
			[64]  = "6ec3ff:dd40ff", -- Arcane
			[65]  = "908894:c492d9", -- Spellstrike
			[126] = "d830f1:d8b5ff", -- Magic
			[646] = "a4feff:8fb7ff", -- Conjuration | Teleport | Enchanting
			[124] = "52ffb8:ff70cb", -- Chromatic
			[640] = "f2e199:ffa019", -- Temporal

			-- Astral
			[72]  = "62d5ff:ffa4f3", -- Astral
			[720] = "7178d0:76ffba", -- Spectral

			-- Decay
			[414] = "618400:b4e54e", -- Unholy | Bone
			[40]  = "967213:b7e751", -- Plague
			[410] = "6a6009:f1b33b", -- Disease | Rot
			[412] = "5d243a:ff273b", -- Nightmare
			[411] = "372e4b:6e857a", -- Death | Mawsworn
			[413] = "212e54:3d97a2", -- Drust | Devourer

			-- Shadow
			[32]  = "633768:8f7a93", -- Shadow
			[328] = "4c3189:7b7c9e", -- Psychic | Mind Control
			[33]  = "6b616c:635266", -- Shadowstrike
			[322] = "73193d:e4c06a", -- Pain
			[323] = "523d5c:558d8b", -- Haunt | Nether
			[324] = "6e1b3e:ec9da2", -- Corruption | Old Gods
			[96]  = "602b61:8482d9", -- Spellshadow | Runic
			[48]  = "5e3a62:88d4ff", -- Shadowfrost

			-- Darkness
			[320] = "220649:243bff", -- Void
			[34]  = "3949dc:ff256d", -- Twilight
			[321] = "711010:f90000", -- Blood | Venthyr
			[326] = "3e6051:20db9e", -- Necromancy | Necrolord
			[325] = "44205b:b03ccd", -- Curse
			[327] = "313146:ffffff", -- Dread | Fear | Sha
			[36]  = "5400b2:ff5400", -- Shadowflame
			[360] = "451ea7:ff73ea", -- Demonic
			[361] = "6000b2:acff00", -- Shadowfelflame
			--ccx

			-- Resources
			["Arcane Charges"] = "b066fe:fca5f1",
			["Astral Power"] = "fca5f1:b5ffff",
			["Chi"] = "bcebdc:fffff6",
			["Combo Points"] = "aa301b:dd5d24",
			["Energy"] = "ffa800:ffd91a",
			["Focus"] = "ff8040:ff9840",
			["Fury"] = "a21046:e63375",
			["Holy Power"] = "ffa500:fff58a",
			["Insanity"] = "220649:243bff",
			["Maelstrom"] = "83acff:d9f5ff",
			["Mana"] = "305dc3:3c94d1",
			["Rage"] = "e6334d:f10f30",
			["Runic Power"] = "6e8bb5:ab9fc0",
			["Soul Shards"] = "a927cf:ae6bdf",

			-- Anima - Dynamic based on covenant

			-- Reaction
			["Tapped"] = "808080:9b9b9b",
			["Friendly"] = "33991a:6ed854",
			["Neutral"] = "ffcc00:ffcc00",
			["Hostile"] = "b3331a:b3331a",
		}

		if covenant == 1 then
			ZA.SchoolGradients["Anima"] = ZA.SchoolGradients[201]
		elseif covenant == 2 then
			ZA.SchoolGradients["Anima"] = ZA.SchoolGradients[321]
		elseif covenant == 3 then
			ZA.SchoolGradients["Anima"] = ZA.SchoolGradients[805]
		elseif covenant == 4 then
			ZA.SchoolGradients["Anima"] = ZA.SchoolGradients[326]
		else
			ZA.SchoolGradients["Anima"] = ZA.SchoolGradients["Mana"]
		end

		ZA.ClassGradients = {
			["DEATHKNIGHT"] = "a6172d:c62843",
			["DEMONHUNTER"] = "8325ab:a738cb",
			["DRUID"] = "e46008:ff8214",
			["HUNTER"] = "8cb758:aed678",
			["MAGE"] = "31a9cf:47c9ec",
			["MONK"] = "00e475:0aff9a",
			["PALADIN"] = "da6b9b:f591bd",
			["PRIEST"] = "d4d4d4:ededed",
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

		greenfire = false
		if class and class == "WARLOCK" and IsSpellKnown(101508) then
		    ZA.SelfSchoolGradients[4] = ZA.SchoolGradients[401] -- The Codex of Xerrath
		    greenfire = true
		end

		ZA.IsHearthstone = {
			["Hearthstone"] = true,
			["Brewfest Reveler's Hearthstone"] = true,
			["Eternal Traveler's Hearthstone"] = true,
			["Fire Eater's Hearthstone"] = true,
			["Greatfather Winter's Hearthstone"] = true,
			["Headless Horseman's Hearthstone"] = true,
			["Holographic Digitalization Hearthstone"] = true,
			["Kyrian Hearthstone"] = true,
			["Lunar Elder's Hearthstone"] = true,
			["Mountebank's Colorful Cloak"] = true,
			["Necrolord Hearthstone"] = true,
			["Night Fae Hearthstone"] = true,
			["Ardenweald Hearthstone"] = true,
			["Noble Gardener's Hearthstone"] = true,
			["Peddlefeet's Lovely Hearthstone"] = true,
			["The Innkeeper's Daughter"] = true,
			["Venthyr Sinstone"] = true,
		}

		ZA.IsAltHearthstone = {
			["Astral Recall"] = true,
			["Dark Portal"] = true,
			["Ethereal Portal"] = true,
			["Ruby Slippers"] = true,
			["Town Portal"] = true,
		}

		if not ZA.CastSchoolByNameAuto then
			ZA.CastSchoolByNameAuto = {}
		end

		ZA.CastSchoolByName = {
			--! Dynamic
			["Activating Specialization"] = class or 0,
			["Serenity Blessing"] = (primary == "int") and 126 or 106,
			["Ascendance:135791"] = (class == "SHAMAN" and spec == 1) and 400 or (class == "SHAMAN" and spec == 2) and 811 or (class == "SHAMAN" and spec == 3) and 801 or 28,
			["Capturing:132487"] = ZA.AH(110, 112),


			--: Physical
			-------------------------
			--! Mechanical  ! Engineering
			["Grappling Gun"] = 100,
			["Searching"] = 100,
			["Handing Over"] = 100,
			["Throw Wyrmtongue Crate"] = 100,
			["Examining"] = 100,
			["Investigating"] = 100,
			["Meteor Impact:369278"] = 100,
			["Sashj'tar Harpoon"] = 100,
			["Harpoon Barrage"] = 100,
			["Pistol Shot"] = 100,
			["Activating"] = 100,
			["Deactivating"] = 100,
			["Aimed Shot"] = 100,
			["Barrage"] = 100,
			["Construct Heavy Barricade"] = 100,
			["Cutting Beam"] = 100,
			["Defibrilate"] = 100,
			["Disabling"] = 100,
			["Electrostatic Distortion"] = 100,
			["Energize"] = 100,
			["Engineering"] = 100,
			["Gnome Ingenuity"] = 100,
			["Gnomish Transporter"] = 100,
			["Goblin Glider"] = 100,
			["Goblin Transporter"] = 100,
			["Haywire"] = 100,
			["Healing Spray"] = 100,
			["Holographic Digitalization Hearthstone"] = 100,
			["Hyper Organic Light Originator"] = 100,
			["Kicking"] = 110,
			["Loot-A-Rang"] = 100,
			["Mobile Banking"] = 100,
			["Mole Machine"] = 100,
			["Ogre Transformation"] = 100,
			["Opening Shredder Crate"] = 100,
			["Opening"] = 100,
			["Parachute"] = 100,
			["Pick Lock"] = 100,
			["Placing Wood"] = 100,
			["Placing"] = 100,
			["Proto-Beam"] = 100,
			["Proto Beam"] = 100,
			["Rapid-Fire"] = 100,
			["Reactivating"] = 100,
			["Reaping Blows"] = 100,
			["Repair Carriage"] = 100,
			["Repairing"] = 100,
			["Retrofit"] = 100,
			["Return to Entrance"] = 100,
			["Scatter Shot"] = 100,
			["Scrapping"] = 100,
			["Shoot"] = 100,
			["Shotgun"] = 100,
			["Steady Shot"] = 100,
			["Survey"] = 100,
			["Teleport With Error"] = 100,
			["Toshley's Station Transporter"] = 100,
			["Trusty Shotgun"] = 100,
			["Tune Up"] = 100,
			["Unlocking"] = 100,
			["Wormhole Teleport"] = 100,
			["Wormhole"] = 100,
			["Wormhole: Pandaria"] = 100,

			--! Strike, Red
			["Bloody Blades"] = 112,
			["Piercing Chomp"] = 112,
			["Critical Shot"] = 112,
			["Jump Strike"] = 112,
			["Savage Assault"] = 112,
			["Hampering Strike"] = 112,
			["Chomp"] = 112,
			["Call to Arms:132485"] = 112,
			["Die by the Sword"] = 112,
			["Goliath's Bane"] = 112,
			["Snipe"] = 112,
			["Opportunity"] = 112,
			["Piercing Thrust"] = 112,
			["Grinding Crunch"] = 112,
			["Vicious Warbanner"] = 112,
			["Whirling Strike"] = 112,
			["Misdirection"] = 112,
			["Tricks of the Trade"] = 112,
			["Gladiator's Warbanner"] = 112,
			["Slashing Talons"] = 112,
			["Shred Armor"] = 112,
			["Crippler"] = 112,
			["Darting Daggers"] = 112,
			["Spreadshot:132208"] = 112,
			["Shattering Pain:1357802"] = 112,
			["Goring Swipe"] = 112,
			["Hack"] = 112,
			["Tenderize"] = 112,
			["Impaling Gaze"] = 112,
			["Hack Tendon"] = 112,
			["Claw Strike"] = 112,
			["Devour"] = 112,

			--! Strike, Orange  ! Cleave
			["Furious Assault"] = 107,
			["Hew"] = 107,
			["Wide Swing"] = 107,
			["Unwavering Assault"] = 107,
			["Furious Thrashing"] = 107,
			["Snap & Chop"] = 107,
			["Claw:575745"] = 107,
			["Tail Swipe:575745"] = 107,
			["Downward Strike"] = 107,
			["Sabriel Slash"] = 107,
			["Sabreil Slash"] = 107,
			["Crippling Blow"] = 107,
			["Triple Bite:1394887"] = 107,
			["Heroic Thrust"] = 107,
			["Flurry"] = 107,
			["Attacking"] = 107,
			["Bash n Smash"] = 107,
			["Blade Flurry"] = 107,
			["Sweeping Strikes"] = 107,
			["Bladestorm"] = 107,
			["Piercing Shot"] = 107,
			["Puncture Armor"] = 107,
			["Ravaging Whirl"] = 107,
			["Savage Claws"] = 107,
			["Skewer"] = 107,
			["Squish 'Em"] = 107,
			["Sunder Armor"] = 107,
			["Crush Armor"] = 107,
			["Crunch Armor"] = 107,
			["War Stomp"] = 107,
			["Wild Carve"] = 107,
			["Destroying"] = 107,
			["Penta-Strike"] = 107,
			["Crushing Strike"] = 107,

			--! Strike, Yellow  ! Swipe
			["Double Claw"] = 108,
			["Pulverize"] = 108,
			["Throw Spear"] = 108,
			["Claw Swipe"] = 108,
			["Swipe"] = 108,
			["Double Swipe"] = 108,
			["Claw"] = 108,
			["Throw Chakram"] = 108,
			["Spinning Blade"] = 108,
			["Smack"] = 108,
			["Hunting Talons"] = 108,
			["Snap and Toss"] = 108,
			["Ram"] = 108,
			["Headbutt"] = 108,
			["Huddle"] = 108,
			["Hampering Blow"] = 108,
			["Hamstring"] = 108,
			["Picking Pocket"] = 108,
			["Stealing Egg"] = 108,
			["Beast Cleave"] = 108,
			["Throw Hammer:3084396"] = 108,
			["Looting"] = 108,
			["Pillage"] = 108,
			["Open Chest"] = 108,
			["Collecting"] = 108,
			["Belly Slam"] = 108,
			["Bite"] = 108,
			["Crushing Smash"] = 108,
			["Brutal Smash"] = 108,
			["Overhead Smash"] = 108,
			["Pincer"] = 108,
			["Resolute Armor"] = 108,
			["Wild Chop"] = 108,
			["Relentless Mauling"] = 108,
			["Haymaker"] = 108,

			--! Strike, Green
			["Hulking Kick"] = 109,
			["Night Glaive"] = 109,
			["Gieger Smash"] = 109,
			["Spiked Bulwark"] = 109,
			["Cleave"] = 109,
			["Big Bop"] = 109,
			["Bop Barrage"] = 109,
			["Smack Down"] = 109,
			["Bolas"] = 109,
			["Flowing Strike"] = 109,
			["Devouring Ambush"] = 109,
			["Smack:458717"] = 109,
			["Snapping Bite"] = 109,
			["Glaive Toss"] = 109,
			["Rebounding Blades"] = 109,
			["Shell Spin"] = 109,
			["Grand Melee"] = 109,

			--! Strike, Blue  ! Armor  ! Thrown
			["Throw Weapon"] = 110,
			["Overwhelming Slam:136170"] = 110,
			["Massive Blow"] = 110,
			["Log Smash"] = 110,
			["Throw Axe"] = 110,
			["Throw Witchalok Blade"] = 110,
			["Face Kick"] = 110,
			["Clobber"] = 110,
			["Throw"] = 110,
			["Throw Gears"] = 110,
			["Peck"] = 110,
			["Bulwark"] = 110,
			["Heroic Throw"] = 110,
			["Call to Arms:132486"] = 110,
			["Overpower"] = 110,
			["Hide-Piercing Shot"] = 110,
			["Piercing Shot"] = 110,
			["Rifle Shot"] = 110,
			["Machine Gun"] = 110,
			["Between the Eyes"] = 110,
			["Three Blade Strike"] = 110,
			["Gluttonous Slam"] = 110,
			["Armor Plating"] = 110,
			["Double Strike"] = 110,
			["Shield Slam"] = 110,
			["Shield Block"] = 110,
			["Whirlwind"] = 110,
			["Whirling Spin"] = 110,
			["Arrow Barrage"] = 110,
			["Crush"] = 110,
			["Impaling Spear"] = 110,
			["Pinning Spear"] = 110,
			["Mortal Strike"] = 110,
			["Volley"] = 110,
			["Shield Wall"] = 110,
			["Ruthless Precision"] = 110,

			--! Strike, Purple  ! Slam  ! Tailoring
			["Overwhelm"] = 113,
			["Backhand"] = 113,
			["Overhead Smash"] = 113,
			["Mash"] = 113,
			["Champion's Honor:135884"] = 113,
			["Wicked Slash"] = 113,
			["Wicked Smash"] = 113,
			["Soulsunder"] = 113,
			["Slam"] = 113,
			["Staggering Slam"] = 113,
			["Blessing of Protection"] = 113,
			["Skull and Crossbones"] = 113,

			--! Bleed  ! Skinning
			["Vicious Throw"] = 101,
			["Cut to the Bone"] = 101,
			["Cut To The Bone"] = 101,
			["Barbed Spear"] = 101,
			["Rending Cut"] = 101,
			["Bleeding Swipe"] = 101,
			["Jagged Chop"] = 101,
			["Shredding Whirl"] = 101,
			["Catch of the Day"] = 101,
			["Steel Trap"] = 101,
			["Piercing Fangs"] = 101,
			["Vital Slice"] = 101,
			["Razor's Edge"] = 101,
			["Regal Bite"] = 101,
			["Ripping Strike"] = 101,
			["Ravage"] = 101,
			["Exsanguinating Bite"] = 101,
			["Heart Rend"] = 101,
			["Jagged Claws"] = 101,
			["Vanquishing Strike:2065633"] = 101,
			["Stone Claws"] = 101,
			["Ragged Claws"] = 101,
			["Gash"] = 101,
			["Scratch"] = 101,
			["Slashing Rend"] = 101,
			["Tearing Bite"] = 101,
			["Rending Talons"] = 101,
			["Serrated Slash"] = 101,
			["Gore"] = 101,
			["A Feast of Eyes"] = 101,
			["A Murder of Crows"] = 101,
			["Bloody Pin"] = 101,
			["Bloody Talons"] = 101,
			["Bruising Strike"] = 101,
			["Garrote"] = 101,
			["Gruesome Tear"] = 101,
			["Heart Strike"] = 101,
			["Internal Bleeding"] = 102,
			["Jagged Maw"] = 101,
			["Leech"] = 101,
			["Rake"] = 101,
			["Rake"] = 101,
			["Rupture"] = 102,
			["Savage Maul"] = 101,
			["Shred"] = 101,
			["Skinning"] = 101,
			["Talon Rake"] = 101,
			["Thrash"] = 101,
			["Throw Flesh"] = 101,
			["Puncturing Stab"] = 101,

			--! Heavy Bleed
			["Shredder"] = 102,
			["Nanoslicer"] = 102,
			["Bloody Tantrum"] = 102,
			["Big Sharp Nasty Teeth"] = 102,
			["Serrated Swipe"] = 102,
			["Grievous Strike"] = 102,
			["Exsanguinating Bite"] = 102,
			["Barbed Cutlass"] = 102,
			["Marrowjaw's Bite"] = 102,
			["Rip"] = 102,

			--! Strength
			["Torturous Might"] = 106,
			["Kill Command"] = 106,
			["Survival Instincts"] = 106,
			["Primal Instinct"] = 106,
			["Gladiator's Badge"] = 106,
			["Gladiator's Insignia"] = 106,
			["Fury of the Beast"] = 106,
			["Sigil of Skoldus"] = 106,
			["Mighty Slam"] = 106,
			["Petrified Pet Food"] = 106,
			["Stampede"] = 106,
			["Negative Energy Token"] = 106,
			["Demoralizing Shout"] = 106,
			["Rallying Cry"] = 106,
			["Demonbane"] = 106,
			["Carrying the Wounded"] = 106,
			["Bestial Wrath"] = 106,
			["Colossus Smash"] = 106,
			["Colossal Strike"] = 106,
			["Coordinated Assault"] = 106,
			["Crushing Slam"] = 106,
			["Obliterate"] = 106,
			["Holy Strength"] = 106,
			["Unholy Strength"] = 106,

			--! Alacrity  ! Speed
			["Gore Charge"] = 104,
			["Disengage"] = 104,
			["Acrobatic Strike"] = 104,
			["Acrobatic Strikes"] = 104,
			["Boar Charge"] = 104,
			["Deadly Pounce"] = 104,
			["Barbarian"] = 104,
			["Quilboar Rush"] = 104,
			["Wily Wits"] = 104,
			["Wild Charge"] = 104,
			["Shoulder Charge"] = 104,
			["Trampling Charge"] = 104,
			["Shuffle"] = 104,
			["Rolling Charge"] = 104,
			["Stampeding Charge"] = 104,
			["Deadeye Charge"] = 104,
			["Swiftstep"] = 104,
			["Rearing Charge"] = 104,
			["Hop"] = 104,
			["Leaping Bite"] = 104,
			["Vicious Charge"] = 104,
			["Skirmisher's Speed"] = 104,
			["Bounding Crush"] = 104,
			["Bounding Stride"] = 104,
			["Spirit's Swiftness"] = 104,
			["Dark Stride"] = 104,
			["Hulking Charge"] = 104,
			["Thunderous Paws"] = 104,
			["Courageous Spirit:236362"] = 104,
			["Charge"] = 104,
			["Goring Charge"] = 104,
			["Heirmir's Arsenal: Gorestompers"] = 104,
			["Skirmishing Pounce"] = 104,
			["Empyreal Reflexes"] = 104,
			["Evasive Lunge"] = 104,
			["Hypertune Anima"] = 104,
			["Revenge!"] = 104,
			["War Machine"] = 104,
			["Murmuring Shawl"] = 104,
			["Acceleration Rune"] = 104,
			["Alacrity"] = 104,
			["Aspect of the Cheetah"] = 104,
			["Body and Soul"] = 104,
			["Dash"] = 104,
			["Draenic Living Action Potion"] = 104,
			["Draenic Swiftness Potion"] = 104,
			["Egg Rush!"] = 104,
			["Empyreal Reflexs"] = 104,
			["Evasion"] = 104,
			["Free Action"] = 104,
			["Haste"] = 104,
			["Living Free Action"] = 104,
			["March of the Highlord"] = 104,
			["Onslaught"] = 104,
			["Posthaste"] = 104,
			["Roar of the Crowd"] = 104,
			["Slice and Dice"] = 104,
			["Speed of Gonk"] = 104,
			["Speed"] = 104,
			["Sprint"] = 104,
			["Stampeding Roar"] = 104,
			["Swiftness"] = 104,
			["The Sentinel's Eternal Refuge"] = 104,
			["Tiger Dash"] = 104,
			["Tiger's Lust"] = 104,
			["Wild Charge"] = 104,

			--! Sonic
			["Deathsong"] = 111,
			["Mrgggrrrll!"] = 111,
			["Massive Screech"] = 111,
			["Bone Rattling Howl"] = 111,
			["Call For Help"] = 111,
			["Call for Help"] = 111,
			["Howl"] = 111,
			["Ragged Roar"] = 111,
			["Argent War Horn"] = 111,
			["Call the Pack"] = 111,
			["Sonic Scream"] = 111,
			["Screaming Blast"] = 111,
			["Howling Screech"] = 111,
			["Ferocious Yell"] = 111,
			["Reckless Provocation:132352"] = 111,
			["Empyreal Roar"] = 111,
			["Whistling"] = 111,
			["Lumbering Roar"] = 111,
			["Howling in Pain"] = 111,
			["Interrupting Shout"] = 111,
			["Call Mommy"] = 111,
			["Sonic Projection"] = 111,
			["Hunter's Signal"] = 111,
			["Scout's Signal"] = 111,
			["Warleader's Signal"] = 111,
			["Sounding Horn"] = 111,
			["Piercing Roar"] = 111,
			["Bleat"] = 111,
			["Call Gormling Larva"] = 111,
			["Colossal Roar"] = 111,
			["Deafening Howl"] = 111,
			["Deafening Roar"] = 111,
			["Disruptive Screams"] = 111,
			["Dread Screech"] = 111,
			["Earsplitting Shriek"] = 111,
			["Echo"] = 111,
			["Echoing Sonar"] = 111,
			["Force and Verve"] = 111,
			["Harpy's Scream"] = 111,
			["Horn of Jale"] = 111,
			["Interrupting Roar"] = 111,
			["Murmur's Touch"] = 111,
			["Rasping Scream"] = 111,
			["Rending Howl"] = 111,
			["Rending Roar"] = 111,
			["Screech"] = 111,
			["Screeching Howl"] = 111,
			["Shattering Song"] = 111,
			["Song of the Empress"] = 111,
			["Sonic Boom"] = 111,
			["Sonic Burst"] = 111,
			["Sonic Pulse"] = 111,
			["Sonic"] = 111,
			["Store Kinetic Energy"] = 111,
			["Supersonic"] = 111,
			["Threatening Roar"] = 111,
			["Primal Roar"] = 111,

			--! Enrage
			["Mongoose Fury"] = 103,
			["Death Wish"] = 103,
			["Blood Rage"] = 103,
			["Undying Frenzy"] = 103,
			["Owlkin Frenzy"] = 103,
			["Fel Rage"] = 103,
			["Berserk"] = 103,
			["Berserker Frenzy"] = 103,
			["Unholy Assault"] = 103,
			["Fixate"] = 103,
			["Rampaging Slam"] = 103,
			["Rampaging Strike"] = 103,
			["Rip You To Pieces"] = 103,
			["Rage of Sargeras"] = 103,
			["Bestial Howl"] = 103,
			["Death Wish"] = 103,
			["Unholy Frenzy"] = 103,
			["Dreadful Anger"] = 103,
			["Fleeting Frenzy"] = 103,
			["Dragon's Flight"] = 103,
			["Ravenous Feast"] = 103,
			["Crazed"] = 103,
			["Crazed Rage"] = 103,
			["Unraveling Frenzy"] = 103,
			["Furious Screech"] = 103,
			["Predator's Gaze:1100023"] = 103,
			["Ragebringer"] = 103,
			["Rampage"] = 103,
			["Adrenaline Rush"] = 103,
			["Berserker Rage"] = 103,
			["Berserking"] = 103,
			["Blood Fury"] = 103,
			["Death Sweep"] = 103,
			["Endless Rage"] = 103,
			["Enrage"] = 103,
			["Frenzy"] = 103,
			["Furious Swipes:1396978"] = 103,
			["Growing Anger"] = 103,
			["Killing Spree"] = 103,
			["Rabid Frenzy"] = 103,
			["Rapid Fire"] = 103,
			["Tantrum"] = 103,
			["Taunka Rage"] = 103,
			["Violent Eruption:136215"] = 103,

			--! Bloodlust
			["Voracious Haste"] = 105,
			["Voracious"] = 105,
			["Blood Frenzy"] = 105,
			["Victorious"] = 105,
			["Enraged Regeneration"] = 105,
			["Lust for Battle"] = 105,
			["Reflection: Massacre"] = 105,
			["Reflection: Ravage"] = 105,
			["Command: Massacre"] = 105,
			["Command: Ravage"] = 105,
			["Keen Empowerment"] = 105,
			["Renegade Strength"] = 105,
			["Black Flight"] = 105,
			["Heightened Senses:3684825"] = 105,
			["Nathrian Hymn: Sinsear"] = 105,
			["Nathrian Hymn: Evershade"] = 105,
			["Nathrian Hymn: Duskhollow"] = 105,
			["Command Bargast"] = 105,
			["Command Hecutis"] = 105,
			["Command Margore"] = 105,
			["March of the Penitent:1357812"] = 105,
			["Ancient Hysteria"] = 105,
			["Bloodlust"] = 105,
			["Choosing Gonk"] = 105,
			["Drums of Deathly Ferocity"] = 105,
			["Drums of Fury"] = 105,
			["Drums of Rage"] = 105,
			["Drums of the Maelstrom"] = 105,
			["Drums of the Mountain"] = 105,
			["Euphoria"] = 105,
			["Heroism"] = 105,
			["Power Infusion"] = 105,
			["Primal Rage"] = 105,
			["Quick Bloodlust"] = 105,
			["Chant of Fury"] = 105,


			--: Fire
			-------------------------
			--! Fire  ! Cooking
			["Smoldering Inertia"] = 400,
			["Fiery Blast"] = 400,
			["Blast Wave:135903"] = 400,
			["Blazing Wave"] = 400,
			["Flame Thrower"] = 400,
			["Barrage of Flame"] = 400,
			["Blaze of Glory"] = 400,
			["Burn"] = 400,
			["Firestorm"] = 400,
			["Fire Whirl"] = 400,
			["Toss Fuel on Bonfire"] = 400,
			["Summon Blazing Servitor"] = 400,
			["Firestorm Kick"] = 400,
			["Flame Breath"] = 400,
			["Call Flames:135789"] = 400,
			["Self-Destruct"] = 400,
			["Self-Destruct Protocol"] = 400,
			["Seething Flames"] = 400,
			["Light Bonfire"] = 400,
			["Throw Torch"] = 400,
			["Blazing Surge"] = 400,
			["Burning"] = 400,
			["Backdraft"] = 400,
			["Ball of Fire"] = 400,
			["Breath of Fire"] = 400,
			["Burn Corpse"] = 400,
			["Chaotic Inferno"] = 400,
			["Combustion"] = 400,
			["Conflagrate"] = 400,
			["Dragon's Breath"] = 400,
			["Elemental Blast: Critical Strike"] = 400,
			["Fiery Breath"] = 400,
			["Fire Eater's Hearthstone"] = 400,
			["Fire Elemental"] = 400,
			["Greater Fire Elemental"] = 400,
			["Primal Fire Elemental"] = 400,
			["Fireball"] = 400,
			["Firebird"] = 400,
			["Firebolt"] = 400,
			["Flame Shock"] = 400,
			["Flick Match"] = 400,
			["Fuselighter"] = 400,
			["Immolation Aura"] = 400,
			["Lavacore Bomb"] = 400,
			["Living Bomb"] = 400,
			["Napalm Thrower"] = 400,
			["Nitro Boosts"] = 400,
			["Rune of Asvior"] = 400,
			["Runed Flame Jets"] = 400,
			["Scorch"] = 400,
			["Signal Flare"] = 400,
			["Uncontrolled Fire"] = 400,
			["Wildfire Bomb"] = 400,
			["Blazing Barrier"] = 400,
			["Sear"] = 400,

			--! Flamestrike  ! Cannonfire  ! Smelting
			["Exploding Oil Barrel"] = 5,
			["Flare"] = 5,
			["Grapeshot Blast"] = 5,
			["Blazing Shot"] = 5,
			["Bombard"] = 5,
			["Cannon Shot"] = 5,
			["Fanning the Flames"] = 5,
			["Fiery Strike"] = 5,
			["Flame Arrows"] = 5,
			["Gauntlet Smash:509966"] = 5,
			["Giantbreaker Spear"] = 5,
			["Gyro-Scrap"] = 5,
			["Heating Up"] = 5,
			["Hurl Boulder:135812"] = 5,
			["Hurl Boulder:252172"] = 5,
			["Left Piston"] = 5,
			["Right Piston"] = 5,
			["Sharpen Steel"] = 5,
			["Shell Spin:459027"] = 5,
			["Shrapnel Blast"] = 5,
			["Stoke the Flames"] = 5,
			["Throw Cluster Bomb"] = 5,
			["Ticking Time Bomb"] = 5,
			["Meteor Fists"] = 5,
			["Refine Meteorite"] = 5,
			["Meteorite Whetstone"] = 5,
			["Fire Support: Black Skies"] = 5,
			["Fire Support: Blackest Skies"] = 5,

			--! Magma  ! Lava  ! Meteor
			["Obsidian Skin"] = 12,
			["Burning Slag"] = 12,
			["Call Meteor"] = 12,
			["Crashing Inferno"] = 12,
			["Dormant Volcano"] = 12,
			["Dormant Volcano"] = 12,
			["Dormant Volcanoes"] = 12,
			["Fiery Boulder"] = 12,
			["Fiery Brimstone"] = 12,
			["Fire Shards"] = 12,
			["Fireblood"] = 12,
			["Fissure:1032476"] = 12,
			["Flamestrike"] = 12,
			["Hurl Boulders:892832"] = 12,
			["Lava Beam"] = 12,
			["Lava Burst"] = 12,
			["Lava Gout"] = 12,
			["Lava Shock"] = 12,
			["Lava Spew"] = 12,
			["Lava Spit"] = 12,
			["Lava Surge"] = 12,
			["Liquid Magma Totem"] = 12,
			["Living Meteor"] = 12,
			["Magma Barrage"] = 12,
			["Magma Belch"] = 12,
			["Magma Eruption"] = 12,
			["Massive Eruption:135830"] = 12,
			["Meteorite"] = 12,
			["Meteor Burn"] = 12,
			["Meteor Cleave"] = 12,
			["Meteor Crack"] = 12,
			["Meteor Explosion"] = 12,
			["Meteor Impact"] = 12,
			["Meteor Rain"] = 12,
			["Meteor Shard"] = 12,
			["Meteor Shower"] = 12,
			["Meteor Slash"] = 12,
			["Meteor Storm"] = 12,
			["Meteor Strike"] = 12,
			["Meteor Swarm"] = 12,
			["Meteor Swarm"] = 12,
			["Abyssal Meteor Fall"] = 12,
			["Meteor"] = 12,
			["Meteorfall"] = 12,
			["Meteoric Impact"] = 12,
			["Molten Eruption"] = 12,
			["Molten Meteor"] = 12,
			["Molten Pool"] = 12,
			["Molten Surge"] = 12,
			["Primal Magma"] = 12,
			["Rune of Destruction:978470"] = 12,
			["Seal Armor Breach:538043"] = 12,
			["Searing Plasma"] = 12,
			["Slag Bolt"] = 12,
			["Slag Breath"] = 12,
			["Soulforge Embers"] = 12,
			["Summon Meteor"] = 12,
			["Summon Slag Elemental"] = 12,
			["Summon Unstable Slag"] = 12,
			["Volcanic Tantrum"] = 12,
			
			--! Hellfire
			["Soul Explosion"] = 402,
			["Roaring Heat"] = 402,
			["Tormenting Flames"] = 402,
			["Cauterize Master"] = 402,
			["Burning Hatred"] = 402,
			["Nuclear Blast"] = 402,
			["Disintegration Laser"] = 402,
			["Soul Fire"] = 402,
			["Rain of Fire"] = 402,
			["Immolate"] = 402,
			["Incinerate"] = 402,
			["Headless Horseman's Hearthstone"] = 402,
			["Hellfire"] = 402,
			["Ritual of Doom"] = 402,

			--! Frostfire  ! Steam
			["Steam Blast"] = 20,
			["Scald"] = 20,
			["Crystalfire Breath"] = 20,
			["Crystalfire Discharge"] = 20,
			["Crystalfire Totem"] = 20,
			["Crystalfire"] = 20,
			["Frostfire Bolt"] = 20,
			["Frostfire Reflector"] = 20,
			["Thawing"] = 20,
			["Crystallize:135866"] = 20,

			--! Spellfire  ! Phoenixfire
			["Phoenix Renewal"] = 68,
			["Phoenix Flames"] = 68,
			["Phoenix Flight"] = 68,
			["Blazing Phoenix"] = 68,
			["Phoenix Strike"] = 68,
			["Phoenix Burst"] = 68,
			["Flash of Phoenixes"] = 68,
			["Phoenix Reborn"] = 68,
			["Bolthorn's Rune of Flame"] = 68,


			--: Fel
			-------------------------
			--! Felfire
			["Foul Blast:135804"] = 401,
			["Hellfire and Brimstone:135801"] = 401,
			["Devour Soul:841221"] = 401,
			["Blazing Swipe:135802"] = 401,
			["Fel Destruction"] = 401,
			["Felshard Meteor"] = 401,
			["Felshard Meteors"] = 401,
			["Meteor Impact:136120"] = 401,
			["Meteor:840199"] = 401,
			["Meteor Slash:135801"] = 401,
			["Meteor Storm:135804"] = 401,
			["Rain of Meteors:135803"] = 401,
			["Backdraft:840404"] = 401,
			["Barrage:135804"] = 401,
			["Belch Flame:135797"] = 401,
			["Blade of Flames:1118739"] = 401,
			["Blazing Hellfire:841221"] = 401,
			["Breath of Annihilation"] = 401,
			["Burn:135794"] = 401,
			["Burn:135799"] = 401,
			["Burning Armor:135799"] = 401,
			["Burning Barrage:135804"] = 401,
			["Burning Bite:135799"] = 401,
			["Burning Blood:841221"] = 401,
			["Burning Breath:135794"] = 401,
			["Burning Fel"] = 401,
			["Burning Flames:135799"] = 401,
			["Burning Fury:841221"] = 401,
			["Burning Fury:841221"] = 401,
			["Burning Gaze:1117876"] = 401,
			["Burning Gaze:841220"] = 401,
			["Burning Iris:1387707"] = 401,
			["Burning Mirror"] = 401,
			["Burning Pitch:135804"] = 401,
			["Burning Slash:135802"] = 401,
			["Burning Spit:841220"] = 401,
			["Burning Spittle:135797"] = 401,
			["Burning:132108"] = 401,
			["Burning:135794"] = 401,
			["Burning:135802"] = 401,
			["Cannon Fire:135797"] = 401,
			["Cauterize Master:840409"] = 401,
			["Chain Felfire"] = 401,
			["Chemical Flames"] = 401,
			["Crashing Comet:135797"] = 401,
			["Crashing Fissure:1118738"] = 401,
			["Dancing Flames:135797"] = 401,
			["Dark Communion:1121020"] = 401,
			["Death Blast:135803"] = 401,
			["Demonic Breath"] = 401,
			["Desecrated Runeblast"] = 401,
			["Empowered Felblast"] = 401,
			["Explosive Fel Rune"] = 401,
			["Eye of Kilrogg"] = 401,
			["Fel Annihilation"] = 401,
			["Fel Bile"] = 401,
			["Fel Bindings"] = 401,
			["Fel Blast"] = 401,
			["Fel Bolt"] = 401,
			["Fel Breath"] = 401,
			["Fel Burn"] = 401,
			["Fel Cannon Blast"] = 401,
			["Fel Cauterize"] = 401,
			["Fel Devastation"] = 401,
			["Fel Empowerment"] = 401,
			["Fel Fire"] = 401,
			["Fel Fireball"] = 401,
			["Fel Fireblast"] = 401,
			["Fel Firebolt"] = 401,
			["Fel Firebomb"] = 401,
			["Fel Firestorm"] = 401,
			["Fel Fissure"] = 401,
			["Fel Flame Spit"] = 401,
			["Fel Flame"] = 401,
			["Fel Flames"] = 401,
			["Fel Flamestrike"] = 401,
			["Fel Gaze"] = 401,
			["Fel Immolate"] = 401,
			["Fel Immolation Aura"] = 401,
			["Fel Immolation"] = 401,
			["Fel Implosion"] = 401,
			["Fel Imprisonment"] = 401,
			["Fel Lance"] = 401,
			["Fel Lava Beam"] = 401,
			["Fel Lava Burst"] = 401,
			["Fel Lightning"] = 401,
			["Fel Meteor"] = 401,
			["Fel Meteor Swarm"] = 401,
			["Fel Meteor Explosion"] = 401,
			["Fel Meteorite"] = 401,
			["Fel Poison"] = 401,
			["Fel Rain"] = 401,
			["Fel Sear"] = 401,
			["Fel Shield Blast"] = 401,
			["Fel Shock"] = 401,
			["Fel Slagblast"] = 401,
			["Fel Slash:135802"] = 427,
			["Fel Spike"] = 401,
			["Fel Squall"] = 401,
			["Fel Storm"] = 401,
			["Fel Streak"] = 401,
			["Fel Tear"] = 401,
			["Fel Tempest"] = 401,
			["Fel Weaving"] = 401,
			["Felblast"] = 401,
			["Felblaze Cleave"] = 401,
			["Felbolt"] = 401,
			["Felburst"] = 401,
			["Felfire Assault"] = 401,
			["Felfire Blast"] = 401,
			["Felfire Bolt"] = 401,
			["Felfire Brazier"] = 401,
			["Felfire Fission"] = 401,
			["Felfire Missiles"] = 401,
			["Felfire Portal"] = 401,
			["Felfire Shock"] = 401,
			["Felfire Slam"] = 401,
			["Felfire Volley"] = 401,
			["Felfire"] = 401,
			["Fiery Brand:1344647"] = 401,
			["Fireball Barrage:135793"] = 401,
			["Fireball Barrage:135797"] = 401,
			["Fireball Barrage:135803"] = 401,
			["Firebolt:135780"] = 401,
			["Firebolt:135797"] = 401,
			["Firebolt:841220"] = 401,
			["Flame Charge:237562"] = 401,
			["Flames of Azzinoth"] = 401,
			["Flaming Core:135799"] = 401,
			["Flickering Flame:135797"] = 401,
			["Focused Blast:1117885"] = 401,
			["Foul Tempest:136135"] = 401,
			["Gather Felfire Munitions"] = 401,
			["Gift of the Martyr:841219"] = 401,
			["Glaive Blast:135797"] = 401,
			["Glob of Fel"] = 401,
			["Hellfire:841221"] = 401,
			["Ignite Felblade"] = 401,
			["Immolate:135802"] = 401,
			["Immolate:840192"] = 401,
			["Immolating Blast:135797"] = 401,
			["Immolation Aura:1305156"] = 401,
			["Immolation Aura:1344649"] = 401,
			["Immolation Aura:135799"] = 401,
			["Immolation Aura:841221"] = 401,
			["Impish Flames:135797"] = 401,
			["Incinerate:135794"] = 401,
			["Incinerate:135802"] = 401,
			["Incinerate:840198"] = 401,
			["Incinerate:841221"] = 401,
			["Incinerating Blast:135797"] = 401,
			["Infernal Burning"] = 401,
			["Infernal Smash"] = 401,
			["Infernal Tempest"] = 401,
			["Infernal Torment"] = 401,
			["Infernal"] = 401,
			["Infernal"] = 401,
			["Living Felflame"] = 401,
			["Massive Eruption:135801"] = 401,
			["Melt Flesh:135802"] = 401,
			["Molten Core:841218"] = 401,
			["Nova:135799"] = 401,
			["Overflowing Taint"] = 401,
			["Portal: Black Temple"] = 401,
			["Raging Blood:841219"] = 401,
			["Rain of Fel"] = 401,
			["Rain of Felfire"] = 401,
			["Rain of Fire:135804"] = 401,
			["Reverse Entropy"] = 401,
			["Rumbling Fissure:1118738"] = 401,
			["Sear:135799"] = 401,
			["Sear:135802"] = 401,
			["Searing Rend:1093862"] = 401,
			["Shoot Me:135797"] = 401,
			["Siege Nova:135795"] = 401,
			["Siege Nova:135799"] = 401,
			["Sigil of Flame:1344652"] = 401,
			["Soul Fire:841220"] = 401,
			["Soul Fissure:135793"] = 401,
			["Soul Fissure:135794"] = 401,
			["Spectral Sight"] = 401,
			["Summon Fel Imp"] = 401,
			["Summon Felguard"] = 401,
			["Summon Imp"] = 401,
			["Summon Infernal"] = 401,
			["Summon Overfiend"] = 401,
			["Summon Phantomflame Infernal"] = 401,
			["Summon Vilefiend"] = 401,
			["Unstable Fel Crystal"] = 401,
			["Violent Eruption:135793"] = 401,
			["Withering Felfire"] = 401,
			["Worldbreaking Stomp:1118738"] = 401,
			["Wrath Bolt"] = 401,
			["Felborne Rage"] = 401,

			--! Chaos
			["Chaos Meteor"] = 127,
			["Annihilation"] = 127,
			["Bang, Bang, Bang"] = 127,
			["Carrion Beam"] = 127,
			["Chaos Blast"] = 127,
			["Chaos Bolt"] = 127,
			["Chaos Volley"] = 127,
			["Claws of Argus"] = 127,
			["Dark Portal"] = 127,
			["Darkglare"] = 127,
			["Deomic Tyrant"] = 127,
			["Eye Beam"] = 127,
			["Fel Armament"] = 127,
			["Fel Barrage"] = 127,
			["Fel Channeling"] = 127,
			["Fel Conduit"] = 127,
			["Fel Gravity Well"] = 127,
			["Fel Rupture"] = 127,
			["Fel Spikes"] = 127,
			["Felguard"] = 127,
			["Felstorm"] = 127,
			["Gift of Argus"] = 127,
			["Hand of Arax'ath"] = 127,
			["Incineratus"] = 127,
			["Metamorphosis"] = 127,
			["Rain of Chaos"] = 127,

			--! Felstrike
			["Fel Whirlwind"] = 427,
			["Call Fel Lord"] = 427,
			["Fel Lord"] = 427,
			["Meteor Slam:1344650"] = 427,
			["Loading Cannon:133009"] = 427,
			["Overpowering Flurry:1344646"] = 427,
			["Emblazoned Swipe:135802"] = 427,
			["Demon Spikes"] = 427,
			["Demonic Trample"] = 427,
			["Glaive Tempest"] = 427,
			["Fel Slicer"] = 427,
			["Mo'arg Strike"] = 427,
			["Felstorm:236303"] = 427,
			["Felstorm:132369"] = 427,
			["Felstorm:841309"] = 427,
			["Fel Arcing Smash"] = 427,
			["Arcing Smash:132406"] = 427,
			["Fel Rush"] = 427,
			["Fel Stomp"] = 427,
			["Abyssal Smash"] = 427,
			["Blade Dance"] = 427,
			["Chaos Strike"] = 427,
			["Demonic Cleave"] = 427,
			["Devastate:136219"] = 427,
			["Doom Blade:1109118"] = 427,
			["Fel Flurry"] = 427,
			["Fel Slash"] = 427,
			["Infernal Cleave"] = 427,
			["Willbreaker:135906"] = 427,
			["War Stomp:1118738"] = 427,


			--: Holy
			-------------------------
			--! Holy
			["Blessing of Freedom"] = 2,
			["Holy Light"] = 2,
			["Light's Speed"] = 2,
			["Solar Heal"] = 2,
			["Divine Steed"] = 2,
			["Angelic Feather"] = 2,
			["Holy Smite"] = 2,
			["Blessing of K'ara"] = 2,
			["Scarlet Resurrection"] = 2,
			["Renew"] = 2,
			["Soulforged Censer"] = 2,
			["Surge of Light"] = 2,
			["Infusion of Light"] = 2,
			["Mark of Conk-quest"] = 2,
			["Selfless Healer"] = 2,
			["Blade of Wrath"] = 2,
			["Restore"] = 2,
			["Desperate Prayer"] = 2,
			["Rune of Ubbi"] = 2,
			["Rune of Healing"] = 2,
			["Aegis of Light"] = 2,
			["Gift of the Naaru"] = 2,
			["Guide Xe'ra"] = 2,
			["Holy Avenger"] = 2,
			["Seraphim"] = 2,
			["Sanity Restoration Orb"] = 2,
			["Teleport to Vindicaar"] = 2,
			["Njord's Rune of Protection"] = 2,
			["Archon's Grace"] = 2,
			["Divine Protection"] = 2,
			["Shining Light"] = 2,
			["Flash Heal"] = 2,

			--! Holy Light  ! Gold
			["The Golden Gaze"] = 200,
			["Imbuing the Light"] = 200,
			["Divine Hymn"] = 200,
			["Avenging Wrath"] = 200,
			["Archangel"] = 200,
			["Apotheosis"] = 200,
			["Avenging Crusader"] = 200,
			["Guardian of Ancient Kings"] = 200,
			["Guardian of Ancient Queens"] = 200,

			--! Holystrike  ! Flash  ! Titan
			["Shielding Words"] = 3,
			["Blessing of the Silver Crescent"] = 3,
			["Blessed Armor of the Fallen"] = 3,
			["Penetrating Insight:3136453"] = 3,
			["Pulsating Light Shield"] = 3,
			["Faithful Javelin"] = 3,
			["Faithful Javelins"] = 3,
			["Faithful Javelin Volley"] = 3,
			["Ardent Defender"] = 3,
			["Waygate Transfer"] = 3,
			["Arrow of Light"] = 3,
			["Blinding Trap"] = 3,
			["Blinding Radiance"] = 3,
			["Crescent Strike"] = 3,
			["Debilitating Beam"] = 3,
			["Devoted Strike"] = 3,
			["Flash Bang"] = 3,
			["Judgment"] = 3,
			["Light Impalement"] = 3,
			["Valiant Strike"] = 3,
			["Blinding Faith"] = 3,
			["Stellar Pylon:253400"] = 3,

			--! Holy Fire  ! Solar
			["Flame Reborn"] = 6,
			["Nature's Wrath:535045"] = 6,
			["Excite:574795"] = 6,
			["Blaze of Glory:574795"] = 6,
			["Golden Bolt"] = 6,
			["Solar Shower"] = 6,
			["Solar Healing Nova"] = 6,
			["Might of the Sun"] = 6,
			["Blessing of Dawn"] = 6,
			["Cleansing Flame"] = 6,
			["Consecrate"] = 6,
			["Consecration"] = 6,
			["Eclipse (Solar)"] = 6,
			["Holy Fire"] = 6,
			["Inert Flames"] = 6,
			["Purge the Wicked"] = 6,
			["Righteous Fury"] = 6,
			["Searing Wrath"] = 6,
			["Shield of Vengeance"] = 6,
			["Solar Empowerment"] = 6,
			["Solar Eruption"] = 6,
			["Solar Radiance"] = 6,
			["Solar Chakram"] = 6,
			["Sun Strike"] = 6,
			["Solar Wrath"] = 6,
			["Solar Zone"] = 6,
			["Solar Beam"] = 6,
			["Solar Burst"] = 6,
			["Stellar Emission:1360763"] = 6,
			["Sun Bolt"] = 6,
			["Sunfire"] = 6,
			["Wrath"] = 6,
			["Summon Solar Orb"] = 6,
			["Solar Orb"] = 6,

			--! Ethereal  ! Kyrian
			["Popo's Potion"] = 201,
			["Newfound Resolve"] = 201,
			["Purifying Blast:3528286"] = 201,
			["Centurion Blast:3528286"] = 201,
			["Anima Farshot"] = 201,
			["Anima Field:3536198"] = 201,
			["Resonating Arrow"] = 201,
			["Vesper Totem"] = 201,
			["Weapons of Order"] = 201,
			["Spear of Bastion"] = 201,
			["Lone Protection"] = 201,
			["Lone Empowerment"] = 201,
			["Lone Meditation"] = 201,
			["Kindred Protection"] = 201,
			["Kindred Empowerment"] = 201,
			["Kindred Meditation"] = 201,
			["Kindred Spirits"] = 201,
			["Radiant Spark"] = 201,
			["Blessing of the Archon"] = 201,
			["Unleash:3528289"] = 201,
			["Swift Recollection"] = 201,
			["Prescient Recollection"] = 201,
			["Armored Recollection"] = 201,
			["Test of Faith:3528286"] = 201,
			["Charged Attacks:3528283"] = 201,
			["Instructor's Divine Bell"] = 201,
			["Whirling Blades:1016243"] = 201,
			["Agathian Spear"] = 201,
			["Anima Barrage:1041233"] = 201,
			["Anima Barrage:135787"] = 201,
			["Anima Barrage:3565443"] = 201,
			["Anima Breath:1029007"] = 201,
			["Anima Charge:3528288"] = 201,
			["Anima Expulsion:3528286"] = 201,
			["Anima Flash:3528287"] = 201,
			["Anima Infusion:1041231"] = 201,
			["Anima Spit:3528286"] = 201,
			["Archonic Resonator"] = 201,
			["Blessing of Dusk"] = 201,
			["Boon of the Ascended"] = 201,
			["Charged Anima Blast:3528282"] = 201,
			["Charged Blast:3528286"] = 201,
			["Charged Fists:3528283"] = 201,
			["Combat Meditation"] = 201,
			["Construct Bomb:3528287"] = 201,
			["Crackdown:237589"] = 201,
			["Drain Anima:3528283"] = 201,
			["Drain Anima:3528284"] = 201,
			["Echoing Reprimand"] = 201,
			["Eternal Traveler's Hearthstone"] = 201,
			["Exoneration:3528286"] = 201,
			["Extracting Histories:1029583"] = 201,
			["Forsworn Doctrine"] = 201,
			["Guardian Spirit"] = 201,
			["Hurl Kyrian Hammer"] = 201,
			["Introspection"] = 201,
			["Korinna's Release"] = 201,
			["Kyrian Glory"] = 201,
			["Kyrian Hearthstone"] = 201,
			["Lyre of Sacred Purpose"] = 201,
			["Mend Anima"] = 201,
			["Purifying Spew"] = 201,
			["Rapture"] = 201,
			["Recharge Anima:237030"] = 201,
			["Recharge Anima:3528283"] = 201,
			["Recharge Anima:3528287"] = 201,
			["Rescue Soul:3528279"] = 201,
			["Siphon Spirit:3528284"] = 201,
			["Smash:3528285"] = 201,
			["Spirit of Redemption"] = 201,
			["Steal Memories:3528284"] = 201,
			["Strength of Many"] = 201,
			["Toxic Pride:3528282"] = 201,
			["Unburden:132864"] = 201,
			["Unleashed Anima:3446309"] = 201,
			["Unleashed Anima:3528287"] = 201,
			["Valiant Shield:135911"] = 201,
			["Xandria's Wrath"] = 201,

			--! Ethereal Flame
			["Detonate:3528287"] = 600,
			["Crackling Anima"] = 600,
			["Tarecgosa's Visage"] = 600,
			["Fervent Barrage"] = 600,
			["Azure Storm"] = 600,
			["EXPLODE!:3528287"] = 600,
			["Flames of Courage"] = 600,
			["Forge Fire:135782"] = 600,
			["Forgeflame:135782"] = 600,
			["Furious Strike:236257"] = 600,
			["Goliath Bulwark:3079436"] = 600,
			["Rain of Wisdom:135787"] = 600,
			["Valiant Bolt"] = 600,
			["Valiant Flame"] = 600,

			--! Discipline  ! Bandage  ! Brewing  ! Inscription
			["Waking"] = 202,
			["Unbinding"] = 202,
			["Aiding"] = 202,
			["Toss Stewards"] = 202,
			["Helping"] = 202,
			["Bandage"] = 202,
			["Drunken Haze"] = 202,
			["Blood Shield"] = 202,
			["Keg Smash"] = 202,
			["Celestial Brew"] = 202,
			["Serve Tea"] = 202,
			["Reading"] = 202,
			["Freeing Critter"] = 202,
			["Scripture of Elune"] = 202,
			["Dampen Harm"] = 202,
			["Flight"] = 202,
			["Essence of the Martyr"] = 202,
			["Rouse Trader"] = 202,
			["Scales of Trauma"] = 202,
			["Releasing"] = 202,
			["Dizzy"] = 202,
			["Wandering Keg"] = 202,
			["Mixing Pigment"] = 202,
			["Mixing Pigments"] = 202,
			["Dismiss Pet"] = 202,
			["Safe Fall"] = 202,
			["Rescue"] = 202,
			["Administer Antidote"] = 202,
			["Administering Antidote"] = 202,
			["Apply Salve"] = 202,
			["Bandaging"] = 202,
			["Brewfest Reveler's Hearthstone"] = 202,
			["Calming"] = 202,
			["Coax"] = 202,
			["Comforting"] = 202,
			["Dampen Harm"] = 202,
			["Dispel"] = 202,
			["Dispelling"] = 202,
			["First Aid"] = 202,
			["First Avenger"] = 202,
			["Focused Will"] = 202,
			["Freeing"] = 202,
			["Gently Lifting"] = 202,
			["Guard"] = 202,
			["Ignore Pain"] = 202,
			["Jump to Skyhold"] = 202,
			["Last Stand"] = 202,
			["Levitate"] = 202,
			["Luminous Barrier"] = 202,
			["Mass Dispel"] = 202,
			["Mend Pet"] = 202,
			["Mending Bandage"] = 202,
			["Mending Wounds"] = 202,
			["Penance"] = 202,
			["Power Word: Barrier"] = 202,
			["Power Word: Shield"] = 202,
			["Purifying"] = 202,
			["Rescuing"] = 202,
			["Resuscitating"] = 202,
			["Rousing"] = 202,
			["Sanctum"] = 202,
			["Saving"] = 202,
			["Secret Infusion"] = 202,
			["Shell Shield"] = 202,
			["Shield of the Righteous"] = 202,
			["Slow Fall"] = 202,
			["Soothing"] = 202,
			["Unspoken Gratitude"] = 202,

			--! Hyperlight  ! Hallow  ! Broker
			["Steal Essence:636333"] = 203,
			["Focused Annihilation"] = 203,
			["Summon Condemned"] = 203,
			["\"Borrowed\" Power"] = 203,
			["Activate Empowerment:4005160"] = 203,
			["Anima Extrapolation:3675491"] = 203,
			["Anima Nova:3528303"] = 203,
			["Annihilate:2101973"] = 203,
			["Attendant's Pocket Portal: Ardenweald"] = 203,
			["Attendant's Pocket Portal: Bastion"] = 203,
			["Attendant's Pocket Portal: Maldraxxus"] = 203,
			["Attendant's Pocket Portal: Oribos"] = 203,
			["Attendant's Pocket Portal: Revendreth"] = 203,
			["Convocation of Pain"] = 203,
			["Cypher of Obfuscation"] = 203,
			["Cypher of Relocation"] = 203,
			["Death Wave:1778230"] = 203,
			["Desintegration Wave"] = 203,
			["Dimensional Tear:526520"] = 203,
			["Discordant Barrage"] = 203,
			["Edge of Annihilation:2101973"] = 203,
			["Fallen Priest's Blessing"] = 203,
			["Focused Conduit:4037119"] = 203,
			["Glyph of Assimilation"] = 203,
			["Glyph of Destruction:236219"] = 203,
			["Hyperlight Backhand"] = 203,
			["Hyperlight Beam"] = 203,
			["Hyperlight Bolt"] = 203,
			["Hyperlight Bomb"] = 203,
			["Hyperlight Containment Cell"] = 203,
			["Hyperlight Eruption"] = 203,
			["Hyperlight Jolt"] = 203,
			["Hyperlight Nova"] = 203,
			["Hyperlight Salvo"] = 203,
			["Hyperlight Spark"] = 203,
			["Lantern of Force"] = 203,
			["Releasing Souls"] = 203,
			["Rescue Soul"] = 203,
			["Rift Blast:3528282"] = 203,
			["Soul Blast"] = 203,
			["Soul Bolt Volley"] = 203,
			["Soul Bolt"] = 203,
			["Soul Jaunt"] = 203,
			["Soul Prison"] = 203,
			["Soul Shot"] = 203,
			["Soul Volley"] = 203,
			["Soulsmash:237526"] = 203,
			["Soulstorm:4067362"] = 203,
			["Spectral Smite"] = 203,
			["Stygian Storm"] = 203,
			["Tachyon Jump"] = 203,
			["Tal'Galan's Trial"] = 203,
			["Unleashed Soulstorm:4067362"] = 203,

			--! Holyfrost
			-- 18

			--! Azerite
			["Puryfying Blast:2967103"] = 204,
			["Puryfying Blast:1408832"] = 204,
			["Empowering the Heart"] = 204,
			["Absorbing Azerite"] = 204,
			["Ancient Awakening"] = 204,
			["Artifice of Time"] = 204,
			["Azerite Barrage"] = 204,
			["Azerite Blast"] = 204,
			["Azerite Effusion"] = 204,
			["Azerite Empowered"] = 204,
			["Azerite Energy"] = 204,
			["Azerite Explosion"] = 204,
			["Azerite Expulsion"] = 204,
			["Azerite Grenade"] = 204,
			["Azerite Infusion"] = 800,
			["Azerite Potion"] = 204,
			["Azerite Shards"] = 204,
			["Azerite Smash"] = 204,
			["Blood of the Enemy"] = 204,
			["Breath of Everlasting Spirit"] = 204,
			["Breath of the Dying"] = 204,
			["Concentrated Flame"] = 204,
			["Condensed Life-Force"] = 204,
			["Conflict and Strife"] = 204,
			["Empower Heart of Azeroth"] = 204,
			["Empower Heart"] = 204,
			["Essence of the Focusing Iris"] = 204,
			["Guardian of Azeroth"] = 204,
			["Heart of Azeroth"] = 204,
			["Life-Binder's Invocation"] = 204,
			["Memory of Lucid Dreams"] = 204,
			["Purification Protocol"] = 204,
			["Reaping Flames"] = 204,
			["Resonant Burst"] = 204,
			["Resonant Cascade"] = 204,
			["Resonant Pulse"] = 204,
			["Ripple in Space"] = 204,
			["Spark of Inspiration"] = 204,
			["Sparks of Unwavering Strength"] = 204,
			["Spirit of Preservation"] = 204,
			["Strength of the Warden"] = 204,
			["The Crucible of Flame"] = 204,
			["The Ever-Rising Tide"] = 204,
			["The Formless Void"] = 204,
			["The Unbound Force"] = 204,
			["The Well of Existance"] = 204,
			["Touch of the Everlasting"] = 204,
			["Unleash Heart of Azeroth"] = 204,
			["Unwavering Ward"] = 204,
			["Vision of Perfection"] = 204,
			["Vitality Conduit"] = 204,
			["Worldvein Resonance"] = 204,


			--: Divine
			-------------------------
			--! Divine  ! Chi-Ji
			["Crumbling Aegis"] = 66,
			["Chi-Ji"] = 66,
			["Chi-Ji, the Red Crane"] = 66,
			["Invoke Chi-Ji, the Red Crane"] = 66,
			["Divine Purpose"] = 66,
			["Divine Shield"] = 66,
			["Play Fae Drum"] = 66,
			["Play Fae Harp"] = 66,
			["Ray of Hope"] = 66,
			["Blessing of Spellwarding"] = 66,

			--! Legendary
			["Draconic Descent"] = 660,
			["Draconic Empowerment"] = 660,
			["Empower Ashjra'kamas"] = 660,
			["Gift of the Titans"] = 660,
			["Master Assassin's Mark"] = 660,
			["Steadfast Resolve"] = 660,

			--! Love
			["Mass Temptation"] = 661,
			["Temptation"] = 661,
			["Seduction"] = 661,
			["Tame Beast"] = 661,
			["Ball!"] = 661,
			["Peddlefeet's Lovely Hearthstone"] = 661,
			["Petting"] = 661,
			["Rainbow Generator"] = 661,


			--: Frost
			-------------------------
			--! Frost
			["Frozen Sweep"] = 16,
			["Unstable Frost"] = 16,
			["Icy Shard"] = 16,
			["Glacial Spike"] = 16,
			["Frostbolt"] = 16,
			["Freezing Blast"] = 16,
			["Blizzard"] = 16,
			["Frozen Rain"] = 16,
			["Elemental Blast: Mastery"] = 16,
			["Frostflurry"] = 16,
			["Greatfather Winter's Hearthstone"] = 16,
			["Path of Frost"] = 16,
			["Icy Veins"] = 16,

			--! Ice  ! Snow
			["Ring of Frost"] = 160,
			["Snowball"] = 160,
			["Ice Fall"] = 160,
			["Ice Form"] = 160,
			["Icefury"] = 160,
			["Frozen Orb"] = 160,
			["Ice Barrier"] = 160,
			["Icy Grip"] = 160,
			["Ice Wall"] = 160,
			["Ice Shard"] = 160,
			["Fingers of Frost"] = 160,
			["Ice Floes"] = 160,
			["Ice Lance"] = 160,
			["Icicles"] = 160,

			--! Froststrike
			["Bitter Slash"] = 17,
			["Hurl Boulder:429385"] = 17,
			["Froststrike"] = 17,
			["Killing Machine"] = 17,
			["Belch Frost"] = 17,
			["Big Blue Fist"] = 17,
			["Brain Freeze"] = 17,
			["Frost Strike"] = 17,
			["Ice Block"] = 17,
			["Icebound Fortitude"] = 17,
			["Icestrand Web"] = 17,

			--! Froststorm
			["Wardstone Activation"] = 24,
			["Typhoon:135861"] = 24,
			["Piercing Rain"] = 24,
			["Remorseless Winter"] = 24,
			["Chilling Winds"] = 24,
			["Glacial Winds"] = 24,
			["Freezing Storm"] = 24,
			["Frost Fever"] = 24,
			["Freezing Winds"] = 24,
			["Cry of Wrath"] = 24,
			["Freezing Rain"] = 24,
			["Froststorm Breath"] = 24,

			--! Spellfrost
			["Frost Armor"] = 80,
			["Crystal Eruption:132783"] = 80,
			["Crystal Growth:132783"] = 80,
			["Crystalline Dust:135776"] = 80,
			["Crystalline Ground:132779"] = 80,
			["Pillar of Frost"] = 80,


			--: Elemental
			-------------------------
			--! Elemental
			["Maelstrom-Powered Elemental Blast"] = 28,
			["Ascendance"] = 28,
			["Elemental Blast"] = 28,
			["Storm, Earth, and Fire"] = 28,

			--! Natural  ! Spiritual
			["Spirit Link Totem"] = 280,
			["Healing Ward"] = 280,
			["Spirit Mend"] = 280,
			["Ancestral Spirit"] = 280,
			["Ancestral Vision"] = 280,
			["Master of the Elements"] = 280,
			["Spiritwalker's Grace"] = 280,

			--! Chemical  ! Alchemy
			["Gaseous Bubbles"] = 281,
			["Rejuvenating Serum"] = 281,
			["Healing Balm"] = 281,
			["Alchemy"] = 281,
			
			
			--: Nature
			-------------------------
			--! Nature  ! Herbalism
			["Germinate Arborblade"] = 8,
			["Entanglement"] = 8,
			["Bramble Patch"] = 8,
			["Regurgitate"] = 8,
			["Regeneration:1850550"] = 8,
			["Regeneration:136077"] = 8,
			["Induce Regeneration:136077"] = 8,
			["Wrath:136006"] = 8,
			["Pick Flower"] = 8,
			["Feed Young:134437"] = 8,
			["Regeneratin'"] = 8,
			["Leafstorm"] = 8,
			["Overgrowth"] = 8,
			["Frenzied Regeneration"] = 8,
			["Astral Recall"] = 8,
			["Gather Pollen"] = 8,
			["Seeds of Sorrow"] = 8,
			["Bounding Spores"] = 8,
			["Aspect of the Wild"] = 8,
			["Force of Nature"] = 8,
			["Hearth to Faol's Rest"] = 8,
			["Hearthstone"] = 8,
			["Herb Gathering"] = 8,
			["Forage"] = 8,
			["Leaf Blast"] = 8,
			["Mountebank's Colorful Cloak"] = 8,
			["Noble Gardener's Hearthstone"] = 8,
			["One with Nature"] = 8,
			["Serpentine Cleansing"] = 8,
			["The Innkeeper's Daughter"] = 8,
			["Survival of the Fittest"] = 8,

			--! Naturestrike  ! Web  ! Milling
			["Hibernate"] = 900,
			["Deep Slumber"] = 900,
			["Give Silk"] = 900,
			["Lashing Flurry:134218"] = 900,
			["Spider Swarm"] = 900,
			["Blinding Webs"] = 900,
			["Vile Webbing"] = 900,
			["Briarskin"] = 900,
			["Leeching Bite"] = 900,
			["Bag of Snakes"] = 900,
			["Dire Beast"] = 900,
			["Hurl Seed"] = 900,
			["Shell Shield"] = 900,
			["Scale Shield"] = 900,
			["Razor Spin"] = 900,
			["Web Strand"] = 900,
			["Summon Spiderlings"] = 900,
			["Barbed Lunge"] = 900,
			["Milling"] = 900,
			["Barkskin"] = 900,
			["Ironbark"] = 900,
			["Dance of Thorns"] = 900,
			["Web"] = 900,
			["Webspinner Song"] = 900,
			["Dancing Thorns"] = 900,
			["Aspect of the Turtle"] = 900,
			["Camouflage"] = 900,
			["Iron Bark"] = 900,
			["Quill Barb"] = 900,
			["Smash:1390637"] = 900,
			["Thorns"] = 900,
			["Throw Brambles"] = 900,

			--! Life  ! Wild
			["Genesis"] = 10,
			["Rebirth"] = 10,
			["Dreamwalk"] = 10,
			["Cenarion Ward"] = 10,
			["Efflorescence"] = 10,
			["Tranquility"] = 10,
			["Grow Tree"] = 10,
			["Rejuvenating Wind"] = 10,

			--! Fey  ! Night Fae
			["Eyes of Elune"] = 805,
			["Convocation of Elune"] = 805,
			["Nightfire"] = 805,
			["Elune's Wrath"] = 805,
			["Bewildering Slam"] = 805,
			["Bewildering Pollen"] = 805,
			["Fae Transfusion"] = 805,
			["Guessing Game"] = 805,
			["Dodge Ball:132387"] = 805,
			["Wrathful Faerie"] = 805,
			["Guardian Faerie"] = 805,
			["Benevolent Faerie"] = 805,
			["Fae Guardian"] = 805,
			["Fae Guardians"] = 805,
			["Ancient Aftershock"] = 805,
			["The Hunt"] = 805,
			["Fury of Elune"] = 805,
			["Shifting Power"] = 805,
			["Faerie Fire"] = 805,
			["Radiant Breath:3528278"] = 805,
			["Bounding Duskshroom"] = 805,
			["Convoke the Spirits"] = 805,
			["Dirge of the Fallen Sanctum"] = 805,
			["Dragon Plume"] = 805,
			["Dreaming Charge"] = 805,
			["Elder Charge"] = 805,
			["Eradication Seeds:1282282"] = 805,
			["Faerie's Blessing"] = 805,
			["Faerie's Whisper"] = 805,
			["Gift of Ardenweald"] = 805,
			["Gorging Leap:1506795"] = 805,
			["Let's Play Catch!"] = 805,
			["Night Fae Hearthstone"] = 805,
			["Ardenweald Hearthstone"] = 805,
			["Seeds of Extinction:3575389"] = 805,
			["Seeds of Extinction:3636841"] = 805,
			["Sepsis"] = 805,
			["Sepsis"] = 805,
			["Shimmering Transformation"] = 805,
			["Snarling Blast"] = 805,
			["Soulshape"] = 805,
			["Soulshape"] = 805,
			["Tears of the Forest"] = 805,
			["Wake Zayhad"] = 805,
			["Wakener's Frond"] = 805,
			["Whimsy Eruption"] = 805,
			["Wild Spirits"] = 805,
			["Wish"] = 805,
			["Wisp Bond"] = 805,


			--: Poison
			-------------------------
			--! Poison  ! Venom  ! Slime
			["Volatile Burst:136182"] = 806,
			["Volatile Burst:136030"] = 806,
			["Turbulent Juice"] = 806,
			["Abrasive Slime"] = 806,
			["Acid Spit"] = 806,
			["Acid Spray"] = 806,
			["Acid"] = 806,
			["Acidic Injection"] = 806,
			["Acidic Spit"] = 806,
			["Acidic Spittle"] = 806,
			["Belch Slime"] = 806,
			["Blight Bomb"] = 806,
			["Blighted Arrow"] = 806,
			["Blighted Lick"] = 806,
			["Blow Dart"] = 806,
			["Brinescale Venom"] = 806,
			["Bursting Toxin"] = 806,
			["Caustic Liquid"] = 806,
			["Caustic Orb"] = 806,
			["Concentrated Venom"] = 806,
			["Corrosive Breath"] = 806,
			["Corrupted Healing Totem"] = 806,
			["Crippling Poison"] = 806,
			["Deadly Poison"] = 806,
			["Death Venom"] = 806,
			["Debilitating Vial"] = 806,
			["Dissolving Bolt"] = 806,
			["Ebon Scourge"] = 806,
			["Fatal Sting"] = 806,
			["Grim Venom"] = 806,
			["Instant Poison"] = 806,
			["Luciferase"] = 806,
			["Melt Flesh:132108"] = 806,
			["Mind-Numbing Extract"] = 806,
			["Mischievous Blast"] = 806,
			["Necrotic Burst"] = 806,
			["Noxious Eruption"] = 806,
			["Noxious Fumes"] = 806,
			["Noxious Mixture"] = 806,
			["Numbing Poison"] = 806,
			["Ogron Be-Gone"] = 806,
			["Oozing Slime"] = 806,
			["Parabolic Excrement"] = 806,
			["Plague in a Jar"] = 806,
			["Poison Barrage"] = 806,
			["Poison Bolt"] = 806,
			["Poison Bomb"] = 806,
			["Poison Claws"] = 806,
			["Poison Dart"] = 806,
			["Poison Nova"] = 806,
			["Poison Spit"] = 806,
			["Poison Spray"] = 806,
			["Poison Squirt"] = 806,
			["Poison Sting"] = 806,
			["Poison Vial"] = 806,
			["Poison Weapon"] = 806,
			["Poison"] = 806,
			["Poisoned Bite"] = 806,
			["Retched Acid"] = 806,
			["Serpent Sting"] = 806,
			["Shiver Venom"] = 806,
			["Slime Injection"] = 806,
			["Slimy Coating"] = 806,
			["Snail Slime"] = 806,
			["Sneezing Fit"] = 806,
			["Spear of Anguish"] = 806,
			["Sting"] = 806,
			["Stoneblood Bolt"] = 806,
			["Stoneblood Embrace"] = 806,
			["Stoneblood Geyser"] = 806,
			["Toxic Blades"] = 806,
			["Toxic Breath"] = 806,
			["Toxic Fumes"] = 806,
			["Toxic Mist"] = 806,
			["Toxic Spit"] = 806,
			["Toxic Volley"] = 806,
			["Venom Bolt"] = 806,
			["Venom Spit"] = 806,
			["Venom Splash"] = 806,
			["Venom"] = 806,
			["Venomous Bite"] = 806,
			["Venomous Fangs"] = 806,
			["Venomous Shot"] = 806,
			["Vile Impact"] = 806,
			["Vile Sting"] = 806,
			["Virulent Burrow"] = 806,
			["Virulent Gasp"] = 806,
			["Volatile Acid"] = 806,
			["Whimsy Barb"] = 806,
			["Worm Bile"] = 806,
			["Wound Poison"] = 806,

			--! Poisonstrike
			["Poisoning Strike"] = 906,
			["Poisonous Claws"] = 906,
			["Barbed Assault"] = 906,
			["Venom-Laced Web"] = 906,
			["Triple Bite:463493"] = 906,
			["Triple Bite:136067"] = 906,
			["Rampage:463493"] = 906,
			["Bile Strike"] = 906,
			["Envenom"] = 906,
			["Shiv"] = 906,
			["Toxic Whirl"] = 906,
			["Stoneblood Swoop"] = 906,


			--: Air
			-------------------------
			--! Wind  ! Air
			["Flap Wings"] = 811,
			["Gale Slash"] = 811,
			["Wing Buffet"] = 811,
			["Windburst"] = 811,
			["Four Winds"] = 811,
			["Windwall"] = 811,
			["Wing Buffet"] = 811,
			["Dire Beast: Hawk"] = 811,
			["Hawk"] = 811,
			["Summon Air Elemental"] = 811,
			["Whirling Axe"] = 811,
			["Windfury Totem"] = 811,
			["Blinding Wind"] = 811,
			["Umbral Blast:1029595"] = 811,
			["Flight Master's Whistle"] = 811,
			["Flurry of Feathers"] = 811,
			["Air Blast"] = 811,
			["Aspect of the Eagle"] = 811,
			["Aviana's Blessing"] = 10,
			["Azurethos' Fury"] = 811,
			["Blow Bubble"] = 811,
			["Burst of Air"] = 811,
			["Call the Skyhorn"] = 811,
			["Choosing Pa'ku"] = 811,
			["Colossal Blowback"] = 811,
			["Embrace of Pa'ku"] = 811,
			["Farseer's Raging Tempest"] = 811,
			["Feather Burst"] = 811,
			["Flap"] = 811,
			["Gale Force"] = 811,
			["Gale Winds"] = 811,
			["Gust"] = 811,
			["Gust of Wind"] = 811,
			["Nimbus Bolt"] = 811,
			["Quills"] = 811,
			["Ritual of Winds"] = 811,
			["Water Walking"] = 811,
			["Wind Blast"] = 811,
			["Wind Burst"] = 811,
			["Wind Gust"] = 811,
			["Wing Beat"] = 811,
			["Wing Blast"] = 811,
			["Wing Buffet"] = 811,
			["Windwall"] = 811,
			["Wind Rush"] = 811,
			["Swooping Lunge"] = 811,

			--! Storm
			["Wild Tornado"] = 911,
			["Tornado"] = 911,
			["Dervish"] = 911,
			["Dark Lightning:252174"] = 911,
			["Shockbitten"] = 911,
			["Highborne Compendium of Storms"] = 911,
			["Beckon Storm"] = 911,
			["Cyclone"] = 911,
			["Eye of the Storm"] = 911,
			["Gathering Storms"] = 911,
			["Horrific Vortex"] = 911,
			["Localized Windstorm"] = 911,
			["Lorenado"] = 911,
			["Plume Typhoon"] = 911,
			["Raging Storms"] = 911,
			["Storm Cloud"] = 911,
			["Storm Elemental"] = 911,
			["Greater Storm Elemental"] = 911,
			["Primal Storm Elemental"] = 911,
			["Storm"] = 911,
			["Stormclouds"] = 911,
			["Wind Rush Totem"] = 911,
			["Windrush"] = 911,
			["Localized Storm"] = 911,

			--! Lightning  ! Thunder  ! Electric
			["Electric Shock"] = 800,
			["Sashj'tar Blast"] = 800,
			["Stormbringer"] = 800,
			["Lizard Bolt"] = 800,
			["Channel Lightning"] = 800,
			["Nimbus Bolt:136048"] = 800,
			["Polarization"] = 800,
			["Thundercharge"] = 800,
			["Conducted Shock Pulse"] = 800,
			["Corruption Shock"] = 800,
			["Electrostatic Charge"] = 800,
			["Interrupting Jolt"] = 800,
			["Thundering Shock"] = 800,
			["Lightning Burst"] = 800,
			["Lightning Lash"] = 800,
			["Diviner's Signal:237587"] = 800,
			["Capacitor Discharge"] = 800,
			["Anti-Personnel Squirrel"] = 800,
			["Blossom Blast"] = 800,
			["Giga-Zap"] = 800,
			["Pulse Blast"] = 800,
			["Self-Destruct:1041235"] = 800,
			["Charged Coil"] = 800,
			["Giga-Wallop"] = 800,
			["Short Out"] = 800,
			["Arcing Zap"] = 800,
			["Ring of Thunder"] = 800,
			["Raging Tempest"] = 800,
			["Thunderbolt"] = 800,
			["Welding Beam"] = 800,
			["Arc Bolt"] = 800,
			["Zap"] = 800,
			["Shocking Squall"] = 800,
			["Arc Lightning"] = 800,
			["Power Stomp:2065583"] = 800,
			["Charged Fists:839974"] = 800,
			["Chaotic Tempest"] = 800,
			["Arc Lightning"] = 800,
			["Ball Lightning"] = 800,
			["Bioelectric Blast"] = 800,
			["Call Lightning"] = 800,
			["Call the Storm"] = 800,
			["Call Thunder"] = 800,
			["Chain Lightning"] = 800,
			["Charged Bolt"] = 800,
			["Charged Claw"] = 800,
			["Crackling Lightning"] = 800,
			["Crackling Tempest"] = 800,
			["Crash Lightning"] = 800,
			["Electric Discharge"] = 800,
			["Electrified Chakram"] = 800,
			["Elemental Blast: Haste"] = 800,
			["Energy Shield"] = 800,
			["Focused Lightning"] = 800,
			["Forked Lightning"] = 800,
			["Jolt"] = 800,
			["Lightning Blast"] = 800,
			["Lightning Bolt"] = 800,
			["Lightning Breath"] = 800,
			["Lightning Cloud"] = 800,
			["Lightning Discharge"] = 800,
			["Lightning Lasso"] = 800,
			["Lightning Nova"] = 800,
			["Lightning Spit"] = 800,
			["Overcharge"] = 800,
			["Rune of the Storm"] = 800,
			["Runic Focus:136057"] = 800,
			["Runic Lightning"] = 800,
			["Shock Burst"] = 800,
			["Shocking Breath"] = 800,
			["Shocking Claw"] = 800,
			["Slicing Maelstrom"] = 800,
			["Sparkbolt Volley"] = 800,
			["Static Bolt"] = 800,
			["Static Bolts"] = 800,
			["Static Charge"] = 800,
			["Static Maelstrom"] = 800,
			["Static Nova"] = 800,
			["Static Pulse"] = 800,
			["Storm Nova"] = 800,
			["Stormborn"] = 800,
			["Stormkeeper"] = 800,
			["Thorim's Bolt"] = 800,
			["Thunder Focus Tea"] = 800,
			["Thunder's Call"] = 800,
			["Thunderstorm"] = 800,
			["Wrath of Lei Shen"] = 800,
			["Zot!"] = 800,

			--! Stormstrike
			["Crashing Storm"] = 9,
			["Stormhammer"] = 9,
			["Thundering Rush"] = 9,
			["Focused Assault:294033"] = 9,
			["Throw Totem"] = 9,
			["Thundering Stomp"] = 9,
			["Dragon Stomp"] = 9,
			["Lightning Nova Totem"] = 9,
			["Smelt Rune"] = 9,
			["Stormstrike"] = 9,
			["Thunder Spear"] = 9,
			["Tornado Kick"] = 9,


			--: Water
			-------------------------
			--! Water  ! Sea  ! Fishing
			["Watery Splash"] = 801,
			["Summon Water Elemental"] = 801,
			["Wild Charge:136148"] = 801,
			["Rapid Tides"] = 801,
			["Revitalizing Waters"] = 801,
			["Healing Waters"] = 801,
			["Spawn Waterlings"] = 801,
			["Pull of the Tides"] = 801,
			["Touch of the Drowned"] = 801,
			["Restorative Waters"] = 801,
			["Undulating Tides"] = 801,
			["Tidal Wave"] = 801,
			["Tidal Flurry"] = 801,
			["Untaintable Waters"] = 801,
			["Aqua Spout"] = 801,
			["Bathing"] = 801,
			["Beckon Storm:135861"] = 801,
			["Bubble Shield"] = 801,
			["Bubblebeam"] = 801,
			["Call the Rivermane"] = 801,
			["Capsize"] = 801,
			["Captive Tides"] = 801,
			["Chain Heal"] = 801,
			["Corrupting Waters"] = 801,
			["Crashing Wave"] = 801,
			["Deep Waters"] = 801,
			["Deluge"] = 801,
			["Downpour"] = 801,
			["Empower Spawning Pool"] = 801,
			["Extinguish Fire"] = 801,
			["Fishing"] = 801,
			["Healing Rain"] = 801,
			["Healing Stream Totem"] = 801,
			["Healing Surge"] = 801,
			["Healing Tide Totem"] = 801,
			["Healing Wave"] = 801,
			["Massive Deluge"] = 801,
			["Rejuvenating Water"] = 801,
			["Rejuvenating Waters"] = 801,
			["Splash"] = 801,
			["Spray Water"] = 801,
			["Tidal Armor"] = 801,
			["Tidal Fury"] = 801,
			["Tidal Waves"] = 801,
			["Torrent"] = 801,
			["Undertow"] = 801,
			["Undulation"] = 801,
			["Water Blast"] = 801,
			["Water Bolt"] = 801,
			["Water Breathing"] = 801,
			["Water Jet"] = 801,
			["Watersight"] = 801,
			["Wave Crash"] = 801,
			["Wave Crush"] = 801,
			["Wellspring"] = 801,
			["Whirlpool"] = 801,

			--! Waterstrike
			["Drowning Smash"] = 901,
			["Empowered Drowning Smash"] = 901,
			["Anchor Drag"] = 901,
			["Throw Anchor"] = 901,
			["Call Reinforcements:236422"] = 901,
			["Call Reinforcements:298644"] = 901,
			["Choking Stream"] = 901,
			["Fishy Strike"] = 901,
			["March of the Murlocs"] = 901,
			["Massive Crash:893778"] = 901,
			["Tidal Spear"] = 901,
			["Tide Crush"] = 901,

			--! Mist
			["Soothing Breath"] = 802,
			["Dance of Chi-Ji"] = 802,
			["Summon Cloud Serpent"] = 802,
			["Call of the Mists"] = 802,
			["Enveloping Breath"] = 802,
			["Enveloping Mist"] = 802,
			["Essence Font"] = 802,
			["Fumarole"] = 802,
			["Life Cocoon"] = 802,
			["Reawaken"] = 802,
			["Renewing Mist"] = 802,
			["Resuscitate"] = 802,
			["Soothing Mist"] = 802,
			["Surging Mist"] = 802,
			["Vivify"] = 802,

			--! Jade  ! Yu'lon
			["Jade Crystal Fragment"] = 902,
			["Jade Serpent Statue"] = 902,
			["Summon Jade Serpent Statue"] = 902,
			["Whirling Dragon Punch"] = 902,
			["Yu'lon"] = 902,
			["Yu'lon, the Jade Serpent"] = 902,
			["Invoke Yu'lon, the Jade Serpent"] = 902,

			--! Jade Lightning
			["Alpha Tiger"] = 807,
			["Chi Torpedo"] = 807,
			["Flying Serpent Kick"] = 807,
			["Crackling Jade Lightning"] = 807,
			["Jade Fire"] = 807,
			["Living Firebolt"] = 807,
			["Refreshing Jade Wind"] = 807,
			["Rushing Jade Wind"] = 807,
			["Spinning Crane Kick"] = 807,
			["Transcendance"] = 807,
			["Transcendance: Transfer"] = 807,
			["Zen Healing"] = 807,
			["Zen Meditation"] = 807,
			["Zen Pilgrimage"] = 807,
			["Serenity"] = 807,

			--! Chi  ! Xuen
			["Zen Travel"] = 907,
			["Xuen, the White Tiger"] = 907,
			["Xuen"] = 907,
			["Invoke Xuen, the White Tiger"] = 907,
			["Focused Chi Burst"] = 907,
			["Blackout Kick!"] = 907,
			["Touch of Karma"] = 907,
			["Invoke Xuen"] = 907,
			["Chi Burst"] = 907,
			["Fists of Fury"] = 907,
			["Meditating"] = 907,


			--: Earth
			-------------------------
			--! Earth  ! Mud
			["Digging"] = 803,
			["Meteoric Earthspire"] = 803,
			["Pulverizing Meteor:2101174"] = 803,
			["Earth Rumble"] = 803,
			["Rupture Line"] = 803,
			["Sling Mud"] = 803,
			["Slag Smash"] = 803,
			["Shatter Earth"] = 803,
			["Earth Crush"] = 803,
			["Wallow"] = 803,
			["Tunnel"] = 803,
			["Kinetic Impact:132838"] = 803,
			["Niuzao"] = 803,
			["Niuzao, the Black Ox"] = 803,
			["Invoke Niuzao, the Black Ox"] = 803,
			["Downward Smash:463566"] = 803,
			["Harden Skin"] = 803,
			["Hardened Spike"] = 803,
			["Burrow"] = 803,
			["Borehole"] = 803,
			["Cascading Slam"] = 803,
			["Earth Blast"] = 803,
			["Earth Bolt"] = 803,
			["Earth Elemental"] = 803,
			["Greater Earth Elemental"] = 803,
			["Primal Earth Elemental"] = 803,
			["Earth Shatter"] = 803,
			["Earth Shield"] = 803,
			["Earth Slash"] = 803,
			["Earth Spike"] = 803,
			["Earthbind"] = 803,
			["Earthen Strikes"] = 803,
			["Earthquake"] = 803,
			["Earthshards"] = 803,
			["Earthshatter"] = 803,
			["Earthwarden"] = 803,
			["Eruption:136025"] = 803,
			["Eruption:237002"] = 803,
			["Eruption:463566"] = 803,
			["Furious Quake"] = 803,
			["Ground Shatter"] = 803,
			["Ground Spike"] = 803,
			["Massive Quake"] = 803,
			["Quake"] = 803,
			["Rising Fury:463566"] = 803,
			["Seismic Force"] = 803,
			["Seismic Upheaval"] = 803,
			["Tremor Totem"] = 803,
			["Upheaval"] = 803,
			["Earthen Blast"] = 803,
			["Hardened Muck"] = 803,

			--! Earthstrike  ! Leatherworking
			["Ground Stomp"] = 903,
			["Colossal Smash"] = 903,
			["Shattering Smash"] = 903,
			["Ground Crush"] = 903,
			["Meteor Leap"] = 903,
			["Angry Snort"] = 903,
			["Crushing Swipe"] = 903,
			["Seismic Slam"] = 903,
			["Colossal Blow"] = 903,
			["Snort"] = 903,
			["Shattering Stomp"] = 903,
			["Lumbering Stomp"] = 903,
			["Basilisk"] = 903,
			["Dire Beast: Basilisk"] = 903,
			["Crush:451165"] = 903,
			["Avatar"] = 903,
			["Giant-felling Cleave"] = 903,
			["Shockwave"] = 903,
			["Massive Shockwave"] = 903,
			["Shatter"] = 903,
			["Smash"] = 903,
			["Ground Slap"] = 903,
			["Upheaving Stomp"] = 903,
			["Earthrending Slam"] = 903,
			["Crushing Stomp"] = 903,
			["Trembling Stomp"] = 903,
			["Echoing Smash:796637"] = 903,
			["Earthen Wall Totem"] = 903,
			["Reverberating Leap"] = 903,
			["Destructive Stomp"] = 903,
			["Shell Harden"] = 903,
			["Earthshaking Club"] = 903,
			["Ground Pound"] = 903,
			["Earth Shaking Club"] = 903,
			["Burrowing Impact"] = 903,
			["Burrowing Spike"] = 903,
			["Earthbind Totem"] = 903,
			["Ground Slam"] = 903,
			["Harden Skin"] = 903,
			["Harden"] = 903,

			--! Stone  ! Rock
			["Rock Bash"] = 809,
			["Cave-in"] = 809,
			["Stone Bulwark"] = 809,
			["Stoneshape"] = 809,
			["Rock Barrage"] = 809,
			["Stone Splinter"] = 809,
			["Animate Pebble"] = 809,
			["Boulder Barrage"] = 809,
			["Boulder"] = 809,
			["Boulderbolt"] = 809,
			["Cracked Stone"] = 809,
			["Flesh to Stone"] = 809,
			["Fortifying Brew"] = 809,
			["Granite Wings"] = 809,
			["Hail of Stones"] = 809,
			["Hurl Boulder"] = 809,
			["Hurl Boulders"] = 809,
			["Ironfur"] = 809,
			["Petrifying Breath"] = 809,
			["Petrifying Gaze"] = 809,
			["Petrifying Howl"] = 809,
			["Rock Lance"] = 809,
			["Rolling Stone"] = 809,
			["Shale Spit"] = 809,
			["Shatter:132358"] = 809,
			["Stone Bolt"] = 809,
			["Stone Breath"] = 809,
			["Stone Disc"] = 809,
			["Stone Eruption"] = 809,
			["Stone Fist"] = 809,
			["Stone Form"] = 809,
			["Stone Gaze"] = 809,
			["Stone Shell Detonation"] = 809,
			["Stone Smash"] = 809,
			["Stone Spike"] = 809,
			["Stone Stomp"] = 809,
			["Stoneform"] = 809,
			["Stoneshape"] = 809,
			["Stoneskin"] = 809,
			["Swamp Breath"] = 809,

			--! Stonestrike  ! Metal  ! Salt  ! Blacksmithing  ! Mining
			["Binding Chains"] = 909,
			["Scourge Hook"] = 909,
			["Shield Spike"] = 909,
			["Stone Breaker"] = 909,
			["Stonebreaker"] = 909,
			["Stone Throw"] = 909,
			["Brulbash"] = 909,
			["Salt Spray"] = 909,
			["Mining"] = 909,
			["Shackles"] = 909,
			["Iron Shackles"] = 909,
			["Lockdown"] = 909,
			["Subduing Chains"] = 909,
			["In Irons"] = 909,

			--! Sand  ! Ash
			["Sand Breath"] = 804,
			["From the Ashes"] = 804,
			["Kick Up Dust"] = 804,
			["Dirt Toss"] = 804,
			["Hindering Soot"] = 804,
			["Ashen Bolt"] = 804,
			["Ashen Bolt Volley"] = 804,
			["Sand Blast"] = 804,
			["Sand Bolt"] = 804,
			["Sandblast"] = 804,
			["Eruption:236758"] = 804,

			--! Amber
			["Splintered Elemental Rod"] = 810,
			["Amber Blast"] = 810,
			["Amber Bolt"] = 810,
			["Amber Burst"] = 810,
			["Amber Corrosion"] = 810,
			["Amber Eruption"] = 810,
			["Amber Explosion"] = 810,
			["Amber Fountain"] = 810,
			["Amber Growth"] = 810,
			["Amber Mending"] = 810,
			["Amber Mutation"] = 810,
			["Amber Prison"] = 810,
			["Amber Regeneration"] = 810,
			["Amber Release"] = 810,
			["Amber Scalpel"] = 810,
			["Amber Shards"] = 810,
			["Amber Spew"] = 810,
			["Amber Volley"] = 810,
			["Amber Volley"] = 810,
			["Amber"] = 810,
			["Ambergesic"] = 810,
			["Ancient Rune:1058940"] = 810,
			["Blight Crystal Explosion"] = 810,
			["Blister"] = 810,
			["Caustic Amber"] = 810,
			["Chuck Crystal:132777"] = 810,
			["Crystal Barbs:237196"] = 810,
			["Crystal Bolt:1003593"] = 810,
			["Crystal Call:132780"] = 810,
			["Crystal Shards:629524"] = 810,
			["Crystal Spike:1003593"] = 810,
			["Crystal Spikes:132780"] = 810,
			["Crystal Storm:1003593"] = 810,
			["Crystal Trap:463485"] = 810,
			["Crystal:132780"] = 810,
			["Crystalline Barrier:253400"] = 810,
			["Crystallize:132780"] = 810,
			["Empowered Explosive Runes:1122137"] = 810,
			["Exploding Runes:135829"] = 810,
			["Explosive Runes:1122136"] = 810,
			["Hurl Amber"] = 810,
			["Light of the Crystal"] = 810,
			["Piercing Shards:132777"] = 810,
			["Rune of Grasping Earth"] = 810,
			["Rune of Trembling Earth"] = 810,
			["Runic Brand:442743"] = 810,
			["Runic Spike"] = 810,

			--! Crystal  ! Glass  ! Jewelcrafting
			["Summon Rogg Shard"] = 808,
			["Lethargic Glare"] = 808,
			["Glass Cannon"] = 808,
			["Hurl Crystalshards"] = 808,
			["Prospecting"] = 808,
			["Chuck Crystal"] = 808,
			["Crystal Barbs"] = 808,
			["Crystal Barrage"] = 808,
			["Crystal Bolt"] = 808,
			["Crystal Breath"] = 808,
			["Crystal Call"] = 808,
			["Crystal Charge"] = 808,
			["Crystal Eruption"] = 808,
			["Crystal Flash"] = 808,
			["Crystal Gaze"] = 808,
			["Crystal Growth"] = 808,
			["Crystal Shards"] = 808,
			["Crystal Spike"] = 808,
			["Crystal Spikes"] = 808,
			["Crystal Storm"] = 808,
			["Crystal Trap"] = 808,
			["Crystal"] = 808,
			["Crystalize"] = 808,
			["Crystalline Assault"] = 808,
			["Crystalline Barrier"] = 808,
			["Crystalline Bolt"] = 808,
			["Crystalline Bonds"] = 808,
			["Crystalline Burst"] = 808,
			["Crystalline Cage"] = 808,
			["Crystalline Cleave"] = 808,
			["Crystalline Command"] = 808,
			["Crystalline Defense Grid"] = 808,
			["Crystalline Dust"] = 808,
			["Crystalline Ground"] = 808,
			["Crystalline Growth"] = 808,
			["Crystalline Kick"] = 808,
			["Crystalline Resonance"] = 808,
			["Crystalline Shield"] = 808,
			["Crystalline Shrapnel"] = 808,
			["Crystalline Slumber"] = 808,
			["Crystalline Surge"] = 808,
			["Crystalline Tether"] = 808,
			["Crystalline Torment"] = 808,
			["Crystallize"] = 808,
			["Death Glare:433446"] = 808,
			["Exposed Core"] = 808,
			["Form Crystals"] = 808,
			["Impaling Coral"] = 808,
			["Piercing Shards"] = 808,
			["Throw Crystal"] = 808,

			--! Diamond  ! Prismatic  ! White
			-- 812

			--! Amethyst  ! Purple
			["Resonating Crystals"] = 813,

			--! Sapphire  ! Blue
			-- 814

			--! Emerald  ! Green
			-- 815

			--! Citrine  ! Yellow
			-- 816

			--! Topaz  ! Orange
			-- 817

			--! Ruby  ! Red
			["Shattering Ruby"] = 818,

			--! Onyx  ! Obsidian  ! Black
			-- 819


			--: Arcane
			-------------------------
			--! Arcane
			["Prismatic Barrier"] = 64,
			["Arcane Meteor"] = 64,
			["Star Gate:610471"] = 64,
			["Meteor Shower:1041233"] = 64,
			["Arcane Bolt"] = 64,
			["Arcane Bolts"] = 64,
			["Sear:135731"] = 64,
			["Arcane Wall"] = 64,
			["Eclipse (Lunar)"] = 64,
			["Portal: Dalaran"] = 64,
			["Moonfire"] = 64,
			["Arcane Bombardment"] = 64,
			["Arcane Bomb"] = 64,
			["Rune of Unmaking"] = 64,
			["Conjure Arcane Rune"] = 64,
			["Ablative Pulse"] = 64,
			["Arcane Barrage"] = 64,
			["Arcane Blast"] = 64,
			["Arcane Burst"] = 64,
			["Arcane Power"] = 64,
			["Empower Golem"] = 64,
			["Ethereal Portal"] = 64,
			["Focused Blast"] = 64,
			["Lunar Elder's Hearthstone"] = 64,
			["Polymorph"] = 64,
			["Portal"] = 64,
			["Power Crystal"] = 64,
			["Power Crystals"] = 64,
			["Ruby Slippers"] = 64,
			["Scrying"] = 64,
			["Summon Power Crystal"] = 64,
			["Summon Power Crystals"] = 64,
			["Town Portal"] = 64,

			--! Spellstrike
			["Umbral Glaive Storm"] = 65,
			["A Compendium of the Herbs of Draenor"] = 65,
			["A Guide to Skinning in Draenor"] = 65,
			["A Treatise on Mining in Draenor"] = 65,
			["A Treatise on the Alchemy of Draenor"] = 65,
			["A Treatise on the Inscription of Draenor"] = 65,
			["Draenor Blacksmithing"] = 65,
			["Draenor Jewelcrafting"] = 65,
			["Draenor Leatherworking"] = 65,
			["Draenor Tailoring"] = 65,
			["Fishing Guide to Draenor"] = 65,
			["Introduction to Cooking in Draenor"] = 65,
			["Learning"] = 65,
			["Mana Rage"] = 65,
			["Glowing Rune Axe"] = 65,
			["Runic Strike"] = 65,
			["Shattering Throw"] = 65,
			["Mass Spell Reflection"] = 65,
			["Diffuse Magic"] = 65,
			["Reflective Shield"] = 65,
			["Rune of the Stoneskin Gargoyle"] = 65,
			["Runic Cleave"] = 65,
			["Spell Reflect"] = 65,
			["Spell Reflection"] = 65,

			--! Magic
			["Arcane Explosion"] = 126,
			["Arcane Missiles"] = 126,
			["Summon Doomskull"] = 126,
			["Touch of the Magi"] = 126,
			["Focused Bursts:136050"] = 126,
			["Cantrips"] = 126,
			["Teleport: Hall of the Guardian"] = 126,
			["Runic Mending"] = 126,
			["Wild Magic"] = 126,
			["Energy Drain"] = 126,
			["Conjure Mana Gem"] = 126,

			--! Conjuration  ! Teleport  ! Enchanting
			["Mirror Image"] = 646,
			["Mirror Images"] = 646,
			["Dalaran Hearthstone"] = 646,
			["Ancient Portal: Dalaran"] = 646,
			["Ancient Teleport: Dalaran"] = 646,
			["Blink"] = 646,
			["Disenchant"] = 646,
			["Disenchanting Carefully"] = 646,
			["Disenchanting"] = 646,
			["Enchant"] = 646,
			["Enchanting"] = 646,
			["Garrison Hearthstone"] = 646,
			["Orb of Translocation"] = 646,
			["Portal: Boralus"] = 646,
			["Portal: Dalaran - Broken Isles"] = 646,
			["Portal: Dalaran - Northrend"] = 646,
			["Portal: Dalaran"] = 646,
			["Portal: Darnassus"] = 646,
			["Portal: Dazar'alor"] = 646,
			["Portal: Exodar"] = 646,
			["Portal: Ironforge"] = 646,
			["Portal: Moonglade"] = 646,
			["Portal: Orgrimmar"] = 646,
			["Portal: Oribos"] = 646,
			["Portal: Shattrath"] = 646,
			["Portal: Silvermoon"] = 646,
			["Portal: Stonard"] = 646,
			["Portal: Stormshield"] = 646,
			["Portal: Stormwind"] = 646,
			["Portal: Theramore"] = 646,
			["Portal: Thunder Bluff"] = 646,
			["Portal: Tol Barad"] = 646,
			["Portal: Undercity"] = 646,
			["Portal: Vale of Eternal Blossoms"] = 646,
			["Portal: Warspear"] = 646,
			["Portal: The Broken Shore"] = 646,
			["Portal: Violet Hold"] = 646,
			["Raid Portal: Oribos"] = 646,
			["Summon Wolfoids"] = 646,
			["Teleport to Shipyard"] = 646,
			["Teleport"] = 646,
			["Teleport: Boralus"] = 646,
			["Teleport: Dalaran - Broken Isles"] = 646,
			["Teleport: Dalaran - Northrend"] = 646,
			["Teleport: Dalaran"] = 646,
			["Teleport: Darnassus"] = 646,
			["Teleport: Dazar'alor"] = 646,
			["Teleport: Exodar"] = 646,
			["Teleport: Ironforge"] = 646,
			["Teleport: Moonglade"] = 646,
			["Teleport: Orgrimmar"] = 646,
			["Teleport: Oribos"] = 646,
			["Teleport: Shattrath"] = 646,
			["Teleport: Silvermoon"] = 646,
			["Teleport: Stonard"] = 646,
			["Teleport: Stormshield"] = 646,
			["Teleport: Stormwind"] = 646,
			["Teleport: Theramore"] = 646,
			["Teleport: Thunder Bluff"] = 646,
			["Teleport: Tol Barad"] = 646,
			["Teleport: Undercity"] = 646,
			["Teleport: Vale of Eternal Blossoms"] = 646,
			["Teleport: Warspear"] = 646,
			["Translocate"] = 646,
			["Conjure Food"] = 646,
			["Conjure Water"] = 646,
			["Conjure Refreshment"] = 646,
			["Conjure Refreshments"] = 646,
			["Conjure Refreshment Table"] = 646,
			["Conjure Image"] = 646,

			--! Chromatic  ! Prismatic
			["Protective Phantasma"] = 124,
			["Chromatic Infusion"] = 124,
			["Chromatic Mantle of the Dawn"] = 124,
			["Chromatic Mount"] = 124,
			["Chromatic Resistance Aura"] = 124,
			["Chromatic Shift"] = 124,
			["Mindmeld"] = 124,

			--! Temporal  ! Time
			["Temporal Blast"] = 640,
			["Accelerated Mending"] = 640,
			["Chrono Shift"] = 640,
			["True Bearing"] = 640,
			["Slow"] = 640,
			["Mass Slow"] = 640,
			["Time Warp"] = 640,
			["Alter Time"] = 640,



			--: Astral
			-------------------------
			--! Astral
			["Constellation Shield"] = 72,
			["Starfall"] = 72,
			["Celestial Alignment"] = 72,
			["Ancestral Protection Totem"] = 72,
			["Ancestral Guidance"] = 72,
			["Astral Annihilation"] = 72,
			["Astral Shift"] = 72,
			["Call to the Stars"] = 72,
			["Faerie Dust"] = 72,
			["Far Sight"] = 72,
			["Siphon Nightwell"] = 72,

			--! Spectral
			["Spirit of Ka-Sha"] = 720,
			["Starlance Vigil"] = 720,
			["Shadow Pounce"] = 720,
			["Spectral Swipe"] = 720,
			["Spirit Walk"] = 720,
			["Spirit Stream"] = 720,
			["Lesser Invisibility"] = 720,
			["Invisibility"] = 720,
			["Invisible"] = 720,
			["Mass Invisibility"] = 720,
			["Greater Invisibility"] = 720,
			["Veilwalking"] = 720,
			["Doom Gaze"] = 720,
			["Fade"] = 720,
			["Blur"] = 720,
			["Fading Strike"] = 720,
			["Ferocity of the Frostwolf"] = 720,
			["Greater Fade"] = 720,
			["Might of the Blackrock"] = 720,
			["Rictus of the Laughing Skull"] = 720,
			["Spectral Storm"] = 720,
			["Wraith Walk"] = 720,
			["Zeal of the Burning Blade"] = 720,


			--: Decay
			-------------------------
			--! Unholy  ! Bone
			["Bind to the Bones"] = 414,
			["Helya's Boon"] = 414,
			["Foul Smash"] = 414,
			["Bone Splinter"] = 414,
			["Exhume the Crypts"] = 414,
			["Apocalypse"] = 414,
			["Ectoplasm"] = 414,
			["Ectoplasm Spew"] = 414,
			["Dark Transformation"] = 414,
			["Lichborne"] = 414,
			["Army of the Dead"] = 414,
			["Bony Strike"] = 414,
			["Bone Spike Graveyard"] = 414,
			["Bone Spike"] = 414,
			["Bone Spear"] = 414,
			["Bone Toss"] = 414,
			["Grave Spike"] = 414,
			["Shambling Rush"] = 414,
			["Jagged Spines"] = 414,
			["Raise Dead"] = 414,
			["Bone Cleave"] = 414,
			["Spine Crawl"] = 414,
			["Unholy Bulwark"] = 414,
			["Devour Magic"] = 414,
			["Unraveling Horror"] = 414,
			["Decimate:135797"] = 414,
			["Rune of Suffering"] = 414,
			["Anti-Magic Shell"] = 414,
			["Bone Armor"] = 414,
			["Bone Shield"] = 414,
			["Brackish Bolt"] = 414,
			["Strange Brew"] = 414,
			["Cauldron Catalyst"] = 414,
			["Decaying Strike"] = 414,
			["Plague-Tipped Arrows"] = 414,
			["Plague-Dipped Arrows"] = 414,
			["Plagued Broadside"] = 414,
			["Stagnant Blast"] = 414,
			["Volatile Concoction"] = 414,
			["Whirling Mist"] = 414,

			--! Plague
			["Carrion Slam"] = 40,
			["Infected Thorn"] = 40,
			["Bile Spew"] = 40,
			["Belch"] = 40,
			["Gaseous Breath"] = 40,
			["Parasitic Growth"] = 40,
			["Carrion Swarm"] = 40,
			["Impact Spit"] = 40,
			["Putrid Swarm"] = 40,
			["Infested Breath"] = 40,
			["Tummy Ache"] = 40,
			["Unholy Blight"] = 40,
			["Virulent Plague"] = 40,
			["Retched Belch"] = 40,
			["Rapid Contagion"] = 40,
			["Death Breath"] = 40,
			["Fling Goop"] = 40,
			["Twigin's Wings"] = 40,
			["Belch Organs"] = 40,
			["Clining Infestation"] = 40,
			["Contagion"] = 40,
			["Contaminate"] = 40,
			["Decay Flesh"] = 40,
			["Decaying Breath"] = 40,
			["Decaying Flesh"] = 40,
			["Fetid Breath"] = 40,
			["Fetid Corpse"] = 40,
			["Fetid Hide"] = 40,
			["Fling Filth"] = 40,
			["Heaving Retch"] = 40,
			["Ooz's Frictionless Coating"] = 40,
			["Plague Spit"] = 40,
			["Plaguepiercer"] = 40,
			["Putrefied Flesh"] = 40,
			["Rot Barrage"] = 40,
			["Rotting Bolt"] = 40,
			["Rotting Tempest"] = 40,
			["Shoot Plague"] = 40,
			["Unraveling Flesh"] = 40,
			["Call Plagueling"] = 40,
			["Vile Eruption"] = 40,
			["Ooze Cap"] = 40,
			["Insect Plague"] = 40,
			["Retch"] = 40,

			--! Disease  ! Rot
			["Rats!"] = 410,
			["Diseased Spit"] = 410,
			["Rotten to the Core"] = 410,
			["Mimic:342913"] = 410,
			["Desperate Retching"] = 410,
			["Sludge Bolt"] = 410,
			["Blood Plague"] = 410,
			["Fetid Bite"] = 410,
			["Muck Spit"] = 410,
			["Putrid Jar"] = 410,
			["Foul Breath"] = 410,
			["Bug Sprayer"] = 410,
			["Razor Gills"] = 410,
			["Bone Boil"] = 410,
			["Burrowing Grubs"] = 410,
			["Call Blood Maggots"] = 410,
			["Diseased Bite"] = 410,
			["Fling Muck"] = 410,
			["Plague Seed"] = 410,
			["Spit Filth"] = 410,
			["Throw Muck"] = 410,
			["Unfettered Growth"] = 410,
			["Throw Blight Crystal"] = 410,
			["Drink Muck"] = 410,
			["Clinging Infestation"] = 410,

			--! Nightmare
			["Corrupt the Wild:1357812"] = 412,
			["Nightmare Blast"] = 412,
			["Nightmare Nova"] = 412,
			["Nightmare Swipe"] = 412,
			["Shadow Meteor:1357805"] = 412,
			["Corrupted Dreams"] = 412,
			["Raining Filth:1357799"] = 412,
			["Darkfall:1357806"] = 412,
			["Twisted Nova:1357801"] = 412,
			["Summon Dread Spirit:132183"] = 412,
			["Erupting Terror:1357798"] = 412,
			["Dark Ruination:1357796"] = 412,
			["Despoiling Roots:1357816"] = 412,
			["Corrupting Nova:1396969"] = 412,
			["Crushing Darkness:1396971"] = 412,
			["Forces of Nightmare"] = 412,
			["Terror Barrage:1357806"] = 412,
			["Creeping Nightmare"] = 412,
			["Cries of Insanity:236364"] = 412,
			["Hateful Rebuke:1357806"] = 412,
			["Havoc"] = 412,
			["Lurking Eruption:1357803"] = 412,
			["Nightmare Bolt"] = 412,
			["Nightmare Breath"] = 412,
			["Nightmare Burst"] = 412,
			["Nightmare Infusion"] = 412,
			["Nightmare Torment"] = 412,
			["Nightmare"] = 412,
			["Nightmareburst"] = 412,
			["Torment Bolt:1357810"] = 412,
			["Torment Dreams"] = 412,
			["Unleashed Madness:1357797"] = 412,

			--! Death  ! Mawsworn
			["Doomblast:3528298"] = 411,
			["Torturous Reach"] = 411,
			["Effigy of Torment"] = 411,
			["Soul Fracture"] = 411,
			["Fracture Soul"] = 411,
			["Unraveler's Tempest:3528305"] = 411,
			["Ritual of Pain:3528301"] = 411,
			["Pain Bringer:1035046"] = 411,
			["Trap the Soul"] = 411,
			["Persecute"] = 411,
			["Crashing Death"] = 411,
			["Execution Sentence:306922"] = 411,
			["Corrupted Ordnance:3528302"] = 411,
			["Corrupted Ordnance:3528301"] = 411,
			["Anima Cannon:3528303"] = 411,
			["Tortured Stomp:3528303"] = 411,
			["Darkmist Bombardment"] = 411,
			["Call of the Tormented"] = 411,
			["Entropic Detonation:3528301"] = 411,
			["Fracture Soul"] = 411,
			["Siphon Loyalty"] = 411,
			["Torment Soul:3528300"] = 411,
			["Dark Communion:3528299"] = 411,
			["Wracking Torment"] = 411,
			["Dark Eclupse"] = 411,
			["Draw Soulkindling"] = 411,
			["Steal Essence:347045"] = 411,
			["Defiling Slam"] = 411,
			["Call Shade:3731618"] = 411,
			["Mawsworn Fervor"] = 411,
			["Stygian Rampage"] = 411,
			["Defiling Dreadslam"] = 411,
			["Font of Torment"] = 411,
			["Painwaves:3528305"] = 411,
			["Mawsworn Shield"] = 411,
			["Relic Breaker:3528303"] = 411,
			["Mawsworn Bombardment"] = 411,
			["Mawsworn Slam"] = 411,
			["Pillage Hope"] = 411,
			["Piercing Lens:132160"] = 411,
			["Wracking Torture"] = 411,
			["Wracking Interrogation"] = 411,
			["Painbringer's Tempest"] = 411,
			["Forbidden Knowledge:3528299"] = 411,
			["Wracking Torture:3528300"] = 411,
			["Eradicate"] = 411,
			["Banshee Form"] = 411,
			["Death Gate"] = 411,
			["Dreadful Wrath:1357799"] = 411,
			["Sudden Death"] = 411,
			["Attenuated Barrage:3528304"] = 411,
			["Dark Seeker:1345085"] = 411,
			["Unstable Affliction"] = 411,
			["Excruciating Agony:3528304"] = 411,
			["Stygia Tap"] = 411,
			["Stygian Breath"] = 411,
			["Tormentous Crash:3528305"] = 411,
			["Cadaverous Cleats"] = 411,
			["Subterfuge"] = 411,
			["Master Assassin"] = 411,
			["Umbral Blast"] = 411,
			["Blackened Claws:645142"] = 411,
			["Mawrat Harness"] = 411,
			["Death Blast"] = 411,
			["Vanish to Nothing"] = 411,
			["Soul Feast"] = 411,
			["Siphon Anima:3528298"] = 411,
			["Dark Spin:135337"] = 411,
			["Discordant Howl:3528300"] = 411,
			["Betrayed Fury:3528302"] = 411,
			["Darksworn Blast"] = 411,
			["Forsworn Bolt"] = 411,
			["Forsworn Ground"] = 411,
			["Constricting Memories:3528301"] = 411,
			["Deathbolt Rifts:3528303"] = 411,
			["Death Tempest:3528305"] = 411,
			["Inflated Ego:3528299"] = 411,
			["Blazing Surge:348565"] = 411,
			["Dark Lash:3528302"] = 411,
			["Stygian Lament"] = 411,
			["Glare:3528302"] = 411,
			["Searing Glare:3528298"] = 411,
			["Concealing Fog:3528303"] = 411,
			["Anima Barrage:3528302"] = 411,
			["Embrace of Death"] = 411,
			["Overwhelming Despair:3528302"] = 411,
			["Extract Agony:3528302"] = 411,
			["Massive Crush:3284844"] = 411,
			["Stygian Shield"] = 411,
			["Malefic Resonance"] = 411,
			["Wave of Agony:3528300"] = 411,
			["Touch of Anguish"] = 411,
			["Pain Spike:3528302"] = 411,
			["Call of Death"] = 411,
			["Call to Chaos"] = 411,
			["Cone of Death"] = 411,
			["Dark Bolt"] = 411,
			["Deadly Bargain"] = 411,
			["Death Bolt"] = 411,
			["Death Burst"] = 411,
			["Decaying Blast:3528302"] = 411,
			["Defile"] = 411,
			["Ebon Clarion"] = 411,
			["Feign Death"] = 411,
			["Infuse Death"] = 411,
			["Mawsworn Crossbow"] = 411,
			["Ritual of Bone"] = 411,
			["Ritual of Bones"] = 411,
			["Shroud of Concealment"] = 411,
			["Succumb to Doubt"] = 411,
			["Suffering"] = 411,
			["Surging Doubt"] = 411,
			["Symbols of Death"] = 411,
			["Unstable Stygia"] = 411,
			["Vanish"] = 411,
			["Wave of Suffering"] = 411,

			--! Drust  ! Devourer
			["Bewitching Eye"] = 413,
			["Devourer's Rift"] = 413,
			["Worldeating Rift"] = 413,
			["Mass Devour"] = 413,
			["Ruinous Bolt"] = 413,
			["Soul Bolt:631503"] = 413,
			["Scar Soul:895888"] = 413,
			["Hungering Eruption:135786"] = 413,
			["Severing Roar:1778228"] = 413,
			["Unstable Ejection:342917"] = 413,
			["Devourer Rift"] = 413,
			["Devouring Rift"] = 413,
			["Essence Link:132146"] = 413,
			["Essence Rift:135729"] = 413,
			["Gorging Smash"] = 413,
			["Tear Rift:462651"] = 413,
			["Siphon Anima:236222"] = 413,
			["Dark Claw:237564"] = 413,
			["Twisted Upheaval:134413"] = 413,
			["Soul Eruption:1390943"] = 413,
			["Soul Rot"] = 413,
			["Spirit Bolt"] = 413,
			["Edge of Annihilation:1778227"] = 413,
			["Volatile Ejection:342917"] = 413,
			["Feeding:136213"] = 413,
			["Relentless Feeding"] = 413,
			["Devour Essence"] = 413,
			["Desolate:1778230"] = 413,


			--: Shadow
			-------------------------
			--! Shadow
			["Woven Shadows"] = 32,
			["Sudden Doom"] = 32,
			["Death's Advance"] = 32,
			["Catharstick"] = 32,
			["Shadow Bulwark"] = 32,
			["Expulse Shadows"] = 32,
			["Shadowfiend"] = 32,
			["Breathless Darkness"] = 32,
			["Corruption Ritual"] = 32,
			["Shadow Bolt"] = 32,
			["Shadow Dance"] = 32,
			["Shadowstep"] = 32,
			["Nightfall"] = 32,

			--! Psychic  ! Mind Control
			["Mind Rend"] = 328,
			["Cripple"] = 328,
			["Piercing Gaze"] = 328,
			["Subjugate"] = 328,
			["Subjugate Demon"] = 328,
			["Control Undead"] = 328,
			["Debilitate"] = 328,
			["Mass Debilitate"] = 328,
			["Silence"] = 328,
			["Mana Burn"] = 328,
			["Mindbender"] = 328,
			["Addled Mind"] = 328,
			["Dark Thought"] = 328,
			["Mind Blast"] = 328,
			["Mind Control"] = 328,
			["Mind Flay"] = 328,
			["Mind Sear"] = 328,
			["Mind Soothe"] = 328,
			["Mind Trauma"] = 328,
			["Mind Vision"] = 328,
			["Searing Nightmare"] = 328,
			["Mind Bomb"] = 328,
			["Mind Warp"] = 328,
			["Shadow Sight"] = 328,
			["Shadow Strangle"] = 328,
			["Siphon of Acherus"] = 328,

			--! Shadowstrike
			["Veil of Midnight"] = 33,
			["Foul Smash:607850"] = 33,
			["Dark Rend"] = 33,
			["Heaving Blow"] = 33,
			["Blindside"] = 33,
			["Darkflight"] = 33,
			["Rat Traps"] = 33,
			["Rat Trap"] = 33,
			["Death Blow"] = 33,
			["Sweeping Blow:916656"] = 33,
			["Dark Claw"] = 33,
			["Forsworn Strike"] = 33,
			["Shadowstrike"] = 33,
			["Shadow Strike"] = 33,
			["Shadow Strikes"] = 33,
			["Gargoyle Strike"] = 33,
			["Harrow"] = 33,
			["Hollow Bite"] = 33,
			["Running Wild"] = 33,
			["Soulsunder"] = 33,
			["Summon Gargoyle"] = 33,
			["Tentacle Slam"] = 33,
			["Chain Cleave"] = 33,

			--! Pain
			["Surge of Pain"] = 322,
			["Excruciating Agony"] = 322,
			["Wave of Agony"] = 322,
			["Agony"] = 322,
			["Eternal Torment"] = 322,
			["Pain Spike"] = 322,
			["Pain Suppression"] = 322,
			["Shadow Word: Pain"] = 322,
			["Torment"] = 322,

			--! Haunt  ! Nether
			["Unleashed Suffering"] = 323,
			["Cries of Anguish"] = 323,
			["Desperation"] = 323,
			["Nether Meteor"] = 323,
			["Nether Touch"] = 323,
			["Withered Woe"] = 323,
			["Unrelenting Anguish"] = 323,
			["Tortured Soul"] = 323,
			["Shattered Visage"] = 323,
			["Soul Steal"] = 323,
			["Soul Shred"] = 323,
			["Torn Spirits"] = 323,
			["Soul Vessel"] = 323,
			["Banshee Wail"] = 323,
			["Phantom Lance"] = 323,
			["Demon Soul"] = 323,
			["Obsidian Claw"] = 323,
			["Nathrian Hymn: Gloomveil"] = 323,
			["Rip Soul:1378703"] = 323,
			["Deathly Roar:132095"] = 323,
			["Shades of Bargast"] = 323,
			["Grasping Spirits"] = 323,
			["Wail of the Dead"] = 323,
			["Tormenting Haunt"] = 323,
			["Rend Soul"] = 323,
			["Banish"] = 323,
			["Banishment"] = 323,
			["Banish Scourge Crystal"] = 323,
			["Cry of the Forgotten"] = 323,
			["Dispersion"] = 323,
			["Drain Soul"] = 323,
			["Feint"] = 323,
			["Ghastly Wail"] = 323,
			["Harrowing Wail"] = 323,
			["Haunt"] = 323,
			["Incorporeal"] = 323,
			["Mind Vision"] = 323,
			["Phantom Singularity"] = 323,
			["Shrieking Souls"] = 323,
			["Spectral Shackle"] = 323,
			["Unleashed Torment"] = 323,
			["Vampiric Embrace"] = 323,
			["Vampiric Speed"] = 323,
			["Vampiric Touch"] = 323,
			["Leeching Cleave"] = 323,
			["Wail of the Restless"] = 323,
			["Wail"] = 323,

			--! Corruption  ! Old Gods
			["Insanity"] = 324,
			["Constricting Grasp"] = 324,
			["Consuming Bite"] = 324,
			["Corrupt Soul"] = 324,
			["Corrupt"] = 324,
			["Corrupting Nova"] = 324,
			["Corruption Bolt"] = 324,
			["Corruption"] = 324,
			["Creepy Crawly"] = 324,
			["Creepy Crawler"] = 324,
			["Crushing Doubt"] = 324,
			["Dark Drain"] = 324,
			["Dark Maul"] = 324,
			["Defiled Ground"] = 324,
			["Despair"] = 324,
			["Devouring Blackness"] = 324,
			["Devouring Plague"] = 324,
			["Emotion Expulsion"] = 324,
			["Emotional Outburst:136158"] = 324,
			["Emotional Outburst:136184"] = 324,
			["Endless Hunger"] = 324,
			["Externalize Rage"] = 324,
			["Festering Wound"] = 324,
			["Leviathan's Grip"] = 324,
			["Mass Corruption"] = 324,
			["Orb of Corruption"] = 324,
			["Piercing Memory:878214"] = 324,
			["Seed of Corruption"] = 324,
			["Seed of Doubt"] = 324,
			["Steal Memories"] = 324,
			["Summon Tentacle of the Old Ones"] = 324,
			["Surrender to Madness"] = 324,
			["Tentacle of the Old Ones"] = 324,
			["Unleash Burden"] = 324,
			["Unleash Burdens"] = 324,
			["Unleash Corruption"] = 324,
			["Unleashed Madness"] = 324,
			["Unstable Gloom"] = 324,
			["Wither"] = 324,

			--! Spellshadow  ! Runic  ! Harpy
			["Shadow Bond:611425"] = 96,
			["Vicious Storm:649816"] = 96,
			["Foul Blast:425959"] = 96,
			["Ritual of the Berserker"] = 96,
			["Shadow Prison"] = 96,
			["Etch:136202"] = 96,
			["Surging Fist:877699"] = 96,
			["Shadowdelving"] = 96,
			["Frailty"] = 96,
			["Shattered Resolve:136201"] = 96,
			["Detecting Life"] = 96,
			["Soulshift"] = 96,
			["Shadow Rip"] = 96,
			["Rune-Etched Axe"] = 96,
			["Dark Pact"] = 96,
			["Enslave Demon"] = 96,
			["Assassin's Soulcloak"] = 96,
			["Detect Anima"] = 96,
			["Soul Shroud"] = 96,
			["Anima Rune"] = 96,
			["Awaken Runestone"] = 96,
			["Champion of the Runeaxe"] = 96,
			["Cloak of Shadows"] = 96,
			["Dark Rune"] = 96,
			["Empower Rune Weapon"] = 96,
			["Empower Runeblade"] = 96,
			["Explosive Rune"] = 96,
			["Explosive Runes"] = 96,
			["Forbidden Rune"] = 96,
			["Mass Deliberate"] = 96,
			["Mogu Rune of Power"] = 96,
			["Rune Blast"] = 96,
			["Rune of Alacrity"] = 96,
			["Rune of Binding"] = 96,
			["Rune of Destruction"] = 96,
			["Rune of Power"] = 96,
			["Rune of Summoning"] = 96,
			["Rune of the Fallen Crusader"] = 96,
			["Rune Shield"] = 96,
			["Rune Weaving"] = 96,
			["Runecarving"] = 96,
			["Runed Weapon"] = 96,
			["Runes of Shielding"] = 96,
			["Runic Blast"] = 96,
			["Runic Brand"] = 96,
			["Runic Bulwark"] = 96,
			["Runic Corruption"] = 96,
			["Runic Displacement"] = 96,
			["Runic Empowerment"] = 96,
			["Runic Focus"] = 96,
			["Runic Hide"] = 96,
			["Runic Mark"] = 96,
			["Runic Prison"] = 96,
			["Runic Shield"] = 96,
			["Shadow Blades"] = 96,
			["Shatter Rune"] = 96,
			["Shatter Runes"] = 96,
			["Shattered Rune"] = 96,
			["Shield of Runes"] = 96,
			["Shroud of Runes"] = 96,
			["Dancing Rune Weapon"] = 96,
			["Stygian Rune of Oblivion"] = 96,
			["Stygian Rune Tap"] = 96,
			["Unravel the Runes"] = 96,
			["Unstable Runic Mark"] = 96,
			["Soul Reaper"] = 96,

			--! Shadowfrost
			["Forlorn Tears"] = 48,
			["Frozen Tears"] = 48,
			["Shadowfrost Shard"] = 48,
			["Soulfreezing Rune"] = 48,
			["Rune of Razorice"] = 48,


			--: Darkness
			-------------------------
			--! Void
			["Unravel:236296"] = 320,
			["Unravel:136202"] = 320,
			["Shadow Wrath"] = 320,
			["Void Crash"] = 320,
			["Void Crush"] = 320,
			["Voidrend"] = 320,
			["Call of the Void"] = 320,
			["Void Infusion"] = 320,
			["Pitch Blast:460700"] = 320,
			["Drops of Void"] = 320,
			["Delving the Void"] = 320,
			["Void Whip"] = 320,
			["Stampeding Corruption"] = 320,
			["Decimator:1097742"] = 320,
			["Dark Force:136201"] = 320,
			["Orb of Annihilation:132851"] = 320,
			["Void Quills"] = 320,
			["Moonless Night Kick"] = 320,
			["Void Mending"] = 320,
			["Void Vortex"] = 320,
			["Whispers of the Dark Star"] = 320,
			["Rending Voidlash"] = 320,
			["Void Shift"] = 320,
			["Void Pulse"] = 320,
			["Creeping Tendrils:537022"] = 320,
			["Grip of the Void"] = 320,
			["Circle of Power:425958"] = 320,
			["Mental Assault"] = 320,
			["Void Buffet"] = 320,
			["Void Burst"] = 320,
			["Cries of the Void"] = 320,
			["Disintegration Beam:1386551"] = 320,
			["Rain of Darkness"] = 320,
			["Unleash the Void"] = 320,
			["Glimpse of the Void"] = 320,
			["Maw of Death:136131"] = 320,
			["Void Blast"] = 320,
			["Coalescing Shadow"] = 320,
			["Nightmare Visage:136221"] = 320,
			["Dissonant Echoes"] = 320,
			["Voidwraith"] = 320,
			["Void Flay"] = 320,
			["Chaotic Ablution"] = 320,
			["Void Scars"] = 320,
			["Charge:136221"] = 320,
			["Void Frenzy"] = 320,
			["Consume:1778226"] = 320,
			["Call Voidwalker"] = 320,
			["Force of Gravity"] = 320,
			["Void Consumption"] = 320,
			["Armageddon:607865"] = 320,
			["Channel the Void"] = 320,
			["Crackling Void"] = 320,
			["Dark Torrent"] = 320,
			["Dark Void"] = 320,
			["Desintegration Beam"] = 320,
			["Distorting Reality"] = 320,
			["Enter The Rift"] = 320,
			["Entropic Embrace"] = 320,
			["Entropic Focus"] = 320,
			["Entropic Whirl"] = 320,
			["Fragmented Halo"] = 320,
			["Hungering Void"] = 320,
			["Hurl the Void"] = 320,
			["Lashing Void"] = 320,
			["Nothingness"] = 320,
			["Open Vision"] = 320,
			["Pierce the Veil"] = 320,
			["Reality Rend"] = 320,
			["Ring of Chaos:632353"] = 320,
			["Screech From Beyond"] = 320,
			["Shadow Word: Void"] = 320,
			["Singularity"] = 320,
			["Spatial Rift"] = 320,
			["Summon Voidwalker"] = 320,
			["Summon Voidlord"] = 320,
			["Summoning Voidwalker"] = 320,
			["Surging Darkness"] = 320,
			["The Dark is Rising"] = 320,
			["Twist Reality"] = 320,
			["Unbound Darkness"] = 320,
			["Void Beam"] = 320,
			["Void Bolt Volley"] = 320,
			["Void Bolt"] = 320,
			["Void Collapse"] = 320,
			["Void Eruption"] = 320,
			["Void Exhaust"] = 320,
			["Void Form"] = 320,
			["Void Lash"] = 320,
			["Void Mend"] = 320,
			["Void Nova"] = 320,
			["Void Ray"] = 320,
			["Void Shards"] = 320,
			["Void Slash"] = 320,
			["Void Slice"] = 320,
			["Void Stomp"] = 320,
			["Void Storm"] = 320,
			["Void Stream"] = 320,
			["Void Torrent"] = 320,
			["Void Vacuum"] = 320,
			["Voidform"] = 320,
			["Voidsight"] = 320,
			["Voidwrath"] = 320,

			--! Twilight
			["Edge of Twilight"] = 34,
			["Hour of Twilight"] = 34,
			["Twilight Barrage"] = 34,
			["Twilight Barrier"] = 34,
			["Twilight Blast"] = 34,
			["Twilight Bolt"] = 34,
			["Twilight Burst"] = 34,
			["Twilight Fissure"] = 34,
			["Twilight Flames"] = 34,
			["Twilight Meteor"] = 34,
			["Twilight Meteorite"] = 34,
			["Twilight Phoenix"] = 34,
			["Twilight Volley"] = 34,
			["Twilight Whirl"] = 34,
			["Twlight Flames"] = 34, -- [sic]

			--! Blood  ! Venthyr
			["Consume the Living"] = 321,
			["Impending Catastrophe"] = 321,
			["Lingering Hunger"] = 321,
			["Blood Drinker"] = 321,
			["Consume Wrath:3528308"] = 321,
			["Wrath Unleashed:3565716"] = 321,
			["Blood Splatter"] = 321,
			["Summon Arsenal:3151164"] = 321,
			["Ashen Hallow"] = 321,
			["Sanguine Feast"] = 321,
			["Dark Omen"] = 321,
			["Dark Reconstruction"] = 321,
			["Blood Howl"] = 321,
			["Queen's Bite:136231"] = 321,
			["Vampiric Blood"] = 321,
			["Sanguine Sphere"] = 321,
			["Crimson Scourge"] = 321,
			["Dark Communion:3528308"] = 321,
			["Dark Communion:3528312"] = 321,
			["Dark Succor"] = 321,
			["Chain Harvest"] = 321,
			["Ritual of Woe:237536"] = 321,
			["Telekinetic Onslaught:135822"] = 321,
			["Sanguine Extraction"] = 321,
			["Vile Deluge:3528310"] = 321,
			["Overflowing Chalice"] = 321,
			["Depraved Reversion:237585"] = 321,
			["Sinful Brand"] = 321,
			["Ravenous Frenzy:3565718"] = 321,
			["Anima Ring"] = 321,
			["FULL POWER:460687"] = 321,
			["Mirrors of Torment"] = 321,
			["Forced Contrition"] = 321,
			["Volatile Eruption:3528311"] = 321,
			["Overwhelming Gloom:3528311"] = 321,
			["Anima Bulwark:458719"] = 321,
			["Anima Charge:3528313"] = 321,
			["Anima Drain:3528306"] = 321,
			["Anima Drain:3528308"] = 321,
			["Anima Drain:538040"] = 321,
			["Anima Infusion:3528306"] = 321,
			["Anima Infusion:3565725"] = 321,
			["Anima Infusion:3854016"] = 321,
			["Anima Infusion:838812"] = 321,
			["Animate Guardian"] = 321,
			["Begin the Chorus:3528307"] = 321,
			["Blade Volley:3565727"] = 321,
			["Blood Bolt"] = 321,
			["Blood Bolt"] = 321,
			["Blood Infusion"] = 321,
			["Blood Price"] = 321,
			["Blood Ritual"] = 321,
			["Blood Shroud"] = 321,
			["Bloodbolt"] = 321,
			["Blooddrinker"] = 321,
			["Bloodletting"] = 321,
			["Bloodstone"] = 321,
			["Bolt of Madness"] = 321,
			["Bottled Anima:3565722"] = 321,
			["Bottled Anima:3684825"] = 321,
			["Chaotic Infusion:3528307"] = 321,
			["Cleansing Pain:3528313"] = 321,
			["Coalesced Sin"] = 321,
			["Concentrate Anima:3684827"] = 321,
			["Concentrated Anima:3684827"] = 321,
			["Condemn:3565727"] = 321,
			["Condemn:463568"] = 321,
			["Crimson Chorus:3528307"] = 321,
			["Crimson Vial"] = 321,
			["Dark Bolt Volley:3528312"] = 321,
			["Dark Bolt:3528312"] = 321,
			["Dark Destruction:3528311"] = 321,
			["Dark Recital"] = 321,
			["Death and Decay"] = 321,
			["Death Lotus Powder"] = 321,
			["Depraved Harvest"] = 321,
			["Devour Sins:1035055"] = 321,
			["Door of Shadows"] = 321,
			["Drain Anima:3528306"] = 321,
			["Drain Anima:3528308"] = 321,
			["Drain Anima:538040"] = 321,
			["Drain Blood"] = 321,
			["Drain Colossus:3528306"] = 321,
			["Drain Essence:1003601"] = 321,
			["Dread Chaos"] = 321,
			["Dread Orb:332402"] = 321,
			["Dread Slug:132323"] = 321,
			["Dreadbolt Volley:3528310"] = 321,
			["Duke's Descent"] = 321,
			["Essence Rain"] = 321,
			["Expose Desires:3684826"] = 321,
			["Extracting Power:132096"] = 321,
			["Flagellation"] = 321,
			["Forced Contition:3528308"] = 321,
			["Greater Castigation:3528313"] = 321,
			["Harvest Anima"] = 321,
			["Health Funnel"] = 321,
			["Indignation:3528311"] = 321,
			["Inquisitor's Mark"] = 321,
			["Lightly Concentrated Anima:3684827"] = 321,
			["Lingering Anima:1035041"] = 321,
			["Lingering Anima:3684825"] = 321,
			["Mastercrafted Gamesman's Snare"] = 321,
			["Overflowing Anima Cage"] = 321,
			["Prideful Eruption:3528311"] = 321,
			["Rune of Unending Thirst"] = 321,
			["Sanguine Residue"] = 321,
			["Scornful Blast:1357801"] = 321,
			["Shadow Spit:3528310"] = 321,
			["Sin Bolt Volley"] = 321,
			["Sin Bolt"] = 321,
			["Sinheart Volley"] = 321,
			["Sinseeker"] = 321,
			["Siphon Anima:3528307"] = 321,
			["Siphon Blood"] = 321,
			["Soul Flay:3528306"] = 321,
			["Soul Infusion:3528306"] = 321,
			["Spit Blood"] = 321,
			["Subdue:3528312"] = 321,
			["Throw Concoction:236882"] = 321,
			["Tithe Anima"] = 321,
			["Toss Soul Stalker Trap"] = 321,
			["Twilight Restoration:3528307"] = 321,
			["Unconscionable Guilt:3386971"] = 321,
			["Unleashed Anima:236305"] = 321,
			["Unleashing Anima:3528306"] = 321,
			["Vampiric Consumption"] = 321,
			["Venthyr Sinstone"] = 321,
			["Venthyr's Gratitude"] = 321,
			["Visceral Fluid"] = 321,
			["Vulgar Ally"] = 321,
			["Waltz of Blood"] = 321,
			["Wave of Blood"] = 321,
			["Weary Soul:3528307"] = 321,
			["Wicked Bolt"] = 321,
			["Wild Blast:3528310"] = 321,
			["Wracking Pain:3528313"] = 321,
			["Wrathful Invocation"] = 321,
			["Vampiric Drain"] = 321,
			["Vampire Drain"] = 321,
			["Mindgames:3565723"] = 321,

			--! Necromancy  ! Necrolord
			["Soul Fracture:2576087"] = 326,
			["Devour Soul"] = 326,
			["Putrid Burst"] = 326,
			["Stygic Bolt"] = 326,
			["Wing Buffet:2576095"] = 326,
			["Death Burst:2576094"] = 326,
			["Bonedust Brew"] = 326,
			["Abomination Limb"] = 326,
			["Immortality:3528292"] = 326,
			["Unholy Transfusion"] = 326,
			["Soul Leech"] = 326,
			["Summon Skeletons"] = 326,
			["Conqueror's Banner:3578234"] = 326,
			["Adaptive Swarm"] = 326,
			["Revive Champion:298674"] = 326,
			["Deathborne"] = 326,
			["Chimaera's Spittle:3535832"] = 326,
			["Draw Mojo:2576088"] = 326,
			["Necrotic Siphon"] = 326,
			["Ritual of Decay"] = 326,
			["Inevitable Demise"] = 326,
			["Unholy Bulwark:2576096"] = 326,
			["Leech Vitality"] = 326,
			["Spectre Rush"] = 326,
			["Bonecleaver:236363"] = 326,
			["Dark Binding"] = 326,
			["Anima Barrage:2576086"] = 326,
			["Anima Infusion:3528291"] = 326,
			["Attune Hearth Kidneystone"] = 326,
			["Awaken Darkness"] = 326,
			["Bind Soul:2576086"] = 326,
			["Bind the Fallen"] = 326,
			["Blade Guardian's Rune"] = 326,
			["Blighted Breath"] = 326,
			["Bone Shrapnel:460686"] = 326,
			["Bone Spear:3578230"] = 326,
			["Bone Spikes"] = 326,
			["Bone Storm"] = 326,
			["Bonemend"] = 326,
			["Bonestorm"] = 326,
			["Bulwark of Maldraxxus"] = 326,
			["Calcify:254114"] = 326,
			["Call to Zolramus"] = 326,
			["Crystal of Phantasms"] = 326,
			["Crystalline Assault:1519260"] = 326,
			["Death Blast:2576089"] = 326,
			["Death Blast:2576091"] = 326,
			["Death Bolt:2576097"] = 326,
			["Death Rites Ritual"] = 326,
			["Death Tempest"] = 326,
			["Death Winds:3528295"] = 326,
			["Deathbolt Rift"] = 326,
			["Deathbolt Rifts"] = 326,
			["Deathshades"] = 326,
			["Decaying Touch"] = 326,
			["Desecrate"] = 326,
			["Drain Life"] = 326,
			["Harvest Essence"] = 326,
			["Drain Essence"] = 326,
			["Drain Spirit"] = 326,
			["Draw Soul:2576083"] = 326,
			["Draw Soul:2576088"] = 326,
			["Final Harvest"] = 326,
			["Flame of Battle:3536188"] = 326,
			["Fleshcraft"] = 326,
			["Grim Fate"] = 326,
			["Hearth Kidneystone"] = 326,
			["Land of the Dead"] = 326,
			["Lich's Phylactery"] = 326,
			["Maldraxxian Repayment"] = 326,
			["Might of Maldraxxus"] = 326,
			["Necrolord Hearthstone"] = 326,
			["Necrosis"] = 326,
			["Necrotic Aura"] = 326,
			["Necrotic Bolt Volley"] = 326,
			["Necrotic Bolt"] = 326,
			["Necrotic Breath"] = 326,
			["Necrotic Orb"] = 326,
			["Necrotic Spittle"] = 326,
			["Necrotic Staff"] = 326,
			["Ossein Summon"] = 326,
			["Primordial Wave"] = 326,
			["Radiate Pain:2576089"] = 326,
			["Risen Shadows"] = 326,
			["Ritual of Bone"] = 326,
			["Serrated Bone Spike"] = 326,
			["Shadow Well"] = 326,
			["Siphon Anima:2576086"] = 326,
			["Siphon Anima:2576095"] = 326,
			["Siphon Essence"] = 326,
			["Siphon Life"] = 326,
			["Soul Grasp"] = 326,
			["Soul Touch:2576086"] = 326,
			["Soul Touch:2576086"] = 326,
			["Soulblast Nova"] = 326,
			["Soulstorm:3528295"] = 326,
			["Spectral Bolt Volley"] = 326,
			["Spectral Bolt"] = 326,
			["Spinal Tap"] = 326,
			["Summon Skeleton"] = 326,
			["Throw Crystal:1135365"] = 326,
			["Twisting Agony:2576086"] = 326,
			["Unbreakable Guard:3190332"] = 326,
			["Wrath of Zolramus"] = 326,

			--! Curse
			["Touch of the Occult"] = 325,
			["Arugal's Gift"] = 325,
			["Banish"] = 325,
			["Banshee's Curse"] = 325,
			["Big Bad Voodoo"] = 325,
			["Curse of Agony"] = 325,
			["Curse of Blood"] = 325,
			["Curse of Exhaustion"] = 325,
			["Curse of Frailty"] = 325,
			["Curse of Stone"] = 325,
			["Curse of the Dominus"] = 325,
			["Curse of the Runecaster"] = 325,
			["Curse of Tongues"] = 325,
			["Curse of Torment"] = 325,
			["Curse of Weakness"] = 325,
			["Curse"] = 325,
			["Dark Luck"] = 325,
			["Debilitating Smash"] = 325,
			["Diminishing Curse"] = 325,
			["Hex of Weakness"] = 325,
			["Hex"] = 325,
			["Horrifying Bolt"] = 325,
			["Mindwrack"] = 325,
			["Shadow Manacles"] = 325,
			["Shrink"] = 325,
			["Sorrowful Burden"] = 325,
			["Unnerving Wail"] = 325,
			["Voodoo Totem"] = 325,
			["Vulgar Brand"] = 325,
			["Weeping Burden"] = 325,

			--! Dread  ! Fear  ! Sha
			["Cry of Desolation"] = 327,
			["Trembling Roar"] = 327,
			["Mortal Coil"] = 327,
			["Cries of the Tormented"] = 327,
			["Terrifying Slam"] = 327,
			["Primal Howl"] = 327,
			["Withering Roar"] = 327,
			["Meteor Storm:651092"] = 327,
			["Touch of the Ravenclaw"] = 327,
			["Hopelessness"] = 327,
			["Unnerving Howl"] = 327,
			["Gift of G'huun"] = 327,
			["Psychic Terror"] = 327,
			["Psychic Terrors"] = 327,
			["Frightening Roar"] = 327,
			["Bellowing Roar"] = 327,
			["Darkest Secrets:3528308"] = 327,
			["Maddening Roar"] = 327,
			["Touch of the Abyss"] = 327,
			["Terror Gasp"] = 327,
			["Bewildering Gaze:136215"] = 327,
			["Mawfused Orb"] = 327,
			["Mawfused Orbs"] = 327,
			["Mawfocused Orb"] = 327,
			["Mawfocused Orbs"] = 327,
			["Detonate:3528304"] = 327,
			["Explosive Mawsphere"] = 327,
			["Explosive Mawspheres"] = 327,
			["Terror Blast"] = 327,
			["Death Wail"] = 327,
			["Dread Roar"] = 327,
			["Howl from Beyond"] = 327,
			["Focused Loathing"] = 327,
			["Wave of Trepidation"] = 327,
			["Phasing Roar"] = 327,
			["Psychic Horror"] = 327,
			["Fearsome Howl"] = 327,
			["Breath of Fear"] = 327,
			["Consuming Terror"] = 327,
			["Convocation of Grief"] = 327,
			["Cry of Terror"] = 327,
			["Deathly Roar"] = 327,
			["Devouring Howl"] = 327,
			["Dread Strike"] = 327,
			["Eerie Skull"] = 327,
			["Entrap Soul"] = 327,
			["Eye of Dread"] = 327,
			["Eyes of the Empress"] = 327,
			["Fear"] = 327,
			["Fearsome Shriek"] = 327,
			["Horrifying Shout"] = 327,
			["Howl of Terror"] = 327,
			["Manifest Dread"] = 327,
			["Nightmare Scream"] = 327,
			["Ominous Cackle"] = 327,
			["Psychic Scream"] = 327,
			["Reaching Attack"] = 327,
			["Seethe"] = 327,
			["Sha Bolt"] = 327,
			["Sha Breath"] = 327,
			["Sha Energy"] = 327,
			["Sha Smash"] = 327,
			["Sha Spike"] = 327,
			["Sha Touch"] = 327,
			["Smoke Blades"] = 327,
			["Terrifying Chaos"] = 327,
			["Terrifying Roar"] = 327,
			["Terrifying Screech"] = 327,
			["Terror"] = 327,
			["Unleashed Wrath:651092"] = 327,
			["Unleashed:895887"] = 327,
			["Unyielding Terror"] = 327,
			["Crushing Doubt:651087"] = 327,
			["Rejection:651096"] = 327,

			--! Shadowflame
			["Shadow Meteor"] = 36,
			["Accursed Strength"] = 36,
			["Eradicate:460698"] = 36,
			["Shadowflame Immolation"] = 36,
			["Shadow Slagblast"] = 36,
			["Fel Domination"] = 36,
			["Incinerate:136130"] = 36,
			["Eye of Gul'dan"] = 36,
			["Burning Spittle:1357810"] = 36,
			["Shadowflame"] = 36,
			["Shadowflame Bolt"] = 36,
			["Corrupting Flames"] = 36,
			["Demonic Core"] = 36,

			--! Demonic
			["Erupting Shadow:136201"] = 360,
			["Soulstone"] = 360,
			["Summon Demonic Tyrant"] = 360,
			["Shadowfury"] = 360,
			["Shadow Bolt:136197"] = 360,
			["Expulse Shadows"] = 360,
			["Ritual of Shadow"] = 360,
			["Demonic Strikes"] = 360,
			["Shadow Swipe"] = 360,
			["Shadow Nova"] = 360,
			["Dark Hunger"] = 360,
			["Defiled Consecration"] = 360,
			["Shadow Burst"] = 360,
			["Consume Shadows"] = 360,
			["Call of the Legion:132303"] = 360,
			["Ritual of Destruction"] = 360,
			["Summon Lesser Demon"] = 360,
			["Summon Lesser Demons"] = 360,
			["Demonic Burst"] = 360,
			["Convocation of Shadow"] = 360,
			["Dark Gaze"] = 360,
			["Dark Ritual"] = 360,
			["Malevolence"] = 360,
			["Unstable Shadows"] = 360,
			["Abyss Howl"] = 360,
			["Dark Intent"] = 360,
			["Dark Communion:237564"] = 360,
			["Grimoire of Service"] = 360,
			["Grimoire of Servitude"] = 360,
			["Grimoire of Sacrifice"] = 360,
			["Malevolence"] = 360,
			["Malefic Grasp"] = 360,
			["Malefic Rapture"] = 360,
			["Malefic"] = 360,
			["Chaos Wave:607850"] = 360,
			["Chaos Wave:463569"] = 360,
			["Convert Souls"] = 360,
			["Soul Charge"] = 360,
			["Twisted Lightning"] = 360,
			["Demonic Rift"] = 360,
			["Ritual of Summoning"] = 360,
			["Malefic Rapture"] = 360,
			["Twilight Immolate"] = 360,
			["Leyflame Burner"] = 360,
			["Demonic Calling"] = 360,
			["Summon Succubus"] = 360,
			["Summon Felhunter"] = 360,
			["Summon Observer"] = 360,
			["Summon Shivarra"] = 360,
			["Summon Wrathguard"] = 360,
			["Summon Sharazaan"] = 360,
			["Unending Resolve"] = 360,
			["Dreadstalkers"] = 360,
			["Call Dreadstalkers"] = 360,

			--! Shadowfelflame
			["Demon Spit"] = 361,
			["Agent of the All-Seer"] = 361,
			["Create Healthstone"] = 361,
			["Create Soulwell"] = 361,
			["Demonic Gateway"] = 361,
			["Demonic Circle"] = 361,
			["Soulflame:841221"] = 361,
			["Blood Call:134437"] = 361,
			["Hand of Gul'dan"] = 361,
			["Bilescourge Bombers"] = 361,


			--: Resources
			-------------------------
			--! Mana
			["Clearcasting"] = "Mana",
			["Deposit Anima"] = "Anima",
			["Evocation"] = "Mana",
			["Innervate"] = "Mana",
			["Mana Tide Totem"] = "Mana",
			["Potion of Replenishment"] = "Mana",
			["Spot of Tea"] = "Mana",
			["Symbol of Hope"] = "Mana",

			--! Energy
			["Buried Treasure"] = "Energy",

			--! Combo Points
			["Broadside"] = "Combo Points",

			--! Rage
			["Bloodrage"] = "Rage",
			["Battle Trance"] = "Rage",


			--: Other
			-------------------------
			--! Fatigue
			["Weakened Soul"] = 999,
			["Forbearance"] = 999,
			["Exhaustion"] = 999,
			["Sated"] = 999,
			["Temporal Displacement:458224"] = 999,

			

			-------------------------
			--! Mounts
			["Ardenweald Wilderling"] = 805,
			["Autumnal Wilderling"] = 200,
			["Summer Wilderling"] = 8,
			["Winter Wilderling"] = 160,
			["Abyss Worm"] = 32,
			["Acherus Deathcharger"] = 411,
			["Acid Belcher"] = 401,
			["Admiralty Stallion"] = 903,
			["Aerial Unit R-21/X"] = 100,
			["Alabaster Hyena"] = 804,
			["Alabaster Stormtalon"] = 3,
			["Alabaster Thunderwing"] = 3,
			["Albino Drake"] = 124,
			["Amani Battle Bear"] = 5,
			["Amber Ardenmoth"] = 805,
			["Amber Primordial Direhorn"] = 903,
			["Amber Scorpion"] = 810,
			["Amber Shardhide"] = 903,
			["Amethyst Ruinstrider"] = 903,
			["Ankoan Waveray"] = 901,
			["Antoran Charhound"] = 400,
			["Antoran Gloomhound"] = 36,
			["Arboreal Gulper"] = 805,
			["Arcadian War Turtle"] = 12,
			["Arcanist's Manasaber"] = 64,
			["Archmage's Prismatic Disc:1516058"] = 64, -- Arcane
			["Archmage's Prismatic Disc:1517838"] = 400, -- Fire
			["Archmage's Prismatic Disc:1517839"] = 16, -- Frost
			["Argent Charger"] = 2,
			["Argent Hippogryph"] = 3,
			["Argent Warhorse"] = 3,
			["Armored Bloodwing"] = 321,
			["Armored Blue Dragonhawk"] = 80,
			["Armored Blue Windrider"] = 811,
			["Armored Bonehoof Tauralus"] = 40,
			["Armored Brown Bear"] = 903,
			["Armored Chosen Tauralus"] = 40,
			["Armored Frostboar"] = 903,
			["Armored Frostwolf"] = 903,
			["Armored Irontusk"] = 5,
			["Armored Plaguerot Tauralus"] = 40,
			["Armored Razorback"] = 903,
			["Armored Razzashi Raptor"] = 903,
			["Armored Red Dragonhawk"] = 68,
			["Armored Skyscreamer"] = 811,
			["Armored Snowy Gryphon"] = 811,
			["Armored War-Bred Tauralus"] = 40,
			["Ascendant's Aquilon"] = 201,
			["Ascended Skymane"] = 201,
			["Ashen Pandaren Phoenix"] = 802,
			["Ashenvale Chimaera"] = 33,
			["Ashes of Al'ar"] = 68,
			["Ashhide Mushan Beast"] = 903,
			["Astral Cloud Serpent"] = 72,
			["Avenging Felcrusher"] = 2,
			["Azshari Bloatray"] = 901,
			["Azure Cloud Serpent"] = 80,
			["Azure Drake"] = 64,
			["Azure Netherwing Drake"] = 323,
			["Azure Riding Crane"] = 903,
			["Azure Water Strider"] = 901,
			["Azureshell Krolusk"] = 903,
			["Ban-Lu, Grandmaster's Companion"] = 802,
			["Battle Gargon Silessa"] = 903,
			["Battle Gargon Vrednic"] = 903,
			["Battle-Bound Warhound"] = 414,
			["Battle-Hardened Aquilon"] = 201,
			["Battlefield Swarmer"] = 40,
			["Battlelord's Bloodthirsty War Wyrm"] = 105,
			["Beastlord's Irontusk"] = 5,
			["Beastlord's Warwolf"] = 5,
			["Beryl Ruinstrider"] = 903,
			["Beryl Shardhide"] = 903,
			["Big Blizzard Bear"] = 903,
			["Big Love Rocket"] = 661,
			["Biletooth Gnasher"] = 806,
			["Black Battlestrider"] = 100,
			["Black Dragon Turtle"] = 900,
			["Black Drake"] = 12,
			["Black Hawkstrider"] = 903,
			["Black Primal Raptor"] = 903,
			["Black Riding Goat"] = 903,
			["Black Serpent of N'Zoth"] = 324,
			["Black Skeletal Horse"] = 32,
			["Black Stallion"] = 903,
			["Black War Bear"] = 903,
			["Black War Elekk"] = 903,
			["Black War Kodo"] = 903,
			["Black War Mammoth"] = 903,
			["Black War Ram"] = 903,
			["Black War Raptor"] = 903,
			["Black War Steed"] = 903,
			["Black War Tiger"] = 903,
			["Black War Wolf"] = 903,
			["Black Wolf"] = 903,
			["Blackpaw"] = 903,
			["Blacksteel Battleboar"] = 903,
			["Blazing Drake"] = 5,
			["Bleakhoof Ruinstrider"] = 427,
			["Blessed Felcrusher"] = 2,
			["Blisterback Bloodtusk"] = 40,
			["Blonde Riding Yak"] = 903,
			["Bloodbathed Frostbrood Vanquisher"] = 160,
			["Bloodfang Widow"] = 101,
			["Bloodflank Charger"] = 903,
			["Bloodgorged Crawg"] = 101,
			["Bloodgorged Hunter"] = 16,
			["Bloodhoof Bull"] = 903,
			["Bloodthirsty Dreadwing"] = 101,
			["Blue Dragon Turtle"] = 900,
			["Blue Dragonhawk"] = 80,
			["Blue Drake"] = 64,
			["Blue Hawkstrider"] = 903,
			["Blue Marsh Hopper"] = 900,
			["Blue Mechanostrider"] = 100,
			["Blue Proto-Drake"] = 24,
			["Blue Qiraji Battle Tank"] = 32,
			["Blue Riding Nether Ray"] = 811,
			["Blue Shado-Pan Riding Tiger"] = 903,
			["Blue Skeletal Horse"] = 32,
			["Blue Wind Rider"] = 811,
			["Bone-White Primal Raptor"] = 903,
			["Bonehoof Tauralus"] = 40,
			["Bonesewn Fleshroc"] = 40,
			["Bound Shadehound"] = 411,
			["Brawler's Burly Basilisk"] = 903,
			["Brawler's Burly Mushan Beast"] = 903,
			["Breezestrider Stallion"] = 903,
			["Brilliant Direbeak"] = 900,
			["Brinedeep Bottom-Feeder"] = 801,
			["Bristling Hellboar"] = 101,
			["Broken Highland Mustang"] = 903,
			["Bronze Drake"] = 640,
			["Brown Dragon Turtle"] = 900,
			["Brown Elekk"] = 903,
			["Brown Horse"] = 903,
			["Brown Kodo"] = 903,
			["Brown Ram"] = 903,
			["Brown Riding Camel"] = 804,
			["Brown Riding Goat"] = 903,
			["Brown Skeletal Horse"] = 32,
			["Brown Wolf"] = 903,
			["Bruce"] = 901,
			["Bulbous Necroray"] = 410,
			["Callow Flayedwing"] = 40,
			["Captured Swampstalker"] = 811,
			["Caravan Hyena"] = 804,
			["Cartel Master's Gearglider"] = 203,
			["Celestial Steed"] = 72,
			["Cenarion War Hippogryph"] = 811,
			["Cerulean Ruinstrider"] = 903,
			["Challenger's War Yeti"] = 903,
			["Champion's Treadblade"] = 100,
			["Chauffeured Mechano-Hog"] = 100,
			["Chestnut Mare"] = 903,
			["Child of Torcali"] = 903,
			["Chittering Animite"] = 413,
			["Chosen Tauralus"] = 40,
			["Cindermane Charger"] = 400,
			["Cloudwing Hippogryph"] = 811,
			["Clutch of Ha-Li"] = 811,
			["Clutch of Ji-Kun"] = 811,
			["Coalfist Gronnling"] = 903,
			["Cobalt Netherwing Drake"] = 323,
			["Cobalt Primordial Direhorn"] = 903,
			["Cobalt Pterrordax"] = 811,
			["Cobalt Riding Talbuk"] = 903,
			["Cobalt War Talbuk"] = 903,
			["Colossal Slaughterclaw"] = 40,
			["Conqueror's Scythemaw"] = 903,
			["Core Hound"] = 12,
			["Corridor Creeper"] = 411,
			["Corrupted Dreadwing"] = 361,
			["Corrupted Fire Hawk"] = 36,
			["Court Sinrunner"] = 321,
			["Craghorn Chasm-Leaper"] = 903,
			["Creeping Carpet"] = 68,
			["Crimson Cloud Serpent"] = 5,
			["Crimson Deathcharger"] = 411,
			["Crimson Pandaren Phoenix"] = 802,
			["Crimson Primal Direhorn"] = 903,
			["Crimson Shardhide"] = 903,
			["Crimson Slavermaw"] = 401,
			["Crimson Tidestallion"] = 801,
			["Crimson Water Strider"] = 901,
			["Crusader's Direhorn"] = 2,
			["Crypt Gargon"] = 903,
			["Dapple Gray"] = 903,
			["Dark Iron Core Hound"] = 12,
			["Dark Phoenix"] = 320,
			["Dark Riding Talbuk"] = 903,
			["Dark War Talbuk"] = 903,
			["Darkflutter Ardenmoth"] = 805,
			["Darkmaul"] = 903,
			["Darkmoon Dancing Bear"] = 903,
			["Darkmoon Dirigible"] = 100,
			["Darkspear Raptor"] = 903,
			["Darkspore Mana Ray"] = 328,
			["Darkwarren Hardshell"] = 805,
			["Darkwater Skate"] = 801,
			["Darnassian Nightsaber"] = 903,
			["Dauntless Duskrunner"] = 33,
			["Dazar'alor Windreaver"] = 811,
			["Deathlord's Vilebrood Vanquisher:1518275"] = 40,
			["Deathlord's Vilebrood Vanquisher:1580440"] = 321, -- Blood
			["Deathlord's Vilebrood Vanquisher:1580441"] = 16, -- Frost
			["Deathlord's Vilebrood Vanquisher:1580442"] = 40, -- Unholy
			["Deathtusk Felboar"] = 401,
			["Deepcoral Snapdragon"] = 901,
			["Depleted-Kyparium Rocket"] = 100,
			["Desire's Battle Gargon"] = 903,
			["Dire Wolf"] = 903,
			["Domesticated Razorback"] = 903,
			["Drake of the East Wind"] = 800,
			["Drake of the Four Winds"] = 800,
			["Drake of the North Wind"] = 800,
			["Drake of the South Wind"] = 800,
			["Drake of the West Wind"] = 800,
			["Dread Raven"] = 6,
			["Dreadsteed"] = greenfire and 401 or 402,
			["Dreamlight Runestag"] = 805,
			["Dune Scavenger"] = 804,
			["Duskflutter Ardenmoth"] = 805,
			["Dusklight Razorwing"] = 811,
			["Dusky Waycrest Gryphon"] = 811,
			["Dustmane Direwolf"] = 903,
			["Dusty Rockhide"] = 903,
			["Ebon Gryphon"] = 811,
			["Eclipse Dragonhawk"] = 68,
			["Elusive Quickhoof"] = 804,
			["Elysian Aquilon"] = 201,
			["Emerald Drake"] = 8,
			["Emerald Hippogryph"] = 8,
			["Emerald Pandaren Phoenix"] = 802,
			["Emerald Raptor"] = 903,
			["Enchanted Dreamlight Runestag"] = 805,
			["Enchanted Fey Dragon"] = 805,
			["Enchanted Shadeleaf Runestag"] = 805,
			["Enchanted Wakener's Runestag"] = 805,
			["Enchanted Winterborn Runestag"] = 805,
			["Endmire Flyer"] = 413,
			["Ensorcelled Everwyrm"] = 201,
			["Eternal Phalynx of Courage"] = 201,
			["Eternal Phalynx of Humility"] = 201,
			["Eternal Phalynx of Loyalty"] = 96,
			["Eternal Phalynx of Purity"] = 201,
			["Exodar Elekk"] = 903,
			["Expedition Bloodswarmer"] = 101,
			["Experiment 12-B"] = 124,
			["Explorer's Dunetrekker"] = 804,
			["Explorer's Jungle Hopper"] = 100,
			["Fabious"] = 801,
			["Fallen Charger"] = 411,
			["Fathom Dweller"] = 324,
			["Felblaze Infernal"] = 401,
			["Felfire Hawk"] = 401,
			["Felglow Mana Ray"] = 401,
			["Felsaber"] = 401,
			["Felsteed"] = greenfire and 401 or 402,
			["Felsteel Annihilator"] = 127,
			["Fierce Razorwing"] = 811,
			["Fiery Warhorse"] = 401,
			["Fireplume Phoenix"] = 68,
			["Flametalon of Alysrazor"] = 400,
			["Flameward Hippogryph"] = 400,
			["Flying Carpet"] = 64,
			["Flying Machine"] = 100,
			["Foresworn Aquilon"] = 96,
			["Forsaken Warhorse"] = 32,
			["Fossilized Raptor"] = 803,
			["Frenzied Feltalon"] = 401,
			["Frightened Kodo"] = 903,
			["Frostplains Battleboar"] = 903,
			["Frostshard Infernal"] = 16,
			["Frostwolf Snarler"] = 903,
			["Frosty Flying Carpet"] = 80,
			["G.M.O.D."] = 204,
			["Garn Nighthowl"] = 903,
			["Garn Steelmaw"] = 903,
			["Garnet Razorwing"] = 811,
			["Geosynchronous World Spinner"] = 100,
			["Giant Coldsnout"] = 903,
			["Gilded Prowler"] = 811,
			["Gilded Ravasaur"] = 200,
			["Glacial Tidestorm"] = 24,
			["Glorious Felcrusher"] = 2,
			["Gnomeregan Mechanostrider"] = 100,
			["Goblin Trike"] = 100,
			["Goblin Turbo-Trike"] = 100,
			["Golden Cloud Serpent"] = 6,
			["Golden Gryphon"] = 811,
			["Golden King"] = 903,
			["Golden Primal Direhorn"] = 903,
			["Golden Riding Crane"] = 903,
			["Goldenmane"] = 903,
			["Gorespine"] = 40,
			["Gorestrider Gronnling"] = 903,
			["Grand Armored Gryphon"] = 811,
			["Grand Armored Wyvern"] = 811,
			["Grand Black War Mammoth"] = 903,
			["Grand Expedition Yak"] = 903,
			["Grand Gryphon"] = 811,
			["Grand Ice Mammoth"] = 903,
			["Grand Wyvern"] = 811,
			["Gravestone Battle Gargon"] = 903,
			["Gray Elekk"] = 903,
			["Gray Kodo"] = 903,
			["Gray Ram"] = 903,
			["Great Black Dragon Turtle"] = 900,
			["Great Blue Dragon Turtle"] = 900,
			["Great Blue Elekk"] = 903,
			["Great Brewfest Kodo"] = 903,
			["Great Brown Dragon Turtle"] = 900,
			["Great Brown Kodo"] = 903,
			["Great Gray Kodo"] = 903,
			["Great Green Dragon Turtle"] = 900,
			["Great Green Elekk"] = 903,
			["Great Greytusk"] = 903,
			["Great Northern Elderhorn"] = 903,
			["Great Purple Dragon Turtle"] = 900,
			["Great Purple Elekk"] = 903,
			["Great Red Dragon Turtle"] = 900,
			["Great Red Elekk"] = 903,
			["Great Sea Ray"] = 801,
			["Great White Kodo"] = 903,
			["Green Dragon Turtle"] = 900,
			["Green Marsh Hopper"] = 900,
			["Green Mechanostrider"] = 100,
			["Green Primal Raptor"] = 903,
			["Green Proto-Drake"] = 8,
			["Green Qiraji Battle Tank"] = 324,
			["Green Riding Nether Ray"] = 811,
			["Green Shado-Pan Riding Tiger"] = 903,
			["Green Skeletal Warhorse"] = 32,
			["Green Wind Rider"] = 811,
			["Grey Riding Camel"] = 804,
			["Grey Riding Yak"] = 903,
			["Grinning Reaver"] = 8,
			["Grove Defiler"] = 412,
			["Grove Warden"] = 805,
			["Gruesome Flayedwing"] = 40,
			["Hand of Bahmethra"] = 360,
			["Hand of Hrestimorak"] = 48,
			["Hand of Nilganihmaht"] = 411,
			["Hand of Salaranga"] = 411,
			["Harvester's Dredwing"] = 321,
			["Headless Horseman's Mount"] = 401,
			["Heart of the Aspects"] = 2,
			["Hearthsteed"] = 201,
			["Heavenly Azure Cloud Serpent"] = 201,
			["Heavenly Crimson Cloud Serpent"] = 66,
			["Heavenly Golden Cloud Serpent"] = 2,
			["Heavenly Onyx Cloud Serpent"] = 203,
			["Hellfire Infernal"] = 402,
			["High Priest's Lightsworn Seeker:1509824"] = 2,
			["High Priest's Lightsworn Seeker:1518632"] = 201, -- Discipline
			["High Priest's Lightsworn Seeker:1518633"] = 2, -- Holy
			["High Priest's Lightsworn Seeker:1518634"] = 320, -- Shadow
			["Highland Mustang"] = 903,
			["Highlord's Golden Charger"] = 2,
			["Highlord's Valorous Charger"] = 2,
			["Highlord's Vengeful Charger"] = 2,
			["Highlord's Vigilant Charger"] = 2,
			["Highmountain Elderhorn"] = 903,
			["Highmountain Thunderhoof"] = 903,
			["Highwind Darkmane"] = 811,
			["Hogrus, Swine of Good Fortune"] = 902,
			["Honeyback Harvester"] = 8,
			["Hopecrusher Gargon"] = 903,
			["Horrid Dredwing"] = 321,
			["Hulking Deathroc"] = 40,
			["Huntmaster's Dire Wolfhawk"] = 811,
			["Huntmaster's Fierce Wolfhawk"] = 811,
			["Huntmaster's Loyal Wolfhawk"] = 811,
			["Ice Mammoth"] = 903,
			["Icebound Frostbrood Vanquisher"] = 160,
			["Illidari Felstalker"] = 32,
			["Imperial Quilen"] = 902,
			["Infernal Direwolf"] = 401,
			["Infested Necroray"] = 414,
			["Infinite Timereaver"] = 411,
			["Inkscale Deepseeker"] = 801,
			["Inquisition Gargon"] = 903,
			["Invincible"] = 323,
			["Iron Skyreaver"] = 5,
			["Ironbound Proto-Drake"] = 17,
			["Ironbound Wraithcharger"] = 720,
			["Ironclad Frostclaw"] = 903,
			["Ironforge Ram"] = 903,
			["Ironhoof Destroyer"] = 5,
			["Ironside Warwolf"] = 903,
			["Island Thunderscale"] = 800,
			["Ivory Cloud Serpent"] = 66,
			["Ivory Hawkstrider"] = 903,
			["Jade Cloud Serpent"] = 902,
			["Jade Pandaren Kite"] = 802,
			["Jade Panther"] = 815,
			["Jade Primordial Direhorn"] = 902,
			["Jeweled Onyx Panther"] = 819,
			["Junkheap Drifter"] = 100,
			["Kaldorei Nightsaber"] = 903,
			["Kor'kron Annihilator"] = 906,
			["Kor'kron Juggernaut"] = 100,
			["Kor'kron War Wolf"] = 903,
			["Kul Tiran Charger"] = 903,
			["Lambent Mana Ray"] = 328,
			["Leaping Veinseeker"] = 101,
			["Leyfeather Hippogryph"] = 126,
			["Leywoven Flying Carpet"] = 126,
			["Life-Binder's Handmaiden"] = 66,
			["Lightforged Felcrusher"] = 2,
			["Lightforged Warframe"] = 200,
			["Lil' Donkey"] = 903,
			["Llothien Prowler"] = 903,
			["Long-Forgotten Hippogryph"] = 811,
			["Lord of the Corpseflies"] = 40,
			["Loyal Gorger"] = 413,
			["Lucid Nightmare"] = 320,
			["Lucky Yun"] = 902,
			["Luminous Starseeker"] = 72,
			["Lurid Bloodtusk"] = 40,
			["Maddened Chaosrunner"] = 127,
			["Maelie, the Wanderer"] = 661,
			["Wandering Arden Doe"] = 661,
			["Mag'har Direwolf"] = 903,
			["Magnificent Flying Carpet"] = 68,
			["Mail Muncher"] = 324,
			["Maldraxxian Corpsefly"] = 40,
			["Malevolent Drone"] = 324,
			["Marrowfang"] = 40,
			["Mawsworn Charger"] = 48,
			["Mawsworn Soulhunter"] = 411,
			["Meat Wagon"] = 101,
			["Mecha-Mogul Mk2"] = 100,
			["Mechacycle Model W"] = 100,
			["Mechagon Mechanostrider"] = 100,
			["Mechagon Peacekeeper"] = 100,
			["Mechanized Lumber Extractor"] = 100,
			["Mekgineer's Chopper"] = 100,
			["Midnight"] = 402,
			["Mighty Caravan Brutosaur"] = 903,
			["Mimiron's Head"] = 100,
			["Minion of Grumpus"] = 903,
			["Mollie"] = 804,
			["Mosshide Riverwallow"] = 901,
			["Mottled Meadowstomper"] = 903,
			["Mountain Horse"] = 903,
			["Mudback Riverbeast"] = 901,
			["Mystic Runesaber"] = 126,
			["Nazjatar Blood Serpent"] = 321,
			["Netherlord's Accursed Wrathsteed"] = 320,
			["Netherlord's Brimstone Wrathsteed"] = 402,
			["Netherlord's Chaotic Wrathsteed"] = 127,
			["Nightborne Manasaber"] = 126,
			["Ny'alotha Allseer"] = 324,
			["Obsidian Krolusk"] = 819,
			["Obsidian Nightwing"] = 819,
			["Obsidian Worldbreaker"] = 12,
			["Ochre Skeletal Warhorse"] = 32,
			["Onyx Cloud Serpent"] = 819,
			["Onyx Netherwing Drake"] = 323,
			["Onyxian Drake"] = 12,
			["Orgrimmar Interceptor"] = 100,
			["Orgrimmar Wolf"] = 903,
			["Pale Acidmaw"] = 805,
			["Pale Thorngrazer"] = 903,
			["Palehide Direhorn"] = 903,
			["Pandaren Kite"] = 802,
			["Pestilent Necroray"] = 40,
			["Phalynx of Courage"] = 201,
			["Phalynx of Humility"] = 201,
			["Phalynx of Loyalty"] = 96,
			["Phalynx of Purity"] = 201,
			["Phosphorescent Stone Drake"] = 813,
			["Pinto"] = 903,
			["Plaguerot Tauralus"] = 40,
			["Pond Nettle"] = 324,
			["Predatory Bloodgazer"] = 101,
			["Predatory Plagueroc"] = 40,
			["Prestigious Azure Courser"] = 903,
			["Prestigious Bronze Courser"] = 5,
			["Prestigious Forest Courser"] = 900,
			["Prestigious Ivory Courser"] = 201,
			["Prestigious Royal Courser"] = 33,
			["Prestigious War Steed"] = 903,
			["Prestigious War Wolf"] = 903,
			["Priestess' Moonsaber"] = 72,
			["Primal Flamesaber"] = 400,
			["Proudmoore Sea Scout"] = 811,
			["Pureblood Fire Hawk"] = 400,
			["Pureheart Courser"] = 201,
			["Purple Dragon Turtle"] = 900,
			["Purple Elekk"] = 903,
			["Purple Hawkstrider"] = 903,
			["Purple Netherwing Drake"] = 323,
			["Purple Riding Nether Ray"] = 811,
			["Purple Skeletal Warhorse"] = 32,
			["Qinsho's Eternal Hound"] = 902,
			["Quel'dorei Steed"] = 802,
			["Rajani Warserpent"] = 800,
			["Rampaging Mauler"] = 413,
			["Rampart Screecher"] = 101,
			["Ran Riding Talbuk"] = 903,
			["Ratstallion"] = 903,
			["Raven Lord"] = 6,
			["Red Dragon Turtle"] = 900,
			["Red Dragonhawk"] = 68,
			["Red Drake"] = 5,
			["Red Flying Cloud"] = 811,
			["Red Hawkstrider"] = 903,
			["Red Mechanostrider"] = 100,
			["Red Primal Raptor"] = 903,
			["Red Proto-Drake"] = 5,
			["Red Qiraji Battle Tank"] = 324,
			["Red Riding Nether Ray"] = 811,
			["Red Shado-Pan Riding Tiger"] = 903,
			["Red Skeletal Horse"] = 32,
			["Red Skeletal Warhorse"] = 32,
			["Regal Corpsefly"] = 40,
			["Regal Riding Crane"] = 903,
			["Ren's Stalwart Hound"] = 902,
			["Riddler's Mind-Worm"] = 906,
			["Riding Turtle"] = 801,
			["Risen Mare"] = 32,
			["Rivendare's Deathcharger"] = 32,
			["Rocktusk Battleboar"] = 903,
			["Royal Snapdragon"] = 901,
			["Ruby Panther"] = 818,
			["Rubyshell Krolusk"] = 903,
			["Russet Ruinstrider"] = 903,
			["Rustbolt Resistor"] = 100,
			["Rusted Proto-Drake"] = 804,
			["Rusty Mechanocrawler"] = 100,
			["Sable Ruinstrider"] = 903,
			["Saltwater Seahorse"] = 801,
			["Sanctum Gloomcharger"] = 32,
			["Sandstone Drake"] = 816,
			["Sandy Nightsaber"] = 903,
			["Sapphire Panther"] = 814,
			["Sapphire Riverbeast"] = 901,
			["Sapphire Skyblazer"] = 600,
			["Scintillating Mana Ray"] = 200,
			["Scrapforged Mechaspider"] = 100,
			["Sea Turtle"] = 801,
			["Seabraid Stallion"] = 903,
			["Shackled Ur'zul"] = 414,
			["Shadeleaf Runestag"] = 805,
			["Shadowbarb Drone"] = 324,
			["Shadowblade's Baneful Omen"] = 33,
			["Shadowblade's Crimson Omen"] = 33,
			["Shadowblade's Lethal Omen"] = 33,
			["Shadowblade's Murderous Omen"] = 33,
			["Shadowhide Pearltusk"] = 903,
			["Shadowmane Charger"] = 903,
			["Sharkbait"] = 811,
			["Shimmermist Runner"] = 805,
			["Shu-Zen, the Divine Sentinel"] = 2,
			["Silent Glider"] = 901,
			["Silky Shimmermoth"] = 805,
			["Siltwing Albatross"] = 811,
			["Silver Covenant Hippogryph"] = 811,
			["Silver Riding Nether Ray"] = 811,
			["Silver Riding Talbuk"] = 903,
			["Silver War Talbuk"] = 903,
			["Silvermoon Hawkstrider"] = 903,
			["Silvertip Dredwing"] = 101,
			["Silverwind Larion"] = 811,
			["Sinfall Gargon"] = 903,
			["Sinrunner Blanchy"] = 321,
			["Sintouched Deathwalker"] = 411,
			["Skullripper"] = 903,
			["Sky Golem"] = 100,
			["Slate Primordial Direhorn"] = 903,
			["Slayer's Felbroken Shrieker"] = 127,
			["Slime Serpent"] = 410,
			["Smoky Charger"] = 903,
			["Smoky Direwolf"] = 903,
			["Smoldering Ember Wyrm"] = 400,
			["Snapback Scuttler"] = 901,
			["Snapdragon Kelpstalker"] = 901,
			["Snowfeather Hunter"] = 17,
			["Snowstorm"] = 16,
			["Snowy Gryphon"] = 811,
			["Soaring Razorwing"] = 811,
			["Soaring Skyterror"] = 811,
			["Solar Spirehawk"] = 6,
			["Son of Galleon"] = 903,
			["Soulbound Gloomcharger"] = 326,
			["Soultwisted Deathwalker"] = 326,
			["Spawn of Galakras"] = 5,
			["Spawn of Horridon"] = 903,
			["Spectral Gryphon"] = 720,
			["Spectral Pterrorwing"] = 720,
			["Spectral Steed"] = 720,
			["Spectral Wind Rider"] = 720,
			["Spectral Wolf"] = 720,
			["Spinemaw Gladechewer"] = 805,
			["Spirit of Eche'ro"] = 720,
			["Spotted Frostsaber"] = 903,
			["Springfur Alpaca"] = 804,
			["Squawks"] = 811,
			["Squeakers, the Trickster"] = 802,
			["Starcursed Voidstrider"] = 320,
			["Steamscale Incinerator"] = 100,
			["Steelbound Devourer"] = 401,
			["Stonehide Elderhorn"] = 903,
			["Stormpike Battle Charger"] = 903,
			["Stormpike Battle Ram"] = 903,
			["Stormsong Coastwatcher"] = 811,
			["Stormwind Skychaser"] = 100,
			["Stormwind Steed"] = 903,
			["Striped Dawnsaber"] = 903,
			["Striped Frostsaber"] = 903,
			["Striped Nightsaber"] = 903,
			["Subdued Seahorse"] = 801,
			["Summon Charger"] = 2,
			["Summon Chauffeur"] = 100,
			["Summon Darkforge Ram"] = 2,
			["Summon Dawnforge Ram"] = 2,
			["Summon Exarch's Elekk"] = 2,
			["Summon Great Exarch's Elekk"] = 2,
			["Summon Thalassian Charger"] = 2,
			["Summon Thalassian Warhorse"] = 2,
			["Summon Warhorse"] = 2,
			["Sundancer"] = 3,
			["Sunhide Gronnling"] = 903,
			["Sunreaver Dragonhawk"] = 68,
			["Sunreaver Hawkstrider"] = 903,
			["Sunstone Panther"] = 816,
			["Surf Jelly"] = 324,
			["Swift Albino Raptor"] = 903,
			["Swift Blue Gryphon"] = 811,
			["Swift Blue Ratpor"] = 903,
			["Swift Breezestrider"] = 903,
			["Swift Brewfest Ram"] = 903,
			["Swift Brown Ram"] = 903,
			["Swift Brown Steed"] = 903,
			["Swift Brown Wolf"] = 903,
			["Swift Burgundy Wolf"] = 903,
			["Swift Forest Strider"] = 903,
			["Swift Frostsaber"] = 903,
			["Swift Frostwolf"] = 903,
			["Swift Gloomhoof"] = 96,
			["Swift Gray Ram"] = 903,
			["Swift Gray Steed"] = 903,
			["Swift Gray Wolf"] = 903,
			["Swift Green Gryphon"] = 811,
			["Swift Green Hawkstrider"] = 903,
			["Swift Green Mechanostrider"] = 100,
			["Swift Green Wind Rider"] = 811,
			["Swift Lovebird"] = 661,
			["Swift Mistsaber"] = 903,
			["Swift Moonsaber"] = 903,
			["Swift Mountain Horse"] = 903,
			["Swift Olive Raptor"] = 903,
			["Swift Orange Raptor"] = 903,
			["Swift Palomino"] = 903,
			["Swift Pink Hawkstrider"] = 903,
			["Swift Purple Gryphon"] = 811,
			["Swift Purple Hawkstrider"] = 903,
			["Swift Purple Raptor"] = 903,
			["Swift Purple Wind Rider"] = 811,
			["Swift Red Gryphon"] = 811,
			["Swift Red Hawkstrider"] = 903,
			["Swift Red Wind Rider"] = 811,
			["Swift Springstrider"] = 903,
			["Swift Stormsaber"] = 903,
			["Swift Timber Wolf"] = 903,
			["Swift Violet Ram"] = 903,
			["Swift Warstrider"] = 903,
			["Swift White Hawkstrider"] = 903,
			["Swift White Mechanostrider"] = 100,
			["Swift White Ram"] = 903,
			["Swift White Steed"] = 903,
			["Swift Windsteed"] = 811,
			["Swift Yellow Mechanostrider"] = 100,
			["Swift Yellow Wind Rider"] = 811,
			["Swift Zhevra"] = 903,
			["Swift Zulian Panther"] = 903,
			["Sylverian Dreamer"] = 805,
			["Tamed Mauler"] = 413,
			["Tan Riding Camel"] = 804,
			["Tan War Talbuk"] = 903,
			["Tawny Wind Rider"] = 811,
			["Tazavesh Gearglider"] = 203,
			["Teldrassil Hippogryph"] = 811,
			["Terrified Pack Mule"] = 903,
			["The Dreadwake"] = 323,
			["The Hivemind"] = 320,
			["Thunder Bluff Kodo"] = 903,
			["Thundering August Cloud Serpent"] = 6,
			["Thundering Cobalt Cloud Serpent"] = 80,
			["Thundering Jade Cloud Serpent"] = 902,
			["Thundering Onyx Cloud Serpent"] = 819,
			["Thundering Ruby Cloud Serpent"] = 5,
			["Timber Wolf"] = 903,
			["Time-Lost Proto-Drake"] = 640,
			["Tomb Stalker"] = 414,
			["Trained Icehoof"] = 903,
			["Trained Meadowstomper"] = 903,
			["Trained Riverwallow"] = 901,
			["Trained Rocktusk"] = 903,
			["Trained Silverpelt"] = 903,
			["Trained Snarler"] = 903,
			["Traveler's Tundra Mammoth"] = 903,
			["Tundra Icehoof"] = 903,
			["Turbo-Charged Flying Machine"] = 100,
			["Turbostrider"] = 100,
			["Turquoise Raptor"] = 903,
			["Twilight Avenger"] = 34,
			["Twilight Drake"] = 34,
			["Twilight Harbinger"] = 34,
			["Tyrael's Charger"] = 201,
			["Ultramarine Qiraji Battle Tank"] = 324,
			["Umber Nightsaber"] = 903,
			["Umber Ruinstrider"] = 903,
			["Umbral Scythehorn"] = 413,
			["Uncorrupted Voidwing"] = 320,
			["Undercity Plaguebat"] = 414,
			["Underrot Crawg"] = 101,
			["Undying Darkhound"] = 32,
			["Unpainted Mechanostrider"] = 100,
			["Unshackled Waveray"] = 901,
			["Valarjar Stormwing"] = 800,
			["Vashj'ir Seahorse"] = 801,
			["Vengeance"] = 411,
			["Venomhide Ravasaur"] = 903,
			["Veridian Netherwing Drake"] = 323,
			["Vibrant Flutterwing"] = 805,
			["Vibrant Mana Ray"] = 328,
			["Vicious Black Bonesteed"] = 36,
			["Vicious Black Warsaber"] = 903,
			["Vicious Gilnean Warhorse"] = 903,
			["Vicious Kaldorei Warsaber"] = 903,
			["Vicious Skeletal Warhorse"] = 414,
			["Vicious War Basilisk"] = 903,
			["Vicious War Bear"] = 903,
			["Vicious War Clefthoof"] = 903,
			["Vicious War Elekk"] = 903,
			["Vicious War Fox"] = 903,
			["Vicious War Gorm"] = 905,
			["Vicious War Kodo"] = 903,
			["Vicious War Lion"] = 903,
			["Vicious War Mechanostrider"] = 100,
			["Vicious War Ram"] = 903,
			["Vicious War Raptor"] = 903,
			["Vicious War Riverbeast"] = 901,
			["Vicious War Scorpion"] = 903,
			["Vicious War Spider"] = ZA.AH(101, 906),
			["Vicious War Steed"] = 903,
			["Vicious War Trike"] = 100,
			["Vicious War Turtle"] = 900,
			["Vicious War Wolf"] = 903,
			["Vicious Warstrider"] = 903,
			["Vicious White Bonesteed"] = 18,
			["Vicious White Warsaber"] = 18,
			["Vile Fiend"] = 806,
			["Violet Netherwing Drake"] = 323,
			["Violet Pandaren Phoenix"] = 802,
			["Violet Proto-Drake"] = 5,
			["Violet Raptor"] = 903,
			["Violet Spellwing"] = 64,
			["Viridian Phase-Hunter"] = 323,
			["Viridian Sharptalon"] = 8,
			["Vitreous Stone Drake"] = 808,
			["Voidtalon of the Dark Star"] = 36,
			["Volcanic Stone Drake"] = 818,
			["Voldunai Dunescraper"] = 811,
			["Voracious Gorger"] = 413,
			["Vulpine Familiar"] = 805,
			["Wakener's Runestag"] = 805,
			["Wandering Ancient"] = 8,
			["War-Bred Tauralus"] = 40,
			["Warforged Nightmare"] = 402,
			["Warlord's Deathwheel"] = 100,
			["Warsong Direfang"] = 903,
			["Warstitched Darkhound"] = 32,
			["Waste Marauder"] = 804,
			["Wastewander Skyterror"] = 804,
			["White Kodo"] = 903,
			["White Polar Bear"] = 903,
			["White Ram"] = 903,
			["White Riding Camel"] = 804,
			["White Riding Goat"] = 903,
			["White Riding Talbuk"] = 903,
			["White Skeletal Warhorse"] = 18,
			["White War Talbuk"] = 903,
			["Wicked Swarmer"] = 324,
			["Wild Dreamrunner"] = 8,
			["Wild Glimmerfur Prowler"] = 902,
			["Wild Goretusk"] = 903,
			["Wild Hunt Legsplitter"] = 805,
			["Wildseed Cradle"] = 805,
			["Winged Guardian"] = 202,
			["Winged Steed of the Ebon Blade"] = 411,
			["Winterborn Runestag"] = 805,
			["Winterspring Frostsaber"] = 903,
			["Witherbark Direwing"] = 101,
			["Witherhide Cliffstomper"] = 903,
			["Wonderwing 2.0"] = 100,
			["Wooly Mammoth"] = 903,
			["Wriggling Parasite"] = 324,
			["X-53 Touring Rocket"] = 100,
			["X-995 Mechanocat"] = 100,
			["Xinlao"] = 902,
			["Xiwyllag ATV"] = 100,
			["Yellow Marsh Hopper"] = 900,
			["Yellow Qiraji Battle Tank"] = 324,
			["Yu'lei, Daughter of Jade"] = 902,
			["Zandalari Direhorn"] = 903,
		}

		if class and class == "SHAMAN" and spec == 1 then
			ZA.CastSchoolByName["Farseer's Raging Tempest"] = 400
		elseif class and class == "SHAMAN" and spec == 3 then
			ZA.CastSchoolByName["Farseer's Raging Tempest"] = 24
		end

		ZA.CastSchoolByIcon = {
			-- Azerite
			[1869493] = 204, -- Heart of Azeroth
		}

		ZA.CastSchoolBySpellID = {
			-- Quest
			[106872] = 327,
			[145949] = 400,
			[156087] = 323,
			[178335] = 202,
			[178787] = 361,
			[179071] = 110,
			[180720] = 202,
			[180737] = 800,
			[180935] = 10,
			[182592] = 321,
			[183124] = 2,
			[185071] = 202,
			[186253] = 96,
			[186608] = 803,
			[188432] = 202,
			[192535] = 100,
			[192924] = 202,
			[192952] = 107,
			[193017] = 803,
			[193269] = 126,
			[193277] = 126,
			[193278] = 126,
			[194133] = 202,
			[198335] = 323,
			[198424] = 323,
			[198444] = 323,
			[199336] = 96,
			[200228] = 401,
			[203156] = 202,
			[204542] = 8,
			[207493] = 34,
			[207501] = 107,
			[210773] = 801,
			[211546] = 646,
			[212782] = 126,
			[213485] = 808,
			[214482] = 813,
			[215749] = 72,
			[216693] = 66,
			[219920] = 127,
			[220037] = 800,
			[225023] = 64,
			[225025] = 64,
			[225026] = 64,
			[22562] = 801,
			[230266] = 202,
			[236262] = 202,
			[240473] = 360,
			[243833] = 321,
			[245030] = 400,
			[248345] = 2,
			[248906] = 202,
			[251746] = 800,
			[252295] = 2,
			[255460] = 2,
			[257795] = 801,
			[262446] = 325,
			[300203] = 204,
			[300656] = 2,
			[305716] = 100,
			[308080] = 321,
			[308244] = 201,
			[308671] = 201,
			[308754] = 201,
			[309343] = 803,
			[310105] = 805,
			[310984] = 201,
			[311385] = 72,
			[311387] = 903,
			[311655] = 806,
			[311670] = 5,
			[311678] = 8,
			[311681] = 8,
			[311682] = 100,
			[311703] = 8,
			[311704] = 8,
			[311710] = 806,
			[311721] = 805,
			[311749] = 8,
			[311873] = 802,
			[311897] = 8,
			[312394] = 33,
			[312448] = 201,
			[312493] = 201,
			[312692] = 600,
			[313107] = 800,
			[313712] = 8,
			[314724] = 805,
			[314846] = 321,
			[315010] = 805,
			[315060] = 661,
			[315075] = 321,
			[315611] = 806,
			[315688] = 806,
			[315755] = 321,
			[316939] = 720,
			[316947] = 201,
			[317081] = 33,
			[317355] = 326,
			[318107] = 201,
			[318340] = 201,
			[319047] = 600,
			[319184] = 2,
			[319782] = 201,
			[319840] = 201,
			[319892] = 326,
			[320109] = 720,
			[320245] = 201,
			[320728] = 201,
			[321072] = 8,
			[321826] = 321,
			[322065] = 805,
			[322334] = 201,
			[323876] = 806,
			[323959] = 101,
			[323973] = 201,
			[323978] = 201,
			[323980] = 201,
			[324003] = 321,
			[324054] = 201,
			[324126] = 66,
			[324812] = 411,
			[324973] = 600,
			[324975] = 600,
			[324977] = 600,
			[325341] = 201,
			[325345] = 100,
			[325347] = 100,
			[325609] = 201,
			[325737] = 201,
			[325783] = 201,
			[325940] = 201,
			[325941] = 201,
			[326260] = 411,
			[326568] = 203,
			[326915] = 201,
			[327358] = 201,
			[327753] = 321,
			[328174] = 321,
			[328524] = 105,
			[328858] = 805,
			[328905] = 326,
			[329075] = 900,
			[329131] = 805,
			[329328] = 805,
			[329464] = 411,
			[329582] = 805,
			[330615] = 805,
			[331299] = 111,
			[332186] = 900,
			[332315] = 203,
			[332533] = 900,
			[332594] = 326,
			[332851] = 326,
			[332921] = 805,
			[333810] = 805,
			[334027] = 203,
			[334063] = 203,
			[334697] = 413,
			[334890] = 203,
			[335539] = 321,
			[335664] = 326,
			[335844] = 321,
			[335910] = 202,
			[336010] = 203,
			[336132] = 600,
			[336278] = 805,
			[336657] = 661,
			[337376] = 201,
			[338479] = 326,
			[338540] = 326,
			[338656] = 326,
			[338734] = 201,
			[338954] = 203,
			[339283] = 411,
			[339469] = 326,
			[339515] = 326,
			[339665] = 321,
			[339923] = 326,
			[340554] = 203,
			[340810] = 100,
			[341097] = 203,
			[341836] = 326,
			[341925] = 110,
			[342040] = 660,
			[342106] = 201,
			[342113] = 201,
			[342127] = 203,
			[342169] = 201,
			[342188] = 201,
			[342506] = 326,
			[342663] = 201,
			[343070] = 326,
			[343574] = 326,
			[343575] = 326,
			[344489] = 805,
			[345180] = 411,
			[346490] = 203,
			[346917] = 203,
			[347020] = 203,
			[347080] = 203,
			[347080] = 203,
			[347107] = 203,
			[347111] = 203,
			[347241] = 203,
			[347749] = 321,
			[38439] = 101,
			[38453] = 101,
			[38762] = 720,
			[42418] = 2,
			[4975] = 202,
			[4976] = 801,
			[4977] = 202,
			[4978] = 202,
			[62772] = 321,
			[63797] = 321,
			[6610] = 801,
			[66280] = 100,
			[68283] = 801,
			[68422] = 801,
			[69855] = 202,
			[70458] = 8,
			[70476] = 100,
			[70813] = 101,
			[71030] = 400,
			[75192] = 28,
			[77314] = 400,
			[78336] = 32,
			[80702] = 32,
			[80704] = 32,
			[86264] = 100,
			[93773] = 100,
			[205446] = 8,
			[245988] = 65,
			[210519] = 202,
			[189038] = 112,
			[219181] = 900,
			[219297] = 400,
			[213293] = 400,
			[218184] = 107,
			[218296] = 202,
			[219448] = 8,
			[210122] = 900,
			[210123] = 108,
			[217377] = 112,
			[217458] = 127,
			[203269] = 127,
			[203802] = 127,
			[56345] = 903,
			[54301] = 903,
			[56562] = 101,
			[337624] = 805,
			[319538] = 805,
			[313558] = 400,
			[321587] = 805,
			[343890] = 65,
			[324346] = 411,
			[330596] = 411,
			[330012] = 202,
			[317812] = 202,
			[319035] = 202,
			[319177] = 805,
			[340391] = 413,
			[314081] = 326,
			[311705] = 8,
			[241211] = 112,
			[211723] = 360,
			[200095] = 127,
			[321334] = 101,
			[315056] = 202,
			[308071] = 8,
			[307753] = 805,
			[335690] = 801,
			[339739] = 8,
			[323836] = 411,
			[324418] = 805,
			[336187] = 805,
			[334690] = 805,
			[325584] = 805,
			[327948] = 805,
			[327932] = 805,
			[336003] = 805,
			[327946] = 805,
			[327947] = 805,
			[323617] = 805,
			[325501] = 805,
			[151088] = 112,
			[328685] = 201,
			[72070] = 112,
			[315165] = 321,
			[329453] = 100,
			[311756] = 202,
			[217648] = 803,
			[326487] = 100,
			[329193] = 411,
			[327895] = 203,
			[213297] = 400,
			[129586] = 400,
			[229086] = 202,
			[192456] = 202,
			[192481] = 107,
			[206766] = 107,
			[73945] = 100,
			[198513] = 400,
			[147002] = 401,
			[146915] = 360,
			[166018] = 8,
			[166459] = 100,
			[161198] = 5,
			[163107] = 202,
			[162225] = 900,
			[159614] = 900,
			[161549] = 900,
			[161550] = 900,
			[161551] = 900,
			[161554] = 900,
			[161557] = 900,
			[162226] = 900,
			[162235] = 900,
			[162237] = 900,
			[162240] = 900,
			[163381] = 320,
			[167108] = 400,
			[166661] = 400,
			[167133] = 101,
			[167301] = 808,
			[171985] = 102,
			[169195] = 100,
			[172258] = 202,
			[350175] = 805,
			[350284] = 805,
			[353215] = 805,
			[352145] = 805,
			[351172] = "Anima",
			[353260] = 105,
			[357775] = 201,
			[352909] = 203,
			[353191] = 203,
			[354782] = 203,
			[351391] = 203,
			[354133] = 6,
			[354119] = 6,
			[352560] = 811,
			[352836] = 203,
			[353740] = 203,
			[346310] = 203,
			[358432] = 805,
			[353543] = 805,
			[353597] = 805,
			[353135] = 202,
			[351205] = 203,
			[355862] = 202,
			[352230] = 65,
			[254667] = 401,
			[168103] = 65,
			[351138] = 201,
			[351245] = 202,
			[352413] = 100,
			[357969] = 203,
			[357963] = 203,
			[357983] = 203,
			[352820] = 660,
			[168115] = 65,
			[79450] = 202,
			[312443] = 201,
			[324937] = 804,
			[310646] = 600,
			[310648] = 600,
			[310647] = 100,
			[310687] = 202,
			[307434] = 201,
			[77821] = 909,
			[77819] = 202,
			[78395] = 107,
			[78628] = 33,
			[311792] = 3,
			[309369] = 201,
			[320718] = 201,
			[324364] = 202,
			[324359] = 202,
			[309678] = 805,
			[309779] = 805,
			[327844] = 804,
			[311775] = 321,
			[311278] = 100,
			[312098] = 811,
			[312018] = 202,
			[321313] = 40,
			[316317] = 202,
			[320559] = 809,
			[311848] = 321,
			[310586] = 321,
			[191827] = 107,
			[202064] = 107,
			[204588] = 100,
			[67869] = 100,
			[200255] = 202,
			[201112] = 107,
			[191481] = 202,
			[192252] = 107,
			[196731] = 326,
			[196724] = 326,
			[67922] = 126,
			[69054] = 126,
			[68945] = 126,
			[69230] = 18,
			[69217] = 100,
			[76241] = 5,
			[74793] = 400,
			[74475] = 72,
			[76724] = 10,
			[76759] = 111,
			[89821] = 321,
			[89752] = 806,
			[91085] = 100,
			[91400] = 100,
			[154475] = 202,
			[154485] = 202,
			[325380] = 100,
			[351910] = 203,
			[317175] = 107,
			[303967] = 811,
			[285327] = 413,
			[284447] = 413,
			[286256] = 126,
			[171204] = 101,
			[77976] = 100,
			[78141] = 281,
			[78336] = 96,
			[70155] = 111,
			[70476] = 280,
			[71225] = 100,
			[321920] = 326,
			[197071] = 126,
			[200170] = 909,
			[204867] = 126,
			[224553] = 126,
			[201200] = 202,
			[31549] = 321,
			[313684] = 202,
			[346327] = 202,
			[317812] = 202,
			[317813] = 202,
			[330938] = 33,
			[333473] = 100,
			[333474] = 100,
			[333475] = 100,
			[325543] = 202,
			[325722] = 202,
			[150029] = 202,
			[336250] = 202,
			[181456] = 202,
			[186052] = 5,
			[226373] = 201,
			[248062] = 204,
			[199728] = 100,
			[321212] = 805,
			[340626] = 100,
			[223600] = 202,
			[351673] = 201,
			[356553] = 3,
			[319666] = 100,
			[319697] = 100,
			[319698] = 100,
			[319699] = 100,
			[351895] = 201,
			[351905] = 201,
			[297365] = 204,
			[341726] = 203,
			[354171] = 805,
			[352672] = 100,
			[358113] = 326,
			[357779] = 326,
			[350591] = 36,
			[351333] = 321,
			[322332] = 201,
			[337039] = 326,
			[350186] = 201,
			[350187] = 201,
			[350192] = 201,
			[357319] = 805,
			[357307] = 326,
			[357301] = 201,
			[357299] = 321,
			[235570] = 901,
			[236525] = 202,
			[169758] = 202,
			[169973] = 640,
			[356266] = 326,
			[214669] = 326,
			[356593] = 203,
			[203675] = 646,
			--qqq

			--! NPC spells
			[319294] = 326, -- Spirit Bolt (Exile's Reach)
			[325143] = 201, -- Restore (Bastion)
			[335485] = 327, -- Bwllowing Roar (The Maw)
			[333821] = 326, -- Ancient Tome (Maldraxxus)
			[324114] = 326, -- Forbidden Knowledge (Maldraxxus)
			[322802] = 805, -- Psychic Blast (Gorm Matriarch)
			[324483] = 805, -- Anima-Charged Spear (Ardenweald)
			[327474] = 201, -- Crushing Doubt (Uther)
			[329509] = 68, -- Blazing Surge (Kael'thas)
			[343086] = 321, -- Ricocheting Shuriken (General Kaal)
			[333387] = 101, -- Wicked Blade (General Kaal)
			[309749] = 326, -- Dispel Disguise (Maldraxxus)
			[339783] = 326, -- Dispel Disguise (Maldraxxus)
			[342328] = 48, -- Soul Fissure (Kel'Thuzad)
			[338591] = 326, -- Death and Decay (Kel'Thuzad)
			[338590] = 326, -- Death and Decay (Kel'Thuzad)
			[334509] = 326, -- Warlord's Slam (Maldraxxus)
			[211685] = 401, -- Focused Trance (Soulkeeper - Fangs of the Devourer Scenario)
			[318879] = 321, -- Summon Guardian (Revendreth)
			[225249] = 412, -- Devastating Stomp (Emerald Nightmare)
			[149236] = 320, -- Darkrush (Terrorfang - WoD Shadowmoon Valley)
			[244969] = 127, -- Eradication (Garothi Worldbreaker - Antorus)
			[337344] = 96, -- Mystic Bolt (Revendreth)
			[339120] = 413, -- Ruinous Bolt (Ardenweald)
			[153804] = 811, -- Inhale (Bonemaw - Shadowmoon Burial Grounds)
			[292903] = 411, -- Massive Strike (Mawsworn)
			[320734] = 411, -- Massive Strike (Mawsworn)
			[347091] = 411, -- Massive Strike (Mawsworn)
			[322450] = 413, -- Consumption (Tred'ova - Mists of Tirna Scithe)
			[153153] = 323, -- Dark Communion (Sedana Bloodfury - Shadowmoon Burial Grounds)
			[154110] = 3, -- Smash (Araknat - Skyreach)
			[154135] = 6, -- Burst (Araknath - Skyreach)
			[304946] = 411, -- Shadow Rip (The Maw)
			[157742] = 320, -- Reave (Shadowmoon Orcs)
			[306828] = 320, -- Defiled Ground (Visions of N'Zoth - Thrall)
			[306726] = 320, -- Defiled Ground (Visions of N'Zoth - Vez'okk the Lightless)
			[256880] = 413, -- Bone Splinter (Drustvar)
			[266035] = 413, -- Bone Splinter (Waycrest Manor)
			[263455] = 360, -- Sacrifice (Waycrest Manor - Matron Christiane)
			[214184] = 360, -- Vortex (Legion Demons)
			[355456] = 411, -- Damnation (The Maw - Mor'geth)
			[332239] = 413, -- Shatter Essence (Drust)
			[227660] = 28, -- Guardian's Breath (Guarm)
			[227666] = 28, -- Guardian's Breath (Guarm)
			[227669] = 28, -- Guardian's Breath (Guarm)
			[227658] = 28, -- Guardian's Breath (Guarm)
			[333931] = 48, -- Elemental Chomp (Ylva)
			[358835] = 28, -- Guardian's Breath (Ylva)
			[354114] = 411, -- Unleashed Suffering (Mawsworn)
			[358303] = 413, -- Essence Ejection (Konthrogz the Obliterator)
			[353782] = 260, -- Shadow Nova (Nathrezim)
			[217003] = 360, -- Slumber Fog (Nathrezim)
			[193100] = 9, -- Dropping the Hammer (Dargrul)
			--nnn

			--! Auras
			[345569] = 105, -- Flagellation (Haste Buff)
			[312106] = 600, -- Weapons of Order (Debuff)
			[259277] = 101, -- Kill Command (Bleed) (Bloodseeker talent)


			-- Ascension Crafting
			[328321] = 201, -- Overcharged Goliath Core
			[328680] = 201, -- Soul Mirror
			[333209] = 201, -- Herald's Footpads
			[333220] = 201, -- Charm of Fortitude
			[333230] = 201, -- Deep Echo Trident
			[333362] = 201, -- Vial of Lichfrost
			[333372] = 201, -- Phial of Serenity
			[333374] = 201, -- Spiritforged Aegis
			[333530] = 201, -- Anointment Oil
			[333533] = 201, -- Heartpiercer Javelin
			[333535] = 201, -- Fountain of Rejuvenation
			[333545] = 201, -- Catalyst of Creation
			[333546] = 201, -- Praetor Resonance Beacon
			[333547] = 201, -- Soulseeker Crystal
			[333548] = 201, -- Ashfallen Key
			[333549] = 201, -- Humility's Guard
			[335596] = 201, -- Charm of Alacrity
			[335603] = 201, -- Charm of Persistence
			[335619] = 201, -- Charm of Discord
			[335626] = 201, -- Charm of Focus
			[335705] = 201, -- Sigil of Haunting Memories
			[335849] = 201, -- Charm of Energizing (Unused?)
			[338384] = 201, -- Charm of Quickness
			[342503] = 201, -- Skystrider Glider
			[342521] = 201, -- Empyrean Refreshment
			[345713] = 201, -- Kyrian Smith's Kit
			[345757] = 201, -- Steward Mail Pouch
			[345760] = 201, -- Gilded Abacus
			[345786] = 201, -- Artisan Tool Belt
			[345894] = 201, -- Medallion of Service
			[345916] = 201, -- Vesper of Calling
			[345978] = 201, -- Ring of Warding


			-- Abominable Stitching
			[325284] = 414, -- Construct Body: "Chordy"
			[325454] = 414, -- Construct Body: "Atticus"
			[325452] = 414, -- Construct Body: "Marz"
			[325451] = 414, -- Construct Body: "Roseboil"
			[325453] = 414, -- Construct Body: "Flytrap"
			[326406] = 414, -- Construct Body: "Professor"
			[338040] = 414, -- Construct Body: "Sabrina"
			[326407] = 414, -- Construct Body: "Toothpick"
			[326380] = 414, -- Construct Body: "Gas Bag"
			[338039] = 414, -- Construct Body: "Guillotine"
			[338037] = 414, -- Construct Body: "Iron Phillip"
			[338043] = 414, -- Construct Body: "Naxx"
			[326408] = 414, -- Construct Body: "Mama Tomalin"
			[325458] = 414, -- Construct Body: "Miru"
			[326379] = 414, -- Construct Body: "Neena"

			[326525] = 326, -- Call Chordy
			[327203] = 326, -- Call Atticus
			[327556] = 326, -- Call Marz
			[327580] = 326, -- Call Roseboil
			[327002] = 326, -- Call Flytrap
			[341181] = 326, -- Call Professor
			[339451] = 326, -- Call Sabrina
			[340465] = 326, -- Call Toothpick
			[340882] = 326, -- Call Gas Bag
			[340839] = 326, -- Call Guillotine
			[340340] = 326, -- Call Iron Phillip
			[340841] = 326, -- Call Naxx

			-- Mining
			[102167] = 5, -- Smelt Trillium
			[102165] = 5, -- Smelt Ghost Iron
			[74529] = 5, -- Smelt Pyrite
			[74537] = 5, -- Smelt Hardened Elementium
			[74530] = 5, -- Smelt Elementium
			[84038] = 5, -- Smelt Obsidium
			[49258] = 5, -- Smelt Saronite
			[55211] = 5, -- Smelt Titanium
			[55208] = 5, -- Smelt Titansteel
			[49252] = 5, -- Smelt Cobalt
			[35750] = 803, -- Earth Sunder
			[35751] = 400, -- Fire Sunder
			[46353] = 5, -- Smelt Hardened Khorium
			[29361] = 5, -- Smelt Khorium
			[29686] = 5, -- Smelt Hardened Adamantite
			[29360] = 5, -- Smelt Felsteel
			[29359] = 5, -- Smelt Eternium
			[29358] = 5, -- Smelt Adamantite
			[29356] = 5, -- Smelt Fel Iron
			[14891] = 5, -- Smelt Dark Iron
			[22967] = 5, -- Smelt Enchanted Elementium
			[70524] = 5, -- Enchanted Thorium Bar
			[16153] = 5, -- Smelt Thorium
			[10098] = 5, -- Smelt Truesilver
			[10097] = 5, -- Smelt Mithril
			[3308] = 5, -- Smelt Gold
			[3307] = 5, -- Smelt Iron
			[3569] = 5, -- Smelt Steel
			[2659] = 5, -- Smelt Bronze
			[2658] = 5, -- Smelt Silver
			[3304] = 5, -- Smelt Tin
			[2657] = 5, -- Smelt Copper

			-- Cooking
			[308402] = 400, -- Surprisingly Palatable Feast
			[308403] = 400, -- Feast of Gluttonous Hedonism
			[308400] = 400, -- Spinefin Souffle and Fries
			[308413] = 400, -- Iridescent Ravioli with Apple Sauce
			[308405] = 400, -- Tenebrous Crown Roast Aspic
			[308426] = 400, -- Steal a la Mode
			[308411] = 400, -- Candied Amberjack Cakes
			[308415] = 400, -- Banana Beaf Pudding
			[308404] = 400, -- Cinnamon Bonefish Stew
			[308412] = 400, -- Meaty Apple Dumplings
			[308425] = 400, -- Sweet Silvergill Sausages
			[308397] = 400, -- Butterscotch Marinated Ribs
			[308414] = 400, -- Pickled Meat Smoothie
			[308410] = 400, -- Biscuits and Caviar
			[308419] = 400, -- Smothered Shank
			[308417] = 400, -- Seraph Tenders
			[308416] = 400, -- Quiethounds
			[308420] = 400, -- Fried Bonefish
			[338100] = 400, -- Arden Apple Pie
			[338107] = 400, -- Diced Vegetables
			[338115] = 400, -- Ember Sauce
			[338106] = 400, -- Grazer Bone Broth
			[338101] = 400, -- Oat Pie Crust
			[338117] = 400, -- Seared Cutlets
			[338116] = 400, -- Skewered Meats
			[338102] = 400, -- Sliced Arden Apples
			[338110] = 400, -- Spider Jerky
			[338105] = 400, -- Steward Stew
			[338113] = 400, -- Thick Spider Meat
			[314959] = 400, -- Baked Voidfin
			[314961] = 400, -- Dubious Delight
			[314962] = 400, -- Ghastly Goulash
			[314963] = 400, -- Grilled Gnasher
			[314960] = 400, -- K'Bab
			[303788] = 400, -- Unagi Skewer
			[259435] = 400, -- Seasoned Loins (Rank 3)
			[259434] = 400, -- Seasoned Loins (Rank 2)
			[259433] = 400, -- Seasoned Loins (Rank 1)
			[286381] = 400, -- Honey Potpie
			[259432] = 400, -- Grilled Catfish (Rank 3)
			[259431] = 400, -- Grilled Catfish (Rank 2)
			[259430] = 400, -- Grilled Catfish (Rank 1)
			[280282] = 400, -- Heartsbane Hexwurst
			[259413] = 400, -- Kul Tiramisu (Rank 3)
			[259412] = 400, -- Kul Tiramisu (Rank 2)
			[259411] = 400, -- Kul Tiramisu (Rank 1)
			[259438] = 400, -- Loa Loaf (Rank 3)
			[259437] = 400, -- Loa Loaf (Rank 2)
			[259436] = 400, -- Loa Loaf (Rank 1)
			[259444] = 400, -- Mon'Dazi (Rank 3)
			[259443] = 400, -- Mon'Dazi (Rank 2)
			[259442] = 400, -- Mon'Dazi (Rank 1)
			[259426] = 400, -- Ravenberry Tarts (Rank 3)
			[259425] = 400, -- Ravenberry Tarts (Rank 2)
			[259424] = 400, -- Ravenberry Tarts (Rank 1)
			[288029] = 400, -- Wild Berry Bread (Rank 3)
			[288028] = 400, -- Wild Berry Bread (Rank 2)
			[288027] = 400, -- Wild Berry Bread (Rank 1)
			[301392] = 400, -- Mecha-Bytes
			[297086] = 400, -- Abyssal-Fried Rissole (Rank 3)
			[297085] = 400, -- Abyssal-Fried Rissole (Rank 2)
			[297084] = 400, -- Abyssal-Fried Rissole (Rank 1)
			[297083] = 400, -- Baked Port Tato (Rank 3)
			[297082] = 400, -- Baked Port Tato (Rank 2)
			[297081] = 400, -- Baked Port Tato (Rank 1)
			[297089] = 400, -- Bil'Tong (Rank 3)
			[297088] = 400, -- Bil'Tong (Rank 2)
			[297087] = 400, -- Bil'Tong (Rank 1)
			[297074] = 400, -- Fragrant Kakavia (Rank 3)
			[297075] = 400, -- Fragrant Kakavia (Rank 2)
			[297077] = 400, -- Fragrant Kakavia (Rank 1)
			[297080] = 400, -- Mech-Dowel's "Big Mech" (Rank 3)
			[297079] = 400, -- Mech-Dowel's "Big Mech" (Rank 2)
			[297078] = 400, -- Mech-Dowel's "Big Mech" (Rank 1)
			[259416] = 400, -- Honey-Glazed Haunches (Rank 3)
			[259415] = 400, -- Honey-Glazed Haunches (Rank 3)
			[259414] = 400, -- Honey-Glazed Haunches (Rank 3)
			[259441] = 400, -- Sailor's Pie (Rank 3)
			[259440] = 400, -- Sailor's Pie (Rank 2)
			[259439] = 400, -- Sailor's Pie (Rank 1)
			[288033] = 400, -- Seasoned Steak and Potatoes (Rank 3)
			[288032] = 400, -- Seasoned Steak and Potatoes (Rank 2)
			[288030] = 400, -- Seasoned Steak and Potatoes (Rank 1)
			[259447] = 400, -- Spiced Snapper (Rank 3)
			[259446] = 400, -- Spiced Snapper (Rank 2)
			[259445] = 400, -- Spiced Snapper (Rank 1)
			[259429] = 400, -- Swamp Fish 'n Chips (Rank 3)
			[259428] = 400, -- Swamp Fish 'n Chips (Rank 2)
			[259427] = 400, -- Swamp Fish 'n Chips (Rank 1)
			[290473] = 400, -- Boralus Blood Sausage (Rank 3)
			[290472] = 400, -- Boralus Blood Sausage (Rank 2)
			[290471] = 400, -- Boralus Blood Sausage (Rank 1)
			[297107] = 400, -- Famine Evaluator And Snack Table (Rank 3)
			[297106] = 400, -- Famine Evaluator And Snack Table (Rank 2)
			[297105] = 400, -- Famine Evaluator And Snack Table (Rank 1)
			[259423] = 400, -- Bountiful Captain's Feast (Rank 3)
			[259422] = 400, -- Bountiful Captain's Feast (Rank 2)
			[259421] = 400, -- Bountiful Captain's Feast (Rank 1)
			[287112] = 400, -- Sanguinated Feast (Rank 3)
			[287110] = 400, -- Sanguinated Feast (Rank 2)
			[287108] = 400, -- Sanguinated Feast (Rank 1)
			[259420] = 400, -- Galley Banquet (Rank 3)
			[259419] = 400, -- Galley Banquet (Rank 2)
			[259418] = 400, -- Galley Banquet (Rank 1)
			[201685] = 400, -- Crispy Bacon (Rank 3)
			[201684] = 400, -- Crispy Bacon (Rank 2)
			[201683] = 400, -- Crispy Bacon (Rank 1)
			[230046] = 400, -- Spiced Falcosaur Omelet
			[201560] = 400, -- Bear Tartare (Rank 3)
			[201540] = 400, -- Bear Tartare (Rank 2)
			[201513] = 400, -- Bear Tartare (Rank 1)
			[201559] = 400, -- Dried Mackerel Strips (Rank 3)
			[201539] = 400, -- Dried Mackerel Strips (Rank 2)
			[201512] = 400, -- Dried Mackerel Strips (Rank 1)
			[201561] = 400, -- Fighter Chow (Rank 3)
			[201541] = 400, -- Fighter Chow (Rank 2)
			[201514] = 400, -- Fighter Chow (Rank 1)
			[201545] = 400, -- Deep-Fried Mossgill (Rank 3)
			[201525] = 400, -- Deep-Fried Mossgill (Rank 2)
			[201496] = 400, -- Deep-Fried Mossgill (Rank 1)
			[201547] = 400, -- Faronaar Fizz (Rank 3)
			[201527] = 400, -- Faronaar Fizz (Rank 2)
			[201498] = 400, -- Faronaar Fizz (Rank 1)
			[201546] = 400, -- Pickled Stormray (Rank 3)
			[201526] = 400, -- Pickled Stormray (Rank 2)
			[201497] = 400, -- Pickled Stormray (Rank 1)
			[201544] = 400, -- Salt and Pepper Shank (Rank 3)
			[201524] = 400, -- Salt and Pepper Shank (Rank 2)
			[201413] = 400, -- Salt and Pepper Shank (Rank 1)
			[201548] = 400, -- Spiced Rib Roast (Rank 3)
			[201528] = 400, -- Spiced Rib Roast (Rank 2)
			[201499] = 400, -- Spiced Rib Roast (Rank 1)
			[201551] = 400, -- Barracuda Mrglgagh (Rank 3)
			[201531] = 400, -- Barracuda Mrglgagh (Rank 2)
			[201502] = 400, -- Barracuda Mrglgagh (Rank 1)
			[201553] = 400, -- Drogbar-Style Salmon (Rank 3)
			[201533] = 400, -- Drogbar-Style Salmon (Rank 2)
			[201504] = 400, -- Drogbar-Style Salmon (Rank 1)
			[201552] = 400, -- Koi-Scented Stormray (Rank 3)
			[201532] = 400, -- Koi-Scented Stormray (Rank 2)
			[201503] = 400, -- Koi-Scented Stormray (Rank 1)
			[201549] = 400, -- Leybeque Ribs (Rank 3)
			[201529] = 400, -- Leybeque Ribs (Rank 2)
			[201500] = 400, -- Leybeque Ribs (Rank 1)
			[201550] = 400, -- Suramar Surf and Turf (Rank 3)
			[201530] = 400, -- Suramar Surf and Turf (Rank 2)
			[201501] = 400, -- Suramar Surf and Turf (Rank 1)
			[201555] = 400, -- Azshari Salad (Rank 3)
			[201535] = 400, -- Azshari Salad (Rank 2)
			[201506] = 400, -- Azshari Salad (Rank 1)
			[201558] = 400, -- Fishbrul Special (Rank 3)
			[201538] = 400, -- Fishbrul Special (Rank 2)
			[201511] = 400, -- Fishbrul Special (Rank 1)
			[201556] = 400, -- Nightborne Delicacy Platter (Rank 3)
			[201536] = 400, -- Nightborne Delicacy Platter (Rank 2)
			[201507] = 400, -- Nightborne Delicacy Platter (Rank 1)
			[201557] = 400, -- Seed-Battered Fish Plate (Rank 3)
			[201537] = 400, -- Seed-Battered Fish Plate (Rank 2)
			[201508] = 400, -- Seed-Battered Fish Plate (Rank 1)
			[201554] = 400, -- The Hungry Magister (Rank 3)
			[201534] = 400, -- The Hungry Magister (Rank 2)
			[201505] = 400, -- The Hungry Magister (Rank 1)
			[201562] = 400, -- Hearty Feast (Rank 3)
			[201542] = 400, -- Hearty Feast (Rank 2)
			[201515] = 400, -- Hearty Feast (Rank 1)
			[201563] = 400, -- Lavish Suramar Feast (Rank 3)
			[201543] = 400, -- Lavish Suramar Feast (Rank 2)
			[201516] = 400, -- Lavish Suramar Feast (Rank 1)
			[251258] = 400, -- Feast of the Fishes
			[173978] = 400, -- Feast of Blood
			[173979] = 400, -- Feast of the Waters
			[160986] = 400, -- Blackrock Barbecue
			[160999] = 400, -- Calamari Crepes
			[160987] = 400, -- Frosty Stew
			[161000] = 400, -- Gorgrond Chowder
			[160989] = 400, -- Sleeper Surprise
			[160984] = 400, -- Talador Surf and Turf
			[160962] = 400, -- Blackrock Ham
			[160968] = 400, -- Braised Riverbeast
			[160971] = 400, -- Clefthoof Sausages
			[160958] = 400, -- Hearty Elekk Steak
			[160966] = 400, -- Pan-Seared Talbuk
			[160969] = 400, -- Rylak Crepes
			[190788] = 400, -- Fel Eggs and Ham
			[160981] = 400, -- Fat Sleeper Cakes
			[160982] = 400, -- Fiery Calamari
			[160978] = 400, -- Grilled Gulper
			[160983] = 400, -- Skulker Chowder
			[160973] = 400, -- Steamed Scorpion
			[160979] = 400, -- Sturgeon Stew
			[161002] = 400, -- Grilled Saberfish
			[161001] = 400, -- Saberfish Broth
			[180761] = 400, -- Buttered Sturgeon
			[180759] = 400, -- Jumbo Sea Dog
			[180758] = 400, -- Pickled Eel
			[180757] = 400, -- Salty Squid Roll
			[180762] = 400, -- Sleeper Sushi
			[180760] = 400, -- Whiptail Fillet
			[125141] = 400, -- Banquet of the Grill
			[104300] = 400, -- Black Pepper Ribs and Shrimp
			[145311] = 400, -- Fluffy Silkfeather Omelet
			[125142] = 400, -- Great Banquet of the Grill
			[104299] = 400, -- Eternal Blossom Fish
			[104298] = 400, -- Charbroiled Tiger Steak
			[125594] = 400, -- Banquet of the Wok
			[125595] = 400, -- Great Banquet of the Wok
			[104303] = 400, -- Sea Mist Rice Noodles
			[145305] = 400, -- Seasoned Pomfruit Slices
			[104302] = 400, -- Valley Stir Fry
			[104301] = 400, -- Sauteed Carrots
			[125596] = 400, -- Banquet of the Pot
			[125597] = 400, -- Great Banquet of the Pot
			[104306] = 400, -- Mogu Fish Stew
			[145307] = 400, -- Spiced Blossom Soup
			[104305] = 400, -- Braised Turtle
			[104304] = 400, -- Swiling Mist Soup
			[125598] = 400, -- Banquet of the Steamer
			[145309] = 400, -- Farmer's Delight
			[125599] = 400, -- Great Banquet of the Steamer
			[104309] = 400, -- Steamed Crab Surprise
			[104308] = 400, -- Fire Spirit Salmon
			[104307] = 400, -- Shrimp Dumplings
			[125600] = 400, -- Banquet of the Oven
			[104312] = 400, -- Chun Tian Spring Rolls
			[125601] = 400, -- Great Banquet of the Oven
			[145310] = 400, -- Stuffed Lushrooms
			[104311] = 400, -- Twin Fish Platter
			[104310] = 400, -- Wildfowl Roast
			[125602] = 400, -- Banquet of the Brew
			[125603] = 400, -- Great Banquet of the Brew
			[124054] = 400, -- Mad Brewer's Breakfast
			[126655] = 400, -- Banana Infused Rum
			[126654] = 400, -- Four Senses Brew
			[124053] = 400, -- Jade Witch Brew
			[124052] = 400, -- Ginseng Tea
			[145061] = 400, -- Deluxe Noodle Cart Kit
			[105194] = 400, -- Great Pandaren Banquet
			[145308] = 400, -- Mango Ice
			[145038] = 400, -- Noodle Cart Kit
			[105190] = 400, -- Pandaren Banquet
			[145062] = 400, -- Pandaren Treasure Noodle Cart Kit
			[125120] = 400, -- Spicy Salmon
			[125123] = 400, -- Spicy Vegetable Chips
			[124032] = 400, -- Krasarang Fritters
			[125122] = 400, -- Rice Pudding
			[124029] = 400, -- Viseclaw Soup
			[124233] = 400, -- Blanched Needle Mushrooms
			[124229] = 400, -- Red Bean Bun
			[124228] = 400, -- Boiled Silkwork Pupa
			[124227] = 400, -- Dried Needle Mushrooms
			[124226] = 400, -- Dried Peaches
			[104297] = 400, -- Fish Cake
			[104237] = 400, -- Golden Carp Consomme
			[124231] = 400, -- Green Curry Fish
			[124232] = 400, -- Peach Pie
			[125080] = 400, -- Pearl Milk Tea
			[125067] = 400, -- Perfectly Cooked Instant Noodles
			[124223] = 400, -- Pounded Rice Cake
			[125078] = 400, -- Roasted Barley Tea
			[124234] = 400, -- Skewered Peanut Chicken
			[125117] = 400, -- Sliced Peaches
			[124230] = 400, -- Tangy Yogurt
			[124225] = 400, -- Toasted Fish Jerky
			[125121] = 400, -- Wildfowl Ginseng Soup
			[124224] = 400, -- Yak Cheese Curds
			[88011] = 400, -- Broiled Dragon Feast
			[88019] = 400, -- Fortune Cookie
			[88036] = 400, -- Seafood Magnifique Feast
			[88003] = 400, -- Baked Rockfish
			[88004] = 400, -- Basilisk Liverdog
			[88005] = 400, -- Beer-Basted Crocolisk
			[88034] = 400, -- Blackbelly Sushi
			[88014] = 400, -- Crocolisk Au Gratin
			[88016] = 400, -- Delicious Sagefish Tail
			[88020] = 400, -- Grilled Dragon
			[88025] = 400, -- Lavascale Minestrone
			[88031] = 400, -- Mushroom Sauce Mudfish
			[88039] = 400, -- Severed Sagefish Head
			[88042] = 400, -- Skewered Eel
			[88013] = 400, -- Chocolate Cookie
			[88018] = 400, -- Fish Fry
			[96133] = 400, -- Scalding Murglesnout
			[88021] = 400, -- Hearty Seafood Soup
			[88033] = 400, -- Pickled Guppy
			[88046] = 400, -- Tender Baked Turtle
			[88012] = 400, -- Broiled Mountain Trout
			[88024] = 400, -- Lavascale Fillet
			[88028] = 400, -- Lightly Fried Lurker
			[88030] = 400, -- Lurker Lunch
			[88035] = 400, -- Salted Eye
			[88037] = 400, -- Seasoned Crab
			[88047] = 400, -- Whitecrest Gumbo
			[88006] = 400, -- Blackened Surprise
			[88044] = 400, -- South Island Iced Tea
			[88022] = 400, -- Highland Spirits
			[88045] = 400, -- Starfire Espresso
			[88015] = 400, -- Darkbrew Lager
			[88017] = 100, -- Feathered Lure
			[57423] = 400, -- Fish Feast
			[58528] = 400, -- Small Feast
			[58527] = 400, -- Gigantic Feast
			[57441] = 400, -- Blackened Dragonfin
			[57438] = 400, -- Blackened Worg Steak
			[57435] = 400, -- Critter Bites
			[57439] = 400, -- Cuttlesteak
			[57442] = 400, -- Dragonfin Filet
			[45568] = 400, -- Firecracker Salmon
			[57436] = 400, -- Hearty Rhino
			[45570] = 400, -- Imperial Manta Steak
			[45555] = 400, -- Mega Mammoth Meal
			[45559] = 400, -- Mighty Rhino Dogs
			[45567] = 400, -- Poached Northern Sculpin
			[57434] = 400, -- Rhinolicious Wormsteak
			[57437] = 400, -- Snapper Extreme
			[57440] = 400, -- Spiced Mammoth Treats
			[45557] = 400, -- Spiced Worm Burger
			[45571] = 400, -- Spicy Blue Nettlefish
			[57433] = 400, -- Spicy Fried Herring
			[45556] = 400, -- Tender Shoveltusk Steak
			[57443] = 400, -- Tracker Snacks
			[45558] = 400, -- Very Burnt Worg
			[64358] = 400, -- Black Jelly
			[62350] = 400, -- Worg Tartare
			[45554] = 400, -- Great Feast
			[45569] = 400, -- Baked Manta Ray
			[58065] = 400, -- Dalaran Clam Chowder
			[45563] = 400, -- Grilled Sculpin
			[45549] = 400, -- Mammoth Meal
			[45566] = 400, -- Pickled Fangtooth
			[45565] = 400, -- Poached Nettlefish
			[45553] = 400, -- Rhino Dogs
			[45552] = 400, -- Roasted Worg
			[45550] = 400, -- Shoveltusk Steak
			[45564] = 400, -- Smoked Salmon
			[45551] = 400, -- Worm Delight
			[53056] = 400, -- Kungaloosh
			[58523] = 400, -- Bad Clams
			[45561] = 400, -- Grilled Bonescale
			[58525] = 400, -- Haunted Herring
			[58521] = 400, -- Last Week's Mammoth
			[57421] = 400, -- Northern Stew
			[45562] = 400, -- Sauteed Goby
			[45560] = 400, -- Smoked Rockfin
			[58512] = 400, -- Tasty Cupcake
			[42302] = 400, -- Fisherman's Feast
			[42305] = 400, -- Hot Buttered Trout
			[33296] = 400, -- Spicy Crawdad
			[38868] = 400, -- Crunchy Serpent
			[38867] = 400, -- Mok'Nathal Shortribs
			[33295] = 400, -- Golden Fish Sticks
			[43772] = 400, -- Kibler's Bits
			[33287] = 400, -- Roasted Clefthoof
			[33289] = 400, -- Talbuk Steak
			[33288] = 400, -- Warp Burger
			[33293] = 400, -- Grilled Mudfish
			[33294] = 400, -- Poached Bluefish
			[33286] = 400, -- Blackened Basilisk
			[43707] = 400, -- Skullfish Soup
			[43765] = 400, -- Spicy Hot Talbuk
			[42296] = 400, -- Stewed Trout
			[33292] = 400, -- Blackened Sporefish
			[33290] = 400, -- Blackened Trout
			[43761] = 400, -- Broiled Bloodfin
			[33279] = 400, -- Buzzard Bites
			[36210] = 400, -- Clam Bar
			[33291] = 400, -- Feltail Delight
			[33284] = 400, -- Ravager Dog
			[43758] = 400, -- Stormchops
			[18247] = 400, -- Baked Salmon
			[25659] = 400, -- Dirge's Kickin' Chimaerok Chops
			[18245] = 400, -- Lobster Stew
			[18246] = 400, -- Mightfish Steak
			[22761] = 400, -- Runn Tum Tuber Surprise
			[24801] = 400, -- Smoked Desert Dumplings
			[18242] = 400, -- Hot Smoked Bass
			[46684] = 400, -- Charred Bear Kabobs
			[46688] = 400, -- Juicy Bear Burger
			[18243] = 400, -- Nightfin Soup
			[18244] = 400, -- Poached Sunscale Salmon
			[64054] = 400, -- Clamlette Magnifique
			[18239] = 400, -- Cooked Glossy Mightfish
			[18241] = 400, -- Filet of Redgill
			[15933] = 400, -- Monster Omelet
			[15915] = 400, -- Spiced Chili Crab
			[22480] = 400, -- Tender Wolf Steak
			[20626] = 400, -- Unddermine Clam Chowder
			[185705] = 400, -- Fancy Darkmoon Feast
			[18240] = 400, -- Grilled Squid
			[18238] = 400, -- Spotted Yellowtail
			[15910] = 400, -- Heavy Kodo Stew
			[15863] = 400, -- Carrion Surprise
			[7213] = 400, -- Giant Clam Scorcho
			[15856] = 400, -- Hot Wolf Ribs
			[15861] = 400, -- Jungle Stew
			[20916] = 400, -- Mithril Head Trout
			[15865] = 400, -- Mystery Stew
			[15855] = 400, -- Roast Raptor
			[25954] = 400, -- Sagefish Delight
			[21175] = 400, -- Spider Sausage
			[7828] = 400, -- Rockscale Cod
			[4094] = 400, -- Barbecued Buzzard Wing
			[3400] = 400, -- Soothing Turtle Bisque
			[3398] = 400, -- Hot Lion Chops
			[13028] = 400, -- Goldthorn Tea
			[3376] = 400, -- Curiously Tasty Omelet
			[15853] = 400, -- Lean Wolf Steak
			[3373] = 400, -- Crocolisk Gumbo
			[24418] = 400, -- Heavy Crocolisk Stew
			[3399] = 400, -- Tasty Lion Steak
			[3377] = 400, -- Gooey Spider Cake
			[6419] = 400, -- Lean Venison
			[7755] = 400, -- Bristle Whisker Catfish
			[6418] = 400, -- Crispy Lizard Tail
			[2549] = 400, -- Seasoned Wolf Kabob
			[2547] = 400, -- Redridge Goulash
			[6501] = 400, -- Clam Chowder
			[6417] = 400, -- Dig Rat Stew
			[3372] = 400, -- Murloc Fin Soup
			[2548] = 400, -- Succulent Pork Ribs
			[6500] = 400, -- Goblin Deviled Clams
			[185708] = 400, -- Sugar-Crusted Fish Feast
			[2545] = 400, -- Cooked Crab Claw
			[3370] = 400, -- Crocolisk Steak
			[25704] = 400, -- Smoked Sagefish
			[2543] = 400, -- Westfall Stew
			[3371] = 400, -- Blood Sausage
			[28267] = 400, -- Crunchy Spider Surprise
			[33278] = 400, -- Bat Bites
			[2542] = 400, -- Goretusk Liver Pie
			[7754] = 400, -- Loch Frenzy Delight
			[7753] = 400, -- Longjaw Mud Snapper
			[7827] = 400, -- Rainbow Fin Albacore
			[6416] = 400, -- Strider Stew
			[2546] = 400, -- Dry Pork Ribs
			[8607] = 400, -- Smoked Bear Meat
			[2544] = 400, -- Crab Cake
			[6414] = 400, -- Roasted Kodo Meat
			[2795] = 400, -- Beer Basted Boar Ribs
			[6413] = 400, -- Scorpid Surprise
			[6499] = 400, -- Boiled Clams
			[2541] = 400, -- Coyote Steak
			[6415] = 400, -- Fillet of Frenzy
			[185704] = 400, -- Lemon Herb Fillet
			[43779] = 400, -- Delicious Chocolate Cake
			[7751] = 400, -- Brilliant Smallfish
			[2538] = 400, -- Charred Wolf Meat
			[15935] = 400, -- Crispy Bat Wing
			[8604] = 400, -- Herb Baked Egg
			[33276] = 400, -- Lynx Steak
			[2540] = 400, -- Roasted Boar Meat
			[33277] = 400, -- Roasted Moongraze Tenderloin
			[7752] = 400, -- Slitherskin Mackerel
			[93741] = 400, -- Venison Jerky
			[6412] = 400, -- Kaldorei Spider Kabob
			[2539] = 400, -- Spiced Wolf Meat
			[3397] = 400, -- Big Bear Steak
			[37836] = 400, -- Spice Bread
			[45022] = 400, -- Hot Apple Cider
			[62051] = 400, -- Candied Sweet Potato (Alliance)
			[66034] = 400, -- Candied Sweet Potato (Horde)
			[62049] = 400, -- Cranberry Chutney (Alliance)
			[66035] = 400, -- Cranberry Chutney (Horde)
			[62045] = 400, -- Slow-Roasted Turkey (Alliance)
			[66037] = 400, -- Slow-Roasted Turkey (Horde)
			[62044] = 400, -- Pumpkin Pie (Alliance)
			[66036] = 400, -- Pumpkin Pie (Horde)
			[66038] = 400, -- Spice Bread Stuffing (Aliance)
			[62050] = 400, -- Spice Bread Stuffing (Horde)
			[21144] = 400, -- Winter Veil Egg Nog
			[21143] = 400, -- Gingerbread Cookie
			[65454] = 400, -- Bread of the Dead
			[15906] = 400, -- Dragonbreath Chili
			[8238] = 400, -- Savory Deviate Delight
			[9513] = 400, -- Thistle Tea
			[45695] = 400, -- Captain Rumsey's Lager

			-- Engineering
			[310496] = 100, -- Electro-Jump
			[310495] = 100, -- Dimensional Shifter
			[310497] = 100, -- Damage Retaliator
			[310486] = 100, -- Bomb Bola Launcher
			[310485] = 100, -- Shadow Land Mine
			[310484] = 100, -- Nutcracker Grenade
			[310535] = 100, -- Wormhole Generator: Shadowlands
			[310490] = 100, -- Momentum Redistributor Boots
			[310492] = 100, -- Gravimetric Scrambler Cannon
			[345179] = 100, -- Disposable Spectrophasic Reanimator
			[310493] = 100, -- 50UL-TR4P
			[310509] = 100, -- Reinforced Ectoplasmic Specs
			[310504] = 100, -- Grounded Ectoplasmic Specs
			[310501] = 100, -- Flexible Ectoplasmic Specs
			[310507] = 100, -- Articulated Ectoplasmic Specs
			[343100] = 100, -- Crafter's Mark II
			[343099] = 100, -- Crafter's Mark I
			[343661] = 100, -- Novice Crafter's Mark
			[310526] = 100, -- Wormfed Gear Assembly
			[310525] = 100, -- Mortal Coiled Spring
			[310524] = 100, -- Porous Polishing Abrasive
			[310522] = 100, -- Handful of Laestrite Bolts
			[331007] = 100, -- PHA7-YNX
			[310533] = 100, -- Optical Target Embiggener
			[310534] = 100, -- Infra-green Reflex Sight
			[310536] = 100, -- Precision Lifeforce Inverter
			[338218] = 100, -- Bone Reinforced Oxxein Tubing
			[338217] = 100, -- Boneclad Stake Launcher
			[338119] = 100, -- Bug Zapifier
			[338220] = 100, -- Duelist's Pistol
			[338212] = 100, -- Electro Cable
			[338210] = 100, -- Energized Battery
			[338219] = 100, -- Handful of Oxxein Bolts
			[338216] = 100, -- Hardened Bolts
			[338214] = 100, -- Piston Assembly
			[338213] = 100, -- Power Hammer
			[338222] = 100, -- Sinvyr Barrel
			[338223] = 100, -- Sinvyr Trigger Mechanism
			[255936] = 100, -- Belt Enchant: Holographic Horror Projector
			[269123] = 100, -- Belt Enchant: Miniaturized Plasma Shield
			[255940] = 100, -- Belt Enchant: Personal Space Amplifier
			[255394] = 100, -- F.R.I.E.D. (Rank 3)
			[255393] = 100, -- F.R.I.E.D. (Rank 2)
			[255392] = 100, -- F.R.I.E.D. (Rank 1)
			[255409] = 100, -- Organic Discombobulation Grenade (Rank 3)
			[255408] = 100, -- Organic Discombobulation Grenade (Rank 2)
			[255407] = 100, -- Organic Discombobulation Grenade (Rank 1)
			[255397] = 100, -- Thermo-Accelerated Plague Spreader (Rank 3)
			[255396] = 100, -- Thermo-Accelerated Plague Spreader (Rank 2)
			[255395] = 100, -- Thermo-Accelerated Plague Spreader (Rank 1)
			[298930] = 100, -- Blingtron 7000
			[299105] = 100, -- Wormhole Generator: Kul Tiras
			[299106] = 100, -- Wormhole Generator: Zandalar
			[283916] = 100, -- Unstable Temporal Time Shifter (Rank 3)
			[283915] = 100, -- Unstable Temporal Time Shifter (Rank 2)
			[283914] = 100, -- Unstable Temporal Time Shifter (Rank 1)
			[256156] = 100, -- Deployable Attire Rearranger (Rank 3)
			[256155] = 100, -- Deployable Attire Rearranger (Rank 2)
			[256154] = 100, -- Deployable Attire Rearranger (Rank 1)
			[256072] = 100, -- Electroshock Mount Motivator (Rank 3)
			[256071] = 100, -- Electroshock Mount Motivator (Rank 2)
			[256070] = 100, -- Electroshock Mount Motivator (Rank 1)
			[256084] = 100, -- Interdimensional Companion Repository (Rank 3)
			[256082] = 100, -- Interdimensional Companion Repository (Rank 2)
			[256080] = 100, -- Interdimensional Companion Repository (Rank 1)
			[256075] = 100, -- XA-1000 Surface Skimmer (Rank 3)
			[256074] = 100, -- XA-1000 Surface Skimmer (Rank 2)
			[256073] = 100, -- XA-1000 Surface Skimmer (Rank 1)
			[280734] = 100, -- Magical Intrusion Dampener (Rank 3)
			[280733] = 100, -- Magical Intrusion Dampener (Rank 2)
			[280732] = 100, -- Magical Intrusion Dampener (Rank 1)
			[305945] = 100, -- A-N0M-A-L0U5 Synthetic Specs
			[299005] = 100, -- A5C-3N-D3D Synthetic Specs
			[299004] = 100, -- Abyssal Synthetic Specs
			[299006] = 100, -- Charged A5C-3N-D3D Synthetic Specs
			[305943] = 100, -- Paramount Synthetic Specs
			[305944] = 100, -- Superior Synthetic Specs
			[272058] = 100, -- AZ3-R1-T3 Synthetic Specs (Rank 3)
			[272057] = 100, -- AZ3-R1-T3 Synthetic Specs (Rank 2)
			[272056] = 100, -- AZ3-R1-T3 Synthetic Specs (Rank 1)
			[286875] = 100, -- Charged SP1-R1-73D Synthetic Specs
			[286874] = 100, -- SP1-R1-73D Synthetic Specs
			[286873] = 100, -- Surging Synthetic Specs
			[291090] = 100, -- Emblazoned Synthetic Specs
			[291089] = 100, -- Imbued Synthetic Specs
			[305942] = 100, -- A-N0M-A-L0U5 Gearspun Goggles
			[299008] = 100, -- A5C-3N-D3D Gearspun Goggles
			[299007] = 100, -- Abyssal Gearspun Goggles
			[299009] = 100, -- Charged A5C-3N-D3D Gearspun Goggles
			[305940] = 100, -- Paramount Gearspun Goggles
			[305941] = 100, -- Superior Gearspun Goggles
			[272061] = 100, -- AZ3-R1-T3 Gearspun Goggles (Rank 3)
			[272060] = 100, -- AZ3-R1-T3 Gearspun Goggles (Rank 2)
			[272059] = 100, -- AZ3-R1-T3 Gearspun Goggles (Rank 1)
			[286869] = 100, -- Charged SP1-R1-73D Gearspun Goggles
			[286868] = 100, -- SP1-R1-73D Gearspun Goggles
			[286867] = 100, -- Surging Gearspun Goggles
			[291092] = 100, -- Emblazoned Gearspun Goggles
			[291091] = 100, -- Imbued Gearspun Goggles
			[305951] = 100, -- A-N0M-A-L0U5 Bionic Bifocals
			[299011] = 100, -- A5C-3N-D3D Bionic Bifocals
			[299010] = 100, -- Abyssal Bionic Bifocals
			[299012] = 100, -- Charged A5C-3N-D3D Bionic Bifocals
			[305949] = 100, -- Paramount Bionic Bifocals
			[305950] = 100, -- Superior Bionic Bifocals
			[272064] = 100, -- AZ3-R1-T3 Bionic Bifocals (Rank 3)
			[272063] = 100, -- AZ3-R1-T3 Bionic Bifocals (Rank 2)
			[272062] = 100, -- AZ3-R1-T3 Bionic Bifocals (Rank 1)
			[286866] = 100, -- Charged SP1-R1-73D Bionic Bifocals
			[286865] = 100, -- SP1-R1-73D Bionic Bifocals
			[286864] = 100, -- Surging Bionic Bifocals
			[291094] = 100, -- Emblazoned Bionic Bifocals
			[291093] = 100, -- Imbued Bionic Bifocals
			[305948] = 100, -- A-N0M-A-L0U5 Orthogonal Optics
			[299014] = 100, -- A5C-3N-D3D Orthogonal Optics
			[299013] = 100, -- Abyssal Orthogonal Optics
			[299015] = 100, -- Charged A5C-3N-D3D Orthogonal Optics
			[305946] = 100, -- Paramount Orthogonal Optics
			[305947] = 100, -- Superior Orthogonal Optics
			[272067] = 100, -- AZ3-R1-T3 Orthogonal Optics (Rank 3)
			[272066] = 100, -- AZ3-R1-T3 Orthogonal Optics (Rank 2)
			[272065] = 100, -- AZ3-R1-T3 Orthogonal Optics (Rank 1)
			[286872] = 100, -- Charged SP1-R1-73D Orthogonal Optics
			[286871] = 100, -- SP1-R1-73D Orthogonal Optics
			[286870] = 100, -- Surging Orthogonal Optics
			[291096] = 100, -- Emblazoned Orthogonal Optics
			[291095] = 100, -- Imbued Orthogonal Optics
			[294786] = 100, -- Notorious Combatant's Discombobulator (Rank 3)
			[294785] = 100, -- Notorious Combatant's Discombobulator (Rank 2)
			[294784] = 100, -- Notorious Combatant's Discombobulator (Rank 1)
			[294789] = 100, -- Notorious Combatant's Stormsteel Destroyer (Rank 3)
			[294788] = 100, -- Notorious Combatant's Stormsteel Destroyer (Rank 2)
			[294787] = 100, -- Notorious Combatant's Stormsteel Destroyer (Rank 1)
			[305861] = 100, -- Uncanny Combatant's Discombobulator (Rank 3)
			[305862] = 100, -- Uncanny Combatant's Discombobulator (Rank 2)
			[305863] = 100, -- Uncanny Combatant's Discombobulator (Rank 1)
			[305858] = 100, -- Uncanny Combatant's Stormsteel Destroyer (Rank 3)
			[305859] = 100, -- Uncanny Combatant's Stormsteel Destroyer (Rank 2)
			[305860] = 100, -- Uncanny Combatant's Stormsteel Destroyer (Rank 1)
			[255459] = 100, -- Finely-Tuned Stormsteel Destroyer (Rank 3)
			[255458] = 100, -- Finely-Tuned Stormsteel Destroyer (Rank 2)
			[255457] = 100, -- Finely-Tuned Stormsteel Destroyer (Rank 1)
			[253152] = 100, -- Precision Attitude Adjuster (Rank 3)
			[253151] = 100, -- Precision Attitude Adjuster (Rank 2)
			[253150] = 100, -- Precision Attitude Adjuster (Rank 1)
			[282808] = 100, -- Sinister Combatant's Discombobulator (Rank 3)
			[282807] = 100, -- Sinister Combatant's Discombobulator (Rank 2)
			[282806] = 100, -- Sinister Combatant's Discombobulator (Rank 1)
			[282811] = 100, -- Sinister Combatant's Stormsteel Destroyer (Rank 3)
			[282810] = 100, -- Sinister Combatant's Stormsteel Destroyer (Rank 2)
			[282809] = 100, -- Sinister Combatant's Stormsteel Destroyer (Rank 1)
			[269726] = 100, -- Honorable Combatant's Discombobulator (Rank 3)
			[269725] = 100, -- Honorable Combatant's Discombobulator (Rank 2)
			[269724] = 100, -- Honorable Combatant's Discombobulator (Rank 1)
			[269729] = 100, -- Honorable Combatant's Stormsteel Destroyer (Rank 3)
			[269728] = 100, -- Honorable Combatant's Stormsteel Destroyer (Rank 2)
			[269727] = 100, -- Honorable Combatant's Stormsteel Destroyer (Rank 1)
			[253122] = 100, -- Magnetic Discombobulator
			[264962] = 100, -- Crow's Nest Scope (Rank 3)
			[264961] = 100, -- Crow's Nest Scope (Rank 2)
			[264960] = 100, -- Crow's Nest Scope (Rank 1)
			[265102] = 100, -- Frost-Laced Ammunition (Rank 3)
			[265101] = 100, -- Frost-Laced Ammunition (Rank 2)
			[265100] = 100, -- Frost-Laced Ammunition (Rank 1)
			[265099] = 100, -- Incendiary Ammunition (Rank 3)
			[265098] = 100, -- Incendiary Ammunition (Rank 2)
			[265097] = 100, -- Incendiary Ammunition (Rank 1)
			[264967] = 100, -- Monelite Scope of Alacrity (Rank 3)
			[264966] = 100, -- Monelite Scope of Alacrity (Rank 2)
			[264964] = 100, -- Monelite Scope of Alacrity (Rank 1)
			[256132] = 100, -- Super-Charged Engine
			[274621] = 100, -- Mecha-Mogul Mk2
			[286478] = 100, -- Mechantula
			[287279] = 100, -- Aqueous Thermo-Degradation
			[286647] = 100, -- Sanguinated Thermo-Degradation
			[278411] = 100, -- Makeshift Azerite Detector
			[278413] = 100, -- Monelite Fish Finder
			[307220] = 320, -- Void Focus
			[298255] = 100, -- Ub3r-Module: P.O.G.O.
			[298256] = 100, -- Ub3r-Module: Scrap Cannon
			[298257] = 100, -- Ub3r-Module: Ub3r-Coil
			[282975] = 100, -- The Ub3r-SPanner
			[283399] = 100, -- Ub3r-Module: Short-Fused Bomb Bots
			[283401] = 100, -- Ub3r-Module: Ub3r S3ntry Mk. X8.0
			[283403] = 100, -- Ub3r-Module: Ub3r-Improved Target Dummy
			[235755] = 100, -- Chain Skullblasters
			[199011] = 100, -- Double-Barreled Cranial Cannon (Rank 3)
			[198997] = 100, -- Double-Barreled Cranial Cannon (Rank 2)
			[198970] = 100, -- Double-Barreled Cranial Cannon (Rank 1)
			[235756] = 100, -- Heavy Skullblasters
			[199012] = 100, -- Ironsight Cranial Cannon (Rank 3)
			[198998] = 100, -- Ironsight Cranial Cannon (Rank 2)
			[198971] = 100, -- Ironsight Cranial Cannon (Rank 1)
			[235754] = 100, -- Rugged Skullblasters
			[199010] = 100, -- Sawed-Off Cranial Cannon (Rank 3)
			[198996] = 100, -- Sawed-Off Cranial Cannon (Rank 2)
			[198969] = 100, -- Sawed-Off Cranial Cannon (Rank 1)
			[199009] = 100, -- Semi-Automagic Cranial Cannon (Rank 3)
			[198995] = 100, -- Semi-Automagic Cranial Cannon (Rank 2)
			[198968] = 100, -- Semi-Automagic Cranial Cannon (Rank 1)
			[235753] = 100, -- Tailored Skullblasters
			[199005] = 100, -- Blink-Trigger Headgun (Rank 3)
			[198991] = 100, -- Blink-Trigger Headgun (Rank 2)
			[198939] = 100, -- Blink-Trigger Headgun (Rank 1)
			[199007] = 100, -- Bolt-Action Headgun (Rank 3)
			[198993] = 100, -- Bolt-Action Headgun (Rank 2)
			[198966] = 100, -- Bolt-Action Headgun (Rank 1)
			[199008] = 100, -- Reinforced Headgun (Rank 3)
			[198994] = 100, -- Reinforced Headgun (Rank 2)
			[198967] = 100, -- Reinforced Headgun (Rank 1)
			[199006] = 100, -- Tactical Headgun (Rank 3)
			[198992] = 100, -- Tactical Headgun (Rank 2)
			[198965] = 100, -- Tactical Headgun (Rank 1)
			[199013] = 100, -- Deployable Bullet Dispenser (Rank 3)
			[198999] = 100, -- Deployable Bullet Dispenser (Rank 2)
			[198972] = 100, -- Deployable Bullet Dispenser (Rank 1)
			[199014] = 100, -- Gunpowder Charge (Rank 3)
			[199000] = 100, -- Gunpowder Charge (Rank 2)
			[198973] = 100, -- Gunpowder Charge (Rank 1)
			[199015] = 100, -- Pump-Action Bandage Gun (Rank 3)
			[199001] = 100, -- Pump-Action Bandage Gun (Rank 2)
			[198974] = 100, -- Pump-Action Bandage Gun (Rank 1)
			[198981] = 100, -- Trigger
			[199017] = 100, -- Auto-Hammer (Rank 3)
			[199003] = 100, -- Auto-Hammer (Rank 2)
			[198976] = 100, -- Auto-Hammer (Rank 1)
			[198980] = 100, -- Blingtron's Circuit Design Tutorial
			[199018] = 100, -- Failure Detection Pylon (Rank 3)
			[199004] = 100, -- Failure Detection Pylon (Rank 2)
			[198977] = 100, -- Failure Detection Pylon (Rank 1)
			[199016] = 100, -- Gunpack (Rank 3)
			[199002] = 100, -- Gunpack (Rank 2)
			[198975] = 100, -- Gunpack (Rank 1)
			[247744] = 100, -- Wormhole Generator: Argus
			[247717] = 100, -- Gravitational Reduction Slippers
			[198978] = 100, -- Gunshoes
			[198979] = 100, -- Intra-Dalaran Wormhole Generator
			[209645] = 100, -- Leystone Buoy
			[209646] = 100, -- Mecha-Bond Imprint Matrix
			[209501] = 100, -- "The Felic"
			[209502] = 100, -- Shockinator
			[235775] = 100, -- Rechargeable Reaves Battery
			[198989] = 100, -- Reaves Module: Bling Mode
			[198985] = 100, -- Reaves Module: Failure Detection Mode
			[198987] = 100, -- Reaves Module: Fireworks Display Mode
			[198990] = 100, -- Reaves Module: Piloted Combat Mode
			[198984] = 100, -- Reaves Module: Repair Mode
			[198988] = 100, -- Reaves Module: Snack Distribution Mode
			[198983] = 100, -- Reaves Module: Wormhole Generator Mode
			[200466] = 100, -- Sonic Environment Enhancer
			[198982] = 100, -- Reaves Battery
			[182120] = 100, -- Primal Welding
			[169080] = 100, -- Gearspring Parts
			[177054] = 100, -- Secrets of Draenor Engineering
			[162195] = 100, -- Cybernetic Mechshades
			[162196] = 100, -- Night-Vision Mechshades
			[162197] = 100, -- Plasma Mechshades
			[162198] = 100, -- Razorguard Mechshades
			[187496] = 100, -- Advanced Muzzlesprocket
			[187497] = 100, -- Bi-Directional Fizzle Reducer
			[169078] = 100, -- Didi's Delicate Assembly
			[162205] = 100, -- Findle's Loot-a-Rang
			[173289] = 100, -- Hemets Heartseeker
			[187521] = 100, -- Infrablue-Blocker Lenses
			[463878] = 100, -- Linkgrease Locksprocket
			[162203] = 100, -- Megawatt Filament
			[162202] = 100, -- Oglethorpe's Missile Splitter
			[162214] = 100, -- Personal Hologram
			[162199] = 100, -- Shrediron's Shredder
			[162217] = 100, -- Swapblaster
			[187520] = 100, -- Taladite Firing Pin
			[177363] = 100, -- True Iron Trigger
			[162208] = 100, -- Ultimate Gnomish Army Knife (Uncommon)
			[169140] = 100, -- Ultimate Gnomish Army Knife (Rare)
			[162206] = 100, -- World Shrinker
			[162216] = 100, -- Wormhole Centrifuge
			[162204] = 100, -- Goblin Glider Kit
			[173308] = 100, -- Mecha-Blast Rocket
			[173309] = 100, -- Shieldtronic Shield
			[162207] = 100, -- Stealthman 54
			[162218] = 100, -- Blingtron 5000
			[162210] = 100, -- Lifelike Mechanical Frostboar
			[162209] = 100, -- Mechanical Axebeak
			[176732] = 100, -- Mechanical Scorpid
			[171072] = 100, -- Alliance Firework
			[171073] = 100, -- Horde Firework
			[171074] = 100, -- Snake Firework
			[143743] = 100, -- Schematic: Chief Engineer Jard's Journal
			[127128] = 100, -- Goblin Dragon Gun, Mark II
			[127127] = 100, -- G91 Landshark
			[127124] = 100, -- Locksmith's Powderkeg
			[131256] = 100, -- Autumn Flower Firework
			[128260] = 100, -- Celestial Firework
			[128261] = 100, -- Grand Celebration Firework
			[131258] = 100, -- Jade Blossom Firework
			[131353] = 100, -- Pandaria Fireworks
			[128262] = 100, -- Serpent's Heart Firework
			[139197] = 100, -- Advanced Refrigeration Unit
			[139196] = 100, -- Pierre
			[143714] = 100, -- Rascal-Bot
			[127129] = 100, -- Blingtron 4000
			[127135] = 100, -- Mechanical Pandaren Dragonling
			[127132] = 100, -- Wormhole Generator: Pandaria
			[127134] = 100, -- Ghost Iron Dragonling
			[127131] = 100, -- Thermal Anvil
			[126392] = 100, -- Goblin Glider
			[109099] = 100, -- Watergliding Jets
			[139176] = 100, -- Jard's Peculiar Energy Source
			[131563] = 100, -- Tinker's Kit
			[127113] = 100, -- Ghost Iron Bolts
			[127114] = 100, -- High-Explosive Gunpowder
			[127118] = 100, -- Agile Retinal Armor
			[127119] = 100, -- Camouflage Retinal Armor
			[127120] = 100, -- Deadly Retinal Armor
			[127121] = 100, -- Energized Retinal Armor
			[127117] = 100, -- Lightweight Retinal Armor
			[127130] = 100, -- Mist-Piercing Goggles
			[127123] = 100, -- Reinforced Retinal Armor
			[127122] = 100, -- Specialized Retinal Armor
			[127137] = 100, -- Long-Range Trillium Sniper
			[127136] = 100, -- Big Game Hunter
			[127115] = 100, -- Lord Blastington's Scope of Doom
			[127116] = 100, -- Mirror Scope
			[139192] = 100, -- Sky Golem
			[127138] = 100, -- Depleted-Kyparium Rocket
			[127139] = 100, -- Geosynchronous World Spinner
			[131211] = 100, -- Flashing Tinker's Gear
			[131212] = 100, -- Fractured Tinker's Gear
			[131213] = 100, -- Precise Tinker's Gear
			[131214] = 100, -- Quick Tinker's Gear
			[131215] = 100, -- Rigid Tinker's Gear
			[131216] = 100, -- Smooth Tinker's Gear
			[131217] = 100, -- Sparkling Tinker's Gear
			[131218] = 100, -- Subtle Tinker's Gear
			[84425] = 100, -- Cardboard Assassin
			[84427] = 100, -- Grounded Plasma Shield
			[84424] = 100, -- Invisibility Field
			[82200] = 100, -- Spinal Healing Injector
			[94748] = 800, -- Electrified Ether
			[84403] = 100, -- Handful of Obsidium Bolts
			[95707] = 100, -- Big Daddy
			[84409] = 100, -- Volatile Seaforium Blastpack
			[81722] = 100, -- Agile Bio-Optic Killshades
			[81724] = 100, -- Camouflage Bio-Optic Killshades
			[81716] = 100, -- Deadly Bio-Optic Killshades
			[81720] = 100, -- Energized Bio-Optic Killshades
			[81725] = 100, -- Lightweight Bio-Optic Killshades
			[81714] = 100, -- Reinforced Bio-Optic Killshades
			[81715] = 100, -- Specialized Bio-Optic Killshades
			[84406] = 100, -- Authentic Jr. Engineer Goggles
			[84418] = 100, -- Elementium Dragonling
			[84416] = 100, -- Elementium Toolbox
			[95705] = 100, -- Gnomish Gravity Well
			[84421] = 100, -- Loot-a-Rang
			[84429] = 100, -- Goblin Barbecue
			[84430] = 100, -- Heat-Treated Spinning Lure
			[84413] = 100, -- De-Weaponized Mechanical Companion
			[84412] = 100, -- Personal World Destroyer
			[84415] = 100, -- Lure Master Tackle Box
			[95703] = 100, -- Electrostatic Condenser
			[100687] = 100, -- Extreme-Impact Hole Puncher
			[84420] = 100, -- Finely-Tuned Throat Needler
			[84432] = 100, -- Kickback 5000
			[84431] = 100, -- Overpowered Chicken Splitter
			[84417] = 100, -- Volatile Thunderstick
			[84411] = 100, -- High-Powered Bolt Gun
			[100587] = 100, -- Flintlocke's Woodchucker
			[84428] = 100, -- Gnomish X-Ray Scope
			[84408] = 100, -- R19 Threatfinder
			[84410] = 100, -- Safety Catch Removal Kit
			[67839] = 100, -- Mind Amplification Dish
			[55016] = 100, -- Nitro Boosts
			[54736] = 100, -- EMP Generator
			[55002] = 100, -- Flexweave Underlay
			[54793] = 100, -- Frag Belt
			[56471] = 100, -- Froststeel Tube
			[56464] = 100, -- Overcharged Capacitor
			[53281] = 100, -- Volatile Blasting Trigger
			[56349] = 100, -- Handful of Cobalt Bolts
			[56514] = 100, -- Global Thermal Sapper Charge
			[56468] = 100, -- Box of Bombs
			[56463] = 100, -- Explosive Decoy
			[56460] = 100, -- Cobalt Frag Bomb
			[56480] = 100, -- Armored Titanium Goggles
			[56483] = 100, -- Charged Titanium Specs
			[56487] = 100, -- Electroflux Sight Enhancers
			[56486] = 100, -- Greensight Gogs
			[56574] = 100, -- Truesight Ice Blinders
			[62271] = 100, -- Unbreakable Healing Amplifiers
			[56484] = 100, -- Visage Liquification Goggles
			[56481] = 100, -- Weakness Spectralizers
			[61482] = 100, -- Mechanized Snow Goggles (Mail)
			[61483] = 100, -- Mechanized Snow Goggles (Plate)
			[56465] = 100, -- Mechanized Snow Goggles (Cloth)
			[61481] = 100, -- Mechanized Snow Goggles (Leather)
			[56473] = 100, -- Gnomish X-Ray Specs
			[68067] = 100, -- Jeeves
			[67920] = 100, -- Wormhole Generator: Northrend
			[56462] = 100, -- Gnomish Army Knife
			[56467] = 100, -- Noise Machine
			[56466] = 100, -- Sonic Booster
			[56469] = 100, -- Gnomish Lightning Generator
			[30349] = 100, -- Titanium Toolbox
			[56472] = 100, -- MOLL-E
			[56477] = 100, -- Mana Injector Kit
			[67326] = 100, -- Goblin Beam Welder
			[56476] = 100, -- Healing Injector Kit
			[55252] = 100, -- Scapbot Construction Kit
			[56459] = 100, -- Hammer Pick
			[56461] = 100, -- Bladed Pickaxe
			[56479] = 100, -- Armor Plated Combat Shotgun
			[60874] = 100, -- Nesingwary 4000
			[54353] = 100, -- Mark "S" Boomstick
			[60866] = 100, -- Mechano-Hog (Horde)
			[60867] = 100, -- Mekgineer's Chopper (Alliance)
			[56478] = 100, -- Heartseeker Scope
			[56470] = 100, -- Sun Scope
			[61471] = 100, -- Diamond-cut Refractor Scope
			[30309] = 100, -- Felsteel Stabilizer
			[30307] = 100, -- Hardened Adamantite Tube
			[30308] = 100, -- Khorium Power Core
			[39971] = 100, -- Icy Blasting Primers
			[30306] = 100, -- Adamantite Frame
			[30303] = 100, -- Elemental Blasting Powder
			[30304] = 100, -- Fel Iron Casing
			[30305] = 100, -- Handful or Fel Iron Bolts
			[39973] = 100, -- Frost Grenade
			[30547] = 100, -- Elemental Seaforium Charge
			[30560] = 100, -- Super Sapper Charge
			[30311] = 100, -- Adamantite Grenade
			[30558] = 100, -- The Bigger One
			[30310] = 100, -- Fel Iron Bomb
			[46111] = 100, -- Annihilator Holo-Gogs
			[46115] = 100, -- Hard Khorium Goggles
			[46109] = 100, -- Hyper-Magnified Moon Specs
			[46107] = 100, -- Justicebringer 3000 Specs
			[46112] = 100, -- Lightning Etched Specs
			[46114] = 100, -- Mayhem Projection Goggles
			[46108] = 100, -- Powerheal 9000 Lens
			[46110] = 100, -- Primal-Attuned Goggles
			[46116] = 100, -- Quad Deathblow X44 Goggles
			[46106] = 100, -- Wonderheal XT68 Shades
			[41317] = 100, -- Deathblow X11 Goggles
			[41320] = 100, -- Destruction Holo-gogs
			[40274] = 100, -- Furious Gizmatic Goggles
			[41315] = 100, -- Gadgetstorm Goggles
			[41311] = 100, -- Justicebringer 2000 Specs
			[41316] = 100, -- Living Replicator Specs
			[41319] = 100, -- Magnified Moon Specs
			[41321] = 100, -- Powerheal 4000 Lens
			[41314] = 100, -- Surestrike Goggles v2.0
			[41312] = 100, -- Tankatronic Goggles
			[41318] = 100, -- Wonderheal XT40 Shades
			[30325] = 100, -- Hyper-Vision Goggles
			[30575] = 100, -- Gnomish Battle Goggles
			[30574] = 100, -- Gnomish Power Goggles
			[30318] = 100, -- Ultra-Spectropic Detection Goggles
			[30316] = 100, -- Cogspinner Goggles
			[30317] = 100, -- Power Amplification Goggles
			[46113] = 100, -- Surestrike Goggles v3.0
			[44391] = 100, -- Field Repair Bot 110G
			[30565] = 100, -- Foreman's Enchanted Helmet
			[30566] = 100, -- Foreman's Reinforced Helmet
			[30556] = 100, -- Rocket Boots Xtreme
			[46697] = 100, -- Rocket Boots Xtreme Lite
			[30570] = 100, -- Nigh-Invulnerability Belt
			[36954] = 100, -- Dimensional Ripper - Area 52
			[36955] = 100, -- Ultrasafe Transporter - Toshley's Station
			[30569] = 100, -- Gnomish Pultryizer
			[30563] = 100, -- Goblin Rocket Launcher
			[30552] = 100, -- Mana Potion Injector
			[30568] = 100, -- Gnomish Flame Turret
			[30337] = 100, -- Crashin' Thrashin' Robot
			[30551] = 100, -- Healing Potion Injector
			[30348] = 100, -- Fel Iron Toolbox
			[30548] = 100, -- Zapthrottle Mote Extractor
			[30315] = 100, -- Ornate Khorium Rifle
			[30314] = 100, -- Felsteel Boomstick
			[41307] = 100, -- Gyro-balanced Khorium Destroyer
			[30313] = 100, -- Adamantite Rifle
			[30312] = 100, -- Fel Iron Musket
			[30334] = 100, -- Stabilized Eternium Scope
			[30332] = 100, -- Khorium Scope
			[30329] = 100, -- Adamantite Scope
			[44157] = 100, -- Turbo-Charged Flying Machine
			[44155] = 100, -- Flying Machine
			[30344] = 100, -- Green Smoke Flare
			[32814] = 100, -- Purple Smoke Flare
			[30341] = 100, -- White Smoke Flare
			[19815] = 100, -- Delicate Arcanite Converter
			[19791] = 100, -- Thorium Widget
			[19795] = 100, -- Thorium Tube
			[39895] = 100, -- Fused Wiring
			[23071] = 100, -- Truesilver Transformer
			[133587] = 100, -- Dense Blasting Powder
			[12599] = 100, -- Mithril Casing
			[12591] = 100, -- Unstable Trigger
			[12589] = 100, -- Mithril Tube
			[3961] = 100, -- Gyrochronatom
			[12715] = 100, -- Goblin Rocket Fuel Recipe
			[12895] = 100, -- Inlaid Mithril Cylinder Plans
			[12585] = 100, -- Solid Blasting Powder
			[3953] = 100, -- Bronze Framework
			[12584] = 100, -- Gold Power Core
			[3952] = 100, -- Minor Recombobulator
			[3958] = 100, -- Iron Strut
			[3942] = 100, -- Whirring Bronze Gizmo
			[3938] = 100, -- Bronze Tube
			[3945] = 100, -- Heavy Blasting Powder
			[3973] = 100, -- Silver Contact
			[3929] = 100, -- Coarse Blasting Powder
			[3922] = 100, -- Handful of Copper Bolts
			[3918] = 100, -- Rough Blasting Powder
			[19831] = 100, -- Arcane Bomb
			[19799] = 100, -- Dark Iron Bomb
			[19790] = 100, -- Thorium Grenade
			[23080] = 100, -- Powerful Seaforium Charge
			[12908] = 100, -- Goblin Dragon Gun
			[12619] = 100, -- Hi-Explosive Bomb
			[12754] = 100, -- The Big One
			[12755] = 100, -- Goblin Bomb Dispenser
			[23070] = 100, -- Dense Dynamite
			[12603] = 100, -- Mithril Frag Bomb
			[12716] = 100, -- Goblin Mortar
			[12760] = 100, -- Goblin Sapper Charge
			[3972] = 100, -- Large Seaforium Charge
			[3968] = 100, -- Goblin Land Mine
			[3967] = 100, -- Big Iron Bomb
			[8243] = 100, -- Flash Bomb
			[23069] = 100, -- EZ-Thro Dynamite II
			[3962] = 100, -- Iron Grenade
			[3960] = 100, -- Portable Bronze Mortar
			[3955] = 100, -- Explosive Sheep
			[12586] = 100, -- Solid Dynamite
			[3950] = 100, -- Big Bronze Bomb
			[3941] = 100, -- Small Bronze Bomb
			[3933] = 100, -- Small Seaforium Charge
			[3937] = 100, -- Large Copper Bomb
			[3946] = 100, -- Heavy Dynamite
			[8339] = 100, -- EZ-Thro Dynamite
			[3931] = 100, -- Coarse Dynamite
			[3923] = 100, -- Rough Copper Bomb
			[3919] = 100, -- Rough Dynamite
			[24356] = 100, -- Bloodvine Goggles
			[24357] = 100, -- Bloodvine Lens
			[19825] = 100, -- Master Engineer's Goggles
			[19794] = 100, -- Spellpower Goggles Xtreme Plus
			[12622] = 100, -- Green Lens
			[12618] = 100, -- Rose Colored Goggles
			[12615] = 100, -- Spellpower Goggles Xtreme
			[12607] = 100, -- Catseye Ultra Goggles
			[12897] = 100, -- Gnomish Goggles
			[12594] = 100, -- Fire Goggles
			[3966] = 100, -- Craftsman's Monocle
			[12587] = 100, -- Bright-Eye Goggles
			[3956] = 100, -- Green Tinted Goggles
			[3940] = 100, -- Shadow Goggles
			[3934] = 100, -- Flying Tiger Goggles
			[23486] = 100, -- Dimensional Ripper - Everlook
			[22704] = 100, -- Field Repair Bot 74A
			[23489] = 100, -- Ultrasafe Transporter - Gadgetzan
			[19830] = 100, -- Arcanite Dragonling
			[22797] = 100, -- Force Reactive Disk
			[23081] = 100, -- Hyper-Radiant Flame Reflector
			[23082] = 100, -- Ultra-Flash Shadow Reflector
			[19819] = 100, -- Voice Amplification Modulator
			[19814] = 100, -- Masterwork Target Dummy
			[23078] = 100, -- Goblin Jumper Cables XL
			[23077] = 100, -- Gyrofreeze Ice Reflector
			[19793] = 100, -- Lifelike Mechanical Toad
			[26011] = 100, -- Tranquil Mechanical Yeti
			[23079] = 100, -- Major Recombobulator
			[63750] = 100, -- High-powered Flashlight
			[12624] = 100, -- Mithril Mechanical Dragonling
			[28327] = 100, -- Steam Tonk Controller
			[23096] = 100, -- Gnomish Alarm-o-Bot
			[12758] = 100, -- Goblin Rocket Helmet
			[12759] = 100, -- Gnomish Death Ray
			[12907] = 100, -- Gnomish Mind Control Cap
			[12617] = 100, -- Deepdive Helmet
			[12906] = 100, -- Gnomish Battle Chicken
			[23129] = 100, -- World Enlarger
			[12905] = 100, -- Gnomish Rocket Boots
			[8895] = 100, -- Goblin Rocket Boots
			[12616] = 100, -- Parachute Cloak
			[12903] = 100, -- Gnomish Harm Prevention Belt
			[12902] = 100, -- Gnomish Net-o-Matic Projector
			[12899] = 100, -- Gnomish Shrink Ray
			[12718] = 100, -- Goblin Construction Helmet
			[12717] = 100, -- Goblin Mining Helmet
			[3971] = 100, -- Gnomish Cloaking Device
			[3969] = 100, -- Mechanical Dragonling
			[15255] = 100, -- Mechanical Repair Kit
			[21940] = 100, -- Snowmaster 9000
			[3965] = 100, -- Advanced Target Dummy
			[3963] = 100, -- Compact Harvest Reaper Kit
			[15633] = 100, -- Lil' Smoky
			[15628] = 100, -- Pet Bombling
			[9273] = 100, -- Goblin Jumper Cables
			[3959] = 100, -- Discombobulator Ray
			[3957] = 100, -- Ice Deflector
			[6458] = 100, -- Ornate Spyglass
			[3944] = 100, -- Flame Deflector
			[9269] = 100, -- Gnomish Universal Remote
			[9271] = 100, -- Aquadynamic Fish Attractor
			[3932] = 100, -- Target Dummy
			[3928] = 100, -- Mechanical Squirrel Box
			[8334] = 100, -- Clockwork Box
			[22795] = 100, -- Core Marksman Rifle
			[19833] = 100, -- Flawless Arcanite Rifle
			[19796] = 100, -- Dark Iron Rifle
			[19792] = 100, -- Thorium Rifle
			[12614] = 100, -- Mithril Heavy-bore Rifle
			[12595] = 100, -- Mithril Blunderbuss
			[3954] = 100, -- Moonsight Rifle
			[3949] = 100, -- Silver-plated Shotgun
			[3939] = 100, -- Lovingly Crafted Boomstick
			[3936] = 100, -- Deadly Blunderbuss
			[3925] = 100, -- Rough Boomstick
			[22793] = 100, -- Biznicks 247x128 Accurascope
			[12620] = 100, -- Sniper Scope
			[12597] = 100, -- Deadly Scope
			[3979] = 100, -- Accurate Scope
			[3978] = 100, -- Standard Scope
			[3977] = 100, -- Crude Scope
			[26443] = 100, -- Cluster Launcher
			[26426] = 100, -- Large Blue Rocket Cluster
			[26427] = 100, -- Large Green Rocket Cluster
			[26428] = 100, -- Large Red Rocket Cluster
			[23507] = 100, -- Snake Burst Firework
			[26442] = 100, -- Firework Launcher
			[26423] = 100, -- Blue Rocket Cluster
			[26424] = 100, -- Green Rocket Cluster
			[26425] = 100, -- Red Rocket Cluster
			[26420] = 100, -- Large Blue Rocket
			[26421] = 100, -- Large Green Rocket
			[26422] = 100, -- Large Red Rocket
			[23067] = 100, -- Blue Firework
			[23068] = 100, -- Green Firework
			[23066] = 100, -- Red Fireworks
			[26416] = 100, -- Small Blue Rocket
			[26417] = 100, -- Small Green Rocket
			[26418] = 100, -- Small Red Rocket
			[12590] = 100, -- Gyromatic Micro-Adjustor
			[7430] = 100, -- Arclight Spanner

			-- Jewelcrafting
				-- Shadowlands Designs
					-- Quest Recipes
					[338248] = 818, -- Brilliant Bauble
					[338244] = 808, -- Carved Crystal Ring
					[338239] = 909, -- Engraved Phaedrum Band
					[338246] = 808, -- Faceted Crystal
					[338249] = 909, -- Fine Sinvyr Chain
					[338238] = 808, -- Gem Studded Bangle
					[338241] = 814, -- Gleaming Kyranite Necklace
					[338245] = 808, -- Hollowed Crystal
					[338242] = 808, -- Kyranite Dangle
					[338240] = 808, -- Polished Gemstones
					[338247] = 818, -- Sinister Choker
					[338243] = 909, -- Solenium Wire
					-- Gems
					[311867] = 815, -- Straddling Jewel Doublet
					[311866] = 814, -- Versatile Jewel Doublet
					[311868] = 817, -- Deadly Jewel Doublet
					[311869] = 813, -- Masterful Jewel Doublet
					[311871] = 816, -- Quick Jewel Doublet
					[311870] = 818, -- Revitalizing Jewel Doublet
					[311863] = 817, -- Deadly Jewel Cluster
					[311859] = 814, -- Versatile Jewel Cluster
					[311864] = 813, -- Masterful Jewel Cluster
					[311865] = 816, -- Quick Jewel Cluster
					-- Mass Prospecting
					[311948] = 808, -- Mass Prospect Laestrite
					[311950] = 808, -- Mass Prospect Oxxein
					[311951] = 808, -- Mass Prospect Phaedrum
					[311952] = 808, -- Mass Prospect Sinvyr
					[311949] = 808, -- Mass Prospect Solenium
					[311953] = 808, -- Mass Prospect Elethium
					-- Optional Reagents
					[343693] = 202, -- Novice Crafter's Mark
					[343697] = 202, -- Crafter's Mark I
					[343696] = 202, -- Crafter's Mark II
					[343695] = 202, -- Crafter's Mark III
					[352443] = 660, -- Vestige of Origins
					[343694] = 202, -- Crafter's Mark of the Chained Isle
					-- Necklaces
					[311902] = 817, -- Deadly Laestrite Choker
					[311904] = 813, -- Masterful Laestrite Choker
					[311903] = 816, -- Quick Laestrite Choker
					[311905] = 814, -- Versatile Laestrite Choker
					[311906] = 817, -- Deadly Sinvyr Necklace
					[311908] = 813, -- Masterful Phaedrum Necklace
					[311907] = 816, -- Quick Oxxein Necklace
					[311909] = 814, -- Versatile Solenium Necklace
					-- Rings
					[311880] = 817, -- Deadly Laestrite Band
					[311882] = 813, -- Masterful Laestrite Band
					[311881] = 816, -- Quick Laestrite Band
					[311883] = 814, -- Versatile Laestrite Band
					[311884] = 817, -- Deadly Sinvyr Ring
					[311886] = 813, -- Masterful Phaedrum Ring
					[311885] = 816, -- Quick Oxxein Ring
					[311887] = 814, -- Versatile Solenium Ring
					-- Specialized Jewelry
					[327921] = 818, -- Shadowghast Necklace (Rank 1)
					[332040] = 818, -- Shadowghast Necklace (Rank 2)
					[332075] = 818, -- Shadowghast Necklace (Rank 3)
					[338977] = 818, -- Shadowghast Necklace (Rank 4)
					[327920] = 818, -- Shadowghast Ring (Rank 1)
					[332039] = 818, -- Shadowghast Ring (Rank 2)
					[332074] = 818, -- Shadowghast Ring (Rank 3)
					[338978] = 818, -- Shadowghast Ring (Rank 4)
					-- Statues
					[355187] = 809, -- Porous Stone Statue
					[355189] = 809, -- Shaded Stone Statue
					-- Hats
					[334548] = 812, -- Crown of the Righteous
		}

		-- !aura
		ZA.AuraSchoolByName = ZA.CastSchoolByName

		ZA.AuraSchoolBySpellID = ZA.CastSchoolBySpellID

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
			-- Class
			["Activating Specialization"] = ZA.ClassIcons[class] or 0,
			-- Minor
			["Attacking"] = 0,
			["Opening"] = 0,
			["Return to Entrance"] = 0,
			["Handing Over"] = 0,
			["Kicking"] = 0,
			["Pulling"] = 0,
			["Scrapping"] = 0,
			["Deposit Anima"] = 0,
			["Examine"] = 0,
			["Inspecting"] = 0,
			["Open Chest"] = 0,
			["Collecting"] = 0,
			["Unlocking"] = 0,
			["Looting"] = 0,
			["Loot-A-Rang"] = 0,
			["Destroying"] = 0,
			["Freeing"] = 0,
			["Petting"] = 0,
			["Jump to Skyhold"] = 0,
			["Grappling Hook"] = 0,
			-- Learning
			["A Compendium of the Herbs of Draenor"] = 0,
			["A Guide to Skinning in Draenor"] = 0,
			["A Treatise on Mining in Draenor"] = 0,
			["A Treatise on the Alchemy of Draenor"] = 0,
			["A Treatise on the Inscription of Draenor"] = 0,
			["Draenor Blacksmithing"] = 0,
			["Draenor Jewelcrafting"] = 0,
			["Draenor Leatherworking"] = 0,
			["Draenor Tailoring"] = 0,
			["Fishing Guide to Draenor"] = 0,
			["Introduction to Cooking in Draenor"] = 0,
			["Learning"] = 0,
			-- Flight Path Toy
			["7th Legion Scouting Map"] = 237387,
			["Provisioning Azeroth"] = 1064187,
			["Surviving Kalimdor"] = 237388,
			["Walking Kalimdor with the Earthmother"] = 237388,
			-- Teleports
			["Dreamwalk"] = 1396974,
			["Holographic Digitalization Hearthstone"] = 2491049,
			-- Misc
			["Empower Ashjra'kamas"] = 132886,
			["Tinkering"] = 2915722,
			["Tormenting Haunt"] = 236298,
			["Chi Torpedo"] = 607849,
			["Door of Shadows"] = 3586270,
			-- Quest
			["Summoning Voidwalker"] = 136221,
			-- Mounts
			["Crimson Cloud Serpent"] = 648627,
			["Mountain Horse"] = 2143066,
			["Swift Mountain Horse"] = 2143065,
		}

		ZA.CastIconBySpellID = {
			-- § Quest
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
			[4976] = 134776,
			[30406] = 134241,
			[230266] = 1014022,
			[22562] = 134798,
			[6610] = 134765,
			[91400] = 132814,
			[42301] = 134328,
			[42418] = 136021,
			[42425] = 132484,
			[73945] = 134326,
			[86264] = 133860,
			[79751] = 133710,
			[81515] = 134241,
			[81776] = 134243,
			[311643] = 413582,
			[154888] = 134814,
			[156087] = 133733,
			[262446] = 237031,
			[323973] = 3528286,
			[323978] = 3528286,
			[323980] = 3528286,
			[329075] = 3221443,
			[329328] = 3528278,
			[320109] = 0,
			[251746] = 1624586,
			[308244] = 0,
			[342040] = 0,
			[180720] = 0,
			[311873] = 656240,
			[216384] = 0,
			[180713] = 0,
			[180515] = 0,
			[180463] = 0,
			[207501] = 0,
			[341826] = 0,
			[332315] = 0,
			[236262] = 0,
			[186253] = 0,
			[258303] = 0,
			[343928] = 0,
			[346490] = 0,
			[336657] = 0,
			[38439] = 134368,
			[38453] = 134341,
			[38762] = 134081,
			[311387] = 0,
			[328858] = 0,
			[307934] = 0,
			[311972] = 0,
			[318107] = 3565448,
			[327358] = 0,
			[336132] = 0,
			[321881] = 0,
			[316947] = 0,
			[331299] = 0,
			[324812] = 0,
			[335910] = 0,
			[338540] = 0,
			[321938] = 0,
			[322744] = 0,
			[339923] = 0,
			[328905] = 0,
			[341836] = 0,
			[312580] = 0,
			[325783] = 0,
			[347749] = 0,
			[312394] = 0,
			[334027] = 0,
			[341925] = 0,
			[346917] = 0,
			[347020] = 0,
			[341097] = 0,
			[347241] = 0,
			[347080] = 0,
			[180935] = 0,
			[342169] = 0,
			[193269] = 0,
			[193277] = 0,
			[193278] = 0,
			[183124] = 0,
			[203156] = 0,
			[311897] = 413582,
			[205446] = 0,
			[219181] = 0,
			[219297] = 0,
			[213293] = 0,
			[218184] = 0,
			[219448] = 0,
			[210122] = 0,
			[210123] = 0,
			[334646] = 0,
			[334629] = 0,
			[217377] = 0,
			[217458] = 0,
			[203269] = 0,
			[203802] = 0,
			[56345] = 236245,
			[54301] = 236245,
			[56562] = 135288,
			[45371] = 0,
			[45368] = 0,
			[334063] = 0,
			[343890] = 0,
			[334082] = 0,
			[324346] = 135723,
			[330012] = 0,
			[317723] = 0,
			[319035] = 1500875,
			[311705] = 413582,
			[315056] = 0,
			[335690] = 0,
			[323617] = 1056569,
			[325501] = 3528279,
			[328685] = 0,
			[72070] = 132482,
			[329453] = 0,
			[326487] = 0,
			[329193] = 0,
			[327895] = 0,
			[213297] = 651597,
			[129586] = 133837,
			[166018] = 0,
			[166459] = 0,
			[206766] = 0,
			[229086] = 0,
			[73945] = 0,
			[162225] = 0,
			[159614] = 0,
			[161549] = 0,
			[161550] = 0,
			[161551] = 0,
			[161554] = 0,
			[161557] = 0,
			[162226] = 0,
			[162235] = 0,
			[162237] = 0,
			[162240] = 0,
			[149007] = 0,
			[163381] = 134423,
			[167133] = 0,
			[167301] = 0,
			[169195] = 0,
			[172258] = 0,
			[350175] = 0,
			[350284] = 0,
			[350281] = 0,
			[351172] = 0,
			[352909] = 237476,
			[353191] = 237476,
			[354782] = 0,
			[352560] = 0,
			[346310] = 0,
			[358432] = 0,
			[353543] = 0,
			[353597] = 0,
			[353135] = 0,
			[355862] = 0,
			[352230] = 0,
			[351245] = 0,
			[352413] = 0,
			[352672] = 0,
			[352607] = 0,
			[352820] = 0,
			[168115] = 0,
			[168103] = 0,
			[312443] = 0,
			[312448] = 0,
			[324937] = 0,
			[310647] = 0,
			[310687] = 0,
			[311049] = 0,
			[312493] = 0,
			[327057] = 0,
			[307434] = 0,
			[77821] = 0,
			[78628] = 136091,
			[309369] = 0,
			[320718] = 0,
			[320728] = 0,
			[308671] = 0,
			[327914] = 0,
			[324364] = 0,
			[324359] = 0,
			[309779] = 0,
			[327844] = 0,
			[311278] = 0,
			[311682] = 0,
			[312018] = 0,
			[321313] = 0,
			[307474] = 0,
			[320559] = 0,
			[316317] = 0,
			[191827] = 0,
			[202064] = 0,
			[319184] = 0,
			[314180] = 0,
			[201112] = 0,
			[191481] = 0,
			[192252] = 0,
			[196731] = 0,
			[196724] = 0,
			[69217] = 0,
			[76241] = 134337,
			[74654] = 0,
			[76759] = 132161,
			[193724] = 0,
			[91085] = 237030,
			[154475] = 0,
			[154485] = 0,
			[325380] = 0,
			[351910] = 0,
			[317175] = 0,
			[171204] = 135650,
			[77976] = 0,
			[78141] = 133013,
			[70155] = 134228,
			[70813] = 135638,
			[71711] = 414,
			[71225] = 0,
			[197071] = 0,
			[194402] = 0,
			[31549] = 134801,
			[346327] = 0,
			[325543] = 0,
			[181456] = 0,
			[199728] = 0,
			[340626] = 0,
			[351673] = 0,
			[312692] = 133226,
			[319782] = 0,
			[319840] = 0,
			[351895] = 0,
			[351905] = 0,
			[341726] = 0,
			[352978] = 0,
			[358113] = 0,
			[357779] = 0,
			[350208] = 0,
			[351333] = 0,
			[322332] = 0,
			[358089] = 0,
			[357319] = 3257750,
			[357307] = 3257749,
			[357301] = 3257748,
			[357299] = 3257751,
			[235570] = 0,
			[186608] = 0,
			[193017] = 0,
			[193100] = 1487017,
			[208755] = 0,
			[169758] = 0,
			[356266] = 0,
			[356593] = 0,
			[194477] = 0,
			[194479] = 0,
			[188432] = 0,
			[211546] = 979574,
			--qqi


			-- § Spells
			[164862] = 0, -- Flap
			[337344] = 132868, -- Mystic Bolt (missing icon)
			[337346] = 135731, -- Arcane Bolt (missing icon)
			[80066] = 511543, -- Tornado (Cataclysm air elementals, wrong icon)
			[355456] = 3528298, -- Damnation (transparent icon)

			-- § Ascension Crafting
				-- Lures
				[328321] = 465875, -- Overcharged Goliath Core
				[328680] = 132878, -- Soul Mirror
				[333530] = 463859, -- Anointment Oil
				[333533] = 3095185, -- Heartpiercer Javelin
				[333535] = 463570, -- Fountain of Rejuvenation
				[333545] = 1385268, -- Catalyst of Creation
				[333546] = 3601549, -- Praetor Resonance Beacon
				[333547] = 134105, -- Soulseeker Crystal
				[333548] = 2032583, -- Ashfallen Key
				[333549] = 3095185, -- Humility's Guard
				-- Boons
				[335705] = 237565, -- Sigil of Haunting Memories
				[342503] = 2103804, -- Skystrider Glider
				[342521] = 134776, -- Empyrean Refreshment
				[345713] = 1059112, -- Kyrian Smith's Kit
				[345757] = 348523, -- Steward Mail Pouch
				[345760] = 1551368, -- Gilded Abacus
				[345786] = 236904, -- Artisan Tool Belt
				[345894] = 1033908, -- Medallion of Service
				[345916] = 656322, -- Vesper of Calling
				-- Charms
				[333220] = 618857, -- Charm of Fortitude
				[335596] = 648759, -- Charm of Alacrity
				[335603] = 1033482, -- Charm of Persistence
				[335619] = 458969, -- Charm of Discord
				[335626] = 236498, -- Charm of Focus
				[335849] = 236498, -- Charm of Energizing (Unused?)
				[338384] = 135788, -- Charm of Quickness
				-- Equipment
				[333209] = 368863, -- Herald's Footpads
				[333230] = 838553, -- Deep Echo Trident
				[333362] = 134800, -- Vial of Lichfrost
				[333372] = 463534, -- Phial of Serenity
				[333374] = 3079436, -- Spiritforged Aegis
				[345978] = 1408456, -- Ring of Warding

			-- § Abominable Stitching
			[325284] = 3622121, -- Construct Body: "Chordy"
			[325454] = 3622122, -- Construct Body: "Atticus"
			[325452] = 3601552, -- Construct Body: "Marz"
			[325451] = 3622122, -- Construct Body: "Roseboil"
			[325453] = 3601552, -- Construct Body: "Flytrap"
			[326406] = 3601552, -- Construct Body: "Professor"
			[338040] = 3622122, -- Construct Body: "Sabrina"
			[326407] = 3601552, -- Construct Body: "Toothpick"
			[326380] = 3622122, -- Construct Body: "Gas Bag"
			[338039] = 3601552, -- Construct Body: "Guillotine"
			[338037] = 3601552, -- Construct Body: "Iron Phillip"
			[338043] = 3622121, -- Construct Body: "Naxx"
			[326408] = 3601552, -- Construct Body: "Mama Tomalin"
			[325458] = 3601552, -- Construct Body: "Miru"
			[326379] = 2492254, -- Construct Body: "Neena"
			[326525] = 3622121, -- Call Chordy
			[327203] = 3622122, -- Call Atticus
			[327556] = 3601552, -- Call Marz
			[327580] = 3622122, -- Call Roseboil
			[327002] = 3601552, -- Call Flytrap
			[341181] = 3601552, -- Call Professor
			[339451] = 3622122, -- Call Sabrina
			[340465] = 3601552, -- Call Toothpick
			[340882] = 3622122, -- Call Gas Bag
			[340839] = 3601552, -- Call Guillotine
			[340340] = 3601552, -- Call Iron Phillip
			[340841] = 3622121, -- Call Naxx

			-- § Alchemy
				-- Shadowlands Alchemy
					-- Quest Recipes
					[338204] = 1029738, -- Bramblethorn Juice
					[338199] = 650637, -- Brutal Oil
					[338200] = 133849, -- Crushed Bones
					[338195] = 132807, -- Distilled Resolve
					[338198] = 609897, -- Draught of Grotesque Strength
					[338202] = 967530, -- Elixir of Humility
					[338194] = 609901, -- Flask of Measured Discipline
					[338191] = 236878, -- Liquid Sleep
					[338190] = 967529, -- Potion of Hibernal Rest
					[338192] = 134379, -- Powdered Dreamroot
					[338196] = 133208, -- Pulverized Breezebloom
					[338203] = 461806, -- Refined Submission
					-- Anti-Venoms
					[307100] = 3566826, -- Spiritual Anti-Venom
					-- Cauldrons
					[307087] = 3620414, -- Eternal Cauldron
					-- Combat Potions
					[307093] = 3566835, -- Potion of Spectral Agility
					[307096] = 3566836, -- Potion of Spectral Intellect
					[307097] = 3566837, -- Potion of Spectral Stamina
					[307098] = 3566838, -- Potion of Spectral Strength
					[307384] = 3566833, -- Potion of Deathly Fixation
					[307381] = 3566831, -- Potion of Empowered Exorcisms
					[307383] = 3566830, -- Potion of Divine Awakening
					[307382] = 3566829, -- Potion of Phantom Fire
					[322301] = 3566832, -- Potion of Sacrificial Anima
					[307094] = 3566834, -- Potion of Hardened Shadows
					[307095] = 3566828, -- Potion of Spiritual Clarity
					[261423] = 3566859, -- Spiritual Rejuvenation Potion
					[301578] = 3566860, -- Spiritual Healing Potion
					[301683] = 3566858, -- Spiritual Mana Potion
					-- Flasks
					[307101] = 3566840, -- Spectral Flask of Power
					[307103] = 3566841, -- Spectral Flask of Stamina
					-- Optional Reagents
					[343676] = 1500875, -- Crafter's Mark of the Chained Isle
					[343677] = 1500871, -- Crafter's Mark III
					[343678] = 1500867, -- Crafter's Mark II
					[343679] = 1500863, -- Crafter's Mark I
					[343675] = 1500861, -- Novice Crafter's Mark
					-- Oils and Extracts
					[307122] = 3566853, -- Ground Widowbloom
					[307121] = 3566852, -- Ground Vigil's Torch
					[307125] = 3566850, -- Ground Nightshade
					[307123] = 3566856, -- Ground Marrowroot
					[307124] = 3566857, -- Ground Rising Glory
					[307120] = 3566855, -- Ground Death Blossom
					[307119] = 463544, -- Embalmer's Oil
					[307118] = 463543, -- Shadowcore Oil
					-- Transmutation
					[307143] = 1778229, -- Shadestone
					[307142] = 3528421, -- Shadowghast Ingot
					[307144] = 1519431, -- Stones to Ore
					-- Trinkets
					[307200] = 3566862, -- Spiritual Alchemy Stone
					-- Utility Potions
					[344316] = 967556, -- Potion of the Psychopomp's Speed
					[256133] = 3566866, -- Potion of Specter Swiftness
					[256134] = 3566865, -- Potion of Soul Purity
					[342887] = 3566869, -- Potion of Unhindered Passing
					[295084] = 3566867, -- Potion of Shaded Sight
					[261424] = 3566868, -- Potion of the Hidden Spirit
					-- Other
					[354885] = 3566847, -- Blossom Burst
					[354881] = 3566849, -- Glory Burst
					[354880] = 3566848, -- Marrow Burst
					[354884] = 3566844, -- Torch Burst
					[354882] = 3566845, -- Widow Burst
					[334413] = 2061718, -- Red Noggin Candle
				-- Kul Tiran Alchemy & Zandalari Alchemy
					-- Cauldrons
					-- Combat Potions
					-- Utility Potions
					-- Flasks
					-- Transmutation
					-- Trinkets
					-- Conversions
					-- Focus
					-- Follower Equipment
					-- Tool of the Trade
				-- Alchemy of the Broken Isles
					-- Cauldrons
					-- Combat Potions
					-- Flasks
					-- Transmutation
					-- Trinkets
					-- Utility Potions
				-- Alchemy of Draenor
					-- Cures & Tonics
					-- Reagents and Research
					-- Flasks
					-- Transmutation
					-- Potions and Elixirs
					-- Trinkets and Trinket Upgrades
				-- Alchemy of Pandaria
					-- Potions
					-- Elixirs
					-- Flasks
					-- Transmutation
					-- Trinkets
					-- Oils
				-- Alchemy of the Cataclysm
					-- Cauldrons
					-- Potions
					-- Elixirs
					-- Flasks
					-- Transmutation
					-- Trinkets
					-- Oils
					-- Mounts
				-- Alchemy of Northrend
					-- Research
					-- Potions
					-- Elixirs
					-- Flasks
					-- Transmutation
					-- Trinkets
					-- Oils
				-- Alchemy of Outland
					-- Cauldrons
					-- Potions
					-- Elixirs
					-- Flasks
					-- Transmutation
					-- Trinkets
				-- Alchemy
					-- Materials
					-- Potions
					-- Elixirs
					-- Flasks
					-- Transmutation
					-- Trinkets
					-- Oils
					-- Anti-Venoms

			-- § Blacksmithing
				-- Shadowlands Plans
					-- Armor
					-- Optional Reagents
					-- Other
					-- Shields
					-- Reagents
					-- Specialized Armor
					-- Weapons
					-- Weapons Mods
				-- Kul Tiran Plans & Zandalari Plans
					-- Optional Reagents
					-- Armor
					-- Weapons
					-- Other
					-- Mount Equipment
					-- Conversions
					-- Focus
					-- Follower Equipment
					-- Tool of the Trade
				-- Legion Plans
					-- Optional Reagents
					-- Reagents
					-- Relics
					-- Armor
					-- Other
				-- Draenor Plans
					-- Optional Reagents
					-- Reagents and Research
					-- Item Enhancers
					-- Armor
					-- Weapons and Shields
					-- Other
				-- Pandaren Plans
					-- Optional Reagents
					-- Materials
					-- Equipment Mods
					-- Helms
					-- Shoulders
					-- Chest
					-- Gauntlets
					-- Bracers
					-- Belts
					-- Legs
					-- Boots
					-- Shields
					-- Weapons
					-- Skeleton Keys
				-- Cataclysm Plans
					-- Optional Reagents
					-- Materials
					-- Equipment Mods
					-- Armor
					-- Shields
					-- Weapons
					-- Skeleton Keys
				-- Northrend Plans
					-- Optional Reagents
					-- Equipment Mods
					-- Armor
					-- Shields
					-- Weapons
					-- Skeleton Keys
				-- Outland Plans
					-- Optional Reagents
					-- Equipment Mods
					-- Armor
					-- Weapons
				-- Blacksmithing Plans
					-- Optional Reagents
					-- Materials
					-- Weapon Mods
					-- Armor Mods
					-- Helms
					-- Shoulders
					-- Chest
					-- Gauntlets
					-- Bracers
					-- Belts
					-- Legs
					-- Boots
					-- Shields
					-- Weapons
					-- Skeleton Keys

			-- § Enchanting
				-- Shadowlands Enchanting
					-- Boot Enchantments
					-- Bracer Enchantments
					-- Chest Enchantments
					-- Cloak Enchantments
					-- Glove Enchantments
					-- Optional Reagents
					-- Reagents
					-- Ring Enchantments
					-- Shatters
					-- Wands
					-- Weapon Enchantments
					-- Other
				-- Kul Tiran Enchanting & Zandalari Enchanting
					-- Glove Enchantments
					-- Ring Enchantments
					-- Weapon Enchantments
					-- Wrist Enchantments
					-- Wands
					-- Pets
					-- Conversions
					-- Mount Equipment
					-- Disenchants
					-- Follower Equipment
					-- Tool of the Trade
				-- Legion Enchanting
					-- Disenchant
					-- Ring Enchantments
					-- Cloak Enchantments
					-- Neck Enchantments
					-- Shoulder Enchantments
					-- Glove Enchantments
					-- Relics
					-- Toys, Pets, and Mounts
				-- Draenor Enchanting
					-- Reagents and Research
					-- Illusions
					-- Weapon
					-- Cloak
					-- Neck
					-- Ring
					-- Other
				-- Pandaria Enchanting
					-- Illusions
					-- Reagents
					-- Armor Enchantments
					-- Weapon Enchantments
					-- Shield and Off-Hand Enchantments
				-- Cataclysm Enchanting
					-- Illusions
					-- Reagents
					-- Armor Enchantments
					-- Weapon Enchantments
					-- Shield and Off-Hand Enchantments
					-- Pets
				-- Northrend Enchanting
					-- Illusions
					-- Reagents
					-- Boot Enchantments
					-- Glove Enchantments
					-- Chest Enchantments
					-- Cloak Enchantments
					-- Bracer Enchantments
					-- Weapon Enchantments
					-- Shield Enchantments
				-- Outland Enchanting
					-- Illusions
					-- Reagents
					-- Boot Enchantments
					-- Bracer Enchantments
					-- Chest Enchantments
					-- Cloak Enchantments
					-- Glove Enchantments
					-- Weapon Enchantments
					-- Shield Enchantments
					-- Oils
					-- Other
				-- Enchanting
					-- Illusions
					-- Reagents
					-- Boot Enchantments
					-- Bracer Enchantments
					-- Chest Enchantments
					-- Cloak Enchantments
					-- Glove Enchantments
					-- Weapon Enchantments
					-- Shield Enchantments
					-- Wands
					-- Oils
					-- Trinket

			-- § Engineering
				-- Shadowlands Engineering
					-- Belt Attachments
					[310496] = 136243, -- Electro-Jump
					[310495] = 136243, -- Dimensional Shifter
					[310497] = 136243, -- Damage Retaliator
					-- Bombs
					[310486] = 3610500, -- Bomb Bola Launcher
					[310485] = 3610510, -- Shadow Land Mine
					[310484] = 3610497, -- Nutcracker Grenade
					-- Devices
					[310535] = 3610528, -- Wormhole Generator: Shadowlands
					[310490] = 3610502, -- Momentum Redistributor Boots
					[310492] = 3610499, -- Gravimetric Scrambler Cannon
					[345179] = 3610508, -- Disposable Spectrophasic Reanimator
					[310493] = 3610505, -- 50UL-TR4P
					-- Goggles
					[310509] = 3557126, -- Reinforced Ectoplasmic Specs
					[310504] = 3557125, -- Grounded Ectoplasmic Specs
					[310501] = 3557124, -- Flexible Ectoplasmic Specs
					[310507] = 3557127, -- Articulated Ectoplasmic Specs
					-- Optional Reagents
					[343103] = 1500875, -- Crafter's Mark of the Chained Isle
					[343102] = 1500871, -- Crafter's Mark III
					[343100] = 1500867, -- Crafter's Mark II
					[343099] = 1500863, -- Crafter's Mark I
					[343661] = 1500861, -- Novice Crafter's Mark
					-- Parts
					[310526] = 3610506, -- Wormfed Gear Assembly
					[310525] = 3610504, -- Mortal Coiled Spring
					[310524] = 3610507, -- Porous Polishing Abrasive
					[310522] = 3610501, -- Handful of Laestrite Bolts
					-- Robotics
					[331007] = 3061634, -- PHA7-YNX
					-- Scopes
					[310533] = 3610512, -- Optical Target Embiggener
					[310534] = 3610513, -- Infra-green Reflex Sight
					-- Weapons
					[310536] = 3154538, -- Precision Lifeforce Inverter
					-- Quest Recipes
					[338218] = 133010, -- Bone Reinforced Oxxein Tubing
					[338217] = 135537, -- Boneclad Stake Launcher
					[338119] = 132488, -- Bug Zapifier
					[338220] = 331438, -- Duelist's Pistol
					[338212] = 133243, -- Electro Cable
					[338210] = 132489, -- Energized Battery
					[338219] = 133008, -- Handful of Oxxein Bolts
					[338216] = 237292, -- Hardened Bolts
					[338214] = 1405814, -- Piston Assembly
					[338213] = 1405803, -- Power Hammer
					[338222] = 463529, -- Sinvyr Barrel
					[338223] = 1405812, -- Sinvyr Trigger Mechanism
				-- Kul Tiran Engineering & Zandalari Engineering
					-- Belt Attachments
					[255936] = 136243, -- Belt Enchant: Holographic Horror Projector
					[269123] = 136243, -- Belt Enchant: Miniaturized Plasma Shield
					[255940] = 136243, -- Belt Enchant: Personal Space Amplifier
					-- Bombs
					[255394] = 2115301, -- F.R.I.E.D. (Rank 3)
					[255393] = 2115301, -- F.R.I.E.D. (Rank 2)
					[255392] = 2115301, -- F.R.I.E.D. (Rank 1)
					[255409] = 2115304, -- Organic Discombobulation Grenade (Rank 3)
					[255408] = 2115304, -- Organic Discombobulation Grenade (Rank 2)
					[255407] = 2115304, -- Organic Discombobulation Grenade (Rank 1)
					[255397] = 2115303, -- Thermo-Accelerated Plague Spreader (Rank 3)
					[255396] = 2115303, -- Thermo-Accelerated Plague Spreader (Rank 2)
					[255395] = 2115303, -- Thermo-Accelerated Plague Spreader (Rank 1)
					-- Devices
					[298930] = 133015, -- Blingtron 7000
					[299105] = 2000841, -- Wormhole Generator: Kul Tiras
					[299106] = 2000840, -- Wormhole Generator: Zandalar
					[283916] = 2115322, -- Unstable Temporal Time Shifter (Rank 3)
					[283915] = 2115322, -- Unstable Temporal Time Shifter (Rank 2)
					[283914] = 2115322, -- Unstable Temporal Time Shifter (Rank 1)
					[256156] = 2115311, -- Deployable Attire Rearranger (Rank 3)
					[256155] = 2115311, -- Deployable Attire Rearranger (Rank 2)
					[256154] = 2115311, -- Deployable Attire Rearranger (Rank 1)
					[256072] = 2115312, -- Electroshock Mount Motivator (Rank 3)
					[256071] = 2115312, -- Electroshock Mount Motivator (Rank 2)
					[256070] = 2115312, -- Electroshock Mount Motivator (Rank 1)
					[256084] = 2115316, -- Interdimensional Companion Repository (Rank 3)
					[256082] = 2115316, -- Interdimensional Companion Repository (Rank 2)
					[256080] = 2115316, -- Interdimensional Companion Repository (Rank 1)
					[256075] = 2115323, -- XA-1000 Surface Skimmer (Rank 3)
					[256074] = 2115323, -- XA-1000 Surface Skimmer (Rank 2)
					[256073] = 2115323, -- XA-1000 Surface Skimmer (Rank 1)
					[280734] = 2115317, -- Magical Intrusion Dampener (Rank 3)
					[280733] = 2115317, -- Magical Intrusion Dampener (Rank 2)
					[280732] = 2115317, -- Magical Intrusion Dampener (Rank 1)
					-- Cloth Goggles
					[305945] = 1041266, -- A-N0M-A-L0U5 Synthetic Specs
					[299005] = 1041266, -- A5C-3N-D3D Synthetic Specs
					[299004] = 1041266, -- Abyssal Synthetic Specs
					[299006] = 1041266, -- Charged A5C-3N-D3D Synthetic Specs
					[305943] = 1041266, -- Paramount Synthetic Specs
					[305944] = 1041266, -- Superior Synthetic Specs
					[272058] = 1041266, -- AZ3-R1-T3 Synthetic Specs (Rank 3)
					[272057] = 1041266, -- AZ3-R1-T3 Synthetic Specs (Rank 2)
					[272056] = 1041266, -- AZ3-R1-T3 Synthetic Specs (Rank 1)
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
					[272061] = 1041266, -- AZ3-R1-T3 Gearspun Goggles (Rank 3)
					[272060] = 1041266, -- AZ3-R1-T3 Gearspun Goggles (Rank 2)
					[272059] = 1041266, -- AZ3-R1-T3 Gearspun Goggles (Rank 1)
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
					[272064] = 1041266, -- AZ3-R1-T3 Bionic Bifocals (Rank 3)
					[272063] = 1041266, -- AZ3-R1-T3 Bionic Bifocals (Rank 2)
					[272062] = 1041266, -- AZ3-R1-T3 Bionic Bifocals (Rank 1)
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
					[272067] = 1041266, -- AZ3-R1-T3 Orthogonal Optics (Rank 3)
					[272066] = 1041266, -- AZ3-R1-T3 Orthogonal Optics (Rank 2)
					[272065] = 1041266, -- AZ3-R1-T3 Orthogonal Optics (Rank 1)
					[286872] = 1041266, -- Charged SP1-R1-73D Orthogonal Optics
					[286871] = 1041266, -- SP1-R1-73D Orthogonal Optics
					[286870] = 1041266, -- Surging Orthogonal Optics
					[291096] = 1041266, -- Emblazoned Orthogonal Optics
					[291095] = 1041266, -- Imbued Orthogonal Optics
					-- Weapons
					[294786] = 1992345, -- Notorious Combatant's Discombobulator (Rank 3)
					[294785] = 1992345, -- Notorious Combatant's Discombobulator (Rank 2)
					[294784] = 1992345, -- Notorious Combatant's Discombobulator (Rank 1)
					[294789] = 1777844, -- Notorious Combatant's Stormsteel Destroyer (Rank 3)
					[294788] = 1777844, -- Notorious Combatant's Stormsteel Destroyer (Rank 2)
					[294787] = 1777844, -- Notorious Combatant's Stormsteel Destroyer (Rank 1)
					[305861] = 1992345, -- Uncanny Combatant's Discombobulator (Rank 3)
					[305862] = 1992345, -- Uncanny Combatant's Discombobulator (Rank 2)
					[305863] = 1992345, -- Uncanny Combatant's Discombobulator (Rank 1)
					[305858] = 1992345, -- Uncanny Combatant's Stormsteel Destroyer (Rank 3)
					[305859] = 1992345, -- Uncanny Combatant's Stormsteel Destroyer (Rank 2)
					[305860] = 1992345, -- Uncanny Combatant's Stormsteel Destroyer (Rank 1)
					[255459] = 1773651, -- Finely-Tuned Stormsteel Destroyer (Rank 3)
					[255458] = 1773651, -- Finely-Tuned Stormsteel Destroyer (Rank 2)
					[255457] = 1773651, -- Finely-Tuned Stormsteel Destroyer (Rank 1)
					[253152] = 1992345, -- Precision Attitude Adjuster (Rank 3)
					[253151] = 1992345, -- Precision Attitude Adjuster (Rank 2)
					[253150] = 1992345, -- Precision Attitude Adjuster (Rank 1)
					[282808] = 1992345, -- Sinister Combatant's Discombobulator (Rank 3)
					[282807] = 1992345, -- Sinister Combatant's Discombobulator (Rank 2)
					[282806] = 1992345, -- Sinister Combatant's Discombobulator (Rank 1)
					[282811] = 1778299, -- Sinister Combatant's Stormsteel Destroyer (Rank 3)
					[282810] = 1778299, -- Sinister Combatant's Stormsteel Destroyer (Rank 2)
					[282809] = 1778299, -- Sinister Combatant's Stormsteel Destroyer (Rank 1)
					[269726] = 1992345, -- Honorable Combatant's Discombobulator (Rank 3)
					[269725] = 1992345, -- Honorable Combatant's Discombobulator (Rank 2)
					[269724] = 1992345, -- Honorable Combatant's Discombobulator (Rank 1)
					[269729] = 1778299, -- Honorable Combatant's Stormsteel Destroyer (Rank 3)
					[269728] = 1778299, -- Honorable Combatant's Stormsteel Destroyer (Rank 2)
					[269727] = 1778299, -- Honorable Combatant's Stormsteel Destroyer (Rank 1)
					[253122] = 1992345, -- Magnetic Discombobulator
					-- Scopes & Ammo
					[264962] = 2115310, -- Crow's Nest Scope (Rank 3)
					[264961] = 2115310, -- Crow's Nest Scope (Rank 2)
					[264960] = 2115310, -- Crow's Nest Scope (Rank 1)
					[265102] = 2115313, -- Frost-Laced Ammunition (Rank 3)
					[265101] = 2115313, -- Frost-Laced Ammunition (Rank 2)
					[265100] = 2115313, -- Frost-Laced Ammunition (Rank 1)
					[265099] = 2115315, -- Incendiary Ammunition (Rank 3)
					[265098] = 2115315, -- Incendiary Ammunition (Rank 2)
					[265097] = 2115315, -- Incendiary Ammunition (Rank 1)
					[264967] = 2115319, -- Monelite Scope of Alacrity (Rank 3)
					[264966] = 2115319, -- Monelite Scope of Alacrity (Rank 2)
					[264964] = 2115319, -- Monelite Scope of Alacrity (Rank 1)
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
					[199011] = 1391897, -- Double-Barreled Cranial Cannon (Rank 3)
					[198997] = 1391897, -- Double-Barreled Cranial Cannon (Rank 2)
					[198970] = 1391897, -- Double-Barreled Cranial Cannon (Rank 1)
					[235756] = 1391897, -- Heavy Skullblasters
					[199012] = 1391897, -- Ironsight Cranial Cannon (Rank 3)
					[198998] = 1391897, -- Ironsight Cranial Cannon (Rank 2)
					[198971] = 1391897, -- Ironsight Cranial Cannon (Rank 1)
					[235754] = 1391897, -- Rugged Skullblasters
					[199010] = 1391897, -- Sawed-Off Cranial Cannon (Rank 3)
					[198996] = 1391897, -- Sawed-Off Cranial Cannon (Rank 2)
					[198969] = 1391897, -- Sawed-Off Cranial Cannon (Rank 1)
					[199009] = 1391897, -- Semi-Automagic Cranial Cannon (Rank 3)
					[198995] = 1391897, -- Semi-Automagic Cranial Cannon (Rank 2)
					[198968] = 1391897, -- Semi-Automagic Cranial Cannon (Rank 1)
					[235753] = 1391897, -- Tailored Skullblasters
					[199005] = 1391897, -- Blink-Trigger Headgun (Rank 3)
					[198991] = 1391897, -- Blink-Trigger Headgun (Rank 2)
					[198939] = 1391897, -- Blink-Trigger Headgun (Rank 1)
					[199007] = 1391897, -- Bolt-Action Headgun (Rank 3)
					[198993] = 1391897, -- Bolt-Action Headgun (Rank 2)
					[198966] = 1391897, -- Bolt-Action Headgun (Rank 1)
					[199008] = 1391897, -- Reinforced Headgun (Rank 3)
					[198994] = 1391897, -- Reinforced Headgun (Rank 2)
					[198967] = 1391897, -- Reinforced Headgun (Rank 1)
					[199006] = 1391897, -- Tactical Headgun (Rank 3)
					[198992] = 1391897, -- Tactical Headgun (Rank 2)
					[198965] = 1391897, -- Tactical Headgun (Rank 1)
					-- Combat Tools
					[199013] = 1405805, -- Deployable Bullet Dispenser (Rank 3)
					[198999] = 1405805, -- Deployable Bullet Dispenser (Rank 2)
					[198972] = 1405805, -- Deployable Bullet Dispenser (Rank 1)
					[199014] = 1405808, -- Gunpowder Charge (Rank 3)
					[199000] = 1405808, -- Gunpowder Charge (Rank 2)
					[198973] = 1405808, -- Gunpowder Charge (Rank 1)
					[199015] = 1405816, -- Pump-Action Bandage Gun (Rank 3)
					[199001] = 1405816, -- Pump-Action Bandage Gun (Rank 2)
					[198974] = 1405816, -- Pump-Action Bandage Gun (Rank 1)
					-- Devices
					[198981] = 1336885, -- Trigger
					[199017] = 1405803, -- Auto-Hammer (Rank 3)
					[199003] = 1405803, -- Auto-Hammer (Rank 2)
					[198976] = 1405803, -- Auto-Hammer (Rank 1)
					[198980] = 1405804, -- Blingtron's Circuit Design Tutorial
					[199018] = 1405806, -- Failure Detection Pylon (Rank 3)
					[199004] = 1405806, -- Failure Detection Pylon (Rank 2)
					[198977] = 1405806, -- Failure Detection Pylon (Rank 1)
					[199016] = 1405807, -- Gunpack (Rank 3)
					[199002] = 1405807, -- Gunpack (Rank 2)
					[198975] = 1405807, -- Gunpack (Rank 1)
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

			-- § Inscription
				-- Shadowlands Inscription
					-- Ink
					-- Optional Reagents
					-- Books & Scrolls
					-- Contracts
					-- Cards
					-- Vantus Runes
					-- Staves
					-- Off-Hands
					-- Mass Milling
					-- Hats
				-- Kul Tiran Inscription & Zandalari Inscription
					-- Inks
					[298929] = 3007458, -- Maroon Ink
					[264777] = 2178489, -- Crimson Ink
					[264776] = 2178529, -- Ultramarine Ink
					[264778] = 2178532, -- Viridescent Ink
					-- Books & Scrolls
					-- Contracts
					-- Trinkets
					-- Off-Hands
					-- Mass Milling
					-- Vantus Runes
					-- Glyphs
					-- Conversions
					-- Blood Contracts
					-- Follower Equipment
					-- Tool of the Trade
				-- Legion Inscription
					-- Cards
					-- Mass Milling
					-- Glyphs
					-- Vantus Runes
					-- Books & Scrolls
					-- Relics
				-- Draenor Inscription
					-- Reagents and Research
					-- Tools
					-- Mass Milling
					-- Glyphs
					-- Item Enhancers
					-- Card
					-- Staves & Wands
					-- Off-Hand
				-- Pandaria Inscription
					-- Inks
					-- Glyphs
					-- Staves & Off-Hands
					-- Trinkets
					-- Cards
					-- Scrolls & Research
					-- Shoulder Inscription
					-- Quest
					-- Toys & Pets
				-- Cataclysm Inscription
					-- Inks
					-- Glyphs
					-- Scrolls & Research
					-- Cards
					-- Shoulder Inscription
					-- Weapons & Off-Hands
					-- Quest
					-- Toys
				-- Northrend Inscription
					-- Inks
					-- Glyphs
					-- Scrolls & Research
					-- Cards
					-- Off-Hands
					-- Shoulder Inscription
				-- Outland Inscription
					-- Inks
					-- Glyphs
					-- Cards
					-- Scrolls & Research
					-- Off-Hands
				-- Inscription
					-- Research
					-- Ink
					-- Card
					-- Off-Hand
					-- Scrolls
					-- Clear Mind
					-- Glyphs
					-- Other

			-- § Jewelcrafting
				-- Shadowlands Designs
					-- Quest Recipes
					[338248] = 1033177, -- Brilliant Bauble
					[338244] = 1022155, -- Carved Crystal Ring
					[338239] = 1408445, -- Engraved Phaedrum Band
					[338246] = 135229, -- Faceted Crystal
					[338249] = 236922, -- Fine Sinvyr Chain
					[338238] = 1391681, -- Gem Studded Bangle
					[338241] = 1112954, -- Gleaming Kyranite Necklace
					[338245] = 1716831, -- Hollowed Crystal
					[338242] = 338783, -- Kyranite Dangle
					[338240] = 134072, -- Polished Gemstones
					[338247] = 1379215, -- Sinister Choker
					[338243] = 133243, -- Solenium Wire
					-- Gems
					[311867] = 3743163, -- Straddling Jewel Doublet
					[311866] = 3743155, -- Versatile Jewel Doublet
					[311868] = 3743164, -- Deadly Jewel Doublet
					[311869] = 3743165, -- Masterful Jewel Doublet
					[311871] = 3743167, -- Quick Jewel Doublet
					[311870] = 3743166, -- Revitalizing Jewel Doublet
					[311863] = 3743190, -- Deadly Jewel Cluster
					[311859] = 3743188, -- Versatile Jewel Cluster
					[311864] = 3743191, -- Masterful Jewel Cluster
					[311865] = 3743193, -- Quick Jewel Cluster
					-- Mass Prospecting
					[311948] = 3594132, -- Mass Prospect Laestrite
					[311950] = 3608331, -- Mass Prospect Oxxein
					[311951] = 3537032, -- Mass Prospect Phaedrum
					[311952] = 3616941, -- Mass Prospect Sinvyr
					[311949] = 3731242, -- Mass Prospect Solenium
					[311953] = 3749971, -- Mass Prospect Elethium
					-- Optional Reagents
					[343693] = 1500861, -- Novice Crafter's Mark
					[343697] = 1500863, -- Crafter's Mark I
					[343696] = 1500867, -- Crafter's Mark II
					[343695] = 1500871, -- Crafter's Mark III
					[352443] = 1411836, -- Vestige of Origins
					[343694] = 1500875, -- Crafter's Mark of the Chained Isle
					-- Necklaces
					[311902] = 3754299, -- Deadly Laestrite Choker
					[311904] = 3743178, -- Masterful Laestrite Choker
					[311903] = 3754300, -- Quick Laestrite Choker
					[311905] = 3743176, -- Versatile Laestrite Choker
					[311906] = 3754302, -- Deadly Sinvyr Necklace
					[311908] = 3747267, -- Masterful Phaedrum Necklace
					[311907] = 3754303, -- Quick Oxxein Necklace
					[311909] = 3747265, -- Versatile Solenium Necklace
					-- Rings
					[311880] = 3743181, -- Deadly Laestrite Band
					[311882] = 3743182, -- Masterful Laestrite Band
					[311881] = 3754301, -- Quick Laestrite Band
					[311883] = 3743180, -- Versatile Laestrite Band
					[311884] = 3743185, -- Deadly Sinvyr Ring
					[311886] = 3743186, -- Masterful Phaedrum Ring
					[311885] = 3754304, -- Quick Oxxein Ring
					[311887] = 3743184, -- Versatile Solenium Ring
					-- Specialized Jewelry
					[327921] = 3747268, -- Shadowghast Necklace (Rank 1)
					[332040] = 3747268, -- Shadowghast Necklace (Rank 2)
					[332075] = 3747268, -- Shadowghast Necklace (Rank 3)
					[338977] = 3747268, -- Shadowghast Necklace (Rank 4)
					[327920] = 3743187, -- Shadowghast Ring (Rank 1)
					[332039] = 3743187, -- Shadowghast Ring (Rank 2)
					[332074] = 3743187, -- Shadowghast Ring (Rank 3)
					[338978] = 3743187, -- Shadowghast Ring (Rank 4)
					-- Statues
					[355187] = 3852566, -- Porous Stone Statue
					[355189] = 3852564, -- Shaded Stone Statue
					-- Hats
					[334548] = 1670851, -- Crown of the Righteous
				-- Kul Tiran Designs & Zandalari Designs
					-- Gems
					-- Mass Prospecting
					-- Rings
					-- Weapons
					-- Conversions
					-- Focus
					-- Follower Equipment
					-- Tool of the Trade
				-- Legion Designs
					-- Rings
					-- Necklaces
					-- Gems
					-- Crowns
					-- Other
					-- Mass Prospecting
				-- Draenor Designs
					-- Reagents and Research
					-- Jewelry Enhancers
					-- Jewelry
					-- Gems
					-- Other
				-- Pandaria Designs
					-- Research
					-- Blue Gems
					-- Green Gems
					-- Orange Gems
					-- Purple Gems
					-- Red Gems
					-- Yellow Gems
					-- Meta Gems
					-- Necklaces
					-- Rings
					-- Mounts
					-- Toys & Pets
				-- Cataclysm Designs
					-- Blue Gems
					-- Green Gems
					-- Orange Gems
					-- Purple Gems
					-- Red Gems
					-- Yellow Gems
					-- Meta Gems
					-- Necklaces
					-- Rings
					-- Crowns
					-- Fist Weapons
					-- Toys & Prisms
				-- Northrend Designs
					-- Blue Gems
					-- Green Gems
					-- Orange Gems
					-- Purple Gems
					-- Red Gems
					-- Yellow Gems
					-- Meta Gems
					-- Prismatic Gems
					-- Necklaces
					-- Rings
					-- Pets and Projects
				-- Outland Designs
					-- Reagents
					-- Blue Gems
					-- Green Gems
					-- Orange Gems
					-- Purple Gems
					-- Red Gems
					-- Yellow Gems
					-- Meta Gems
					-- Necklaces
					-- Rings
					-- Crowns
					-- Trinkets
					-- Prisms & Statues
				-- Jewelcrafting Designs
					-- Rings
					-- Necklaces
					-- Materials
					-- Crowns
					-- Trinkets
					-- Fist Weapons
					-- Statues

			-- § Leatherworking
				-- Shadowlands Patterns
					-- Materials
					-- Optional Reagents
					-- Armor Kits
					-- Other
					-- Specialized Armor
					-- Leather Armor
					-- Mail Armor
					-- Weapons
					-- Mount Equipment
				-- Kul Tiran Patterns & Zandalari Patterns
					-- Optional Reagents
					-- Leather Armor
					-- Mail Armor
					-- Weapons
					-- Mount Equipment
					-- Other
					-- Conversions
					-- Focus
					-- Follower Equipment
					-- Tool of the Trade
				-- Legion Patterns
					-- Optional Reagents
					-- Leather Armor
					-- Mail Armor
					-- Other
				-- Draenor Patterns
					-- Optional Reagents
					-- Reagents and Research
					-- Bags
					-- Armor Enhancers
					-- Leather Armor
					-- Mail Armor
					-- Cloaks
					-- Other
				-- Pandaria Patterns
					-- Optional Reagents
					-- Materials
					-- Embossments
					-- Armor Kits
					-- Bags
					-- Helms
					-- Shoulders
					-- Chest
					-- Bracers
					-- Gloves
					-- Belts
					-- Pants
					-- Boots
					-- Cloaks
					-- Drums
					-- Research
				-- Cataclysm Patterns
					-- Optional Reagents
					-- Materials
					-- Armor Kits
					-- Bags
					-- Helms
					-- Shoulders
					-- Chest
					-- Bracers
					-- Gloves
					-- Belts
					-- Pants
					-- Boots
					-- Cloaks
				-- Northrend Patterns
					-- Optional Research
					-- Materials
					-- Armor Kits
					-- Bags
					-- Helms
					-- Shoulders
					-- Chest
					-- Bracers
					-- Gloves
					-- Belts
					-- Pants
					-- Boots
					-- Cloaks
					-- Drums
				-- Outland Patterns
					-- Optional Research
					-- Materials
					-- Armor Kits
					-- Bags
					-- Helms
					-- Shoulders
					-- Chest
					-- Bracers
					-- Gloves
					-- Belts
					-- Pants
					-- Boots
					-- Cloaks
					-- Special
					-- Drums
				-- Leatherworking Patterns
					-- Optional Research
					-- Materials
					-- Armor Kits
					-- Bags
					-- Helms
					-- Shoulders
					-- Chest
					-- Bracers
					-- Gloves
					-- Belts
					-- Pants
					-- Boots
					-- Cloaks

			-- § Mining
				-- Pandaria Mining
					-- Smelting
					[102167] = 612063, -- Smelt Trillium
					[102165] = 538438, -- Smelt Ghost Iron
				-- Cataclysm Mining
					-- Smelting
					[74529] = 466846, -- Smelt Pyrite
					[74537] = 463522, -- Smelt Hardened Elementium
					[74530] = 463549, -- Smelt Elementium
					[84038] = 135241, -- Smelt Obsidium
				-- Northrend Mining
					-- Smelting
					[49258] = 237049, -- Smelt Saronite
					[55211] = 237045, -- Smelt Titanium
					[55208] = 237046, -- Smelt Titansteel
					[49252] = 133228, -- Smelt Cobalt
				-- Outland Mining
					-- Elemental
					[35750] = 132838, -- Earth Sunder
					[35751] = 132839, -- Fire Sunder
					-- Smelting
					[46353] = 133235, -- Smelt Hardened Khorium
					[29361] = 133223, -- Smelt Khorium
					[29686] = 133226, -- Smelt Hardened Adamantite
					[29360] = 133231, -- Smelt Felsteel
					[29359] = 133225, -- Smelt Eternium
					[29358] = 133224, -- Smelt Adamantite
					[29356] = 133230, -- Smelt Fel Iron
				-- Mining
					-- Smelting
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

			-- § Tailoring
				-- Shadowlands Patterns
					-- Quest Recipes
					[338270] = 132901, -- Ardensilk Cloth
					[338277] = 237280, -- Bleakcloth
					[338269] = 132902, -- Bolt of Ardensilk Cloth
					[338276] = 463536, -- Bolt of Bleakcloth
					[338279] = 466845, -- Bolt of Prideweave
					[338272] = 348544, -- Bolt of Woven Gossamer
					[338267] = 348279, -- Cloak of Camouflage
					[338273] = 463524, -- Gossamer Cloth
					[338275] = 1318381, -- Haunting Hood
					[338278] = 132484, -- Looming Tapestry
					[338280] = 466843, -- Pridewing Cloth
					[338271] = 132625, -- Woven Gossamer Tunic
					-- Optional Reagents
					[352445] = 1411836, -- Vestige of Origins
					[343200] = 1500875, -- Crafter's Mark of the Chained Isle
					[343201] = 1500871, -- Crafter's Mark III
					[343202] = 1500867, -- Crafter's Mark II
					[343204] = 1500863, -- Crafter's Mark I
					[343659] = 1500861, -- Novice Crafter's Mark
					-- Bags
					[345986] = 3528455, -- Lightless Silk Pouch
					[3528454] = 3528454, -- Shrouded Cloth Bag
					-- Specialized Armor
					[310885] = 3552673, -- Grim-Veiled Belt
					[332037] = 3552673, -- Grim-Veiled Belt
					[332072] = 3552673, -- Grim-Veiled Belt
					[339003] = 3552673, -- Grim-Veiled Belt
					[310886] = 3552697, -- Grim-Veiled Bracers
					[332038] = 3552697, -- Grim-Veiled Bracers
					[332073] = 3552697, -- Grim-Veiled Bracers
					[339004] = 3552697, -- Grim-Veiled Bracers
					[310880] = 3552707, -- Grim-Veiled Cape
					[332032] = 3552707, -- Grim-Veiled Cape
					[332067] = 3552707, -- Grim-Veiled Cape
					[338995] = 3552707, -- Grim-Veiled Cape
					[310882] = 3552748, -- Grim-Veiled Hood
					[332034] = 3552748, -- Grim-Veiled Hood
					[332069] = 3552748, -- Grim-Veiled Hood
					[339000] = 3552748, -- Grim-Veiled Hood
					[310881] = 3552739, -- Grim-Veiled Mittens
					[332033] = 3552739, -- Grim-Veiled Mittens
					[332068] = 3552739, -- Grim-Veiled Mittens
					[338998] = 3552739, -- Grim-Veiled Mittens
					[310883] = 3552762, -- Grim-Veiled Pants
					[332035] = 3552762, -- Grim-Veiled Pants
					[332070] = 3552762, -- Grim-Veiled Pants
					[339001] = 3552762, -- Grim-Veiled Pants
					[310879] = 3552775, -- Grim-Veiled Robe
					[332031] = 3552775, -- Grim-Veiled Robe
					[332066] = 3552775, -- Grim-Veiled Robe
					[338996] = 3552775, -- Grim-Veiled Robe
					[310878] = 3552682, -- Grim-Veiled Sandals
					[332030] = 3552682, -- Grim-Veiled Sandals
					[332065] = 3552682, -- Grim-Veiled Sandals
					[338997] = 3552682, -- Grim-Veiled Sandals
					[310884] = 3552785, -- Grim-Veiled Spaulders
					[332036] = 3552785, -- Grim-Veiled Spaulders
					[332071] = 3552785, -- Grim-Veiled Spaulders
					[339002] = 3552785, -- Grim-Veiled Spaulders
					-- Armor
					[310901] = 3527521, -- Shadowlace Trousers
					[310902] = 3527525, -- Shadowlace Mantle
					[310897] = 3527523, -- Shadowlace Tunic
					[310900] = 3527519, -- Shadowlace Cowl
					[310898] = 3527513, -- Shadowlace Cloak
					[310899] = 3527517, -- Shadowlace Handwraps
					[310903] = 3527505, -- Shadowlace Cord
					[310896] = 3527508, -- Shadowlace Footwraps
					[310904] = 3527510, -- Shadowlace Cuffs
					[310875] = 3386283, -- Shrouded Cloth Spaulders
					[310874] = 3386281, -- Shrouded Cloth Pants
					[310870] = 3386282, -- Shrouded Cloth Robe
					[310873] = 3386280, -- Shrouded Cloth Hood
					[310871] = 3386277, -- Shrouded Cloth Cape
					[310872] = 3386279, -- Shrouded Cloth Mittens
					[310876] = 3449934, -- Shrouded Cloth Belt
					[310869] = 3386274, -- Shrouded Cloth Sandals
					[310877] = 3386275, -- Shrouded Cloth Bracers
					-- Hats & Accessories
					[355183] = 454036, -- Shrouded Hand Towel
					[334499] = 669448, -- Pink Party Hat
					-- Bandages
					[310923] = 3528457, -- Heavy Shrouded Cloth Bandage
					[310924] = 3528458, -- Shrouded Cloth Bandage
				-- Kul Tiran Patterns & Zandalari Patterns
					-- Embroidery
					[272440] = 2060257, -- Embroidered Deep Sea Satin
					[279183] = 136249, -- Discreet Spellthread
					[279184] = 136249, -- Feathery Spellthread
					[279182] = 136249, -- Resilient Spellthread
					-- Optional Reagents
					[330257] = 132527, -- Relic of the Past I
					[330258] = 132528, -- Relic of the Past II
					[330259] = 132529, -- Relic of the Past III
					[330260] = 132531, -- Relic of the Past IV
					[330261] = 132532, -- Relic of the Past V
					-- Bags
					[257130] = 2023244, -- Embroidered Deep Sea Bag (Rank 3)
					[257129] = 2023244, -- Embroidered Deep Sea Bag (Rank 2)
					[257128] = 2023244, -- Embroidered Deep Sea Bag (Rank 1)
					[257127] = 2023243, -- Deep Sea Bag (Rank 3)
					[257126] = 2023243, -- Deep Sea Bag (Rank 2)
					[257125] = 2023243, -- Deep Sea Bag (Rank 1)
					-- Armor
					[304564] = 3048018, -- Eldritch Seaweave Breeches
					[304561] = 3048016, -- Eldritch Seaweave Gloves
					[304563] = 3048009, -- Maddening Seaweave Breeches
					[304560] = 3048007, -- Maddening Seaweave Gloves
					[304562] = 3048009, -- Unsettling Seaweave Breeches
					[304559] = 3048007, -- Unsettling Seaweave Gloves
					[299036] = 2906610, -- Banded Seaweave Breeches
					[299033] = 2906608, -- Banded Seaweave Gloves
					[299035] = 2906600, -- Reinforced Seaweave Breeches
					[299032] = 2906598, -- Reinforced Seaweave Gloves
					[299034] = 2906600, -- Gilded Seaweave Breeches
					[299031] = 2906598, -- Gilded Seaweave Gloves
					[285093] = 2280683, -- Tempered Deep Sea Breeches
					[285094] = 2280679, -- Tempered Deep Sea Gloves
					[285085] = 2280683, -- Fortified Deep Sea Breeches
					[285086] = 2280678, -- Fortified Deep Sea Gloves
					[285077] = 2280683, -- Enhanced Deep Sea Breeches
					[285078] = 2280678, -- Enhanced Deep Sea Gloves
					[257124] = 2059669, -- Emblazoned Deep Sea Breeches
					[257121] = 2059667, -- Emblazoned Deep Sea Gloves
					[257123] = 2059678, -- Imbued Deep Sea Breeches
					[257120] = 2059676, -- Imbued Deep Sea Gloves
					[257122] = 2059678, -- Embroidered Deep Sea Breeches
					[257118] = 2059676, -- Embroidered Deep Sea Gloves
					[294843] = ZA.AH(1866955, 1706370), -- Notorious Combatant's Satin Belt (Rank 3)
					[294842] = ZA.AH(1866955, 1706370), -- Notorious Combatant's Satin Belt (Rank 2)
					[294841] = ZA.AH(1866955, 1706370), -- Notorious Combatant's Satin Belt (Rank 1)
					[294834] = ZA.AH(1866966, 1706373), -- Notorious Combatant's Satin Boots (Rank 3)
					[294833] = ZA.AH(1866966, 1706373), -- Notorious Combatant's Satin Boots (Rank 2)
					[294832] = ZA.AH(1866966, 1706373), -- Notorious Combatant's Satin Boots (Rank 1)
					[294846] = ZA.AH(1866967, 1706376), -- Notorious Combatant's Satin Bracers (Rank 3)
					[294845] = ZA.AH(1866967, 1706376), -- Notorious Combatant's Satin Bracers (Rank 2)
					[294844] = ZA.AH(1866967, 1706376), -- Notorious Combatant's Satin Bracers (Rank 1)
					[294831] = ZA.AH(1866958, 1706396), -- Notorious Combatant's Satin Cloak (Rank 3)
					[294830] = ZA.AH(1866958, 1706396), -- Notorious Combatant's Satin Cloak (Rank 2)
					[294829] = ZA.AH(1866958, 1706396), -- Notorious Combatant's Satin Cloak (Rank 1)
					[294837] = ZA.AH(1866970, 1706382), -- Notorious Combatant's Satin Mittens (Rank 3)
					[294836] = ZA.AH(1866970, 1706382), -- Notorious Combatant's Satin Mittens (Rank 2)
					[294835] = ZA.AH(1866970, 1706382), -- Notorious Combatant's Satin Mittens (Rank 1)
					[294840] = ZA.AH(1866972, 1706388), -- Notorious Combatant's Satin Pants (Rank 3)
					[294839] = ZA.AH(1866972, 1706388), -- Notorious Combatant's Satin Pants (Rank 2)
					[294838] = ZA.AH(1866972, 1706388), -- Notorious Combatant's Satin Pants (Rank 1)
					[304579] = ZA.AH(1866955, 1706370), -- Uncanny Combatant's Satin Belt (Rank 3)
					[304578] = ZA.AH(1866955, 1706370), -- Uncanny Combatant's Satin Belt (Rank 2)
					[304577] = ZA.AH(1866955, 1706370), -- Uncanny Combatant's Satin Belt (Rank 1)
					[304570] = ZA.AH(1866966, 1706373), -- Uncanny Combatant's Satin Boots (Rank 3)
					[304569] = ZA.AH(1866966, 1706373), -- Uncanny Combatant's Satin Boots (Rank 2)
					[304568] = ZA.AH(1866966, 1706373), -- Uncanny Combatant's Satin Boots (Rank 1)
					[304582] = ZA.AH(1866967, 1706376), -- Uncanny Combatant's Satin Bracers (Rank 3)
					[304581] = ZA.AH(1866967, 1706376), -- Uncanny Combatant's Satin Bracers (Rank 2)
					[304580] = ZA.AH(1866967, 1706376), -- Uncanny Combatant's Satin Bracers (Rank 1)
					[304567] = ZA.AH(1866958, 1706396), -- Uncanny Combatant's Satin Cloak (Rank 3)
					[304566] = ZA.AH(1866958, 1706396), -- Uncanny Combatant's Satin Cloak (Rank 2)
					[304565] = ZA.AH(1866958, 1706396), -- Uncanny Combatant's Satin Cloak (Rank 1)
					[304573] = ZA.AH(1866970, 1706382), -- Uncanny Combatant's Satin Mittens (Rank 3)
					[304572] = ZA.AH(1866970, 1706382), -- Uncanny Combatant's Satin Mittens (Rank 2)
					[304571] = ZA.AH(1866970, 1706382), -- Uncanny Combatant's Satin Mittens (Rank 1)
					[304576] = ZA.AH(1866972, 1706388), -- Uncanny Combatant's Satin Pants (Rank 3)
					[304575] = ZA.AH(1866972, 1706388), -- Uncanny Combatant's Satin Pants (Rank 2)
					[304574] = ZA.AH(1866972, 1706388), -- Uncanny Combatant's Satin Pants (Rank 1)
					[257116] = ZA.AH(2032235, 1957069), -- Embroidered Deep Sea Cloak (Rank 3)
					[257115] = ZA.AH(2032235, 1957069), -- Embroidered Deep Sea Cloak (Rank 2)
					[257114] = ZA.AH(2032235, 1957069), -- Embroidered Deep Sea Cloak (Rank 1)
					[282170] = ZA.AH(1866955, 1706370), -- Sinister Combatant's Satin Belt (Rank 3)
					[282169] = ZA.AH(1866955, 1706370), -- Sinister Combatant's Satin Belt (Rank 2)
					[282168] = ZA.AH(1866955, 1706370), -- Sinister Combatant's Satin Belt (Rank 1)
					[282196] = ZA.AH(1866966, 1706373), -- Sinister Combatant's Satin Boots (Rank 3)
					[282195] = ZA.AH(1866966, 1706373), -- Sinister Combatant's Satin Boots (Rank 2)
					[282194] = ZA.AH(1866966, 1706373), -- Sinister Combatant's Satin Boots (Rank 1)
					[282166] = ZA.AH(1866967, 1706376), -- Sinister Combatant's Satin Bracers (Rank 3)
					[282165] = ZA.AH(1866967, 1706376), -- Sinister Combatant's Satin Bracers (Rank 2)
					[282164] = ZA.AH(1866967, 1706376), -- Sinister Combatant's Satin Bracers (Rank 1)
					[282276] = ZA.AH(1866958, 1706396), -- Sinister Combatant's Satin Cloak (Rank 3)
					[282275] = ZA.AH(1866958, 1706396), -- Sinister Combatant's Satin Cloak (Rank 2)
					[282204] = ZA.AH(1866958, 1706396), -- Sinister Combatant's Satin Cloak (Rank 1)
					[282193] = ZA.AH(1866970, 1706382), -- Sinister Combatant's Satin Mittens (Rank 3)
					[282192] = ZA.AH(1866970, 1706382), -- Sinister Combatant's Satin Mittens (Rank 2)
					[282191] = ZA.AH(1866970, 1706382), -- Sinister Combatant's Satin Mittens (Rank 1)
					[282177] = ZA.AH(1866972, 1706388), -- Sinister Combatant's Satin Pants (Rank 3)
					[282176] = ZA.AH(1866972, 1706388), -- Sinister Combatant's Satin Pants (Rank 2)
					[282175] = ZA.AH(1866972, 1706388), -- Sinister Combatant's Satin Pants (Rank 1)
					[269610] = ZA.AH(1866955, 1706370), -- Honorable Combatant's Satin Belt (Rank 3)
					[269609] = ZA.AH(1866955, 1706370), -- Honorable Combatant's Satin Belt (Rank 2)
					[269608] = ZA.AH(1866955, 1706370), -- Honorable Combatant's Satin Belt (Rank 1)
					[269601] = ZA.AH(1866966, 1706373), -- Honorable Combatant's Satin Boots (Rank 3)
					[269600] = ZA.AH(1866966, 1706373), -- Honorable Combatant's Satin Boots (Rank 2)
					[269599] = ZA.AH(1866966, 1706373), -- Honorable Combatant's Satin Boots (Rank 1)
					[269613] = ZA.AH(1866967, 1706376), -- Honorable Combatant's Satin Bracers (Rank 3)
					[269612] = ZA.AH(1866967, 1706376), -- Honorable Combatant's Satin Bracers (Rank 2)
					[269611] = ZA.AH(1866967, 1706376), -- Honorable Combatant's Satin Bracers (Rank 1)
					[269598] = ZA.AH(1866958, 1706396), -- Honorable Combatant's Satin Cloak (Rank 3)
					[269597] = ZA.AH(1866958, 1706396), -- Honorable Combatant's Satin Cloak (Rank 2)
					[269596] = ZA.AH(1866958, 1706396), -- Honorable Combatant's Satin Cloak (Rank 1)
					[269604] = ZA.AH(1866970, 1706382), -- Honorable Combatant's Satin Mittens (Rank 3)
					[269603] = ZA.AH(1866970, 1706382), -- Honorable Combatant's Satin Mittens (Rank 2)
					[269602] = ZA.AH(1866970, 1706382), -- Honorable Combatant's Satin Mittens (Rank 1)
					[269607] = ZA.AH(1866972, 1706388), -- Honorable Combatant's Satin Pants (Rank 3)
					[269606] = ZA.AH(1866972, 1706388), -- Honorable Combatant's Satin Pants (Rank 2)
					[269605] = ZA.AH(1866972, 1706388), -- Honorable Combatant's Satin Pants (Rank 1)
					[257104] = ZA.AH(1698805, 1762576), -- Tidespray Linen Robe
					[257107] = ZA.AH(1698804, 2055323), -- Tidespray Linen Cloak
					[257097] = ZA.AH(1698807, 1762578), -- Tidespray Linen Hood
					[257101] = ZA.AH(1698809, 1762580), -- Tidespray Linen Spaulders
					[257099] = ZA.AH(1698808, 1762579), -- Tidespray Linen Pants
					[257102] = ZA.AH(1698801, 1762573), -- Tidespray Linen Belt
					[257096] = ZA.AH(1698806, 1762577), -- Tidespray Linen Mittens
					[257095] = ZA.AH(1698802, 1762574), -- Tidespray Linen Sandals
					[257103] = ZA.AH(1698803, 1762575), -- Tidespray Linen Bracers
					-- Battle Flags
					[257136] = 2054277, -- Battle Flag: Phalanx Defense (Rank 3)
					[257135] = 2054277, -- Battle Flag: Phalanx Defense (Rank 2)
					[257134] = 2054277, -- Battle Flag: Phalanx Defense (Rank 1)
					[257139] = 2054278, -- Battle Flag: Rallying Swiftness (Rank 3)
					[257138] = 2054278, -- Battle Flag: Rallying Swiftness (Rank 2)
					[257137] = 2054278, -- Battle Flag: Rallying Swiftness (Rank 1)
					[257133] = 2054276, -- Battle Flag: Spirit of Freedom (Rank 3)
					[257132] = 2054276, -- Battle Flag: Spirit of Freedom (Rank 2)
					[257131] = 2054276, -- Battle Flag: Spirit of Freedom (Rank 1)
					-- Other
					[268983] = 2159815, -- Hooked Deep Sea Net
					[268982] = 2159817, -- Tidespray Linen Net
					-- Bandages
					[267202] = 2032603, -- Deep Sea Bandage
					[267201] = 2032604, -- Tidespray Linen Bandage
					-- Conversions
					[287274] = 1020349, -- Aqueous Alteration
					[286654] = 876915, -- Sanguinated Alteration
					-- Mount Equipment
					[301409] = 534598, -- Saddlechute
					[301403] = 647702, -- Seabreeze Saddle Blanket
					-- Focus
					[307175] = 3072251, -- Void Focus
					-- Follower Equipment
					[278414] = 236914, -- Rough-hooked Tidespray Linen
					-- Tool of the Trade
					[292946] = 2490714, -- Synchronous Thread
				-- Legion Patterns
					-- Trainnig
					[186799] = 526170, -- Basic Silkweave Robe
					[186801] = 526170, -- Embroidered Silkweave Robe
					[186803] = 133656, -- Handcrafted Silkweave Bag
					[187060] = 1045771, -- Handcrafted Silkweave Hood
					[186738] = 526170, -- Handcrafted Silkweave Robe
					[187066] = 446097, -- Masterwork Silkweave Bracers
					[186764] = 446098, -- Rune-Threaded Silkweave Bracers
					[186763] = 526170, -- Rune-Threaded Silkweave Robe
					[187064] = 133806, -- Silkweave Bracer Lining
					[187065] = 446097, -- Silkweave Bracer: Outer Layer
					[187058] = 133135, -- Silkweave Hood Lining
					[187059] = 1045771, -- Silkweave Hood: Outer Layer
					-- Optional Reagents
					[330252] = 132527, -- Relic of the Past I
					[330253] = 132528, -- Relic of the Past II
					[330254] = 132529, -- Relic of the Past III
					[330255] = 132531, -- Relic of the Past IV
					[330256] = 132532, -- Relic of the Past V
					-- Reagents
					[185962] = 1379174, -- Imbued Silkweave
					-- Cloth Armor
					[239412] = 1083038, -- Celumbra, the Night's Dichotomy
					[185954] = 1134724, -- Imbued Silkweave Bracers (Rank 3)
					[185946] = 1134724, -- Imbued Silkweave Bracers (Rank 2)
					[185926] = 1134724, -- Imbued Silkweave Bracers (Rank 1)
					[185955] = 1134722, -- Imbued Silkweave Cinch (Rank 3)
					[185947] = 1134722, -- Imbued Silkweave Cinch (Rank 2)
					[185927] = 1134722, -- Imbued Silkweave Cinch (Rank 1)
					[185956] = 1134730, -- Imbued Silkweave Epaulets (Rank 3)
					[185948] = 1134730, -- Imbued Silkweave Epaulets (Rank 2)
					[185928] = 1134730, -- Imbued Silkweave Epaulets (Rank 1)
					[185959] = 1134726, -- Imbued Silkweave Gloves (Rank 3)
					[185951] = 1134726, -- Imbued Silkweave Gloves (Rank 2)
					[185931] = 1134726, -- Imbued Silkweave Gloves (Rank 1)
					[185958] = 1134727, -- Imbued Silkweave Hood (Rank 3)
					[185950] = 1134727, -- Imbued Silkweave Hood (Rank 2)
					[185930] = 1134727, -- Imbued Silkweave Hood (Rank 1)
					[185957] = 1134728, -- Imbued Silkweave Pantaloons (Rank 3)
					[185949] = 1134728, -- Imbued Silkweave Pantaloons (Rank 2)
					[185929] = 1134728, -- Imbued Silkweave Pantaloons (Rank 1)
					[185961] = 1134729, -- Imbued Silkweave Robe (Rank 3)
					[185953] = 1134729, -- Imbued Silkweave Robe (Rank 2)
					[185933] = 1134729, -- Imbued Silkweave Robe (Rank 1)
					[185960] = 1134723, -- Imbued Silkweave Slippers (Rank 3)
					[185952] = 1134723, -- Imbued Silkweave Slippers (Rank 2)
					[185932] = 1134723, -- Imbued Silkweave Slippers (Rank 1)
					[247809] = 1662771, -- Lightweave Breeches (Rank 3)
					[247808] = 1662771, -- Lightweave Breeches (Rank 2)
					[247807] = 1662771, -- Lightweave Breeches (Rank 1)
					[185942] = 1267783, -- Silkweave Bracers (Rank 3)
					[185934] = 1267783, -- Silkweave Bracers (Rank 2)
					[185918] = 1267783, -- Silkweave Bracers (Rank 1)
					[185943] = 1267781, -- Silkweave Cinch (Rank 3)
					[185935] = 1267781, -- Silkweave Cinch (Rank 2)
					[185919] = 1267781, -- Silkweave Cinch (Rank 1)
					[185944] = 1267788, -- Silkweave Epaulets (Rank 3)
					[185936] = 1267788, -- Silkweave Epaulets (Rank 2)
					[185920] = 1267788, -- Silkweave Epaulets (Rank 1)
					[208350] = 1267785, -- Silkweave Gloves (Rank 3)
					[185939] = 1267785, -- Silkweave Gloves (Rank 2)
					[185923] = 1267785, -- Silkweave Gloves (Rank 1)
					[208351] = 1267786, -- Silkweave Hood (Rank 3)
					[185938] = 1267786, -- Silkweave Hood (Rank 2)
					[185922] = 1267786, -- Silkweave Hood (Rank 1)
					[208353] = 1267787, -- Silkweave Pantaloons (Rank 3)
					[185937] = 1267787, -- Silkweave Pantaloons (Rank 2)
					[185921] = 1267787, -- Silkweave Pantaloons (Rank 1)
					[185945] = 1267784, -- Silkweave Robe (Rank 3)
					[185941] = 1267784, -- Silkweave Robe (Rank 2)
					[185925] = 1267784, -- Silkweave Robe (Rank 1)
					[208352] = 1267782, -- Silkweave Slippers (Rank 3)
					[185940] = 1267782, -- Silkweave Slippers (Rank 2)
					[185924] = 1267782, -- Silkweave Slippers (Rank 1)
					-- Cloaks
					[186114] = 1315132, -- Imbued Silkweave Cover (Rank 3)
					[186113] = 1315132, -- Imbued Silkweave Cover (Rank 2)
					[186112] = 1315132, -- Imbued Silkweave Cover (Rank 1)
					[186117] = 1315132, -- Imbued Silkweave Drape (Rank 3)
					[186116] = 1315132, -- Imbued Silkweave Drape (Rank 2)
					[186115] = 1315132, -- Imbued Silkweave Drape (Rank 1)
					[186111] = 1315132, -- Imbued Silkweave Flourish (Rank 3)
					[186110] = 1315132, -- Imbued Silkweave Flourish (Rank 2)
					[186109] = 1315132, -- Imbued Silkweave Flourish (Rank 1)
					[186108] = 1315132, -- Imbued Silkweave Shade (Rank 3)
					[186107] = 1315132, -- Imbued Silkweave Shade (Rank 2)
					[186106] = 1315132, -- Imbued Silkweave Shade (Rank 1)
					[186097] = 1315132, -- Silkweave Cover
					[186100] = 1315132, -- Silkweave Drape
					[186094] = 1315132, -- Silkweave Flourish
					[186091] = 1315132, -- Silkweave Shade
					-- Other
					[229045] = 1379173, -- Imbued Silkweave Bag (Rank 3)
					[229043] = 1379173, -- Imbued Silkweave Bag (Rank 2)
					[229041] = 1379173, -- Imbued Silkweave Bag (Rank 1)
					[220511] = 1379171, -- Bloodtotem Saddle Blanket
					[213035] = 1379168, -- Clothes Chest: Dalaran Citizens
					[213036] = 1379169, -- Clothes Chest: Karazhan Opera House
					[213037] = 1379170, -- Clothes Chest: Molten Core
					[186388] = 1379173, -- Silkweave Satchel
					-- Cures of the Broken Isles
					[202854] = 1387612, -- Silkweave Splint
					[230047] = 132911, -- Feathered Luffa
					[202853] = 1387610, -- Silkweave Bandage
				-- Draenor Patterns
					-- Optional Reagents
					[330247] = 132527, -- Relic of the Past I
					[330248] = 132528, -- Relic of the Past II
					[330249] = 132529, -- Relic of the Past III
					[330250] = 132531, -- Relic of the Past IV
					[330251] = 132532, -- Relic of the Past V
					-- Reagents and Research
					[182123] = 1029754, -- Primal Weaving
					[168835] = 1029754, -- Hexweave Cloth
					[176058] = 133735, -- Secrets of Draenor Tailoring
					-- Dyes and Thread
					[168836] = 1029753, -- Hexweave Embroidery
					-- Armor
					[168847] = 1044837, -- Brilliant Hexweave Cloak
					[168844] = 973183, -- Hexweave Belt
					[168842] = 973187, -- Hexweave Bracers
					[168838] = 973193, -- Hexweave Cowl
					[168840] = 973191, -- Hexweave Gloves
					[168839] = 973195, -- Hexweave Leggings
					[168837] = 973199, -- Hexweave Mantle
					[168841] = 973197, -- Hexweave Robe
					[168843] = 973185, -- Hexweave Slippers
					[168846] = 1044837, -- Nimble Hexweave Cloak
					[168845] = 1044837, -- Powerful Hexweave Cloak
					[168852] = 973194, -- Sumptuous Cowl
					[168854] = 973196, -- Sumptuous Leggings
					[168853] = 973198, -- Sumptuous Robes
					-- Battle Standards
					[176314] = 132486, -- Fearsome Battle Standard (Alliance)
					[176316] = 132485, -- Fearsome Battle Standard (Horde)
					[176313] = 132486, -- Inspiring Battle Standard (Alliance)
					[176315] = 132485, -- Inspiring Battle Standard (Horde)
					-- Other
					[168850] = 1029750, -- Creeping Carpet
					[168849] = 1044082, -- Elekk Plushie
					[168848] = 1029751, -- Hexweave Bag
					-- Cures of Draenor
					[172539] = 1014022, -- Antiseptic Bandage
				-- Pandaria Patterns
					-- Optional Reagents
					-- Materials
					-- Embroidery
					-- Spellthreads
					-- Bags
					-- Hats & Hoods
					-- Shoulders
					-- Robes & Tunics
					-- Bracers
					-- Belts
					-- Gloves
					-- Pants
					-- Boots
					-- Cloaks
					-- Bandages
				-- Cataclysm Patterns
					-- Optional Reagents
					-- Materials
					-- Spellthreads
					-- Bags
					-- Hats & Hoods
					-- Shoulders
					-- Robes & Tunics
					-- Bracers
					-- Belts
					-- Gloves
					-- Pants
					-- Boots
					-- Cloaks
					-- Nets
					-- Bandages
				-- Northrend Patterns
					-- Optional Reagents
					-- Materials
					-- Spellthread
					-- Bags
					-- Hats & Hoods
					-- Shoulders
					-- Robes & Tunics
					-- Bracers
					-- Belts
					-- Gloves
					-- Pants
					-- Boots
					-- Cloaks
					-- Shirts
					-- Mounts
					-- Nets
					-- Bandages
				-- Outland Patterns
					-- Optional Reagents
					-- Materials
					-- Spellthreads
					-- Bags
					-- Hats & Hoods
					-- Shoulders
					-- Robes & Tunics
					-- Bracers
					-- Belts
					-- Gloves
					-- Pants
					-- Boots
					-- Cloaks
					-- Nets
					-- Bandages
				-- Tailoring Patterns
					-- Optional Reagents
					-- Materials
					-- Bags
					-- Hats & Hoods
					-- Shoulders
					-- Robes & Tunics
					-- Bracers
					-- Belts
					-- Gloves
					-- Pants
					-- Boots
					-- Cloaks
					-- Shirts
					-- Bandages

			-- § Cooking
				-- Shadowlands Cuisine
					-- Feasts
					[308402] = 3760524, -- Surprisingly Palatable Feast
					[308403] = 3760523, -- Feast of Gluttonous Hedonism
					-- Large Meals
					[308400] = 3671897, -- Spinefin Souffle and Fries
					[308413] = 3671891, -- Iridescent Ravioli with Apple Sauce
					[308405] = 3671905, -- Tenebrous Crown Roast Aspic
					[308426] = 3671904, -- Steal a la Mode
					[308411] = 3671889, -- Candied Amberjack Cakes
					[308415] = 3671886, -- Banana Beaf Pudding
					-- Light Meals
					[354768] = 135233, -- Porous Rock Candy
					[354764] = 132814, -- Twilight Tea
					[354766] = 133950, -- Bonemeal Bread
					[308404] = 3671890, -- Cinnamon Bonefish Stew
					[308412] = 3671894, -- Meaty Apple Dumplings
					[308425] = 3671901, -- Sweet Silvergill Sausages
					[308397] = 3671888, -- Butterscotch Marinated Ribs
					[308414] = 3671898, -- Pickled Meat Smoothie
					[308410] = 3671887, -- Biscuits and Caviar
					-- Soul Food
					[308419] = 3671902, -- Smothered Shank
					[308417] = 3671900, -- Seraph Tenders
					[308416] = 3671899, -- Quiethounds
					[308420] = 3671893, -- Fried Bonefish
					-- Quest Recipes
					[338100] = 651358, -- Arden Apple Pie
					[338107] = 650635, -- Diced Vegetables
					[338115] = 133779, -- Ember Sauce
					[338106] = 1045948, -- Grazer Bone Broth
					[338101] = 1500973, -- Oat Pie Crust
					[338117] = 134040, -- Seared Cutlets
					[338116] = 237337, -- Skewered Meats
					[338102] = 646177, -- Sliced Arden Apples
					[338110] = 237346, -- Spider Jerky
					[338105] = 134019, -- Steward Stew
					[338113] = 237339, -- Thick Spider Meat
				-- Kul Tiran Cuisine & Zandalari Cuisine
					-- Delicacies
					[314959] = 461132, -- Baked Voidfin
					[314961] = 237335, -- Dubious Delight
					[314962] = 237331, -- Ghastly Goulash
					[314963] = 237353, -- Grilled Gnasher
					[314960] = 461134, -- K'Bab
					-- Light Meals
					[303788] = 134042, -- Unagi Skewer
					[259435] = 2066018, -- Seasoned Loins (Rank 3)
					[259434] = 2066018, -- Seasoned Loins (Rank 2)
					[259433] = 2066018, -- Seasoned Loins (Rank 1)
					[286381] = 2443145, -- Honey Potpie
					[259432] = 2066007, -- Grilled Catfish (Rank 3)
					[259431] = 2066007, -- Grilled Catfish (Rank 2)
					[259430] = 2066007, -- Grilled Catfish (Rank 1)
					[280282] = 133199, -- Heartsbane Hexwurst
					-- Desserts
					[259413] = 2066009, -- Kul Tiramisu (Rank 3)
					[259412] = 2066009, -- Kul Tiramisu (Rank 2)
					[259411] = 2066009, -- Kul Tiramisu (Rank 1)
					[259438] = 2066010, -- Loa Loaf (Rank 3)
					[259437] = 2066010, -- Loa Loaf (Rank 2)
					[259436] = 2066010, -- Loa Loaf (Rank 1)
					[259444] = 2066014, -- Mon'Dazi (Rank 3)
					[259443] = 2066014, -- Mon'Dazi (Rank 2)
					[259442] = 2066014, -- Mon'Dazi (Rank 1)
					[259426] = 2066016, -- Ravenberry Tarts (Rank 3)
					[259425] = 2066016, -- Ravenberry Tarts (Rank 2)
					[259424] = 2066016, -- Ravenberry Tarts (Rank 1)
					[288029] = 2466573, -- Wild Berry Bread (Rank 3)
					[288028] = 2466573, -- Wild Berry Bread (Rank 2)
					[288027] = 2466573, -- Wild Berry Bread (Rank 1)
					-- Large Meals
					[301392] = 134063, -- Mecha-Bytes
					[297086] = 133904, -- Abyssal-Fried Rissole (Rank 3)
					[297085] = 133904, -- Abyssal-Fried Rissole (Rank 2)
					[297084] = 133904, -- Abyssal-Fried Rissole (Rank 1)
					[297083] = 651570, -- Baked Port Tato (Rank 3)
					[297082] = 651570, -- Baked Port Tato (Rank 2)
					[297081] = 651570, -- Baked Port Tato (Rank 1)
					[297089] = 134004, -- Bil'Tong (Rank 3)
					[297088] = 134004, -- Bil'Tong (Rank 2)
					[297087] = 134004, -- Bil'Tong (Rank 1)
					[297074] = 461136, -- Fragrant Kakavia (Rank 3)
					[297075] = 461136, -- Fragrant Kakavia (Rank 2)
					[297077] = 461136, -- Fragrant Kakavia (Rank 1)
					[297080] = 1046262, -- Mech-Dowel's "Big Mech" (Rank 3)
					[297079] = 1046262, -- Mech-Dowel's "Big Mech" (Rank 2)
					[297078] = 1046262, -- Mech-Dowel's "Big Mech" (Rank 1)
					[259416] = 2066008, -- Honey-Glazed Haunches (Rank 3)
					[259415] = 2066008, -- Honey-Glazed Haunches (Rank 3)
					[259414] = 2066008, -- Honey-Glazed Haunches (Rank 3)
					[259441] = 2066017, -- Sailor's Pie (Rank 3)
					[259440] = 2066017, -- Sailor's Pie (Rank 2)
					[259439] = 2066017, -- Sailor's Pie (Rank 1)
					[288033] = 2466899, -- Seasoned Steak and Potatoes (Rank 3)
					[288032] = 2466899, -- Seasoned Steak and Potatoes (Rank 2)
					[288030] = 2466899, -- Seasoned Steak and Potatoes (Rank 1)
					[259447] = 2066019, -- Spiced Snapper (Rank 3)
					[259446] = 2066019, -- Spiced Snapper (Rank 2)
					[259445] = 2066019, -- Spiced Snapper (Rank 1)
					[259429] = 2066021, -- Swamp Fish 'n Chips (Rank 3)
					[259428] = 2066021, -- Swamp Fish 'n Chips (Rank 2)
					[259427] = 2066021, -- Swamp Fish 'n Chips (Rank 1)
					[290473] = 133197, -- Boralus Blood Sausage (Rank 3)
					[290472] = 133197, -- Boralus Blood Sausage (Rank 2)
					[290471] = 133197, -- Boralus Blood Sausage (Rank 1)
					-- Feasts
					[297107] = 456330, -- Famine Evaluator And Snack Table (Rank 3)
					[297106] = 456330, -- Famine Evaluator And Snack Table (Rank 2)
					[297105] = 456330, -- Famine Evaluator And Snack Table (Rank 1)
					[259423] = 2066011, -- Bountiful Captain's Feast (Rank 3)
					[259422] = 2066011, -- Bountiful Captain's Feast (Rank 2)
					[259421] = 2066011, -- Bountiful Captain's Feast (Rank 1)
					[287112] = 2451910, -- Sanguinated Feast (Rank 3)
					[287110] = 2451910, -- Sanguinated Feast (Rank 2)
					[287108] = 2451910, -- Sanguinated Feast (Rank 1)
					[259420] = 2066013, -- Galley Banquet (Rank 3)
					[259419] = 2066013, -- Galley Banquet (Rank 2)
					[259418] = 2066013, -- Galley Banquet (Rank 1)
				-- Food of the Broken Isles
					-- Snacks
					[201685] = 1387636, -- Crispy Bacon (Rank 3)
					[201684] = 1387636, -- Crispy Bacon (Rank 2)
					[201683] = 1387636, -- Crispy Bacon (Rank 1)
					[230046] = 651570, -- Spiced Falcosaur Omelet
					[201560] = 1387641, -- Bear Tartare (Rank 3)
					[201540] = 1387641, -- Bear Tartare (Rank 2)
					[201513] = 1387641, -- Bear Tartare (Rank 1)
					[201559] = 1387645, -- Dried Mackerel Strips (Rank 3)
					[201539] = 1387645, -- Dried Mackerel Strips (Rank 2)
					[201512] = 1387645, -- Dried Mackerel Strips (Rank 1)
					[201561] = 1387649, -- Fighter Chow (Rank 3)
					[201541] = 1387649, -- Fighter Chow (Rank 2)
					[201514] = 1387649, -- Fighter Chow (Rank 1)
					-- Light Meals
					[201545] = 1387644, -- Deep-Fried Mossgill (Rank 3)
					[201525] = 1387644, -- Deep-Fried Mossgill (Rank 2)
					[201496] = 1387644, -- Deep-Fried Mossgill (Rank 1)
					[201547] = 1387647, -- Faronaar Fizz (Rank 3)
					[201527] = 1387647, -- Faronaar Fizz (Rank 2)
					[201498] = 1387647, -- Faronaar Fizz (Rank 1)
					[201546] = 1387660, -- Pickled Stormray (Rank 3)
					[201526] = 1387660, -- Pickled Stormray (Rank 2)
					[201497] = 1387660, -- Pickled Stormray (Rank 1)
					[201544] = 1387662, -- Salt and Pepper Shank (Rank 3)
					[201524] = 1387662, -- Salt and Pepper Shank (Rank 2)
					[201413] = 1387662, -- Salt and Pepper Shank (Rank 1)
					[201548] = 1387664, -- Spiced Rib Roast (Rank 3)
					[201528] = 1387664, -- Spiced Rib Roast (Rank 2)
					[201499] = 1387664, -- Spiced Rib Roast (Rank 1)
					-- Large Meals
					[201551] = 1387640, -- Barracuda Mrglgagh (Rank 3)
					[201531] = 1387640, -- Barracuda Mrglgagh (Rank 2)
					[201502] = 1387640, -- Barracuda Mrglgagh (Rank 1)
					[201553] = 1387646, -- Drogbar-Style Salmon (Rank 3)
					[201533] = 1387646, -- Drogbar-Style Salmon (Rank 2)
					[201504] = 1387646, -- Drogbar-Style Salmon (Rank 1)
					[201552] = 1387653, -- Koi-Scented Stormray (Rank 3)
					[201532] = 1387653, -- Koi-Scented Stormray (Rank 2)
					[201503] = 1387653, -- Koi-Scented Stormray (Rank 1)
					[201549] = 1387656, -- Leybeque Ribs (Rank 3)
					[201529] = 1387656, -- Leybeque Ribs (Rank 2)
					[201500] = 1387656, -- Leybeque Ribs (Rank 1)
					[201550] = 1387666, -- Suramar Surf and Turf (Rank 3)
					[201530] = 1387666, -- Suramar Surf and Turf (Rank 2)
					[201501] = 1387666, -- Suramar Surf and Turf (Rank 1)
					-- Delicacies
					[201555] = 1387635, -- Azshari Salad (Rank 3)
					[201535] = 1387635, -- Azshari Salad (Rank 2)
					[201506] = 1387635, -- Azshari Salad (Rank 1)
					[201558] = 1387650, -- Fishbrul Special (Rank 3)
					[201538] = 1387650, -- Fishbrul Special (Rank 2)
					[201511] = 1387650, -- Fishbrul Special (Rank 1)
					[201556] = 1387659, -- Nightborne Delicacy Platter (Rank 3)
					[201536] = 1387659, -- Nightborne Delicacy Platter (Rank 2)
					[201507] = 1387659, -- Nightborne Delicacy Platter (Rank 1)
					[201557] = 1387663, -- Seed-Battered Fish Plate (Rank 3)
					[201537] = 1387663, -- Seed-Battered Fish Plate (Rank 2)
					[201508] = 1387663, -- Seed-Battered Fish Plate (Rank 1)
					[201554] = 1387667, -- The Hungry Magister (Rank 3)
					[201534] = 1387667, -- The Hungry Magister (Rank 2)
					[201505] = 1387667, -- The Hungry Magister (Rank 1)
					-- Feasts
					[201562] = 1387652, -- Hearty Feast (Rank 3)
					[201542] = 1387652, -- Hearty Feast (Rank 2)
					[201515] = 1387652, -- Hearty Feast (Rank 1)
					[201563] = 1387654, -- Lavish Suramar Feast (Rank 3)
					[201543] = 1387654, -- Lavish Suramar Feast (Rank 2)
					[201516] = 1387654, -- Lavish Suramar Feast (Rank 1)
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

			-- §
		}
	end
end


local function eventHandler(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if ZA and ZA.CastSchoolByNameAuto then
			local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = CombatLogGetCurrentEventInfo()

			if subEvent == "SPELL_CAST_START" or subEvent == "SPELLCAST_SUCCESS" then
				if spellId then
					_, _, icon = GetSpellInfo(spellId)
					ZA.CastSchoolByNameAuto[spellName..":"..(icon or 0)] = spellSchool or 0
				elseif spellName then
					ZA.CastSchoolByNameAuto[spellName] = spellSchool or 0
				end
			end
		end
	elseif event == "VARIABLES_LOADED" then
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
			print(CreateAtlasMarkup("groupfinder-icon-greencheckmark") .. " |cff32de00Debug Mode Enabled|r")
		else
			ZA.DebugMode = false
			print(CreateAtlasMarkup("LFG-lock") .. " Debug Mode Disabled")
		end
	else
		print("ZA is not initialized")
	end
end