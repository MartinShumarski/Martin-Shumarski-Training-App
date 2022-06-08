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
        self.colorsLabel.backgroundColor = Variables.LabelColor!.colorValue()
        
        Leanplum.onVariablesChanged {
            self.colorsLabel.backgroundColor = Variables.LabelColor!.colorValue()
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
        //Sets the
        scrollView.contentSize = CGSize(width: 320, height: 968)
        
        //Tracks  Nil State once viewAppears
        Leanplum.advance(state: "null state")
    }

    //  MARK: Showing the number of unread messages in the inbox
    func refreshInboxLabel () {
        Leanplum.inbox().onInboxChanged(completion: {
            let unreadCount = Leanplum.inbox().unreadCount
            let buttonTitle = "Inbox (\(unreadCount))"
            self.navigationItem.rightBarButtonItem?.setValue(buttonTitle, forKey: "title")
        })
    }
    
    //MARK: Prepare Segue to change the state
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInboxSegue" {
            Leanplum.advance(state: "App Inbox", info: "User Enters the App Inbox")
        }
    }
       

    // MARK: Sets placeholder for the userID text field
    func setUserIdPlaceholder () {
        var currentID : String = ""
        currentID = Leanplum.userId()!
        userId.placeholder = "userID: \(currentID)"
        
    }
    
    // MARK: Change the UserID -> login
    
    @IBAction func changeUserID(_ sender: UIButton) {
        
        if (userId.text?.count != 0) && (userId.text != Leanplum.userId()) {
            Leanplum.setUserId(userId.text!)
            setUserIdPlaceholder()
            userId.text = ""
    
          
            
            DispatchQueue.main.async {
                    self.userId.resignFirstResponder()
            }
        
            
        }
        
        Leanplum.setDeviceLocation(latitude: 0, longitude: 0, city: "(detect)" , region: "(detect)", country: "(detect)", type: .ip)
        
        
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
        
        Leanplum.track("pop", params:["p":"true"])
        Leanplum.track("jsonEvent", params:["jsonParams":"{\"lat\":13.7457329,\"lng\":100.5392942}"])
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
            Leanplum.track(eventName.text!)
            
        }
        else if (nameCount != 0 && valueCount != 0 && parameterCount == 0) {
            Leanplum.track(eventName.text!, value: convEventValue.doubleValue)
        }
        
        else if (nameCount != 0 && valueCount == 0 && parameterCount != 0) {
            
            Leanplum.track(eventName.text!, params: params)
            
        }
        else if (nameCount != 0 && valueCount != 0 && parameterCount != 0) {
            Leanplum.track(eventName.text!, value: convEventValue.doubleValue, params:params )
            
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
    
  
    // MARK: Tracks a state on "ON" and leave's the state on "OFF"
    @IBAction func switchChangedState(_ sender: UISwitch) {
        
        if sender.isOn {
            Leanplum.advance(state: "switchIsActivatedState", info: "You have entered the state")
        }
        
        else {
            Leanplum.advance(state: "Null state", info: "This is the null state")
        }
    }
    
    
}




