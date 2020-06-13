//
//  UserSettingController.swift
//  Groute
//
//  Created by 이민재 on 28/04/2020.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit

class UserSettingController: UIViewController {

    @IBOutlet weak var userNickname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func appearAlert (){
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?" ,preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "예", style: .default){ (action: UIAlertAction) -> Void in self.logout()
        }
        let noButton = UIAlertAction(title: "아니오", style: .default)
        alert.addAction(yesButton)
        alert.addAction(noButton)
        
        self.present(alert, animated: true, completion:  nil)
    }
    
    func logout(){
        UserDefaults.standard.set(nil, forKey: "savedId")
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        appearAlert()
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
