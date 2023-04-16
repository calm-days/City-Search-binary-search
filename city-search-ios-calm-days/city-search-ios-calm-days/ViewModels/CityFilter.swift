import Foundation

struct CityFilter {
    
    func filteredCities(cityLoader: CityLoader, searchText: String) -> [City] {
  
        // Tuple comparison – starts comparing the first elements of both tuples,
        // and if they are equal, it moves on to compare the second elements.
        if searchText.isEmpty {
            return cityLoader.citiesData
                .sorted { ($0.name, $0.country) < ($1.name, $1.country) }
        } else {
            return cityLoader.trie.search(searchText)
                .sorted { ($0.name, $0.country) < ($1.name, $1.country) }
        }
    }
}
