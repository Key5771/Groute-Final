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
    var location: String
    let email: String
    var title: String
    var memo: String
    let timestamp: Date
    var imageAddress: String
    var favorite: Int?
}

struct RouteName{
    let id: String
    let name : String
}

struct Favorite {
    let email: String
}

struct Comment {
    let email: String
    let content: String
    let timestamp: Date
    let calcTime : String
}
