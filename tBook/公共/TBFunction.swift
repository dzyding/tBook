//
//  E7Function.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/7/12.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

/**
 各种简化
 */
import Foundation

//MARK: - 获取本机型号
func dzy_Machine() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    switch identifier {
    case "iPhone5,1", "iPhone5,2":
        return "5"
    default:
        return ""
    }
}

//MARK: - HUD
public func dzy_error(_ str: String?, _ view: UIView? = nil) {
    if let str = str {
        var hud: MBProgressHUD?
        if let view = view {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
        }else if let window = UIApplication.shared.keyWindow {
            hud = MBProgressHUD.showAdded(to: window, animated: true)
        }
        hud?.mode = .text
        hud?.label.text = str
        hud?.hide(animated: true, afterDelay: 2.0)
    }
}

public func dzy_success(_ str: String? = nil, _ view: UIView? = nil) {
    var hudStr = ""
    if let str = str {
        hudStr = str
    }else {
        hudStr = "成功"
    }
    
    var hud: MBProgressHUD?
    if let view = view {
        hud = MBProgressHUD.showAdded(to: view, animated: true)
    }else if let window = UIApplication.shared.keyWindow {
        hud = MBProgressHUD.showAdded(to: window, animated: true)
    }
    hud?.label.text = hudStr
    hud?.mode = .text
    hud?.hide(animated: true, afterDelay: 2.0)
}

public func dzy_showHud() {
    if let window = UIApplication.shared.keyWindow {
        MBProgressHUD.showAdded(to: window, animated: true)
    }
}

public func dzy_hiddenHud() {
    if let window = UIApplication.shared.keyWindow {
        MBProgressHUD.hide(for: window, animated: true)
    }
}

func naviLeftBtn(imgName:String) -> UIButton {
    let btn = UIButton(type: .custom)
    btn.setImage(UIImage(named: imgName), for: .normal)
    btn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
    return btn
}
