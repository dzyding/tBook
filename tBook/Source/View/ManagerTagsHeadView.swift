//
//  ManagerTagsHeadView.swift
//  tBook
//
//  Created by 森泓投资 on 2018/6/28.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

let kManagerTagsHeadView = "ManagerTagsHeadView"

class ManagerTagsHeadView: UICollectionReusableView {
    
    weak var title: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        uiStep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiStep() {
        let title = UILabel()
        title.font = dzy_Font(17)
        title.textColor = FONT_BLACK
        addSubview(title)
        self.title = title
        
        let line = UIView()
        line.backgroundColor = LINE_LIGHT
        addSubview(line)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
}
