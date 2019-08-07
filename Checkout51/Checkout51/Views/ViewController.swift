//
//  ViewController.swift
//  Checkout51
//
//  Created by Patel, Valay on 2019-07-29.
//  Copyright © 2019 FirstAim. All rights reserved.
// 

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var offerTable:UITableView!
    
    //Indicator
    var indicator = UIActivityIndicatorView()
    
    //OfferHolder
    var offers = [Offer]()
    
    
    private let offerManager = OffersManager(sessionProvider: URLSessionProvider())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        //Starting the Activity Indicator
        indicator.startAnimating()
        //Call Your WebService or API
        getOffer()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func showPopoverButtonAction(_ sender: UIBarButtonItem) {
       
        /* 2 */
        //Configure the presentation controller
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "SortPopupOverViewController") as? SortPopupOverViewController
        popoverContentController?.modalPresentationStyle = .popover
        popoverContentController?.delegate = self
        popoverContentController?.selectedSortBy = offerManager.sortBy
        /* 3 */
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.delegate = self
            popoverPresentationController.barButtonItem = sender
            popoverPresentationController.delegate = self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.color = .red
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    //MARK : Fetching Data from Server
    private func getOffer() {
        offerManager.fetchOffers { (offers:[Offer]?,error:NetworkError?) in
            guard let offers = offers else{
                if let error = error {
                    let alert:UIAlertController = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                        self.indicator.stopAnimating()
                    }
                }
                return
            }
            self.offers = offers
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.offerTable.reloadData()
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerReusableIdentifier", for: indexPath)
            as! OfferTableViewCell
        let offer = offers[indexPath.row]
        cell.offerName.text = offer.name
        cell.offerValue.text = "-$\(offer.cash_back)"
        cell.offerImage.loadImage(fromURL: offer.image_url)
        return cell
    }

}

extension ViewController : UIPopoverPresentationControllerDelegate, SortPopupOverViewControllerDelegate {
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    
    func popoverContent(controller: SortPopupOverViewController, didselectItem sortBy: SortBy) {
        self.offers = offerManager.sortOffers(sortBy: sortBy)
        self.offerTable.reloadData()
    }
}



