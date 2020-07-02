
struct MyMapGenerator : MapGenerator {
    func generate(players: [Player]) -> Map {
        let playersCount = players.count
        var size = 0
        var options: [Position] = []
        switch playersCount {
            case  2:
                size = 5
                for i in 1 ... 25{
                    options.append(Position(x: i/5, y: i%5))
                }
            case  3:
                size = 6
                for i in 1 ... 36{
                    options.append(Position(x: i/6, y: i%6))
                }
            case  4:
                size = 7
                for i in 1 ... 36{
                    options.append(Position(x: i/7, y: i%7))
                }
            default: size = 0
        }
        let teleports = generateTilePlaces(options: &options, size: size)
        let walls = generateTilePlaces(options: &options, size: size)
        let rocks = generateTilePlaces(options: &options, size: size)
        let chests = generateTilePlaces(options: &options, size: size)
        return MyMap(players: players, options: options, teleports: teleports, walls: walls, rocks: rocks, chests: chests) 
    }
    func generateTilePlaces(options: inout [Position], size: Int) -> [Position]{
        var result: [Position] = []
        for _ in 1 ... size{
            let randel = options.randomElement()
            result.append(randel!)
            options.remove(at: options.firstIndex(of: randel!)!)
        }
       return result
    }
}

