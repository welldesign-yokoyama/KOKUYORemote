//
//  ViewController.swift
//  KOKUYORemore
//
//  Created by well on 9/21/15.
//  Copyright © 2015 welldesign. All rights reserved.
//

import UIKit

/**
 ViewController Class
 **/
class ViewController: UIViewController, AsyncSocketDelegate {

    @IBOutlet weak var _OUT1_INPUT1: CustomButton!
    @IBOutlet weak var _OUT1_INPUT2: CustomButton!
    @IBOutlet weak var _OUT1_INPUT3: CustomButton!
    @IBOutlet weak var _OUT1_INPUT4: CustomButton!
    @IBOutlet weak var _OUT1_POWERON: CustomButton!
    @IBOutlet weak var _OUT1_STANDBY: CustomButton!
    @IBOutlet weak var _VOL_MUTE: CustomButton!
    @IBOutlet weak var _DVD_PLAY: CustomButton!
    @IBOutlet weak var _DVD_STOP: CustomButton!
    @IBOutlet weak var _DVD_PAUSE: CustomButton!
  //@IBOutlet weak var _OUT1_DISPLAY: CustomButton!
    
    
    var timer = NSTimer()
    var timerRunning = false
    var asyncSocket = AsyncSocket()

    /**
    ルートViewがメモリにロードされた直後の呼ばれる
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // ASyncSocket インスタンス生成
        self.asyncSocket = AsyncSocket(delegate: self)
    }

    /**
　　　 OVSERVER登録
    UIApplicationDidEnterBackgroundNotification
    UIApplicationDidBecomeActiveNotification
    **/
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ApplicationDidEnterBackground:",
            name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ApplicationDidBecomeActive:",
            name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "OrientationChange:",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    /**
    OVSERVER解除
    **/
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    /**
    Orientation Change
    **/
    func OrientationChange(notification: NSNotification) {
        print("Orientation Change")
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            print("Landscape")
        }
        if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            print("Portrate")
        }
    }
    
    /**
    EnterBackground
    Home Button Taped
    **/
    func ApplicationDidEnterBackground(notification: NSNotification) {
        print("Application Did Enter Background")
        
        self.asyncSocket.disconnect()
        print("TCP Socket is DISCONNECTED")
        
        if timerRunning {
            timer.invalidate()
            timerRunning = false
            print("Timer is now STOOPING")
        }
    }

    /**
    　EnterForeground
    **/
    func ApplicationDidBecomeActive(notification: NSNotification) {
        var error: NSError?

        print("Application Did Enter Foreground")
        do {
            try self.asyncSocket.connectToHost("192.168.11.77", onPort:8501, withTimeout:2)
        } catch let error1 as NSError {
            error = error1
        }
        
        if error != nil {
            print(error)
            print("CONNECTION ERROR!")
            if timerRunning {
                timer.invalidate()
                timerRunning = false
                print("Timer is STOPPING")
            }
        } else {
            print("TCP Socket Will CONNECT")
            if !timerRunning {
                timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
                timerRunning = true
                print("Timer is now STARTING")
            }
        }
    }
    
    /**
    アプリがメモリ警告を受け取った時に呼ばれる
     **/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    NSTimer イベント
     **/
    func onUpdate() {
        //print("Event TIMEUP")
        let data1:NSData! = ("RDS DM00100.H 2\u{0D}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        self.asyncSocket.writeData(data1, withTimeout:-1, tag: 0)
        
    }

    /**
    HOSTに接続完了
     **/
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("TCP Socket Did CONNECT TO \(host)")
        self.asyncSocket.readDataWithTimeout(-1, tag: 0)
    }
    
    /**
    データ送信
     **/
    func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int) {
        //print("Info___didWriteData")
    }

    /**
    データ受信
     **/
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        //print("Info___didReadData")

        self.asyncSocket.readDataWithTimeout(-1, tag: 0)
        if let out: NSString = NSString(data: data, encoding: NSUTF8StringEncoding) {
            if (out.length == 11) {
                //print(out)
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
                /*
                print(hex1)
                print(data1)
                print("OUT1_INPUT = \(out1_input)")
                print("OUT2_INPUT = \(out2_input)")
                print("OUT1_POWER = \(out1_power)")
                print("OUT2_POWER = \(out2_power)")
                print("OUT1_DISPLAY = \(out1_display)")
                print("OUT2_DISPLAY = \(out2_display)")
                */
                _OUT1_INPUT1.selected = out1_input == 1
                _OUT1_INPUT2.selected = out1_input == 2
                _OUT1_INPUT3.selected = out1_input == 3
                _OUT1_INPUT4.selected = out1_input == 6
                _OUT1_POWERON.selected = out1_power == 1
                _OUT1_STANDBY.selected = out1_power == 0
                
                let dvd_play: UInt32 = (data2 & 0x8000) >> 15   // DVD_PLAY
                let dvd_stop: UInt32 = (data2 & 0x4000) >> 14   // DVD_STOP
                let dvd_pause: UInt32 = (data2 & 0x2000) >> 13   // DVD_PAUSE
                let dvd_standby: UInt32 = (data2 & 0x1000) >> 12   // DVD_STANDBY
                let vol_mute: UInt32 = (data2 & 0x0001)  // VOL_MUTE
                /*
                print(hex2)
                print(data2)
                print("DVD_PLAY = \(dvd_play)")
                print("DVD_STOP = \(dvd_stop)")
                print("DVD_PAUSE = \(dvd_pause)")
                print("DVD_STANDBY = \(dvd_standby)")
                print("VOL_MUTE = \(vol_mute)")
                */
                _VOL_MUTE.selected = vol_mute == 1
                _DVD_STOP.selected = dvd_stop == 1
                _DVD_PAUSE.selected = dvd_pause == 1
                _DVD_PAUSE.selected = dvd_pause == 1
                
                
            }
        }
    }

    /**
     HOST切断
     **/
    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        print("TCP Socket Did DISCONNECT")
    }

    /**
     TOUCH DOWN イベントアクション
     **/
    @IBAction func kvEvent(sender: CustomButton) {
        
        let data1:NSData! = ("ST R\(sender.tag)\u{0D}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        self.asyncSocket.writeData(data1, withTimeout:-1, tag: 0)
        
        let data2:NSData! = ("ST R1900\u{0D}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        self.asyncSocket.writeData(data2, withTimeout:-1, tag: 0)
        
    }
    

}

