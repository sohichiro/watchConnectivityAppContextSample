//
//  ViewController.swift
//  watchConnectivityAppContextSample
//
//  Created by 長尾 聡一郎 on 2015/09/01.
//  Copyright © 2015年 長尾 聡一郎. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            print("activate session")
            
            if session.paired != true {
                print("Apple Watch is not paired")
            }
            
            if session.watchAppInstalled != true {
                print("WatchKit app is not installed")
            }
            
        }else {
            print("WatchConnectivity is not supported on this device")
        }
    }
    
    @IBAction func pushClearButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.statusLabel.text = "---"
        }
    }
    
    @IBAction func pushActionButton(sender: AnyObject) {
        let button = sender as! UIButton
        let message:[String : AnyObject] = ["sendMessageToWatch" : "\(button.tag)"]
        
        do {
            try WCSession.defaultSession().updateApplicationContext(message)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.statusLabel.text = "Success"
            })
        }
        catch {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.statusLabel.text = "Error"
            })
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let watchInfo = applicationContext["sendMessageToPhone"] as? String {
            var show:String
            
            if watchInfo == "0" {
                show = "🐶"
            }
            else if watchInfo == "1" {
                show = "🐱"
            }
            else if watchInfo == "2" {
                show = "🐘"
            }
            else {
                show = "🐧"
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.statusLabel.text = show
            })
        }
    }
}

