FILES = conf.lua main.lua lib maps gfx

love:
	zip -r landofwayward.love $(FILES)

