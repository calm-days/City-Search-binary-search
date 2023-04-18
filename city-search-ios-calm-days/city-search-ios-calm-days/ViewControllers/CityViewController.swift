import Foundation
import UIKit

final class CityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // Configures the view and its components.
    func configureView() {
        definesPresentationContext = true
        tableView.contentInsetAdjustmentBehavior = .automatic

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cities"
        
        if #available(iOS 15.0, *) {
            tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        } else {
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }

    
    // MARK: - Navigation
    // Prepares data for the destination view controller before performing the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            guard let city = sender as? City else { return }
            guard let destinationViewController = segue.destination as? MapViewController else { return }
            
            destinationViewController.city = city
        }
    }
}


// MARK: - UITableViewDataSource
// Implements UITableViewDataSource methods for displaying the list of cities
extension CityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CitiesController.shared.resultsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)

        let city = CitiesController.shared.cityWithOffset(offset: indexPath.row)
        //cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.textLabel?.text = city.formattedString
        cell.detailTextLabel?.text = city.coord.formattedString
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}


// MARK: - UITableViewDelegate
// Implements UITableViewDelegate methods for handling user interaction with the city list
extension CityViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let city = CitiesController.shared.cityWithOffset(offset: indexPath.row)

        performSegue(withIdentifier: "MapSegue", sender: city)
    }
}


// MARK: - UISearchResultsUpdating
// Implements UISearchResultsUpdating methods for updating search results based on user input
extension CityViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        CitiesController.shared.filter(searchQuery: searchController.searchBar.text!)

        tableView.reloadData()
    }
}
