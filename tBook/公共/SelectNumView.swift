//
//  SelectNumView.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/8/2.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

enum MaxType {
    case repertory(Int)
    case limit(Int)
}

class SelectNumView: UIView {
    
    static let width  = 80
    
    static let height = 25
    
    fileprivate weak var reduce: UIButton!
    
    fileprivate weak var add: UIButton!
    
    weak var num: UILabel!
    //限制最大购买量
    fileprivate var max: Int = -1
    
    var maxType: MaxType = .repertory(-1) {
        didSet {
            switch maxType {
            case .limit(let count):
                max = count
            case .repertory(let count):
                max = count
            }
        }
    }
    
    fileprivate var handler:((Int)->())?
    
    init(_ handler: ((Int)->())?) {
        self.handler = handler
        super.init(frame: .zero)
        basicStep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func basicStep() {
        backgroundColor = .white
        layer.cornerRadius = 3
        layer.borderWidth  = 1
        layer.borderColor  = LINE_DARK.cgColor
        
        let reduce = UIButton(type: .custom)
        reduce.tag = 1
        reduce.setImage(UIImage(named: "shopCart_reduce"), for: .normal)
        reduce.addTarget(self, action: #selector(changeNum(btn:)), for: .touchUpInside)
        addSubview(reduce)
        self.reduce = reduce
        
        let leftLine = UIView()
        leftLine.backgroundColor = LINE_DARK
        addSubview(leftLine)
        
        let num = UILabel()
        num.text = "1"
        num.textAlignment = .center
        num.font = dzy_Font(12)
        num.textColor = FONT_BLACK
        addSubview(num)
        self.num = num
        
        let rightLine = UIView()
        rightLine.backgroundColor = LINE_DARK
        addSubview(rightLine)
        
        let add = UIButton(type: .custom)
        add.tag = 2
        add.setImage(UIImage(named: "shopCart_add"), for: .normal)
        add.addTarget(self, action: #selector(changeNum(btn:)), for: .touchUpInside)
        addSubview(add)
        self.add = add
        
        reduce.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.left.top.equalTo(0)
        }
        
        leftLine.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(reduce.snp.right)
            make.width.equalTo(1)
        }
        
        num.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(leftLine.snp.right)
            make.width.equalTo(28)
            make.height.equalTo(reduce.snp.height)
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(num.snp.right)
            make.width.equalTo(1)
        }
        
        add.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(rightLine.snp.right)
            make.width.height.equalTo(25)
        }
    }
    
    @objc func changeNum(btn:UIButton) {
        var n = Int(num.text!)!
        var ifHandler = true
        if btn.tag == 1 {
            //减
            if n > 1 {
                n -= 1
            }else {
                ifHandler = false
            }
        }else {
            //有最大限制数，且n小于max才+1
            if max != -1 {
                if n < max {
                    n += 1
                }else {
                    switch maxType {
                    case .limit:
                        let error = "超出购买限制，限买\(max)件！"
                        dzy_error(error)
                    case .repertory:
                        dzy_error("此商品库存不足")
                    }
                    return
                }
            }else {
                // 加
                n += 1
            }
        }
        num.text = "\(n)"
        
        if let handler = handler, ifHandler {
            handler(btn.tag == 1 ? 0 : 1)
        }
    }
}
