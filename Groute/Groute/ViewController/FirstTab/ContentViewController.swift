//
//  ContentViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/05/29.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ContentViewController: UIViewController {
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var routeTableView: UITableView!
    @IBOutlet var routeReviewCollectionView: UICollectionView!
    @IBOutlet var reviewCount: UILabel!
    
    
    
    var contentId: String = ""
    
    var content: [routeName] = []
    var review: [Comment] = []
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()
        memoLabel.numberOfLines = 0
        getContent()
        getRoute()
        getReview()
        routeTableView.delegate = self
        routeTableView.dataSource = self
        routeReviewCollectionView.delegate = self
        routeReviewCollectionView.dataSource = self
    }
    
    //MARK: - Get data function
    
        func getRoute(){
            db.collection("Content").document(contentId).collection("Route").getDocuments() {
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting Documents: \(err)")
                } else {
                    self.content = []
                    for document in querySnapshot!.documents{
    //                    print("\(document.documentID) => \(document.data())")
                        let getRouteName : routeName = routeName(name: document.documentID)
                        self.content.append(getRouteName)
                        self.routeTableView.reloadData()
                        print(getRouteName)
                    }
                }
            }
        }
    func getReview(){
        db.collection("Content").document(contentId).collection("Comment").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting Review Data: \(err)")
            } else {
                self.review = []
                for document in querySnapshot!.documents{
                    let getReview : Comment = Comment(email: document.get("email") as! String, content: document.get("comment") as! String, timestamp: (document.get("timestamp") as! Timestamp).dateValue())
                    self.review.append(getReview)
                    print(self.review)
                }
                self.routeReviewCollectionView.reloadData()
                self.reviewCount.text = "(\(self.review.count))"
            }
        }
    }
    func getContent() {
        db.collection("Content").document(contentId).getDocument { (snapshot, err) in
            if let err = err {
                print("Error getting ContentViewController : \(err)")
            } else {
                if let location = snapshot?.get("location") as? String {
                    self.locationLabel.text = location + " 여행"
                }
                if let memo = snapshot?.get("memo") as? String {
                    self.memoLabel.text = memo
                }
                
                if let user = snapshot?.get("email") as? String {
                    self.userLabel.text = user
                }
                
                if let timestamp = snapshot?.get("timestamp") as? Timestamp {
                    let dateFormat: DateFormatter = DateFormatter()
                    dateFormat.dateFormat = "yyyy년 MM월 dd일"
                    let time = dateFormat.string(from: timestamp.dateValue())
                    self.timeLabel.text = time
                }
            }
        }
    }
}

    //MARK: -RouteTableView

extension ContentViewController :UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeListCell",  for: indexPath) as! ContentRouteTableViewCell
        cell.locationName.text = content[indexPath.row].name
        cell.routeIndex.text = String(indexPath.row + 1)
        cell.reviewButton.setTitle("리뷰", for: .normal)
        return cell
    }
}

extension ContentViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    //MARK: -CommentCollectionView

extension ContentViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        review.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewList", for: indexPath) as! RouteReviewCollectionViewCell
        cell.userEmail.text = review[indexPath.row].email
        cell.reviewComment.text = review[indexPath.row].content
        cell.reviewTimestamp.text = review[indexPath.row].timestamp as? String
        return cell
    }
    
}

extension ContentViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width,height: CGFloat(80))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
