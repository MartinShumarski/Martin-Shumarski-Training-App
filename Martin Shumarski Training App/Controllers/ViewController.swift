//
//  ViewController.swift
//  Martin Shumarski Training App
//
//  Created by Martin Shumarski on 4.02.19.
//  Copyright © 2019 Martin Shumarski. All rights reserved.
//

import UIKit
import Leanplum

class ViewController: UIViewController, UITextFieldDelegate {
 
    
    
    
    
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var attributeName: UITextField!
    @IBOutlet weak var attributeValue: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventValue: UITextField!
    @IBOutlet weak var eventParameter: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorsLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet weak var inboxButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshInboxLabel()
        setUserIdPlaceholder()
        self.colorsLabel.backgroundColor = Variables.orangeColor!.colorValue()
        
        Leanplum.onVariablesChanged {
            self.colorsLabel.backgroundColor = Variables.orangeColor!.colorValue()
        }
        
        // Set's the switch button to be Off on App Start
        switchButton.isOn = false
        
        self.userId.delegate = self
        self.attributeName.delegate = self
        self.attributeValue.delegate = self
        self.eventName.delegate = self
        self.eventValue.delegate = self
        self.eventParameter.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        scrollView.contentSize = CGSize(width: 320, height: 968)
    }

    //  MARK: Showing the number of unread messages in the inbox
    func refreshInboxLabel () {
        Leanplum.inbox()?.onChanged({
            let unreadCount = Leanplum.inbox().unreadCount
            let buttonTitle = "Inbox (\(unreadCount))"
            self.navigationItem.rightBarButtonItem?.setValue(buttonTitle, forKey: "title")
        })
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
    
    
    // Refresh Button Pressed - forceContentUpdate
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        
        Leanplum.forceContentUpdate()
        setUserIdPlaceholder()
    }
    


//MARK : Track Events/Parameters

    @IBAction func trackEventButtonPressed(_ sender: UIButton) {
        
        let nameCount = eventName.text?.count
        let valueCount = eventValue.text?.count
        let parameterCount = eventParameter.text?.count
        let convEventValue = eventValue.text! as NSString
        
        let paramString = eventParameter.text!
        let paramIndex = paramString.firstIndex(of: ",") ?? paramString.endIndex
        let firstParam = paramString[..<paramIndex]
        let secondParam = paramString[paramIndex...]
        let secondParamString = secondParam.replacingOccurrences(of: ",", with: "")
        
        
        let params : [String:Any] = [String(firstParam):secondParamString]
        
        if (nameCount != 0 && valueCount == 0 && parameterCount == 0) {
            Leanplum.track(eventName.text)
            
        }
        else if (nameCount != 0 && valueCount != 0 && parameterCount == 0) {
                Leanplum.track(eventName.text, withValue: convEventValue.doubleValue)
        }
        
        else if (nameCount != 0 && valueCount == 0 && parameterCount != 0) {
            
            Leanplum.track(eventName.text, withParameters: params)
            
        }
        else if (nameCount != 0 && valueCount != 0 && parameterCount != 0) {
            Leanplum.track(eventName.text, withValue: convEventValue.doubleValue, andParameters:params )
            
        }
        
        
       
        eventName.text = ""
        eventValue.text = ""
        eventParameter.text = ""
        
        
        
        
        
    }
    
    
    // MARK: Hide keyboard methods -
    
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    
    // Hide keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
  
    // MARK: Tracks a state on On and leave's the state on OFF
    @IBAction func switchChangedState(_ sender: UISwitch) {
        
        if sender.isOn {
            Leanplum.advance(to: "switchIsActivatedState", withInfo: "You have entered the state")
        }
        
        else {
            Leanplum.advance(to: nil)
        }
    }
    
    
    
}




