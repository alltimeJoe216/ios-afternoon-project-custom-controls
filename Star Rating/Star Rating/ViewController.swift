//
//  ViewController.swift
//  Star Rating
//
//  Created by Marissa Gonzales on 5/14/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

       @IBAction func updateRating(_ ratingControl: CustomControl) {
        var stars = "\(ratingControl.value) stars"
        if ratingControl.value == 1 {
            stars = "1 star"
        }
        
        self.title = "User Rating: \(stars)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }



}

