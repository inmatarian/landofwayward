return { version = "1.1", luaversion = "5.1", orientation = "orthogonal", width = 40, height = 45, tilewidth = 16, tileheight = 16, properties = {}, tilesets = { { name = "tileset", firstgid = 1, tilewidth = 16, tileheight = 16, spacing = 0, margin = 0, image = "tileset.png", imagewidth = 256, imageheight = 512, properties = {}, tiles = {} }, { name = "entities", firstgid = 513, tilewidth = 16, tileheight = 16, spacing = 0, margin = 0, image = "entities.png", imagewidth = 256, imageheight = 256, properties = {}, tiles = {} } }, layers = { { type = "tilelayer", name = "Floor", x = 0, y = 0, width = 40, height = 45, visible = true, opacity = 1, properties = {}, encoding = "lua", data = { 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 16, 88, 87, 87, 87, 89, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 16, 16, 86, 160, 158, 160, 86, 16, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 16, 16, 16, 86, 158, 431, 158, 86, 16, 16, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 16, 16, 16, 16, 16, 54, 86, 160, 158, 160, 86, 16, 16, 16, 16, 16, 16, 16, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 16, 16, 16, 16, 16, 16, 16, 16, 54, 88, 91, 160, 160, 160, 90, 89, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 56, 56, 56, 56, 56, 56, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 54, 54, 86, 160, 160, 160, 160, 160, 86, 54, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 56, 56, 56, 56, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 363, 363, 54, 54, 54, 86, 160, 160, 160, 160, 160, 86, 54, 54, 363, 363, 363, 363, 16, 16, 16, 16, 16, 16, 16, 16, 56, 56, 56, 16, 16, 16, 16, 16, 16, 16, 363, 363, 363, 363, 363, 363, 363, 363, 54, 90, 89, 160, 160, 160, 88, 91, 54, 363, 363, 363, 313, 313, 363, 363, 363, 363, 363, 363, 363, 16, 56, 56, 16, 16, 16, 363, 363, 363, 363, 363, 363, 313, 313, 313, 313, 313, 313, 363, 363, 145, 83, 160, 160, 160, 83, 145, 363, 363, 313, 313, 313, 313, 313, 313, 313, 363, 313, 363, 363, 16, 16, 56, 16, 16, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 54, 145, 64, 64, 64, 145, 54, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 16, 56, 16, 363, 363, 313, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 363, 54, 54, 30, 30, 30, 54, 54, 363, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 16, 363, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 363, 313, 363, 54, 54, 54, 54, 54, 363, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 16, 363, 363, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 363, 363, 363, 363, 363, 313, 363, 313, 313, 313, 313, 313, 313, 363, 363, 363, 363, 313, 363, 363, 16, 56, 16, 16, 363, 363, 363, 313, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 363, 363, 313, 363, 363, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 16, 56, 56, 16, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 363, 53, 363, 313, 363, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 313, 363, 363, 16, 56, 56, 56, 16, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 313, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 56, 16, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 313, 313, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 18, 18, 18, 313, 363, 16, 16, 56, 56, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 363, 363, 313, 313, 363, 363, 313, 313, 313, 313, 363, 17, 56, 56, 18, 18, 313, 363, 16, 56, 56, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 363, 53, 363, 363, 313, 313, 313, 313, 313, 313, 313, 56, 56, 56, 56, 18, 313, 363, 16, 56, 56, 16, 16, 363, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 56, 56, 56, 56, 17, 313, 363, 16, 16, 56, 16, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 16, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 363, 363, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 313, 313, 313, 363, 53, 363, 313, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 313, 363, 16, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 313, 313, 313, 363, 16, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 363, 363, 16, 16, 16, 363, 313, 313, 313, 313, 313, 18, 18, 18, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 16, 16, 363, 363, 313, 313, 363, 363, 17, 56, 56, 18, 18, 313, 363, 363, 313, 313, 313, 363, 53, 363, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 16, 363, 313, 313, 313, 313, 363, 56, 56, 56, 56, 18, 313, 313, 313, 313, 313, 313, 363, 53, 363, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 16, 363, 313, 313, 313, 313, 313, 56, 56, 56, 56, 17, 313, 313, 313, 313, 363, 313, 313, 363, 363, 363, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 363, 16, 16, 56, 16, 363, 313, 313, 313, 313, 313, 56, 56, 56, 56, 56, 17, 313, 313, 363, 313, 313, 313, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 16, 363, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 363, 363, 313, 313, 313, 313, 313, 363, 53, 363, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 16, 56, 56, 16, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 16, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 16, 56, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 363, 313, 313, 313, 313, 363, 313, 363, 53, 363, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 16, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 16, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 53, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 16, 16, 363, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 313, 313, 313, 313, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 16, 56, 56, 16, 363, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 363, 363, 16, 56, 56, 16, 363, 363, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 22, 22, 22, 22, 22, 313, 313, 363, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 16, 363, 363, 363, 313, 313, 313, 313, 313, 313, 313, 363, 313, 313, 313, 22, 60, 60, 60, 60, 60, 22, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 313, 363, 16, 56, 56, 56, 16, 363, 363, 313, 313, 363, 363, 363, 363, 363, 363, 363, 363, 22, 60, 23, 23, 23, 23, 23, 60, 22, 363, 363, 363, 363, 363, 363, 313, 313, 313, 313, 313, 313, 363, 363, 16, 56, 56, 56, 56, 16, 363, 363, 363, 363, 16, 16, 16, 16, 363, 363, 363, 22, 60, 23, 24, 24, 24, 23, 60, 22, 363, 16, 16, 363, 363, 363, 363, 313, 363, 363, 363, 313, 363, 16, 16, 56, 56, 56, 56, 56, 16, 16, 16, 16, 16, 56, 56, 16, 16, 16, 16, 16, 60, 24, 59, 59, 59, 24, 60, 16, 16, 16, 16, 16, 16, 363, 363, 363, 363, 16, 16, 363, 363, 16, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 16, 59, 43, 43, 43, 59, 16, 56, 56, 56, 56, 56, 16, 16, 16, 16, 16, 16, 16, 16, 16, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 59, 43, 43, 43, 59, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56 } }, { type = "tilelayer", name = "Decorations", x = 0, y = 0, width = 40, height = 45, visible = true, opacity = 1, properties = {}, encoding = "lua", data = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } }, { type = "tilelayer", name = "Entities", x = 0, y = 0, width = 40, height = 45, visible = true, opacity = 1, properties = {}, encoding = "lua", data = { 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 528, 528, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 528, 528, 0, 0, 0, 0, 0, 528, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 0, 0, 0, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 0, 0, 0, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 528, 528, 528, 528, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 528, 528, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 0, 0, 0, 0, 0, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528, 528 } } } }
