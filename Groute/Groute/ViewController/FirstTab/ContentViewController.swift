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
    @IBOutlet var numberOfLikes: UILabel!
    @IBOutlet var likebtn: UIButton!
    @IBOutlet var reviewTextField: UITextField!
    
    
        
    var contentId: String = ""
    
    var content: [routeName] = []
    var review: [Comment] = []
    var like: [Favorite] = []
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var currentTime: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        memoLabel.numberOfLines = 0
        getContent()
        getRoute()
        getReview()
        getLikeCount()
        routeTableView.delegate = self
        routeTableView.dataSource = self
        routeReviewCollectionView.delegate = self
        routeReviewCollectionView.dataSource = self
    }

    //MARK: - writeReview
    @IBAction func writeReview(_ sender: Any) {
        let connectedEmail = UserDefaults.standard.value(forKey: "savedId")!
        let writtenReview = reviewTextField.text!
        let reviewLocation = db.collection("Content").document(contentId).collection("Comment")
        
        if writtenReview == "" {
            print("Empty")
            return
        } else {
            reviewLocation.addDocument(data: ["comment": writtenReview,
                                              "email" : connectedEmail,
                                              "timestamp" : Date()])
            reviewTextField.text = ""
            getReview()
            let alert = UIAlertController(title: "감사합니다", message: "소중한 리뷰 감사합니다!" ,preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion:  nil)
            
        }
    }

    //MARK: - Like
    @IBAction func clickLikeBtn(_ sender: Any) {
        getExistLikeLocation()
    }
    
    func checkLikeImage()  {
        let connectingEmail = UserDefaults.standard.value(forKey: "savedId")!
        let likeLocation = db.collection("Content").document(contentId).collection("Favorite")
        let checkLike = likeLocation.whereField("email", isEqualTo: connectingEmail)
        checkLike.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.likebtn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                    return
                }
                self.likebtn.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            }
        }
    }
    func getExistLikeLocation() {
        let connectingEmail = UserDefaults.standard.value(forKey: "savedId")!
        let likeLocation = db.collection("Content").document(contentId).collection("Favorite")
        let checkLike = likeLocation.whereField("email", isEqualTo: connectingEmail)
        checkLike.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    likeLocation.document(document.documentID).delete()
                    self.likebtn.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                    self.getLikeCount()
                    return
                }
                likeLocation.addDocument(data: ["email" : connectingEmail])
                self.likebtn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                self.getLikeCount()
            }
        }
        }
    func getLikeCount(){
        checkLikeImage()
        db.collection("Content").document(contentId).collection("Favorite").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting Review Data: \(err)")
            } else {
                self.like = []
                for document in querySnapshot!.documents{
                    let getLike : Favorite = Favorite(email: document.get("email") as! String)
                    self.like.append(getLike)
                }
                self.numberOfLikes.text = "\(self.like.count)"
            }
        }
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
                    let time = (document.get("timestamp") as! Timestamp).dateValue()
                    let checkNum = Date().timeIntervalSince(time)
                    let getReview : Comment = Comment(email: document.get("email") as! String, content: document.get("comment") as! String, timestamp: (document.get("timestamp") as! Timestamp).dateValue() ,calcTime: self.calTime(time: checkNum))
                    self.review.append(getReview)
                }
                self.review.sort { $0.timestamp > $1.timestamp}
                self.routeReviewCollectionView.reloadData()
                self.reviewCount.text = "(\(self.review.count))"
            }
        }
    }
    func calTime(time: Double) -> String {
        let result : String
        if time > 0 && time < 60 {
            result = "방금전"
            return result
        } else if time >= 60 && time < 3600 {
            result = "\(Int(time / 60))분전"
            return result
        }else if time >= 3600 && time < 86400 {
            result = "\(Int(time / 3600))시간전"
            return result
        }else if time >= 86400 && time < 604800 {
            result = "\(Int(time / 86400))일전"
            return result
        }else if time >= 604800 && time < 2419200 {
            result = "\(Int(time / 604800))주전"
            return result
        }else if time >= 2419200 && time < 29030400 {
            result = "\(Int(time / 2419200))달전"
            return result
        }else {
            result = "몰라 ㅅㅂ"
            return result
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
        cell.reviewTimestamp.text = review[indexPath.row].calcTime
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
