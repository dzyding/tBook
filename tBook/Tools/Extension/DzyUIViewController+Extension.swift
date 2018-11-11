//
//  DzyUIViewController+Extension.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2018/2/23.
//  Copyright © 2018年 EFOOD7. All rights reserved.
//

import Foundation

fileprivate let BackImage = "navi_back"

extension UIViewController {
    
    //MARK: 自定义返回按钮
    func dzy_hideBackBtn() -> UIButton {
        navigationItem.hidesBackButton = true
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: BackImage), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 25)
        let back = UIBarButtonItem(customView: btn)
        navigationItem.leftBarButtonItem = back
        return btn
    }
    
    //解决tabbar上移问题
    func fix_iOS11() {
        if #available(iOS 11.0, *) {
            if var frame = tabBarController?.tabBar.frame {
                if dzy_ifX {
                    frame.size.height = 83.0
                }
                frame.origin.y = Screen_H - frame.size.height
                tabBarController?.tabBar.frame = frame
            }
        }
    }
    
    func dzy_adjustsScrollViewInsets(_ scrollView: UIScrollView? = nil) {
        if #available(iOS 11.0, *) {
            if let scrollView = scrollView {
                scrollView.contentInsetAdjustmentBehavior = .never
            }
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    //MARK: - navi跳转相关
    func dzy_push(_ vc:UIViewController, hide:Bool = false, animated:Bool = true) {
        if hide {
            vc.hidesBottomBarWhenPushed = hide
        }
        if #available(iOS 11.0, *) {
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named: BackImage), for: .normal)
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
            btn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            //隐藏返回按钮中的文字
            navigationItem.backBarButtonItem = UIBarButtonItem(customView: btn)
        }
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func dzy_pop(_ vc:UIViewController? = nil, animated:Bool = true) {
        if let finalVC = vc {
            navigationController?.popToViewController(finalVC, animated: animated)
        }else {
            navigationController?.popViewController(animated: animated)
        }
    }
    
    func dzy_popRoot(_ animated:Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func dzy_title(_ str: String) {
        navigationItem.title = str
    }
}
