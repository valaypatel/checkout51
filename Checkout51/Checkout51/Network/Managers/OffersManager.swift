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
    private var offers = [Offer]()
    private var error = NetworkError.unknown
    var sortBy: SortBy?
    
    
    init(sessionProvider: URLSessionProvider) {
        self.sessionProvider = sessionProvider
    }
    
    func fetchOffers(sortBy:SortBy, completion: @escaping ([Offer]) -> Void) {
        self.sortBy = sortBy
        if(offers.count==0) {
            sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
                switch response {
                case let .success(offerBatch):
                    self.offers = offerBatch.offers
                    
                case let .failure(error):
                    self.offers = [Offer]()
                    self.error = error
                }
                switch sortBy {
                case .name:
                    self.offers = self.offers.sorted{$0.name < $1.name}
                case .valueASC:
                    self.offers = self.offers.sorted{$0.cash_back < $1.cash_back}
                case .valueDESC:
                    self.offers = self.offers.sorted{$0.cash_back > $1.cash_back}
                }
                completion(self.offers)
            }
        } else {
            switch sortBy {
            case .name:
                self.offers = self.offers.sorted{$0.name < $1.name}
            case .valueASC:
                self.offers = self.offers.sorted{$0.cash_back < $1.cash_back}
            case .valueDESC:
                self.offers = self.offers.sorted{$0.cash_back > $1.cash_back}
            }
            completion(self.offers)
        }
    }
    
    
}
