//
//  LoginViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/04/27.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    @IBOutlet weak var googleLogin: GIDSignInButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var idTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()

    func changeView(){
        let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigation")
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        idTextfield.delegate = self
        passwordTextfield.delegate = self
        
        // Autologin check and check Existing nickname
        let getSavedidinfo = UserDefaults.standard.string(forKey: "savedId")
        Auth.auth().signIn(withEmail: idTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if getSavedidinfo != nil {
                let docRef = self.db.collection("User").document(getSavedidinfo!)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let hasNick = document.get("ExistNickname")
                        print("Document data: \(hasNick)")
                        if hasNick as? String == "true" {
                            let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigation")
                            viewController.modalPresentationStyle = .overFullScreen
                            self.present(viewController, animated: true, completion: nil)
                        }else {
                            print("Setting your nick plz")
                            self.settingNicknameAlert()
                        }
                    } else {
                        print("Document does not exist")
                    }
                }

            }
        }
        // Do any additional setup after loading the view.
    }
    func settingNicknameAlert (){
        let alert = UIAlertController(title: "닉네임설정", message: "닉네임을 설정해주세요!" ,preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "예", style: .default){ (action: UIAlertAction) -> Void in self.moveToNickView()
        }
        let noButton = UIAlertAction(title: "아니오", style: .default)
        alert.addAction(yesButton)
        alert.addAction(noButton)
        
        self.present(alert, animated: true, completion:  nil)
    }
    func moveToNickView(){
        let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "setNickname")
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func loginButtonClick(_ sender: Any) {
        Auth.auth().signIn(withEmail: idTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if user != nil {
                UserDefaults.standard.set(self.idTextfield.text, forKey: "savedId")
                let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigation")
                viewController.modalPresentationStyle = .overFullScreen
                self.present(viewController, animated: true, completion: nil)
                self.idTextfield.text = ""
                self.passwordTextfield.text = ""
            } else {
                let alertController = UIAlertController(title: "로그인 실패", message: "아이디 또는 패스워드를 확인하여주세요.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
                
                self.idTextfield.text = ""
                self.passwordTextfield.text = ""
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

extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if user != nil {
                print("Login Success")
                UserDefaults.standard.set(authentication.idToken, forKey: "savedId")
                let savedGoogleId = UserDefaults.standard.value(forKey: "savedId")!
                print(savedGoogleId)
                let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigation")
                viewController.modalPresentationStyle = .overFullScreen
                self.present(viewController, animated: true, completion: nil)
//                if savedGoogleId != nil {
//                    let docRef = self.db.collection("User").document(authentication.idToken)
//                    docRef.getDocument { (document, error) in
//                        if let document = document, document.exists {
//                            let hasEmail = document.get("Email")!
//                            let hasNickname = document.get("ExistNickname")!
//                            print("Document data: \(hasEmail)")
//                            print("Document data: \(hasNickname)")
//                            if hasEmail as? String == nil {
//                                print("Dosen't exist Email")
//                                self.db.collection("User").document(authentication.idToken).updateData([
//                                    "Email": authentication.idToken,
//                                    "ExistNickname": "false"
//                                ])
//                                self.settingNicknameAlert()
//                            }else if hasNickname as? String == "false" {
//                                print("Dosen't exist Nickname")
//                                self.settingNicknameAlert()
//
//                            }else{
//                                let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigation")
//                                viewController.modalPresentationStyle = .overFullScreen
//                                self.present(viewController, animated: true, completion: nil)
//                            }
//                        } else {
//                            print("Document does not exist")
//                            self.db.collection("User").document(authentication.idToken).setData([
//                                "Email": authentication.idToken,
//                                "ExistNickname": "false"
//                            ])
//                            self.settingNicknameAlert()
//                        }
//                    }
//                }else{
//                    print("No have Saved Google id")
//                }
            } else {
                let alertController = UIAlertController(title: "로그인 실패", message: "로그인에 실패하였습니다", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
