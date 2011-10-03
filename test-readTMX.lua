require "util"

file = io.open("testboard.tmx")
tmx = file:read("*a")
tree = Util.xmlCollect(tmx)
Util.printr(tree)

