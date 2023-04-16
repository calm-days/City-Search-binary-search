import Foundation
import UIKit

class CitiesController {
    
    static let shared = CitiesController()
    
    // Array containing all city objects
    var cityList = [City]()
    
    // Reversed array containing all city objects for efficient searching.
    private var reversedCityList = [City]()
    
    // Indexes for the first and last items to display in the filtered or unfiltered list
    var searchResultsIndex: (first: Int, last: Int) = (first: 0, last: 0)
    
    // Computed property for getting the count of search results for numberOfRows
    var resultsCount: Int {
        get {
            return searchResultsIndex.last - searchResultsIndex.first
        }
    }
    
    // Helper method to get a city object with an offset from the first index in the search results
    func cityWithOffset(offset: Int) -> City {
        return cityList[searchResultsIndex.first + offset]
    }
    
    init() {
        loadCityData()
    }

    // Method to load city data from the JSON file in the main bundle
    private func loadCityData() {
        let data: Data
        
        // Locating the JSON file in the main bundle
        guard let file = Bundle.main.url(forResource: "cities", withExtension: "json")
        else {
            fatalError("Couldn't find file in main bundle.")
        }
        
        // Attempting to read the JSON file
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(file) from main bundle:\n\(error)")
        }
        
        // Attempting to decode the JSON file
        do {
            cityList = try JSONDecoder().decode([City].self, from: data)
            searchResultsIndex = (first: 0, last: cityList.count - 1)
        }
        catch {
            print("Could not load JSON file.")
        }
    }
 
}
