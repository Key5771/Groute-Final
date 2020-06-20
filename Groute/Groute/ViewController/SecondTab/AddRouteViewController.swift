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
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var finishTextField: UITextField!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var confirmButtonView: UIView!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var hideView: UIView!
    
    var mapView: MTMapView?
    var cellCount: Int = 0
    var point: GeoPoint = GeoPoint(latitude: 0, longitude: 0)
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
        

//        loadKakaoMap()
        
    }
    func loadMapView() {
        let mapPoint: MTMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: point.latitude, longitude: point.longitude))
        // Jeju City Hall
        let mapPoint2: MTMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 33.499598, longitude:  126.531259))
        innerView.backgroundColor = UIColor.gray
        innerView.addSubview(loadKakaoMap(point: mapPoint, point2: mapPoint2))
    }
    func setEnableConfirmButton(){
        confirmButtonView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: "calTime:")
        self.confirmButtonView.addGestureRecognizer(gesture)
    }
    
    @objc func calTime(_ sender:UITapGestureRecognizer){
       print("touched")
        tableView.isHidden = false
        hideView.isHidden = false
        let firstDay = UserDefaults.standard.value(forKey: "firstDate") as! Date
        let lastDay = UserDefaults.standard.value(forKey: "lastDate") as! Date
        let result = lastDay.timeIntervalSince(firstDay)
        let days : Int = Int(result / 86399) + 1
        UserDefaults.standard.set(days, forKey: "days")
        tableView.reloadData()
        loadMapView()
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
        print(pickerView.date)
    }
    
    @objc func finishCancelClick() {
        finishTextField.resignFirstResponder()
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

extension AddRouteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = UserDefaults.standard.value(forKey: "days") as? Int ?? 0
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        if section == 0 {
//            return "Day 1"
//        } else if section == 1 {
//            return finishTextField.text
//        } else if section == 2 {
//            return "장소추가"
//        }
//
        return "day - \(section+1)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            cellCount = 1
//        } else if section == 1 {
//            cellCount = 1
//        } else if section == 2 {
//            cellCount = 1
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "route", for: indexPath) as! AddRouteTableViewCell
        
        cell.addRouteButton.isHidden = false
        
//        if indexPath.section == 0 {
//            cell.locationLabel.text = "제주대학교"
//        } else if indexPath.section == 1 {
//            cell.locationLabel.text = "제주시청"
//        } else if indexPath.section == 2 {
//            if cell.locationLabel.text == "" {
//                cell.addRouteButton.isHidden = false
//            }
//        }
//
        return cell
    }
    
    
}

extension AddRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddRouteViewController: MTMapViewDelegate {
    
    func createMarker(point mapPoint: MTMapPoint, point2 mapPoint2: MTMapPoint) -> [MTMapPOIItem] {
        let positionItem = MTMapPOIItem()
        positionItem.itemName = "제주대학교"
        positionItem.mapPoint = mapPoint
        positionItem.markerType = .bluePin
        positionItem.markerSelectedType = .bluePin
        positionItem.tag = 0

        let positionItem2 = MTMapPOIItem()
        positionItem2.itemName = "제주시청"
        positionItem2.mapPoint = mapPoint2
        positionItem2.markerType = .bluePin
        positionItem2.markerSelectedType = .bluePin
        positionItem2.tag = 1

        return [positionItem, positionItem2]
    }

    func createPolyline(point mapPoint: MTMapPoint, point2 mapPoint2: MTMapPoint) -> MTMapPolyline {
        let polyLine = MTMapPolyline()
        polyLine.addPoints([mapPoint, mapPoint2])

        return polyLine
    }
    
    func loadKakaoMap(point mapPoint: MTMapPoint, point2 mapPoint2: MTMapPoint) -> MTMapView {
        mapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.innerView.frame.width, height: self.innerView.frame.height))
        guard let mapView = mapView else { return MTMapView.init() }
        
        mapView.delegate = self
        
        // Center Point
        mapView.setMapCenter(mapPoint, animated: true)
        // Zoom To
        mapView.setZoomLevel(4, animated: true)
        mapView.baseMapType = .standard
        mapView.showCurrentLocationMarker = true
        print("Marker: \(mapView.showCurrentLocationMarker)")
        mapView.currentLocationTrackingMode = .onWithoutHeading
        
        mapView.addPOIItems(createMarker(point: mapPoint, point2: mapPoint2))
        mapView.addPolyline(createPolyline(point: mapPoint, point2: mapPoint2))
        
        return mapView
    }
}
