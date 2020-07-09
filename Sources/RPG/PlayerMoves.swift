
protocol PlayerMove {
    var direction: MapMoveDirection {get set}
    
    var friendlyCommandName: String {get set} 
}

class StandartPlayerMove: PlayerMove {
    var direction: MapMoveDirection
    
    var friendlyCommandName: String
    
    init(direction: MapMoveDirection) {
        self.direction = direction
        switch self.direction {
        case .up:
            friendlyCommandName = "up"
        case .down:
            friendlyCommandName = "down"
        case .left:
            friendlyCommandName = "left"
        case .right:
            friendlyCommandName = "right"
        case .teleport:
            friendlyCommandName = "teleport"
        }
    }
}


class PlayerActions: StandartPlayerMove{
    var action: MapAction
    init(direction: MapMoveDirection, action: MapAction){
        self.action = action
        super.init(direction: direction)
        friendlyCommandName = "\(self.direction.rawValue) and \(self.action.rawValue)"
    }
}

extension PlayerMove {
    var allMoves: [PlayerMove] {
        return [
        StandartPlayerMove(direction: .up),
        StandartPlayerMove(direction: .down),
        StandartPlayerMove(direction: .left),
        StandartPlayerMove(direction: .right)
        ]
    }
}

enum MapMoveDirection: String {
    case up = "up"
    case down = "down"
    case left = "left"
    case right = "right"
    case teleport = "teleport"
    
}

enum MapAction: String{
    case attack = "attack"
    case push = "push"
    case openChest = "open chest"
}