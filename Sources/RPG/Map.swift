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
    var players: [Player]
    var maze: [[MapTile]] = []
    var itemGen: EquipmentGenerator
    var size:Int
    var playersPositions:[Position] = []
    required init(players: [Player]) {
        self.players = players
        size = players.count + 4
        let line = Array(repeating: EmptyTile(), count: size)
        maze = Array(repeating: line, count: size)
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
    
    func killPlayer(player: Player){
        let pos = findPlayerPosition(player: player)
        maze[pos.x][pos.y] = EmptyTile()
    }

   
    
}





extension MyMap{
    func findMoveChange(position: Position, direction: MapMoveDirection)->(Int,Int){
        let x = position.x
        let y = position.y
        var xChange = 0
        var yChange = 0 
        switch direction{
            case .up:
                xChange = -1
                yChange = 0
            case .down:
                xChange = 1
                yChange = 0
            case .left:
                xChange = 0
                yChange = -1
            case .right:
                xChange = 0
                yChange = 1
            case .teleport:
                 let newPos = (maze[x][y] as! TeleportTile).conection
                 xChange = newPos.x - x
                 yChange = newPos.y - y
        }
        return (xChange,yChange)
    }
    func move(player: Player, move: PlayerMove) {
        let playerPosition = findPlayerPosition(player: player)

        let x = playerPosition.x
        let y = playerPosition.y
        let (xChange, yChange) = findMoveChange(position: playerPosition, direction: move.direction)
        
        let playerNumber = (maze[x][y] as! EmptyTile).playerOnIt
        //clear the old tile and there is no player here anymore
        if let m = move as? PlayerActions{
            switch m.action{
                case .attack:
                    executeFight()
                case .push:
                    (maze[x][y] as! EmptyTile).setPlayer(playerNumber: nil)
                    maze[x + xChange][y + yChange] = EmptyTile(playerOnIt: playerNumber!)
                    maze[x + 2 * xChange][y + 2 * yChange] = RockTile()
                case .openChest:
                    (maze[x][y] as! EmptyTile).setPlayer(playerNumber: nil)
                    maze[x+xChange][y+yChange] = EmptyTile(playerOnIt: playerNumber!)
            }
        }else{
            //print(maze[x+xChange][y+yChange])
            (maze[x][y] as! EmptyTile).setPlayer(playerNumber: nil)
            if let tile = maze[x+xChange][y+yChange] as? TeleportTile{
                tile.setPlayer(playerNumber: playerNumber)
            }else{
                maze[x+xChange][y+yChange] = EmptyTile(playerOnIt: playerNumber!)
            }
            
        }
        playersPositions[playerNumber!-1] = Position(x+xChange, y+yChange)
    }

    func executeFight(){

    }
}



extension MyMap{
     private func isPositionInMap(position: Position)->Bool{
        let x = position.x
        let y = position.y
        if x < 0 || x >= size{
            return false
        }
        if y < 0 || y >= size{
            return false
        }
        return true
    }
    private func isTherePlayerHere(position: Position)->Bool{
        let tile = maze[position.x][position.y]
        if let current = tile as? EmptyTile, current.playerOnIt != nil{
                    return true
        }
        else{
            return false
        }
    }
    private func isEmpty(position: Position)->Bool{
        let tile = maze[position.x][position.y]
        if let current = tile as? EmptyTile, current.playerOnIt == nil{
                    return true
        }
        else{
            return false
        }
    }
}


extension MyMap{
    func removeDeadPlayers(){
        for p in players{
            if p.isAlive == false{
                let pos = findPlayerPosition(player: p)
                //let x = maze[pos.x][pos.y] as! EmptyTile
                //players.remove(at: x.playerOnIt! - 1)
                maze[pos.x][pos.y] = EmptyTile()
            }
        }
    }
    
    func availableMoves(player: Player) -> [PlayerMove] {
        removeDeadPlayers()
        let plPos = findPlayerPosition(player: player)
        let x = plPos.x
        let y = plPos.y
        var result:  [PlayerMove]  = []


        if let current = maze[x][y] as? TeleportTile, current.type == .teleport {
            if isEmpty(position: current.conection){
                result.append(StandartPlayerMove(direction: .teleport))
            } else if isTherePlayerHere(position: current.conection){
                result.append(PlayerActions(direction: .teleport, action: .attack))
            } 
            
        }


        if isPositionInMap(position: Position(x+1,y)) && maze[x+1][y].type != .wall {
           // print("In down")
            if let x = actionsFromNeighbourTile(position: Position(x+1, y), direction: .down){
                result.append(x)
            }
        }
        if isPositionInMap(position: Position(x-1,y)) && maze[x-1][y].type != .wall {
           // print("In up")
            if let x = actionsFromNeighbourTile(position: Position(x-1, y), direction: .up){
                result.append(x)
            }
        }
        if isPositionInMap(position: Position(x,y+1)) && maze[x][y+1].type != .wall {
           // print("In right")
            if let x = actionsFromNeighbourTile(position: Position(x, y+1), direction: .right){
                result.append(x)
            }
        }
        if isPositionInMap(position: Position(x,y-1)) && maze[x][y-1].type != .wall {
            //print("In left")
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
                nextX = x-1
            case .down:
                nextX = x+1
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
            maze[i.x][i.y] = TeleportTile(to: randel!)
            print("Teleport \(i) -> \(randel!)")
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





