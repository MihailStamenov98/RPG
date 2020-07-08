/*var mapGenerator = MyMapGenerator()//DefaultMapGenerator()
var playerGenerator = DefaultPlayerGenerator(heroGenerator: DefaultHeroGenerator())
var figthGenerator = DefaultFightGenerator()
var equipmentGenerator = DefaultEquipmentGenerator()
var mapRendered = MyMapRenderer()
var game = Game(mapGenerator: mapGenerator, playerGenerator: playerGenerator, mapRenderer: mapRendered, itemGenerator: equipmentGenerator)

game.run()*/

//var mapGenerator = MyMapGenerator()
/*
var emptyT = EmptyTile()
var position = Position(1,2)
var teleportT = TeleportTile(to: position)
var stick = WoodenStick()
var chest = ChestTile(item: stick)
var wall = WallTile()
var rock = RockTile()
emptyT.printAll()
print("------------------------")
teleportT.printAll()
print("------------------------")
chest.printAll()
print("------------------------")
wall.printAll()
print("------------------------")
rock.printAll()

let x : String = MapMoveDirection.up.rawValue
print(x)*/
let action = PlayerActions(direction: MapMoveDirection.up, action: MapAction.attack)
print(action.friendlyCommandName)