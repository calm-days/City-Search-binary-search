import Foundation

import XCTest
@testable import city_search_ios_calm_days

class CityFilterTests: XCTestCase {
    let testData: [City] = [
        City(id: 707860, country: "UA", name: "Hurzuf", coord: Coord(lon: 34.283333, lat: 44.549999)),
        City(id: 519188, country: "RU", name: "Novinki", coord: Coord(lon: 37.666668, lat: 55.683334)),
        City(id: 1283378, country: "NP", name: "Gorkhā", coord: Coord(lon: 84.633331, lat: 28)),
        City(id: 1270260, country: "IN", name: "State of Haryāna", coord: Coord(lon: 76, lat: 29)),
        City(id: 708546, country: "UA", name: "Holubynka", coord: Coord(lon: 33.900002, lat: 44.599998)),
        City(id: 1283710, country: "NP", name: "Bāgmatī Zone", coord: Coord(lon: 85.416664, lat: 28)),
        City(id: 529334, country: "RU", name: "Mar’ina Roshcha", coord: Coord(lon: 37.611111, lat: 55.796391))
    ]
    
    var cityFilter: CityFilter!
    var dataLoader: CityLoader!
    
    override func setUp() {
        super.setUp()
        cityFilter = CityFilter()
        dataLoader = CityLoader(cities: testData)
    }
    
    override func tearDown() {
        cityFilter = nil
        dataLoader = nil
        super.tearDown()
    }
    
    func testValidInput() {
        let searchText = "Gorkhā"
        let filteredCities = cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
        XCTAssertEqual(filteredCities.count, 1)
        XCTAssertEqual(filteredCities.first?.name, "Gorkhā")
    }
    
    func testEmptyInput() {
        let searchText = ""
        let filteredCities = cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
        XCTAssertEqual(filteredCities.count, testData.count)
    }
    
    func testInvalidInput() {
        let searchText = "InvalidCityName"
        let filteredCities = cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
        XCTAssertEqual(filteredCities.count, 0)
    }
    
    func testPartialValidInput() {
        let searchText = "H"
        let filteredCities = cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
        XCTAssertEqual(filteredCities.count, 2)
    }
    
    func testCaseInsensitiveInput() {
        let searchText = "gorkhĀ"
        let filteredCities = cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
        XCTAssertEqual(filteredCities.count, 1)
        XCTAssertEqual(filteredCities.first?.name, "Gorkhā")
    }
    
    func testMultiplePartialValidInput() {
        let searchText = "H"
        let filteredCities = cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
        XCTAssertEqual(filteredCities.count, 2)
        XCTAssertEqual(filteredCities.map { $0.name }.sorted(), ["Holubynka", "Hurzuf"].sorted())
    }
    
    func testValidInputWithSpace() {
        let searchText = "Mar’ina "
        let filteredCities = cityFilter.filteredCities(cityLoader: dataLoader, searchText: searchText)
        XCTAssertEqual(filteredCities.count, 1)
        XCTAssertEqual(filteredCities.first?.name, "Mar’ina Roshcha")
    }
}
