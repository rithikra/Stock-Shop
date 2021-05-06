//
//  MessageViewController.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/5/21.
//

import Foundation
import UIKit
import MessageUI


class MessageViewController : MFMessageComposeViewController{
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)}
    
}


