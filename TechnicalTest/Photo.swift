//
//  Photo.swift
//  TechnicalTest
//
//  Created by Fayyazuddin Syed on 2016-11-07.
//  Copyright © 2016 Fayyazuddin Syed. All rights reserved.
//

import Foundation

struct Photo {
    var name : String?
    var path : String?
    var _id : String?
    
    init(json: [String: Any]) {
        name = json["name"] as? String
        path = json["path"] as? String
        _id = json["_id"] as? String
    }
}
