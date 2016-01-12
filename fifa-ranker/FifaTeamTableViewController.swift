//
//  FifaTeamTableViewController.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 11/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import UIKit
import Eureka

class FifaTeamTableViewController<T:Equatable>: SelectorViewController<T> {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("IM IN FIFA CONTROLLER")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
