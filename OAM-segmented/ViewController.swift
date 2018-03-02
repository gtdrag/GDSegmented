//
//  ViewController.swift
//  OAM-segmented
//
//  Created by George Drag on 2/26/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func segmentValueChanged(_ sender: GDSegmented) {
        print("index \(sender.selectedIndex) selected")
    }
    
}

