//
//  AddRouteViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/06/01.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase

class AddRouteViewController: UIViewController {
    //MARK: - Outlet Variable
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var finishTextField: UITextField!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var confirmButtonView: UIView!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var hideView: UIView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    //MARK: - Local Variable
    var mapView: MTMapView?
    var cellCount: Int = 0
    var point: GeoPoint = GeoPoint(latitude: 0, longitude: 0)
    var location: String = ""
    var route: [RouteName] = []
    var setRoute: [RouteName] = []
    var createDocumentId: String = ""
    var newDocumentId: String = ""
    
    var tmp0: [RouteName] = []
    var tmp1: [RouteName] = []
    var tmp2: [RouteName] = []
    var tmp3: [RouteName] = []
    var tmp4: [RouteName] = []
    
    var section0: [RouteName] = []
    var section1: [RouteName] = []
    var section2: [RouteName] = []
    var section3: [RouteName] = []
    var section4: [RouteName] = []
    
    //MARK: - Firebase Constant
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    // MARK: - ViewController Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButtonView.isHidden = true
        confirmButtonView.isUserInteractionEnabled = false
        // Jeju National University Point

        pickerView.isHidden = true
        hideView.isHidden = true
        self.hideView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        if startTextField.text == "" || finishTextField.text == "" {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateRouteDocument()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRouteData(newDocumentId)
//        updateMapView()
        
        if section0.isEmpty != true {
            if section0.count == 1 {
                loadMapView(latitude: section0[0].point.latitude, longitude: section0[0].point.longitude)
            } else if section0.count == 2 {
                loadMapView(latitude: section0[0].point.latitude, longitude: section0[0].point.longitude)
                loadMapView(latitude: section0[1].point.latitude, longitude: section0[1].point.longitude)
            }
        }
        
        if section1.isEmpty != true {
            if section1.count == 1 {
                loadMapView(latitude: section1[0].point.latitude, longitude: section1[0].point.longitude)
            } else if section1.count == 2 {
                loadMapView(latitude: section1[0].point.latitude, longitude: section1[0].point.longitude)
                loadMapView(latitude: section1[1].point.latitude, longitude: section1[1].point.longitude)
            }
        }
        
        if section2.isEmpty != true {
            if section2.count == 1 {
                loadMapView(latitude: section2[0].point.latitude, longitude: section2[0].point.longitude)
            } else if section2.count == 2 {
                loadMapView(latitude: section2[0].point.latitude, longitude: section2[0].point.longitude)
                loadMapView(latitude: section2[1].point.latitude, longitude: section2[1].point.longitude)
            }
        }
    }
    
