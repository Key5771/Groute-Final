//
//  DetailTourViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/06/02.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class DetailTourViewController: UIViewController {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var addButton: UIButton!

    let db = Firestore.firestore()
    
    var documentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDetailTour()
        // Do any additional setup after loading the view.
    }

    func getDetailTour() {
        db.collection("tour").document(documentId).getDocument { (snapshot, err) in
            if let err = err {
                print("Error getting getDetailTour: \(err)")
            } else {
                if let imageAddress = snapshot?.get("imageAddress") as? String {
                    let url = URL(string: imageAddress)
                    self.locationImageView.kf.setImage(with: url)
                }
                
                if let name = snapshot?.get("name") as? String {
                    self.nameLabel.text = name
                }
                
                if let address = snapshot?.get("roadAddress") as? String {
                    self.addressLabel.text = address
                }
                
                if let desc = snapshot?.get("description") as? String {
                    self.descriptionLabel.text = desc
                }
            }
        }
    }
    
    @IBAction func addClick(_ sender: Any) {
        print("Add Button Click")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAddRoute" {
            let viewController = segue.destination as! AddRouteViewController
            viewController.dataPassed = nameLabel.text
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
