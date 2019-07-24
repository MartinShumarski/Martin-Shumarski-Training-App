//
//  ViewController.swift
//  Martin Shumarski Training App
//
//  Created by Martin Shumarski on 4.02.19.
//  Copyright © 2019 Martin Shumarski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    
    
    
    
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var attributeName: UITextField!
    @IBOutlet weak var attributeValue: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventValue: UITextField!
    @IBOutlet weak var eventParameter: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        scrollView.contentSize = CGSize(width: 320, height: 968)
    }

}

