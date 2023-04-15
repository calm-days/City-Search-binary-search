import SwiftUI

struct CityView: View {
    @ObservedObject private var cityLoader = CityLoader()
    @State private var searchText = ""
    
    private var filteredCities: [City] {
        if searchText.isEmpty {
            // Tuple comparison – starts comparing the first elements of both tuples,
            // and if they are equal, it moves on to compare the second elements.
            return cityLoader.citiesData.sorted { ($0.name, $0.country) < ($1.name, $1.country) }
        } else {
            return cityLoader.citiesData
                .filter { $0.name.contains(searchText) }
                .sorted { ($0.name, $0.country) < ($1.name, $1.country) }
        }
    }
    
    var body: some View {
        NavigationView {
            if cityLoader.isLoading {
                ProgressView("Loading...")
                    .tint(.orange)
                    .padding()
            } else {
                List {
                    //delete prefix later
                    ForEach(filteredCities.prefix(100)) { city in
                        NavigationLink {
                            //CityDetailView(city: city)
                        } label: {
                            CityRow(city: city)
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Search City")
            }
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}
