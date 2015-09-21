//
//  ViewController.swift
//  KOKUYORemore
//
//  Created by well on 9/21/15.
//  Copyright © 2015 welldesign. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var _OUT1_INPUT1: CustomButton!
    @IBOutlet weak var _OUT1_INPUT2: CustomButton!
    @IBOutlet weak var _OUT1_INPUT3: CustomButton!
    @IBOutlet weak var _OUT1_INPUT4: CustomButton!
    @IBOutlet weak var _OUT1_POWERON: CustomButton!
    @IBOutlet weak var _OUT1_STANDBY: CustomButton!
    var asyncSocket = AsyncSocket()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var error:NSError?
        self.asyncSocket = AsyncSocket(delegate: self)
        do {
            try self.asyncSocket.connectToHost("192.168.11.77", onPort:8501, withTimeout:2)
        } catch let error1 as NSError {
            error = error1
        }
        
        if error != nil {
            print(error)
        }
        else{
            print("CONNECTION GOOD")
            //NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("Info___didConnectToHost")
        self.asyncSocket.readDataWithTimeout(-1, tag: 0)
        print(host)
    }
    
    func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int) {
        print("WriteData")
    }

    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        print("Info___didReadData")
    }

    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        print("Info___willDisconnectWithError")
    }

    

}

