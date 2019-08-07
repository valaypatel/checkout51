//
//  OffersManager.swift
//  Checkout51
//
//  Created by Patel, Valay on 2019-08-07.
//  Copyright © 2019 FirstAim. All rights reserved.
//

import Foundation

class OffersManager {
    
    private let sessionProvider: URLSessionProvider
    private var offers:[Offer]?
    private var error:NetworkError?
    var sortBy: SortBy?
    
    
    init(sessionProvider: URLSessionProvider) {
        self.sessionProvider = sessionProvider
    }
    
    func fetchOffers(completion: @escaping ([Offer]?, NetworkError?) -> Void) {
        
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case let .success(offerBatch):
                self.offers = offerBatch.offers
                
            case let .failure(error):
                self.error = error
            }
            completion(self.offers,self.error)
        }
    }
    
    func sortOffers(sortBy:SortBy) -> [Offer]{
        guard let offers = self.offers else {
            return [Offer]()
        }
        self.sortBy = sortBy
        switch sortBy {
        case .name:
            self.offers = offers.sorted{$0.name < $1.name}
        case .valueASC:
            self.offers = offers.sorted{$0.cash_back < $1.cash_back}
        case .valueDESC:
            self.offers = offers.sorted{$0.cash_back > $1.cash_back}
        }
        return offers
    }
    
    
}