    func updateRouteDocument() {
        db.collection("Content").whereField("id", isEqualTo: createDocumentId).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let content: Content = Content(id: document.documentID,
                                                   location: document.get("location") as? String ?? "",
                                                   email: document.get("email") as? String ?? "",
                                                   title: document.get("title") as? String ?? "",
                                                   memo: document.get("memo") as? String ?? "",
                                                   timestamp: (document.get("timestamp") as! Timestamp).dateValue(),
                                                   imageAddress: document.get("imageAddress") as? String ?? "",
                                                   favorite: document.get("favorite") as? Int ?? 0)
                    
                    self.newDocumentId = content.id
                }
            }
        }
    }
    
    func getRouteData(_ id: String) {
        db.collection("Content").document(id).collection("Route").addSnapshotListener { (snapshot, err) in
            if let err = err {
                print("Error getting in Route : \(err)")
            } else {
                for doc in snapshot!.documents {
                    let route: RouteName = RouteName(id: doc.documentID,
                                                     name: doc.get("name") as? String ?? "",
                                                     section: doc.get("section") as? Int ?? 0,
                                                     point: (doc.get("geopoint") as? GeoPoint)!,
                                                     imageAddress: doc.get("imageAddress") as? String ?? "")
                    
                    if route.section == 0 {
                        self.tmp0.append(route)
                        self.section0 = Array(Set(self.tmp0))
                    } else if route.section == 1 {
                        self.tmp1.append(route)
                        self.section1 = Array(Set(self.tmp1))
                    } else if route.section == 2 {
                        self.tmp2.append(route)
                        self.section2 = Array(Set(self.tmp2))
                    } else if route.section == 3 {
                        self.tmp3.append(route)
                        self.section3 = Array(Set(self.tmp3))
                    } else if route.section == 4 {
                        self.tmp4.append(route)
                        self.section4 = Array(Set(self.tmp4))
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func updateMapView() {
        if section0.isEmpty != true {
            for i in 0..<section0.count {
                loadMapView(latitude: section0[i].point.latitude, longitude: section0[i].point.latitude)
            }
        }
        
        if section1.isEmpty != true {
            for i in 0..<section1.count {
                loadMapView(latitude: section1[i].point.latitude, longitude: section1[i].point.latitude)
            }
        }
        
        if section2.isEmpty != true {
            for i in 0..<section2.count {
                loadMapView(latitude: section2[i].point.latitude, longitude: section2[i].point.latitude)
            }
        }
        
        if section3.isEmpty != true {
            for i in 0..<section3.count {
                loadMapView(latitude: section3[i].point.latitude, longitude: section3[i].point.latitude)
            }
        }
    }
    
    func loadMapView(latitude x: Double, longitude y: Double) {
        let mapPoint: MTMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: x, longitude: y))
        // Jeju City Hall
        let mapPoint2: MTMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 33.499598, longitude:  126.531259))
        innerView.backgroundColor = UIColor.gray
        innerView.addSubview(loadKakaoMap(point: mapPoint, point2: mapPoint2))
        
        // marker
        mapView?.addPOIItems(createMarker(point: mapPoint))
        mapView?.fitAreaToShowAllPOIItems()
        
        // polyline
        mapView?.addPolyline(createPolyline(point: mapPoint, point2: mapPoint2))
    }
    
    func setEnableConfirmButton(){
        confirmButtonView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.calTime(_:)))
        self.confirmButtonView.addGestureRecognizer(gesture)
    }
    
    @objc func calTime(_ sender:UITapGestureRecognizer){
        tableView.isHidden = false
        hideView.isHidden = false
        let firstDay = UserDefaults.standard.value(forKey: "firstDate") as! Date
        let lastDay = UserDefaults.standard.value(forKey: "lastDate") as! Date
        let result = lastDay.timeIntervalSince(firstDay)
        let days : Int = Int(result / 86399) + 1
        UserDefaults.standard.set(days, forKey: "days")
        tableView.reloadData()
        loadMapView(latitude: point.latitude, longitude: point.longitude)
    }
    
    @IBAction func selectStartDate(_ sender: Any) {
        pickerView.isHidden = false
        createStartDatePicker()
    }
    
    @IBAction func selectFinishDate(_ sender: Any) {
        pickerView.isHidden = false
        createFinishDatePicker()
    }
    
    // MARK: - StartTextField
    func createStartDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(AddRouteViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(AddRouteViewController.startCancelClick))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        startTextField.inputAccessoryView = toolbar
        startTextField.inputView = pickerView
    }
    
    @objc func doneClick() {
        UserDefaults.standard.set(pickerView.date, forKey: "firstDate")
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let selectedDate: String = dateFormatter.string(from: pickerView.date)
        startTextField.text = selectedDate
        startTextField.resignFirstResponder()
        pickerView.isHidden = true
        tableView.reloadData()
    }
    
    @objc func startCancelClick() {
        startTextField.resignFirstResponder()
    }
    
    // MARK: - FinishTextField
    func createFinishDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(AddRouteViewController.finishDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(AddRouteViewController.finishCancelClick))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        finishTextField.inputAccessoryView = toolbar
        finishTextField.inputView = pickerView
    }
    
    @objc func finishDoneClick() {
        UserDefaults.standard.set(pickerView.date, forKey: "lastDate")
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일"
        
        let selectedDate: String = dateFormatter.string(from: pickerView.date)
        confirmButtonView.isHidden = false
        setEnableConfirmButton()
        startDate.text = startTextField.text
        endDate.text = selectedDate
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let showSelectedDate: String = dateFormatter.string(from: pickerView.date)
        finishTextField.text = showSelectedDate
        finishTextField.resignFirstResponder()
        pickerView.isHidden = true
        tableView.reloadData()
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func finishCancelClick() {
        finishTextField.resignFirstResponder()
    }
    
    //MARK: - Save
    @IBAction func saveClick(_ sender: Any) {
        let alertController = UIAlertController(title: "저장", message: "저장하시겠습니까?", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default, handler: { _ in
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            self.db.collection("Content").document(self.newDocumentId).collection("Route").getDocuments { (snapshot, err) in
                snapshot?.documents.forEach { $0.reference.delete() }
            }
            
            self.db.collection("Content").document(self.newDocumentId).collection("Favorite").getDocuments { (snapshot, err) in
                snapshot?.documents.forEach { $0.reference.delete() }
            }
            
            self.db.collection("Content").document(self.newDocumentId).collection("Comment").getDocuments { (snapshot, err) in
                snapshot?.documents.forEach { $0.reference.delete() }
            }
            
            self.db.collection("Content").document(self.newDocumentId).delete(completion: { (err) in
                if let err = err {
                    print("Error getting Delete Document : \(err)")
                }
            })
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        })
        
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRoute" {
            if let row = tableView.indexPathForSelectedRow {
                let vc = segue.destination as? RouteListViewController
                vc?.section = row.section
                vc?.documentId = newDocumentId
                vc?.location = self.location
                vc?.email = auth.currentUser?.email ?? ""
                
                if section0.isEmpty != true {
                    vc?.mainImageAddress = section0[0].imageAddress
                }
            }
        }
    }
    

}

