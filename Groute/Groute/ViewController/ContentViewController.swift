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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var contentId: String = ""
    
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()

        getContent()
//        contentLabel.text = contentId
        // Do any additional setup after loading the view.
    }
    
    func getContent() {
        db.collection("Content").document(contentId).getDocument { (snapshot, err) in
            if let err = err {
                print("Error getting ContentViewController : \(err)")
            } else {
                if let title = snapshot?.get("title") as? String {
                    self.titleLabel.text = title
                    self.navigationItem.title = title
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
