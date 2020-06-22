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

    var dayCount = 3
    var exRoute1 : [String] = ["A","B","C","D","E"]
    var exRoute2 : [String] = ["F","G","H"]
    var exRoute3 : [String] = ["I","J","K","L"]
    var routes = [[String]]()
    var review : [String] = ["1","2","3","4","5","6"]
    let routeId : String = "exRoute"
    var section11 : String = "3"
    var cellCount : Int = 0
    

    @IBOutlet var collectionView: UICollectionView!
    func addRoutes () {
        routes.append(exRoute1)
        print(routes)
        routes.append(exRoute2)
        print(routes)
        routes.append(exRoute3)
        print(routes)
        print(routes.count)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoutes()
        collectionView.register(UINib(nibName: "FirstTabRouteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "routeList")
//        collectionView.register(UINib(FirstTabCollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader), withReuseIdentifier: "reuseRoute")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return routes.count + 2
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
            }else if indexPath.section == routes.count + 1 {
                headerView.isHidden = false
                headerView.title.text = "리뷰"
                headerView.reviewCount.text = "5"
                headerView.backgroundColor = UIColor.lightGray
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
            if data == routes.count + 1 {
                cells = review.count
            }
            if data != 0 && data != routes.count+1{
                print("Middle")
                cells = routes[data-1].count
            }
            return cells
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteringSection(data: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeLocation", for: indexPath)
                return cell
            }else if indexPath.row == 1{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "map", for: indexPath)
                return cell
            }else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likeUsername", for: indexPath)
                return cell
            }else if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memo", for: indexPath)
                return cell
            }
        }else if indexPath.section == numberOfSections(in: collectionView) - 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "else2", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routeList", for: indexPath) as! FirstTabRouteCollectionViewCell
        cell.routeName.text = routes[indexPath.section-1][indexPath.row]
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
