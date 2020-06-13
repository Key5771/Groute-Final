//
//  SignupViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/04/27.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordConfirmTextfield: UITextField!
    
    var ref: DocumentReference? = nil
    var joinId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextfield.delegate = self
        passwordConfirmTextfield.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupClick(_ sender: Any) {
        if joinId == "" {
            doSignUp()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func doSignUp() {
        if emailTextField.text! == "" {
            showAlert(message: "이메일을 입력해주세요")
            return
        }
        
        if passwordTextfield.text! == "" {
            showAlert(message: "비밀번호를 입력해주세요")
            return
        }
        
        if passwordConfirmTextfield.text! == "" {
            showAlert(message: "비밀번호 확인을 입력해주세요")
            return
        }
        
        if passwordTextfield.text != passwordConfirmTextfield.text {
            self.showAlert(message: "비밀번호가 다릅니다.")
            return
        }
        
        signUp(email: emailTextField.text!, password: passwordTextfield.text!)
    }
    
    
    // TODO: Signup
    func signUp(email: String, password: String) {
        let db = Firestore.firestore()
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch errorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(message: "유효하지 않은 이메일입니다.")
                        
                    case AuthErrorCode.emailAlreadyInUse:
                        self.showAlert(message: "이미 가입한 회원입니다.")
                        
                    case AuthErrorCode.weakPassword:
                        self.showAlert(message: "비밀번호는 6자리 이상 입력해주세요.")
                        
                    default:
                        print(errorCode)
                    }
                }
            } else {
                db.collection("User").document(self.emailTextField.text!).setData([
                    "Email": self.emailTextField.text ?? "",
                    "ExistNickname": "false"
                ])
                { err in
                    var alertTitle = "회원가입 완료"
                    var alertMessage = "회원가입이 완료되었습니다."
                    if err != nil {
                        alertTitle = "회원가입 실패"
                        alertMessage = "회원가입에 실패하였습니다."
                    }
                    
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "확인", style: .default, handler: { (_) in
                        UserDefaults.standard.set(self.emailTextField.text, forKey: "savedId") // Save userId for autologin
                        let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "setNickname") // Go to Nickname view
                        viewController.modalPresentationStyle = .overFullScreen
                        self.present(viewController, animated: true, completion: nil)
                    })
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
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

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
