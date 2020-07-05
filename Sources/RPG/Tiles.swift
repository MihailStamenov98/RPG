
/*
class MyMapTile: MapTile {
    var type: MapTileType
    var state: String
    
    init(type: MapTileType) {
        self.type = type
        state = ""
    }
}
*/
protocol MapTile {
    var type: MapTileType {get set}
    var state: String {get set}
}

enum MapTileType {
    case empty
    case chest
    case wall
    case teleport
    case rock
}
class EmptyTile: MapTile{
    var type: MapTileType
    var state: String
    var free: Bool
    public init() {
        self.type = .empty
        state = ""
        free = true
    }
    public func printAll(){
        print(type)
        print(state)
        print("free = \(free)")
    }
}
class TeleportTile: EmptyTile {
    //var type: MapTileType
    //var state: String
    var conection: Position
    var blocked: Bool
    public init(to: Position) {
        self.conection = to
        blocked = false
        super.init()
        super.type = .teleport
        super.state = " and Teleport"
    }
    override public func printAll(){
        super.printAll()
        print(self.conection)
        print(blocked)
    }
}


class ChestTile: EmptyTile{
    var chest: Item
    var opened: Bool
    public init(item: Item) {
        chest = item
        opened = false
        super.init()
        super.type = .chest
        super.state = " open Chest"
    }
    override public func printAll(){
        super.printAll()
        print(chest)
        print("opened = \(opened)")
    }
}



class WallTile: MapTile{
    var type: MapTileType
    var state: String
    public init() {
        self.type = .wall
        state = " is unavailable, There is a wall"
    }
    public func printAll(){
        print(type)
        print(state)
    }
}



class RockTile: MapTile{
    var type: MapTileType
    var state: String
    public init() {
        self.type = .rock
        state = " and push a Rock"
    }
    public func printAll(){
        print(type)
        print(state)
    }
}

