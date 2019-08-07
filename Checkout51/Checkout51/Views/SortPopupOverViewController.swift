//
//  SortPopupOverViewController.swift
//  Checkout51
//
//  Created by Patel, Valay on 2019-08-07.
//  Copyright © 2019 FirstAim. All rights reserved.
//

import UIKit

protocol SortPopupOverViewControllerDelegate:class {
    func popoverContent(controller:SortPopupOverViewController, didselectItem sortBy:SortBy)
}

class SortPopupOverViewController: UIViewController {
    
    let datasourceArray = [SortBy.valueASC,SortBy.valueDESC, SortBy.name]
    static let CELL_RESUE_ID = "POPOVER_CELL_REUSE_ID"
    var selectedSortBy: SortBy?
    var delegate:SortPopupOverViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension SortPopupOverViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SortPopupOverViewController.CELL_RESUE_ID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: SortPopupOverViewController.CELL_RESUE_ID)
        }
        if(selectedSortBy == datasourceArray[indexPath.row]) {
            cell?.textLabel?.textColor = UIColor.red
        }
        cell?.textLabel?.text = datasourceArray[indexPath.row].rawValue
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.popoverContent(controller: self, didselectItem: datasourceArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        
    }
}
