//
//  ViewController.swift
//  Groute
//
//  Created by 김기현 on 2020/04/07.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Firebase

class MapViewController: UIViewController, MTMapViewDelegate {

    var mapView: MTMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MTMapView(frame: self.view.frame)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            self.view.addSubview(mapView)
        }
        
        
    }
}

