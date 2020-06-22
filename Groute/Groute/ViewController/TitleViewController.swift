//
//  TitleViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/06/22.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase

class TitleViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    var createId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoTextView()
        createRouteDocument()
        
        if let currentUser = auth.currentUser?.email {
            print("current user: \(currentUser)")
        } else {
            print("current user is not define")
        }
    }
    
    func setMemoTextView() {
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.gray.cgColor
        memoTextView.layer.cornerRadius = 10
    }
    
    func setAlert() {
        let alertController = UIAlertController(title: "실패", message: "내용을 입력하세요!", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func createRouteDocument() {
        createId = randomString(length: 20)
        db.collection("Content").addDocument(data: [
            "id": createId,
            "email": auth.currentUser?.email ?? "",
            "timestamp": Date(),
            "title": "",
            "memo": "",
            "imageAddress": "",
            "location": ""
        ])
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "title" {
            guard titleTextField.text?.isEmpty == false || memoTextView.text?.isEmpty == false else {
                setAlert()
                return
            }
            
            let vc = segue.destination as? SearchViewController
            
            if let title = titleTextField.text {
                vc?.contentTitle = title
            }
            
            if let memo = memoTextView.text {
                vc?.contentMemo = memo
            }
            
            vc?.createId = self.createId
        }
    }
    

}
