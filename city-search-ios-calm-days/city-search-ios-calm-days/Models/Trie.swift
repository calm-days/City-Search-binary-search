import Foundation

class TrieNode {
    var children: [Character: TrieNode] = [:]
    var cities: [City] = []
}

class Trie {
    private let root = TrieNode()

    // The key is the city name (converted to lowercase)
    func insert(_ city: City, key: String) {
        var currentNode = root
        
        // Iterate through each character in the lowercase city name
        for char in key.lowercased() {
            precondition(!key.isEmpty, "City name should not be empty.")
            
            // If the current node doesn't have the character as a child, create a new TrieNode for the character
            if currentNode.children[char] == nil {
                currentNode.children[char] = TrieNode()
            }
            currentNode = currentNode.children[char]!
        }
        currentNode.cities.append(city)
    }

    func search(_ query: String) -> [City] {
        var currentNode = root
        for char in query.lowercased() {
            if let nextNode = currentNode.children[char] {
                currentNode = nextNode
            } else {
                return []
            }
        }
        return collectCities(from: currentNode)
    }

    private func collectCities(from node: TrieNode) -> [City] {
        var result: [City] = []
        for (_, childNode) in node.children {
            result.append(contentsOf: collectCities(from: childNode))
        }
        result.append(contentsOf: node.cities)
        return result
    }
}
