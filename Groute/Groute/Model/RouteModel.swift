//
//  RouteModel.swift
//  Groute
//
//  Created by 김기현 on 2020/05/26.
//  Copyright © 2020 김기현. All rights reserved.
//

import Foundation

struct Content {
    let id: String
    let email: String
    let title: String
    let memo: String
    let timestamp: Date
    let imageAddress: String
    var favorite: Int?
}

struct Favorite {
    let email: String
}

struct Comment {
    let email: String
    let content: String
    let timestamp: Date
}
