//
//  Restaurant.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

struct Restaurant: Decodable {
    let imageurl: String
    let name: String
    let address: String
    let openinghours: String
    
    init(dictionary: [String: String]) {
        imageurl = dictionary["imageurl"]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        name = dictionary["name"] ?? ""
        address = dictionary["address"] ?? ""
        openinghours = dictionary["openinghours"] ?? ""
    }
    
    var addressCapitalized: String {
        get {
            return address.capitalized
        }
    }
}
