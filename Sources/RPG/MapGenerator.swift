protocol MapGenerator {
    func generate(players:[Player],itemGen: EquipmentGenerator) -> Map
}
struct MyMapGenerator : MapGenerator {
    func generate(players: [Player], itemGen: EquipmentGenerator) -> Map {
        let playersCount = players.count
        var size = 0
        var options: [Position] = []
        switch playersCount {
            case  2:
                size = 6
                for i in 0 ... 35{
                    options.append(Position( i/6,  i%6))
                }
            case  3:
                size = 7
                for i in 0 ... 48{
                    options.append(Position(i/7, i%7))
                }
            case  4:
                size = 8
                for i in 0 ... 63{
                    options.append(Position( i/8,  i%8))
                }
            default: size = 0
        }
       // print(options)
        let teleports = generateTilePlaces(options: &options, size: size)
        let walls = generateTilePlaces(options: &options, size: size)
        let rocks = generateTilePlaces(options: &options, size: size)
        let chests = generateTilePlaces(options: &options, size: size)
        return MyMap(players: players, options: options, teleports: teleports, walls: walls, rocks: rocks, chests: chests, itemGen: itemGen) 
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

