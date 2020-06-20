//
//  SearchViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/05/29.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    
    var cityName: [City] = []
    var filteredCityName: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        getCityName()
    }
    
    func getCityName() {
        db.collection("tour2").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting CityName: \(err)")
            } else {
                for document in snapshot!.documents {
                    let city: City = City(cityName: document.get("cityName") as? String ?? "", cityEtc: document.get("cityEtc") as? String ?? "", cityImage: document.get("cityImage") as? String ?? "", point: document.get("geopoint") as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0) )
                    print("city: \(city)")
                    
                    self.cityName.append(city)
                }
                self.tableView.reloadData()
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city" {
            if let row = tableView.indexPathForSelectedRow {
                let vc = segue.destination as? AddRouteViewController
                
                if searchBar.text != "" {
                    vc?.point = filteredCityName[row.row].point
                } else {
                    vc?.point = cityName[row.row].point
                }
                
                tableView.deselectRow(at: row, animated: true)
            }
        }
    }
    

}

// MARK: - Extension SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            search()
        }
        
        self.tableView.reloadData()
    }
    
    func search() {
        let word = self.searchBar.text ?? ""
        
        filteredCityName = cityName.filter { $0.cityName.contains(word) }
    }
}

//MARK: - Extension TableView
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return filteredCityName.count
        }
        return cityName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
        
        if searchBar.text != "" {
            cell.cityNameLabel.text = filteredCityName[indexPath.row].cityName
            let url = URL(string: filteredCityName[indexPath.row].cityImage)
            cell.cityImageView.kf.setImage(with: url)
        } else {
            cell.cityNameLabel.text = cityName[indexPath.row].cityName
            let url = URL(string: cityName[indexPath.row].cityImage)
            cell.cityImageView.kf.setImage(with: url)
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
