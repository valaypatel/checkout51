//
//  ViewController.swift
//  Checkout51
//
//  Created by Patel, Valay on 2019-07-29.
//  Copyright © 2019 FirstAim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var offerTable:UITableView!
    
    var indicator = UIActivityIndicatorView()
    var offerBatch = OfferBatch.init()
    private let sessionProvider = URLSessionProvider()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerReusableIdentifier", for: indexPath)
            as! OfferTableViewCell
        
        
        return cell
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        //Starting the Activity Indicator
        indicator.startAnimating()
        //Call Your WebService or API
        getBatchOffer()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.color = .red
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    private func getBatchOffer() {
        sessionProvider.request(type: OfferBatch.self, service: OfferBatchService.batchOffers) { response in
            switch response {
            case let .success(offerBatch):
                self.offerBatch = offerBatch
            case let .failure(error):
                print(error)
                
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.offerTable.reloadData()
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


}

