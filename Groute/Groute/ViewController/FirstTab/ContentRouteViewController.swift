//
//  ContentRouteViewController.swift
//  Groute
//
//  Created by 이민재 on 21/06/2020.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ContentRouteViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var routeTime: String = ""
    var routeLocation: String = ""
    var routeMemo: String = ""
    var routeUser: String = ""
    var exRoutes = [[String]]()
    var ex1 = [String]()
    var review : [Comment] = []
    var like: [Favorite] = []
    var likeCount : Int = 0
    var reviewCount : String = ""
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var contentId: String = ""
    

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContent()
        getReview()
        getRoute()
        getLikeCount()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
    }
        func getRoute() {
            for i in 0...100 {
                db.collection("Content").document(contentId).collection("Route").whereField("section", isEqualTo: i).getDocuments() { (querysnapshot, err) in
                    if let err = err {
                        print("Error getting data : \(err)")
                    }else {
                        self.ex1 = []
                        for document in querysnapshot!.documents {
                            print("\(document.documentID) => \(document.get("name")) , \(document.get("section")) \(i)")
                            self.ex1.append(document.get("name") as! String)
                            print("ex1: \(self.ex1) 0")
                        }
                        if self.ex1.isEmpty == true {
                            return
                        }else{
                            self.exRoutes.append(self.ex1)
                            print(self.exRoutes)
                        }
                    }

                }
            }
    }
            func getLikeCount(){
                db.collection("Content").document(contentId).collection("Favorite").getDocuments{ (querySnapshot, err) in
                    if let err = err {
                        print("Error getting Review Data: \(err)")
                    } else {
                        self.like = []
                        for document in querySnapshot!.documents{
                            let getLike : Favorite = Favorite(email: document.get("email") as! String)
                            self.like.append(getLike)
                        }
                        self.likeCount = self.like.count
                    }
                }
                
            }
    @objc func likeButtonClicked(sender: UIButton){
        print("hello")
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
                    self.reviewCount = "(\(self.review.count))"
                    self.collectionView.reloadData()
                    
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
                        self.routeLocation = location + " 여행"
                    }
                    if let memo = snapshot?.get("memo") as? String {
                        self.routeMemo = memo
                    }
                    
                    if let user = snapshot?.get("email") as? String {
                        self.routeUser = user
                    }
                    
                    if let timestamp = snapshot?.get("timestamp") as? Timestamp {
                        let dateFormat: DateFormatter = DateFormatter()
                        dateFormat.dateFormat = "yyyy년 MM월 dd일"
                        let time = dateFormat.string(from: timestamp.dateValue())
                        self.routeTime = time
                    }
                    self.collectionView.reloadData()
                }
            }
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return exRoutes.count + 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           let indexPath = IndexPath(row: 0, section: section)
           let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
        return CGSize(width: collectionView.frame.width, height: 50)
       }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reuseRoute", for: indexPath) as! FirstTabCollectionReusableView
            if indexPath.section == 0 {
                headerView.isHidden = true
            }else if indexPath.section == exRoutes.count + 1 {
                headerView.isHidden = false
                headerView.title.text = "리뷰"
                headerView.reviewCount.text = reviewCount
            } else {
                headerView.isHidden = false
                headerView.reviewCount.isHidden = true
                headerView.title.text = "Day -"+"\(indexPath.section)"
            }
            return headerView
        default:
            assert(false, "no")
        }
    }
        func filteringSection (data : Int) -> Int {
            var cells : Int = 0
            if data == 0 {
                cells = 4
            }
            if data == exRoutes.count + 1 {
                cells = review.count
            }
            if data != 0 && data != exRoutes.count+1{
                cells = exRoutes[data-1].count
            }
            return cells
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteringSection(data: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeLocation", for: indexPath) as! TimeLocationCollectionViewCell
                cell.locationLabel.text = routeLocation
                cell.timeLabel.text = routeTime
                return cell
            }else if indexPath.row == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "map", for: indexPath)
                return cell
            }else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likeUsername", for: indexPath) as! LikeUserCollectionViewCell
                cell.likeButton.tag = indexPath.row
                cell.likeCount.text = String(likeCount)
                cell.likeButton.addTarget(self, action: #selector(ContentRouteViewController.likeButtonClicked(sender:)), for: .touchUpInside)
                cell.userLabel.text = routeUser
                return cell
            }else if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memo", for: indexPath) as! MemoCollectionViewCell
                cell.memoLabel.text = routeMemo
                return cell
            }
        }else if indexPath.section == numberOfSections(in: collectionView) - 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! RouteReviewCollectionViewCell
            cell.userEmail.text = review[indexPath.row].email
            cell.reviewComment.text = review[indexPath.row].content
            cell.reviewTimestamp.text = review[indexPath.row].calcTime
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routeList", for: indexPath) as! FirstTabRouteCollectionViewCell
        cell.routeName.text = exRoutes[indexPath.section-1][indexPath.row]
        return cell
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
extension ContentRouteViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width,height: CGFloat(80))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
