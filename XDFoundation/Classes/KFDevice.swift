//
//  KfangDevice.swift
//  agent-iOS
//
//  Created by Matt on 2021/3/3.
//  Copyright © 2021 深圳市看房网科技有限公司. All rights reserved.
//

import UIKit
import DeviceKit
import CoreTelephony
import Reachability
import WebKit

@objcMembers
public class KFDevice: NSObject {
    
    /// keyWindow
    public static var keyWindow: UIWindow? {
        let wds = (UIApplication.perform(NSSelectorFromString("sharedApplication"))?.takeUnretainedValue() as? UIApplication)?.windows
        return wds?.first(where: {$0.isKeyWindow}) ?? wds?.first
    }
    
    /// 获取屏幕宽度
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 获取屏幕高度
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 获取刘海屏顶部非安全区域高度
    public static var notchTop: CGFloat {
        return keyWindow?.safeAreaInsets.top ?? 0
    }
    
    /// 获取刘海屏底部非安全区域高度
    public static var notchBottom: CGFloat {
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    /// 获取状态栏高度
    public static var statusHeight: CGFloat {
        return notchTop > 0 ? notchTop : 20
    }
    
    /// 获取导航栏高度
    public static var navHeight: CGFloat {
        return statusHeight + 44
    }
    
    /// 设备型号
    public static var deviceModel: String {
        return Device.current.safeDescription
    }
    
    /// 设备品牌
    public static var deviceBrand: String {
        return UIDevice.current.model
    }
    
    /// 系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// app版本
    public static var appVersion: String {
        
        if let temp = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String  {
            return temp
        }
        return ""
    }
    
    /// 设备ID
    public static var deviceId: String {
        // 先从缓存中获取
        if let deviceId = KFKeyChainManager.keyChainReadData(identifier: "KFang-DEVICEID") as? String {
            logInfo("从缓存获取deviceId:", deviceId)
            return deviceId
        }
        
        // 从IDFV中获取，并且缓存
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString, !deviceId.isEmpty  {
            KFKeyChainManager.keyChainSaveData(data: deviceId, withIdentifier: "KFang-DEVICEID")
            logInfo("从IDFV获取deviceId:", deviceId)
            return deviceId
        }
        // 从IDFV获取不到，直接UUID中获取，并且缓存
        let deviceId = UUID().uuidString.lowercased()
        logInfo("UUID新建deviceId:", deviceId)
        KFKeyChainManager.keyChainSaveData(data: deviceId, withIdentifier: "KFang-DEVICEID")
        return deviceId
    }
    
    /// Mac地址
    public static var macAddress: String {
        return "unknown"
    }
    
    /// userAgent
    public static var userAgent: String {
        
        if let jsonStr = UserDefaults.standard.object(forKey: "kUserAgent") as? String {
            return jsonStr
        } else {
            let webView = WKWebView.init(frame: .zero)
            let request = NSURLRequest.init(url: URL(string: "https://www.apple.com.cn")!)
            webView.load(request as URLRequest)
            webView.evaluateJavaScript("navigator.userAgent") { res, _ in
                if let str = res as? String {
                    UserDefaults.standard.setValue(str, forKey: "kUserAgent")
                    UserDefaults.standard.synchronize()
                }
                webView.load(request as URLRequest)
            }
            return  "unknown"
        }
    }
    
    /// 网络类型
    public static var networkType: String {

        do {
            let rech = try Reachability.init(hostname: "https://www.apple.com.cn/")
            var networkType = "unknown"
            if rech.connection == .unavailable {
                return networkType
            }
            
            if rech.connection == .wifi {
                networkType = "WIFI"
                return networkType
            }
            
            var currentRadioTech: String
            if #available(iOS 12.1, *) {
                guard let radioDic = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology,
                      let currentStatus = radioDic.values.first else {
                    return networkType
                }
                currentRadioTech = currentStatus
                
            } else {
                guard let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider,
                      let currentStatus = CTTelephonyNetworkInfo().currentRadioAccessTechnology else {
                    return networkType
                }
                
                logInfo("数据业务信息：\(currentStatus)")
                logInfo("运营商名字：\(carrier.carrierName!)")
                logInfo("移动国家码(MCC)：\(carrier.mobileCountryCode!)")
                logInfo("移动网络码(MNC)：\(carrier.mobileNetworkCode!)")
                logInfo("ISO国家代码：\(carrier.isoCountryCode!)")
                logInfo("是否允许VoIP：\(carrier.allowsVOIP)")
                
                currentRadioTech = currentStatus
            }
                 
            switch currentRadioTech {
            case CTRadioAccessTechnologyGPRS:
                networkType = "2G"
            case CTRadioAccessTechnologyEdge:
                networkType = "2G"
            case CTRadioAccessTechnologyCDMA1x:
                networkType = "2G"
            case CTRadioAccessTechnologyeHRPD:
                networkType = "3G"
            case CTRadioAccessTechnologyHSDPA:
                networkType = "3G"
            case CTRadioAccessTechnologyWCDMA:
                networkType = "3G"
            case CTRadioAccessTechnologyHSUPA:
                networkType = "3G"
            case CTRadioAccessTechnologyCDMAEVDORev0:
                networkType = "3G"
            case CTRadioAccessTechnologyCDMAEVDORevA:
                networkType = "3G"
            case CTRadioAccessTechnologyCDMAEVDORevB:
                networkType = "3G"
            case CTRadioAccessTechnologyLTE:
                networkType = "4G"
            default:
                break
            }
            
            if #available(iOS 14.1, *) {
               if [CTRadioAccessTechnologyNRNSA, CTRadioAccessTechnologyNR].contains(currentRadioTech) {
                   networkType = "5G"
               }
            }

            logInfo("网络制式：\(networkType)")
            return networkType
        } catch {
            return ""
        }
    }
    
    /// 分辨率
    public static var resolution: String {
        let width = Int(KFDevice.screenWidth * UIScreen.main.scale)
        let height = Int(KFDevice.screenHeight * UIScreen.main.scale)
        return "\(width)x\(height)"
    }
}
