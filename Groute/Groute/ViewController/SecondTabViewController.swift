//
//  SecondTabViewController.swift
//  Groute
//
//  Created by 이민재 on 15/05/2020.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class SecondTabViewController: UIViewController {
    @IBOutlet weak var secondTableview: UITableView!
    
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()

    var secondTabList: [SecondTabModel] = []
    var currentUserDocument: [CurrentUserDocument] = []
    var setDocument: [CurrentUserDocument] = []
    var filteredDocument: [CurrentUserDocument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondTableview.delegate = self
        secondTableview.dataSource = self
        
        secondTableview.reloadData()
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCurrentUserDocument()
        
        filteredDocument = setDocument.sorted { (lhs, rhs) -> Bool in
            return lhs.timestamp > rhs.timestamp
        }
        
        secondTableview.reloadData()
    }
    
    func getCurrentUserDocument() {
        guard let currentUser = firebaseAuth.currentUser?.email else { return }
        db.collection("Content").whereField("email", isEqualTo: currentUser).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting CurrentUser's Document : \(err)")
            } else {
                for document in snapshot!.documents {
                    let info: CurrentUserDocument = CurrentUserDocument(id: document.documentID,
                                                                        title: document.get("title") as? String ?? "",
                                                                        imageAddress: document.get("imageAddress") as? String ?? "",
                                                                        timestamp: (document.get("timestamp") as! Timestamp).dateValue())
                    
                    self.currentUserDocument.append(info)
                    self.setDocument = Array(Set(self.currentUserDocument))
                }
                
                self.secondTableview.reloadData()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SecondTabViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDocument.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondTabCell", for: indexPath) as! SecondTabTableViewCell
        
        let url = URL(string: filteredDocument[indexPath.row].imageAddress)
        cell.routeImage.kf.setImage(with: url)
        cell.addressName.text = filteredDocument[indexPath.row].title
        
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let time = dateFormat.string(from: filteredDocument[indexPath.row].timestamp)
        cell.Time.text = time
        
        return cell
    }
}

extension SecondTabViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("currentUserDocument: \(filteredDocument[indexPath.row].id)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let myContent = self.filteredDocument.remove(at: indexPath.row)
            secondTableview.deleteRows(at: [indexPath], with: .fade)
            
            db.collection("Content").document(myContent.id).collection("Favorite").getDocuments { (snapshot, err) in
                snapshot?.documents.forEach { $0.reference.delete() }
            }
            
            db.collection("Content").document(myContent.id).collection("Comment").getDocuments { (snapshot, err) in
                snapshot?.documents.forEach { $0.reference.delete() }
            }
            
            db.collection("Content").document(myContent.id).collection("Route").getDocuments { (snapshot, err) in
                snapshot?.documents.forEach { $0.reference.delete() }
            }
            
            db.collection("Content").document(myContent.id).delete() { err in
                if let err = err {
                    print("Error getting delete document: \(err)")
                    self.filteredDocument.insert(myContent, at: indexPath.row)
                    self.secondTableview.insertRows(at: [indexPath], with: .automatic)
                } else {
                    print("Document is delete")
                    self.secondTableview.reloadData()
                }
            }
        }
    }
}
