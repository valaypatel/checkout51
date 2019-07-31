//
//  Post.swift
//  NetworkLayer
//
//  Created by Marcin Jackowski on 06/09/2018.
//  Copyright © 2018 CocoApps. All rights reserved.
//

import Foundation

struct OfferBatch: Codable {
    
    init() {
        offers = [Offer]()
        batch_id = 0
    }
    
    let batch_id: Int
    let offers: [Offer]
}
