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
            asignSearchKeys()
            sortCities()
            searchResultsIndex = (first: 0, last: cityList.count - 1)
        }
        catch {
            print("Could not load JSON file.")
        }
    }
    
    // Method to assign search keys nameAndCountry to each city object
    private func asignSearchKeys() {
        for index in 0..<cityList.count {
            cityList[index].searchValue = cityList[index].formattedString.lowercased()
        }
    }
    
    // Method to sort city objects based on the searchValue property
    private func sortCities() {
        cityList = cityList.sorted {
            $0.searchValue < $1.searchValue
        }
        
        reversedCityList = cityList.reversed()
    }
    
    // Method to filter the city list based on the provided search query
    func filter(searchQuery: String) {
        let startDate = Date()
        
        // If the search query is empty, all items are visible.
        if searchQuery.isEmpty {
            searchResultsIndex = (first: 0, last: cityList.count - 1)
        }
        else {
            updateSearchRange(search: searchQuery)
        }
        
        //Printing speed of filtering
        print("time of filtering: \(Date().timeIntervalSince(startDate)) - with prefix: \(searchQuery)")
    }
    
    // Method to update the search results range based on the provided search query
    private func updateSearchRange(search: String) {
        let indexFirst = findFirstIndex(searchString: search)
        let indexLast = findLastIndex(searchString: search)
        
        searchResultsIndex = (first: indexFirst, last: indexLast)
    }
    
    // MARK: - Performing binary search
    
    private func findFirstIndex(searchString: String) -> Int {
        var lowerBound = 0
        var upperBound = cityList.count
        let searchValue = searchString.lowercased()

        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            let currentItem = cityList[midIndex].searchValue

            if searchValue <= currentItem {
                upperBound = midIndex
            } else {
                lowerBound = midIndex + 1
            }
        }

        return upperBound
    }
    
    private func findLastIndex(searchString: String) -> Int {
        var lowerBound = 0
        var upperBound = cityList.count
        let searchValue = searchString.lowercased()
        
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            let currentItem = reversedCityList[midIndex].searchValue
            
            if currentItem.starts(with: searchValue) || searchValue > currentItem {
                upperBound = midIndex
            } else {
                lowerBound = midIndex + 1
            }
        }
        
        return cityList.count - upperBound
    }
}
