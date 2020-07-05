

struct Position: Equatable{
    public var x: Int
    public var y: Int
    init (_ x: Int,_ y: Int){
        self.x = x
        self.y = y
    }
}







class MyMap : Map {
   // let size: Int
    var players: [Player]
    var playersPositions: [Position] = []
    var maze: [[MapTile]] = []
    var itemGen: EquipmentGenerator
    required init(players: [Player]) {
        self.players = players
        let line = Array(repeating: EmptyTile(), count: players.count+3)
        maze = Array(repeating: line, count: players.count+3)
        itemGen = DefaultEquipmentGenerator()
    }
    convenience init(players: [Player], options: [Position], teleports: [Position], walls: [Position], rocks: [Position], chests: [Position], itemGen: EquipmentGenerator){   
        self.init(players: players)
        self.itemGen = itemGen
        creatTeleports(teleports: teleports, options: options)
        CreateWallsAndRocks(walls: walls, rocks: rocks)
        CreateChests(chests: chests)
        var leftSpaces = options
        for i in 0 ... players.count - 1 {
            playersPositions.append(leftSpaces.randomElement()!)
            leftSpaces.remove(at: leftSpaces.firstIndex(of: playersPositions[i])!)
        }
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
        let freePositions = teleports + options
        for i in teleports{
            let randel = freePositions.randomElement()
            let currentTeleport = TeleportTile(to: randel!)
            print("na teleport ot miasto \(i) syotvetstva teleporta ot miasto \(randel!)")
            maze[i.x][i.y] = currentTeleport
            
        } 
    }
}
extension MyMap{
    func CreateWallsAndRocks(walls: [Position], rocks: [Position]){
        for i in walls{
            let current = WallTile()
            maze[i.x][i.y] = current
        }
        for i in rocks{
            let current = RockTile()
            maze[i.x][i.y] = current
        }
    }
}


extension MyMap{
    func CreateChests(chests: [Position]){
        let items:[Item] = itemGen.allArmors + itemGen.allWeapons 
        for i in chests{
            let randomItem = items.randomElement()
            let current = ChestTile(item: randomItem!)
            maze[i.x][i.y] = current
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