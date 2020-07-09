
protocol MapRenderer {
    func render(map:Map)
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
                case .wall:
                    r += "🧱"
                case .empty:
                    if let current = tile as? EmptyTile, current.playerOnIt != nil{
                        let str2 = String(current.playerOnIt!)
                        r += ("P"+str2)
                    }else{
                        r += "  "
                    }
                default:
                    if let current = tile as? EmptyTile, current.playerOnIt != nil{
                        let str2 = String(current.playerOnIt!)
                        r += ("P"+str2)
                    }else{
                        r += "💿"
                    }
                    
                    
            }      

        }
        
        print("\(r)")
    }
    
    private func renderMapLegend() {
        print("LEGEND:")
        print("🧱 is wall")
        print("📦 is chest")
        print("🗿 is rock")
        print("💿 is teleport")
    }
}