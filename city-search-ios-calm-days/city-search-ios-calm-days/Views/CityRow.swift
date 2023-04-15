import SwiftUI

struct CityRow: View {
    var city: City
    
    init(city: City) {
        print("Loading row \(city.name)")
        self.city = city
    }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("\(city.name), \(city.country)")
                .fontWeight(.semibold)
            
            Text("\(city.coord.lon), \(city.coord.lat)")
                .font(.footnote)
                .opacity(0.7)
        }
    }
}

