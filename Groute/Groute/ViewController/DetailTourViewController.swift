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
    
    var tourId: String = ""
    var section: Int = 0
    var imageAddress: String = ""
    var address: String = ""
    var documentId: String = ""
    var geoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDetailTour()
        // Do any additional setup after loading the view.
    }
    
    func getDetailTour() {
        db.collection("tour").document(tourId).getDocument { (snapshot, err) in
            if let err = err {
                print("Error getting getDetailTour: \(err)")
            } else {
                if let imageAddress = snapshot?.get("imageAddress") as? String {
                    self.imageAddress = imageAddress
                    let url = URL(string: imageAddress)
                    self.locationImageView.kf.setImage(with: url)
                }
                
                if let name = snapshot?.get("name") as? String {
                    self.nameLabel.text = name
                }
                
                if let roadAddress = snapshot?.get("roadAddress") as? String {
                    self.addressLabel.text = roadAddress
                }
                
                if let address = snapshot?.get("address") as? String {
                    self.address = address
                }
                
                if let desc = snapshot?.get("description") as? String {
                    self.descriptionLabel.text = desc
                }
                
                if let point = snapshot?.get("geopoint") as? GeoPoint {
                    self.geoPoint = point
                }
            }
        }
    }
    
    @IBAction func addClick(_ sender: Any) {
        let alertController = UIAlertController(title: "저장", message: "저장하시겠습니까?", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.db.collection("Content").document(self.documentId).collection("Route").addDocument(data: [
                "section": self.section,
                "name": self.nameLabel.text!,
                "imageAddress": self.imageAddress,
                "address": self.addressLabel.text!,
                "roadAddress": self.address,
                "geopoint": self.geoPoint
            ])
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: nil)
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
