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
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func onUpdate() {
        let data1:NSData! = ("RDS DM00100.H 2\u{0D}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        self.asyncSocket.writeData(data1, withTimeout:-1, tag: 0)
        print("TimeUP")
        
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
        self.asyncSocket.readDataWithTimeout(-1, tag: 0)
        if let out: NSString = NSString(data: data, encoding: NSUTF8StringEncoding) {
            if (out.length == 11) {
                print(out)
                let hex1: String = (out.substringWithRange(NSRange(location: 0, length: 4)))
                let hex2: String = (out.substringWithRange(NSRange(location: 5, length: 4)))
                
                let scan1: NSScanner = NSScanner(string: hex1)
                var data1: UInt32 = 0
                scan1.scanHexInt(&data1)
                
                let scan2: NSScanner = NSScanner(string: hex2)
                var data2: UInt32 = 0
                scan2.scanHexInt(&data2)
                
                let out1_input: UInt32 = (data1 & 0x00f0) >> 4   // OUT1_INPUT
                let out2_input: UInt32 = (data1 & 0x000f)        // OUT2_INPUT
                let out1_power: UInt32 = (data1 & 0x2000) >> 13  // OUT1_POWER
                let out2_power: UInt32 = (data1 & 0x0200) >> 9   // OUT2_POWER
                let out1_display: UInt32 = (data1 & 0x1000) >> 12  // OUT1_DISPLAY
                let out2_display: UInt32 = (data1 & 0x0100) >> 8   // OUT1_DISPLAY
                
                print(hex1)
                print(data1)
                print("OUT1_INPUT = \(out1_input)")
                print("OUT2_INPUT = \(out2_input)")
                print("OUT1_POWER = \(out1_power)")
                print("OUT2_POWER = \(out2_power)")
                print("OUT1_DISPLAY = \(out1_display)")
                print("OUT2_DISPLAY = \(out2_display)")
                
                _OUT1_INPUT1.selected = out1_input == 1
                _OUT1_INPUT2.selected = out1_input == 2
                _OUT1_INPUT3.selected = out1_input == 3
                _OUT1_INPUT4.selected = out1_input == 4
                _OUT1_POWERON.selected = out1_power == 1
                _OUT1_STANDBY.selected = out1_power == 0
                
                let dvd_play: UInt32 = (data2 & 0x8000) >> 15   // DVD_PLAY
                let dvd_stop: UInt32 = (data2 & 0x4000) >> 14   // DVD_STOP
                let dvd_pause: UInt32 = (data2 & 0x2000) >> 13   // DVD_PAUSE
                let dvd_standby: UInt32 = (data2 & 0x1000) >> 12   // DVD_STANDBY
                let vol_mute: UInt32 = (data2 & 0x0001)  // VOL_MUTE
                
                print(hex2)
                print(data2)
                print("DVD_PLAY = \(dvd_play)")
                print("DVD_STOP = \(dvd_stop)")
                print("DVD_PAUSE = \(dvd_pause)")
                print("DVD_STANDBY = \(dvd_standby)")
                print("VOL_MUTE = \(vol_mute)")
                
                
            }
        }
    }

    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        print("Info___willDisconnectWithError")
    }

    @IBAction func kvEvent(sender: CustomButton) {
        
        let data1:NSData! = ("ST R\(sender.tag)\u{0D}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        self.asyncSocket.writeData(data1, withTimeout:-1, tag: 0)
        
        let data2:NSData! = ("ST R1900\u{0D}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        self.asyncSocket.writeData(data2, withTimeout:-1, tag: 0)
    }
    

}

