//
//  CollectionTitleHeaderFooterView.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/7/20.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

enum TitleHeaderFooterType {
    //标题在左侧
    case left
    //标题居中
    case center
    //标题在右边
    case right
    //标题居中并在上面
    case center_top
}

let kCollectionTitleHeaderFooterView = "CollectionTitleHeaderFooterView"

class CollectionTitleHeaderFooterView: UICollectionReusableView {
    
    fileprivate weak var titleL:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    func setTitle(_ title:String,
                  backGroundColor: UIColor? = nil,
                  titleColor: UIColor? = nil,
                  type: TitleHeaderFooterType = .center)
    {
        titleL.text = title
        if titleColor != nil {
            titleL.textColor = titleColor
        }
        if backGroundColor != nil {
            backgroundColor = backGroundColor
        }
        if type == .left {
            titleL.textAlignment = .left
            titleL.snp.makeConstraints { (make) in
                make.left.equalTo(UI_W(15))
                make.bottom.top.right.equalTo(0)
            }
        }else if type == .center {
            titleL.textAlignment = .center
            titleL.snp.makeConstraints { (make) in
                make.left.bottom.top.right.equalTo(0)
            }
        }else if type == .center_top {
            titleL.textAlignment = .center
            titleL.snp.makeConstraints { (make) in
                make.left.top.right.equalTo(0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        let msg = UILabel()
        msg.font = dzy_Font(12)
        msg.textColor = FONT_DARKGRAY
        addSubview(msg)
        titleL = msg
    }
}
