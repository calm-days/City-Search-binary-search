import SwiftUI

struct CityView: View {
    @ObservedObject private var cityLoader = CityLoader()
    @State private var searchText = ""
    @State private var cityFilter = CityFilter()
    
    private var filteredCities: [City] {
        return cityFilter.filteredCities(cityLoader: cityLoader, searchText: searchText)
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
                    ForEach(filteredCities) { city in
                        NavigationLink {
                            CityDetailedView(city: city)
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
