
Testboard_Level = ExplorerState:subclass()

Testboard_Level.signTable = {
  [EntityCode.SIGN1] = "Sup 1",
  [EntityCode.SIGN2] = "Sup 2"
}

function Testboard_Level:init()
  Testboard_Level:superinit(self)
end

function Testboard_Level:stateEnter()
  self:fadeIn()
end

