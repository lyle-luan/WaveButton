//
//  ViewController.swift
//  waveButton
//
//  Created by Aaron on 4/6/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = waveButton(frame: CGRectMake(100, 100, 100, 100)){[unowned self] in
            println("button pushed")
        }
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

