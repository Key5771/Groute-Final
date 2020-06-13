//
//  SetNicknameViewController.swift
//  Groute
//
//  Created by 이민재 on 01/05/2020.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SetNicknameViewController: UIViewController {
    @IBOutlet weak var nickTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func setNickname(_ sender: Any) {
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("User").document()
        db.collection("User").whereField("Email", isEqualTo: UserDefaults.standard.value(forKey: "savedId")!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        db.collection("User").document(document.documentID).updateData([
                            "Email": UserDefaults.standard.value(forKey: "savedId")! ,
                            "Nickname": self.nickTextField.text,
                            "ExistNickname": "true"
                        ]) { err in
                            if let err = err {
                                print("Error: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        }
                }
        }
//        UserDefaults.standard.set(self.nickTextField.text, forKey: "userNickname") // 유저 닉네임 저장
        let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigation")
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
        
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
