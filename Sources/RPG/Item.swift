enum ItemType {
    case weapon
    case armore
}

protocol Item {
    var type: ItemType {get set}
}