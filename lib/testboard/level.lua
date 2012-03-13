
Testboard_Level = ExplorerState:subclass()

Testboard_Level.signTable = {
  [EntityCode.SIGN1] = "Sup 1";
  [EntityCode.SIGN2] = "----------------\nSup 2\nHow's it going?\n----------------";
  [EntityCode.SIGN9 ] = "<-- Tranquil Field\n \nPlateau Commons -->";
  [EntityCode.SIGN10] = "<-- Concrete Cathedral\n \nReticent Forest -->";
  [EntityCode.SIGN11] = "<-- Resolute Yacht\n \nFormer Airport -->";
  [EntityCode.SIGN12] = "<-- hubtosylvia\n \nCerulean Paths -->";
  [EntityCode.SIGN13] = "<-- Elysian Manor\n \nUpward Chase -->";
  [EntityCode.SIGN14] = "<-- Tartarus\n \nLast Avenue -->";
}

function Testboard_Level:init()
  Testboard_Level:superinit(self)
  self.erhardt = Testboard_Erhardt( self.map )
end

function Testboard_Level:stateEnter()
  self:fadeIn()
end

function Testboard_Level:handleTrigger1(x, y)
  print("Trigger 1", x, y)
end

function Testboard_Level:handleTrigger2(x, y)
  print("Trigger 2", x, y)
end

function Testboard_Level:handleTrigger3(x, y)
  print("Trigger 3", x, y)
end

function Testboard_Level:handleTrigger4(x, y)
  print("Trigger 4", x, y)
end

function Testboard_Level:handleTrigger5(x, y)
  print("Trigger 5", x, y)
end

function Testboard_Level:handleTrigger6(x, y)
  print("Trigger 6", x, y)
end

function Testboard_Level:handleTrigger7(x, y)
  print("Trigger 7", x, y)
end

function Testboard_Level:handleTrigger8(x, y)
  print("Trigger 8", x, y)
end

