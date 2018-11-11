//
//  CollectionSingleMsgCell.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/10/24.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

let kCollectionSingleMsgCell = "CollectionSingleMsgCell"

class CollectionSingleMsgCell: UICollectionViewCell {
    weak var title: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        let title = UILabel()
        title.textColor = FONT_BLACK
        title.font = dzy_Font(14)
        contentView.addSubview(title)
        self.title = title
        
        let line = UIView()
        line.backgroundColor = LINE_DARK
        contentView.addSubview(line)
        
        title.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(0, UI_W(15), 0, UI_W(15)))
        }
        
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(UI_W(15))
            make.right.equalTo(UI_W(-15))
            make.bottom.equalTo(0)
        }
    }
}
