//
//  ViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/04/25.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    var documentId: String = "doc"
    
    var tourList: [TourModel] = []
    var content: [Content] = []
    var favorite: [Favorite] = []
    var favoriteCount: [Int] = []
    var count = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        getDocument()
        getContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        for i in 1...5 {
            db.collection("Content").document(documentId+"\(i)").collection("Favorite").addSnapshotListener { (snapshot, err) in
                if let err = err {
                    print("Error getting Favorite: \(err)")
                } else {
                    for doc in snapshot!.documents {
                        let fav: Favorite = Favorite(email: doc.get("email") as? String ?? "")
                        
                        self.favorite.append(fav)
                    }
                    
                    self.favoriteCount.append(self.favorite.count)
//                    self.content[i-1].favorite = self.favorite.count
                    self.favorite = []
                }
            }
        }
    }
    
    func getContent() {
        db.collection("Content").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                self.content = []
                
                for doc in snapshot!.documents {
                    let content: Content = Content(id: doc.documentID,
                                                   location: doc.get("location") as? String ?? "",
                                                   email: doc.get("email") as? String ?? "",
                                                   title: doc.get("title") as? String ?? "",
                                                   memo: doc.get("memo") as? String ?? "",
                                                   timestamp: (doc.get("timestamp") as! Timestamp).dateValue(),
                                                   imageAddress: doc.get("imageAddress") as? String ?? "",
                                                   favorite: 0)
                    
                    self.content.append(content)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    // TODO: - Segment Control
    @IBAction func segmentSelect(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // 이 부분은 HOT Segment에 관한 코드를 남기면 됩니다.
            for i in 0..<favoriteCount.count {
                content[i].favorite = favoriteCount[i]
            }
            content.sort { (lhs, rhs) -> Bool in
                guard let lhs = lhs.favorite, let rhs = rhs.favorite else { return false }
                return lhs > rhs
            }
            tableView.reloadData()
            print("Hot")
            print("favoriteCount: \(favoriteCount)")
        } else {
            // 이 부분은 NEW Segment에 관한 코드를 남기면 됩니다.
            content.sort { (lhs, rhs) -> Bool in
                return lhs.timestamp > rhs.timestamp
            }
            tableView.reloadData()
            print("New")
        }
        
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "content" {
            if let row = tableView.indexPathForSelectedRow {
                let vc = segue.destination as? ContentViewController
                
                vc?.contentId = content[row.row].id
                tableView.deselectRow(at: row, animated: true)
            }
        }
    }
    

}


// MARK: - UITableViewController
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainList", for: indexPath) as! MainTableViewCell
        
//        let url = URL(string: tourList[indexPath.row].imageAddress!)
//        cell.locationImageView.kf.setImage(with: url)
//        cell.locationName.text = tourList[indexPath.row].name!
//        cell.locationAddress.text = tourList[indexPath.row].roadAddress ?? ""
        
        let url = URL(string: content[indexPath.row].imageAddress)
        cell.locationImageView.kf.setImage(with: url)
        cell.locationName.text = content[indexPath.row].title
        
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let time = dateFormat.string(from: content[indexPath.row].timestamp)
        cell.locationAddress.text = time
        
//        cell.favoriteCountLabel.text = "좋아요 \(1)개"
        cell.favoriteCountLabel.text = "좋아요 \(String(describing: content[indexPath.row].favorite ?? 0))개"
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
