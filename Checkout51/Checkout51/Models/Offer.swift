//
//  Comment.swift
//  NetworkLayer
//
//  Created by Marcin Jackowski on 06/09/2018.
//  Copyright © 2018 CocoApps. All rights reserved.
//

import Foundation

struct Offer: Codable,Equatable {
    let offer_id: String
    let name: String
    let cash_back: Double
    let image_url: String
}


func ==(lhs: Offer, rhs: Offer) -> Bool {
    return lhs.name == rhs.name && lhs.cash_back == rhs.cash_back
}
