//
//  ViewController.swift
//  XDFoundation
//
//  Created by 329720990@qq.com on 06/16/2023.
//  Copyright (c) 2023 329720990@qq.com. All rights reserved.
//

import UIKit
import XDFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logInfo(KFDevice.deviceModel, KFDevice.deviceBrand, KFDevice.deviceId, KFDevice.macAddress, KFDevice.networkType, KFDevice.appVersion, KFDevice.systemVersion, KFDevice.resolution)
        logInfo(KFDevice.statusHeight, KFDevice.navHeight, KFDevice.notchBottom)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

