import SwiftUI

struct CityView: View {
    @ObservedObject private var dataLoader = CityLoader()
    @State private var searchText = ""
    @State private var cityFilter = CityFilter()
    
    private var filteredCities: [City] {
        return cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
    }
    
    var body: some View {
        if dataLoader.isLoading {
            ProgressView("Loading...")
                .tint(.orange)
                .padding()
        } else {
            NavigationView {
                //delete prefix later
                List(filteredCities.prefix(3000)) { city in
                    NavigationLink {
                        CityDetailedView(city: city)
                    } label: {
                        CityRow(city: city)
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode:.always))
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
