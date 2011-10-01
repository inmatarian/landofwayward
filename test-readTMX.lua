require "util"

file = io.open("field.tmx")
tmx = file:read("*a")
tree = Util.xmlCollect(tmx)
Util.printr(tree)

