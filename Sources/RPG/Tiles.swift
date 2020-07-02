
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

class TeleportTile: MapTile {
    var type: MapTileType
    var state: String
    var conection: Position
    var blocked: Bool
    init(conection: Position) {
        self.type = .teleport
        state = ""
        self.conection = conection
        blocked = false
    }
}
class EmptyTile: MapTile {
    var type: MapTileType
    var state: String
    
    init() {
        self.type = .empty
        state = ""
    }
}
