import Foundation

struct City: Identifiable {
    
    let id: Int
    let country: String
    let name: String
    let coord: Coord
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country, name, coord
    }
    
    static var defaultCity: City {
        City(id: 123, country: "N/A", name: "N/A", coord: Coord(lon: 0.0, lat: 0.0))
    }
    
    
}

extension City: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        country = try values.decode(String.self, forKey: .country)
        name = try values.decode(String.self, forKey: .name)
        coord = try values.decode(Coord.self, forKey: .coord)
    }
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