extension AddRouteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = UserDefaults.standard.value(forKey: "days") as? Int ?? 0
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "day - \(section+1)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if section0.isEmpty == true {
                return 1
            } else {
                return section0.count
            }
        } else if section == 1 {
            if section1.isEmpty == true {
                return 1
            } else {
                return section1.count
            }
        } else if section == 2 {
            if section2.isEmpty == true {
                return 1
            } else {
                return section2.count
            }
        } else if section == 3 {
            if section3.isEmpty == true {
                return 1
            } else {
                return section3.count
            }
        } else if section == 4 {
            if section4.isEmpty == true {
                return 1
            } else {
                return section4.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "route", for: indexPath) as! AddRouteTableViewCell
        cell.addRouteButton.isHidden = false
        
        switch indexPath.section {
        case 0:
            if section0.isEmpty == true {
                cell.locationLabel.text = ""
            } else {
                cell.locationLabel.text = section0[indexPath.row].name
            }
        case 1:
            if section1.isEmpty == true {
                cell.locationLabel.text = ""
            } else {
                cell.locationLabel.text = section1[indexPath.row].name
            }
        case 2:
            if section2.isEmpty == true {
                cell.locationLabel.text = ""
            } else {
                cell.locationLabel.text = section2[indexPath.row].name
            }
        case 3:
            if section3.isEmpty == true {
                cell.locationLabel.text = ""
            } else {
                cell.locationLabel.text = section3[indexPath.row].name
            }
        case 4:
            if section4.isEmpty == true {
                cell.locationLabel.text = ""
            } else {
                cell.locationLabel.text = section4[indexPath.row].name
            }
        default:
            cell.locationLabel.text = ""
        }
        
        return cell
    }
    
    
}

extension AddRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddRouteViewController: MTMapViewDelegate {
    
    func createMarker(point mapPoint: MTMapPoint) -> [MTMapPOIItem] {
        let positionItem = MTMapPOIItem()
        positionItem.itemName = "제주도청"
        positionItem.mapPoint = mapPoint
        positionItem.markerType = .customImage
        positionItem.tag = 0
        
        if let path = Bundle.main.path(forResource: "map_pin_red", ofType: "png") {
            positionItem.customImage = UIImage(contentsOfFile: path)
        }

        return [positionItem]
    }

    func createPolyline(point mapPoint: MTMapPoint, point2 mapPoint2: MTMapPoint) -> MTMapPolyline {
        let polyLine = MTMapPolyline()
        polyLine.addPoints([mapPoint, mapPoint2])
        polyLine.polylineColor = .red
        
        print("polyLine : \(String(describing: polyLine.mapPointList))")

        return polyLine
    }
    
    func loadKakaoMap(point mapPoint: MTMapPoint, point2 mapPoint2: MTMapPoint) -> MTMapView {
        mapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.innerView.frame.width, height: self.innerView.frame.height))
        guard let mapView = mapView else { return MTMapView.init() }
        
        mapView.delegate = self
        
        // Center Point
        mapView.setMapCenter(mapPoint, animated: true)
        // Zoom To
        mapView.setZoomLevel(5, animated: true)
        mapView.baseMapType = .standard
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeading
        
        
        return mapView
    }
}
