//
//  RouteListViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/06/02.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class RouteListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    
    var tourList: [TourModel] = []
    var filteredTourList: [TourModel] = []
    var section: Int = 0
    var documentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        getList()
    }
    
    func getList() {
        db.collection("tour").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting TourList: \(err)")
            } else {
                self.tourList = []
                
                for document in snapshot!.documents {
                    let tour: TourModel = TourModel(id: document.documentID,
                                                    address: document.get("address") as? String ?? "",
                                                    imageAddress: document.get("imageAddress") as? String ?? "",
                                                    name: document.get("name") as? String ?? "",
                                                    roadAddress: document.get("roadAddress") as? String ?? "",
                                                    geoPoint: (document.get("geopoint") as? GeoPoint)!)
                    
                    self.tourList.append(tour)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTour" {
            if let row = tableView.indexPathForSelectedRow {
                let vc = segue.destination as? DetailTourViewController
                if searchBar.text != "" {
                    vc?.tourId = filteredTourList[row.row].id
                } else {
                    vc?.tourId = tourList[row.row].id
                }
                
                vc?.section = section
                vc?.documentId = documentId
                
                
                tableView.deselectRow(at: row, animated: true)
            }
        }
    }
    

}

extension RouteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            search()
        }
        
        self.tableView.reloadData()
    }
    
    func search() {
        let word = self.searchBar.text ?? ""
        
        filteredTourList = tourList.filter { $0.name.contains(word) }
    }
}

extension RouteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return filteredTourList.count
        }
        return tourList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourList", for: indexPath) as! RouteListTableViewCell
        
        if searchBar.text != "" {
            let url = URL(string: filteredTourList[indexPath.row].imageAddress)
                   cell.locationImageView.kf.setImage(with: url)
                   cell.locationNameLabel.text = filteredTourList[indexPath.row].name
                   cell.locationAddressLabel.text = filteredTourList[indexPath.row].roadAddress
        } else {
            let url = URL(string: tourList[indexPath.row].imageAddress)
            cell.locationImageView.kf.setImage(with: url)
            cell.locationNameLabel.text = tourList[indexPath.row].name
            cell.locationAddressLabel.text = tourList[indexPath.row].roadAddress
        }
        
        return cell
    }
    
    
}

extension RouteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
