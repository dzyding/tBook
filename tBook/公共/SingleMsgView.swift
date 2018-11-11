//
//  SingleMsgView.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/9/13.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

//用于显示单独的提示信息，类似运费说明之类的
class SingleMsgView: UIView {
    init(_ height: CGFloat, title: String, msg: String) {
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
    
    @objc func ok() {
        if let popView = superview as? DzyPopView {
            popView.hide()
        }
    }
    
    func initSubViews(title: String, msg: String) {
        let titleLabel = UILabel()
        titleLabel.font = dzy_FontBlod(16)
        titleLabel.textColor = FONT_BLACK
        titleLabel.text = title
        addSubview(titleLabel)
        
        let msgLabel = UILabel()
        msgLabel.font = dzy_Font(14)
        msgLabel.textColor = FONT_DARKGRAY
        msgLabel.numberOfLines = 0
        msgLabel.text = msg
        addSubview(msgLabel)
        
        let line = UIView()
        line.backgroundColor = BACKGROUND_GRAY
        addSubview(line)
        
        let btn = UIButton(type: .custom)
        btn.setTitle("我知道了", for: .normal)
        btn.setTitleColor(MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = dzy_FontBlod(15)
        btn.addTarget(self, action: #selector(ok), for: .touchUpInside)
        addSubview(btn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(UI_H(10))
        }
        
        msgLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(UI_H(15))
            make.left.equalTo(UI_W(10))
            make.right.equalTo(UI_W(-10))
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(self).offset(UI_H(-40))
        }
        
        btn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(UI_H(40))
        }
    }
}
