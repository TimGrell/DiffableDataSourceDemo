struct CityModel: Hashable {
    let id: Int
    let name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        lhs.id == rhs.id
    }
}
