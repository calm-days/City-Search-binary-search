import Foundation
import UIKit
import MapKit

struct City: Codable {

    let id: Int
    let country: String
    let name: String
    let coord: Coordinates

    // Lowercased nameAndCountry to use for sorting and searching
    var searchValue = ""
    
    var formattedString: String {
        get {
            return "\(name), \(country)"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(coord.lat, coord.lon)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country, name, coord
    }
    
    static var defaultCity: City {
        City(id: 123, country: "N/A", name: "N/A", coord: Coordinates(lon: 0.0, lat: 0.0))
    }
    
    struct Coordinates: Codable {
        
        let lon: Double
        let lat: Double
        
        var formattedString: String {
            return "\(lat), \(lon)"
        }
    }
}

extension City {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        country = try values.decode(String.self, forKey: .country)
        name = try values.decode(String.self, forKey: .name)
        coord = try values.decode(Coordinates.self, forKey: .coord)
    }
}



