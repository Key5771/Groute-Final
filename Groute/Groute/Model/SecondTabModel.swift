//
//  SecondTabModel.swift
//  Groute
//
//  Created by 이민재 on 17/05/2020.
//  Copyright © 2020 김기현. All rights reserved.
//

import Foundation
import Firebase

struct SecondTabModel {
    let Time: String?
    let address: String?
    let imageAddress: String?
    let point: GeoPoint
}

struct CurrentUserDocument: Hashable {
    let id: String
    let title: String
    let imageAddress: String
    let timestamp: Date
}

