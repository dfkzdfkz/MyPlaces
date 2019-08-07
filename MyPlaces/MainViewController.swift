//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Valentina Abramova on 29/07/2019.
//  Copyright © 2019 Valentina Abramova. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    TODO: сделать отображение звезд. Может через [] картинок. по ним пройтись также как там сравнивая с рейтингом
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reverseBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
//        Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlaces.count
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        
        // stars on main
        let emptyStar = UIImage(named: "emptyStar")
        let filledStar = UIImage(named: "filledStar")
        switch place.rating {
        case 0:
            for image in cell.starsImages {
            image.image = emptyStar
            }
        case 1:
            cell.starsImages[0].image = filledStar
            cell.starsImages[1].image = emptyStar
            cell.starsImages[2].image = emptyStar
            cell.starsImages[3].image = emptyStar
            cell.starsImages[4].image = emptyStar
        case 2:
            cell.starsImages[0].image = filledStar
            cell.starsImages[1].image = filledStar
            cell.starsImages[2].image = emptyStar
            cell.starsImages[3].image = emptyStar
            cell.starsImages[4].image = emptyStar
        case 3:
            cell.starsImages[0].image = filledStar
            cell.starsImages[1].image = filledStar
            cell.starsImages[2].image = filledStar
            cell.starsImages[3].image = emptyStar
            cell.starsImages[4].image = emptyStar
        case 4:
            cell.starsImages[0].image = filledStar
            cell.starsImages[1].image = filledStar
            cell.starsImages[2].image = filledStar
            cell.starsImages[3].image = filledStar
            cell.starsImages[4].image = emptyStar
        default:
            for image in cell.starsImages {
                image.image = filledStar
            }
        }

        return cell
    }
    
    //    MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let place = places[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }


//      MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }

     }
 
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    @IBAction func reversedSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reverseBarButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reverseBarButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
}
