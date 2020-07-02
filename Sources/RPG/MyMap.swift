

struct Position: Equatable{
    public var x: Int
    public var y: Int
    init (x: Int, y: Int){
        self.x = x
        self.y = y
    }
}







class MyMap : Map {
   // let size: Int
    var players: [Player]
    var maze: [[MapTile]] = []
    required init(players: [Player]) {
        self.players = players
        let line = Array(repeating: EmptyTile(), count: players.count+3)
        maze = Array(repeating: line, count: players.count+3)
    }
    init(players: [Player], options: [Position], teleports: [Position], walls: [Position], rocks: [Position], chests: [Position]){
        self.players = players

    }
    

    func availableMoves(player: Player) -> [PlayerMove] {
       return []
    }

    func move(player: Player, move: PlayerMove) {
       //ТОДО: редуцирай енергията на героя на играча с 1
    }
    
}


extension MyMap{
    func creatTeleports(teleports: [Position], options: [Position]){
        for i in teleports{

        } 
    }
}


class MyMapRenderer: MapRenderer {
    func render(map: Map) {
        for row in map.maze {
            self.renderMapRow(row: row)
        }
        
        renderMapLegend()
    }
    
    private func renderMapRow(row: [MapTile]) {
        var r = ""
        for tile in row {
            switch tile.type {
            case .chest:
                r += "📦"
            case .rock:
                r += "🗿"
            case .teleport:
                r += "💿"
            case .empty:
                r += "  "
            case .wall:
                r += "🧱"
            /*default:
                //empty
                r += " "*/
            }
        }
        
        print("\(r)")
    }
    
    private func renderMapLegend() {
        print("No map legend, yet!")
    }
}