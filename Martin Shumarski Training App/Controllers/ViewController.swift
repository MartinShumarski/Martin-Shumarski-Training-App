//
//  ViewController.swift
//  Martin Shumarski Training App
//
//  Created by Martin Shumarski on 4.02.19.
//  Copyright © 2019 Martin Shumarski. All rights reserved.
//

import UIKit
import Leanplum

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
        setUserIdPlaceholder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        scrollView.contentSize = CGSize(width: 320, height: 968)
    }

    // MARK: Sets placeholder for the userID text field
    func setUserIdPlaceholder () {
        var currentID : String = ""
        currentID = Leanplum.userId()
        userId.placeholder = "userID: \(currentID)"
        
    }
    
    // MARK: Change the UserID -> login
    
    @IBAction func changeUserID(_ sender: UIButton) {
        
        if (userId.text?.count != 0) && (userId.text != Leanplum.userId()) {
            Leanplum.setUserId(userId.text)
            setUserIdPlaceholder()
            userId.text = ""
            
            DispatchQueue.main.async {
                    self.userId.resignFirstResponder()
            }
        
            
        }
        
    }
    
    
    //MARK : Set User Attributes
    
    @IBAction func setUserAttributes(_ sender: UIButton) {
        
        let newAttributeName = attributeName.text! as NSString
        let newAttributeValue = attributeValue.text! as NSString
        
        if attributeName.text?.count != 0 && attributeValue.text?.count != 0 {
            if let integerValue = NSInteger(attributeValue.text!) {
                Leanplum.setUserAttributes([newAttributeName:integerValue])
            } else {
                Leanplum.setUserAttributes([newAttributeName:newAttributeValue])
            }
            
            attributeValue.text = ""
            attributeName.text = ""
            
        }
        
        
//        DispatchQueue.main.async {
//            self.attributeValue.resignFirstResponder()
        }
        
        
    }
    
    
    





