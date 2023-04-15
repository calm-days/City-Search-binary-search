import SwiftUI
import MapKit

struct CityDetailView: View {
    var city: City
    @State private var mapRegion: MKCoordinateRegion
    
    init(city: City) {
        self.city = city
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: city.coord.lat,
                longitude: city.coord.lon),
            span: MKCoordinateSpan(
                latitudeDelta: 0.2,
                longitudeDelta: 0.2)
        )
        _mapRegion = State(initialValue: initialRegion)
    }
    
    var body: some View {
        VStack {
            Text("\(city.name), \(city.country)")
                .font(.title)
                .fontWeight(.black)
            Text("\(city.coord.lon), \(city.coord.lat)")
                .font(.footnote)
           
            Divider()
           
            Map(coordinateRegion: $mapRegion, annotationItems: [city]) { city in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)) {

                    Circle()
                        .strokeBorder(.white, lineWidth: 3)
                        .background(Circle().fill(.blue).opacity(0.2))
                        .frame(width: 150, height: 150)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .padding()
        }
    }
}



