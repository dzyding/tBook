//
//  MsgsView.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/10/18.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

class MsgsView: UIView {
    var handler: (()->())
    
    init(_ height: CGFloat, title: String, msg: [String], handler: @escaping ()->()) {
        self.handler = handler
        let frame = CGRect(x: 50, y: 0, width: Screen_W - 100, height: height)
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = true
        initSubViews(title: title, msg: msg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hidden() {
        if let popView = superview as? DzyPopView {
            popView.hide()
        }
    }
    
    @objc func ok() {
        handler()
    }
    
    func initSubViews(title: String, msg: [String]) {
        func getLabel(_ text: String) -> UILabel {
            let label = UILabel()
            label.font = dzy_Font(15)
            label.textColor = FONT_DARKGRAY
            label.text = text
            addSubview(label)
            return label
        }
        let titleLabel = UILabel()
        titleLabel.font = dzy_FontBlod(16)
        titleLabel.textColor = FONT_BLACK
        titleLabel.text = title
        addSubview(titleLabel)
        
        let bottom = getBottomView()
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(UI_H(10))
        }
        
        bottom.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(UI_H(55))
        }
        
        let padding = UI_W(8)
        var y:CGFloat = 0
        (0..<msg.count).forEach { (i) in
            let msg = getLabel(msg[i])
            y += (padding + UI_H(20))
            msg.snp.makeConstraints({ (make) in
                make.left.equalTo(padding)
                make.top.equalTo(titleLabel.snp.bottom).offset(y)
                make.height.equalTo(UI_H(20))
            })
        }
    }
    
    func getBottomView() -> UIView {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        
        let line = UIView()
        line.backgroundColor = BACKGROUND_GRAY
        bottomView.addSubview(line)
        
        let cancel = UIButton(type: .custom)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(FONT_DARKGRAY, for: .normal)
        cancel.titleLabel?.font = dzy_FontBlod(15)
        cancel.layer.cornerRadius = 8
        cancel.layer.borderWidth = 1
        cancel.layer.borderColor = FONT_DARKGRAY.cgColor
        cancel.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        bottomView.addSubview(cancel)
        
        let sure = UIButton(type: .custom)
        sure.setTitle("确定", for: .normal)
        sure.setTitleColor(.white, for: .normal)
        sure.titleLabel?.font = dzy_FontBlod(15)
        sure.backgroundColor = MAIN_COLOR
        sure.layer.cornerRadius = 8
        sure.addTarget(self, action: #selector(ok), for: .touchUpInside)
        bottomView.addSubview(sure)
        
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(1)
        }
        
        let padding = UI_W(8)
        
        cancel.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(padding)
            make.left.equalTo(padding)
            make.bottom.equalTo(-padding)
        }
        
        sure.snp.makeConstraints { (make) in
            make.top.equalTo(cancel)
            make.right.equalTo(-padding)
            make.bottom.equalTo(cancel)
            make.width.equalTo(cancel)
            make.left.equalTo(cancel.snp.right).offset(padding)
        }
        
        return bottomView
    }
}
