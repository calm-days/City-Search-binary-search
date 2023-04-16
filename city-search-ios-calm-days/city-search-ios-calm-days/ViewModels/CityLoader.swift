import Foundation
import Combine

final class CityLoader: ObservableObject {
    private let filename = "cities.json"
    @Published private(set) var citiesData = [City]()
    @Published var isLoading: Bool = false
    var onDataLoad: (() -> Void)?
    var trie = Trie()
    
    init() {
        load("cities.json") { result in
            switch result {
            case .success(let cities):
                DispatchQueue.main.async {
                    self.citiesData = cities
                    self.onDataLoad?()
                    self.populateTrie(with: cities)
                }
                
            case .failure(let error):
                print("Error: \(error)")
                // Handle the error appropriately, e.g., show an alert or a message to the user
            }
        }
    }
    
    private func populateTrie(with cities: [City]) {
        for city in cities {
            trie.insert(city, key: city.name)
        }
    }
    
    // enumeration of possible errors that can occur during loading data
    enum LoadError: Error {
        case fileNotFound(String)
        case loadFailed(String, Error)
        case parseFailed(String, Error)
    }
    
    private func load(_ filename: String, completion: @escaping (Result<[City], LoadError>) -> Void) {
        isLoading = true
        
        DispatchQueue.global().async {
            let data: Data
            var result: Result<[City], LoadError>
            
            // safely grabs our file based on the filename we’re given
            guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
                result = .failure(.fileNotFound(filename))
                
                DispatchQueue.main.async {
                    completion(result)
                }
                return
            }
            
            // takes our file and turns it into a Swift Data object so we can manipulate it.
            do {
                data = try Data(contentsOf: file)
            } catch {
                result = .failure(.loadFailed(filename, error))
                
                DispatchQueue.main.async {
                    completion(result)
                }
                return
            }
            
            // initializes a JSONDecoder, along with the data to decode. We then return the output of that decoding, which should be of our type.
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([City].self, from: data)
                result = .success(decodedData)
                
            } catch {
                result = .failure(.parseFailed(filename, error))
            }
            
            DispatchQueue.main.async {
                completion(result)
                self.isLoading = false
            }
        }
    }
    
    //for testing
    init(cities: [City]? = nil) {
        if let cities = cities {
            self.citiesData = cities
            self.populateTrie(with: cities)
        } else {
            load(filename) { result in
                // ...
                switch result {
                case .success(let cities):
                    self.isLoading = false
                    
                    DispatchQueue.main.async {
                        self.citiesData = cities
                        self.populateTrie(with: cities)
                        self.onDataLoad?()
                        self.isLoading = false
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                    // Handle the error appropriately
                }
            }
        }
    }
}
