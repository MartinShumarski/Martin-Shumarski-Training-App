//
//  InboxTableViewController.swift
//  Martin Shumarski Training App
//
//  Created by Martin Shumarski on 1.08.19.
//  Copyright © 2019 Martin Shumarski. All rights reserved.
//

import UIKit
import Leanplum

class InboxTableViewController: UITableViewController {
    
    var inboxMessages : [LeanplumInbox.Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawTable()
        //Hide unused cell lines from tableView with an overlapping view
        self.tableView.tableFooterView = UIView.init()
        
    }
    
    
    
    // Override to call whenever the view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        Leanplum.inbox().onInboxChanged {
            self.drawTable()
        }
    }
    
    func drawTable(){
        let inbox: LeanplumInbox = Leanplum.inbox()
      
//        let proKey = Leanplum.inbox().value(forKey: "pro")
//        print(proKey!)
        self.inboxMessages = inbox.allMessages as [LeanplumInbox.Message]
        
        // Re-sort the messages to newest first.
        self.inboxMessages.sort(by: { (message1, message2) -> Bool in
            let first: Date = message1.deliveryTimestamp!
            let second: Date = message2.deliveryTimestamp!
            return first > second
        })
        
        print("Inbox Count is + \(inboxMessages.count)")
        
        self.tableView.reloadSections(NSIndexSet.init(index: 0) as IndexSet, with: UITableView.RowAnimation.automatic)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Table view Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(Leanplum.inbox().count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellIdentifier = "InboxMessageCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
            // Get the Inbox Message for this table row
        
            let row = indexPath.row
            let message = self.inboxMessages[row]
        
            // Set the cell text and image
        
        cell.textLabel?.text = message.title
        cell.detailTextLabel?.text = message.subtitle
        if(message.imageFilePath != nil){
            cell.imageView?.image = UIImage.init(contentsOfFile: message.imageFilePath!)
        }
        
        //Auto resize the cells
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100.0 // set to whatever your "average" cell height is
        
        // Set the text style for read and unread message
        
        if(message.isRead){
            cell.textLabel?.textColor = UIColor.lightGray
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.accessoryType = .checkmark
        } else {
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    // Override to support editing the table view
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the message.
            self.inboxMessages[indexPath.row].remove()
        }
    }
    
    override func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        // Mark and track the message as read.
        self.inboxMessages[indexPath.row].read()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
}

