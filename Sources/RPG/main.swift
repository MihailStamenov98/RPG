var mapGenerator = MyMapGenerator()//DefaultMapGenerator()
var playerGenerator = DefaultPlayerGenerator(heroGenerator: DefaultHeroGenerator())
var figthGenerator = DefaultFightGenerator()
var equipmentGenerator = DefaultEquipmentGenerator()
var mapRendered = DefaultMapRenderer()
var game = Game(mapGenerator: mapGenerator, playerGenerator: playerGenerator, mapRenderer: mapRendered)

game.run()

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
*/
