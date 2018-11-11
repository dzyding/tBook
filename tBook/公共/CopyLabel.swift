//
//  CopyLabel.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2018/1/9.
//  Copyright © 2018年 EFOOD7. All rights reserved.
//

import UIKit

class CopyLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicStep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func longAction(_ long: UILongPressGestureRecognizer) {
        if case .began = long.state {
            becomeFirstResponder()
            let menuVC = UIMenuController.shared
            let item   = UIMenuItem(title: "复制", action: #selector(copyAction(_:)))
            menuVC.menuItems = [item]
            if let superView = superview {
                menuVC.setTargetRect(bounds, in: superView)
                menuVC.setMenuVisible(true, animated: true)
            }
        }
    }
    
    @objc func copyAction(_ item: UIMenuItem) {
        UIPasteboard.general.string = text
    }
    
    func basicStep() {
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longAction(_:)))
        addGestureRecognizer(long)
        
        var view: UIView? = self
        while view != nil {
            view?.isUserInteractionEnabled = true
            view = view?.superview
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action.description == "copyAction:" ? true : false
    }
}
