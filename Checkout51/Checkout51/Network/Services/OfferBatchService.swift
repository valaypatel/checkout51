//
//  PostService.swift
//  NetworkLayer
//
//  Created by Marcin Jackowski on 06/09/2018.
//  Copyright © 2018 CocoApps. All rights reserved.
//

import Foundation

enum OfferBatchService: ServiceProtocol {
    
    case batchOffers
    case offer(offerId: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.myjson.com/bins/")!
    }
    
    var path: String {
        switch self {
        case .batchOffers:
            return "14xyzl"
        case .offer:
            return "14xyzl"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        case .batchOffers:
            return .requestPlain
        case let .offer(offerId):
            let parameters = ["offer_id": offerId]
            return .requestParameters(parameters)
        }
    }
    
    var headers: Headers? {
        return nil
    }
    
    var parametersEncoding: ParametersEncoding {
        return .url
    }
}
