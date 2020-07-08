protocol Map {
    init(players: [Player])
    var players: [Player] {get}
    var maze: [[MapTile]] {get}

    func availableMoves(player: Player) -> [PlayerMove]
    func move(player: Player, move: PlayerMove)
}




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
    var maze: [[MapTile]] = []
    var itemGen: EquipmentGenerator
    var playersPositions:[Position] = []
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
           let randomPosition = leftSpaces.randomElement()
            leftSpaces.remove(at: leftSpaces.firstIndex(of: randomPosition!)!)
            if maze[randomPosition!.x][randomPosition!.y] is EmptyTile{

                maze[randomPosition!.x][randomPosition!.y] = EmptyTile(playerOnIt: i+1)
                playersPositions.append(randomPosition!)
            }         
        }
    }
    


    func move(player: Player, move: PlayerMove) {
       //ТОДО: редуцирай енергията на героя на играча с 1
    }
    
}

extension MyMap{
     private func isPositionInMap(position: Position)->Bool{
        let x = position.x
        let y = position.y
        if x < 0 || x >= players.count+3{
            return false
        }
        if y < 0 || y >= players.count+3{
            return false
        }
        return true
    }
    private func isEmpty(position: Position)->Bool{
        let tile = maze[position.x][position.y]
        if let current = tile as? EmptyTile, current.playerOnIt != nil{
                    return false
        }
        else{
            return true
        }
    }
}


extension MyMap{
    
    func availableMoves(player: Player) -> [PlayerMove] {
        let plPos = findPlayerPosition(player: player)
        let x = plPos.x
        let y = plPos.y
        var result:  [PlayerMove]  = []
        if let current = maze[x][y] as? TeleportTile, isEmpty(position: current.conection) && maze[x][y].type == .teleport {
            result.append(StandartPlayerMove(direction: .teleport))
        }


        if isPositionInMap(position: Position(x+1,y)) && maze[x+1][y].type != .wall {
            print("In down")
            if let x = actionsFromNeighbourTile(position: Position(x+1, y), direction: .down){
                result.append(x)
            }
        }
        if isPositionInMap(position: Position(x-1,y)) && maze[x-1][y].type != .wall {
            print("In up")
            if let x = actionsFromNeighbourTile(position: Position(x-1, y), direction: .up){
                result.append(x)
            }
        }
        if isPositionInMap(position: Position(x,y+1)) && maze[x][y+1].type != .wall {
            print("In right")
            if let x = actionsFromNeighbourTile(position: Position(x, y+1), direction: .right){
                result.append(x)
            }
        }
        if isPositionInMap(position: Position(x,y-1)) && maze[x][y-1].type != .wall {
            print("In left")
            if let x = actionsFromNeighbourTile(position: Position(x, y-1), direction: .left){
                result.append(x)
            }
        }
       return result
    }
   func findPlayerPosition(player: Player)->Position{
       var i = 0
       for p in players{
           if p.name == player.name{
               return playersPositions[i]
           }
           i = i+1
       }
       return Position(0,0)
   }
    func actionsFromNeighbourTile(position: Position, direction: MapMoveDirection) -> PlayerMove?{
        let tile = maze[position.x][position.y]
        switch tile.type {
            case .chest:
                return PlayerActions(direction:direction, action: .openChest)
            case .rock:
                if let x =  rockCase(rockPosition: position, direction: direction){
                    return x
                }      
            case .empty:
                if let current = tile as? EmptyTile, current.playerOnIt != nil{
                    return PlayerActions(direction:direction, action: .attack)
                }
                else{
                    return StandartPlayerMove(direction:direction)
                }
            case .teleport:
                return StandartPlayerMove(direction: direction)
            default:
                return nil
        }
        return nil
    }


    func rockCase(rockPosition: Position, direction: MapMoveDirection)->PlayerMove?{
        let x = rockPosition.x
        let y = rockPosition.y
        var nextX = x
        var nextY = y 
        switch direction {
            case .up:
                nextX = x+1
            case .down:
                nextX = x-1
            case .left:
                nextY = y-1
            case .right:
                nextY = y+1
            default:
                nextX = x
                nextY = y
        }
        let nextPosition = Position(nextX,nextY)
        if isPositionInMap(position: nextPosition) && isEmpty(position: nextPosition){
            return PlayerActions(direction:direction, action: .push)
        } else{
            return nil
        }

    }
}

extension MyMap{
    func creatTeleports(teleports: [Position], options: [Position]){
        let freePositions = teleports + options
        for i in teleports{
            let randel = freePositions.randomElement()
            let currentTeleport = TeleportTile(to: randel!)
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





