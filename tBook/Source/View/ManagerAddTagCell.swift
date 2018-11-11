//
//  ManagerAddTagCell.swift
//  tBook
//
//  Created by 森泓投资 on 2018/6/28.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

let kManagerAddTagCell = "ManagerAddTagCell"

class ManagerAddTagCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        uiStep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiStep() {
        let bg = UIImageView(image: UIImage(named: "tags_add_board"))
        contentView.addSubview(bg)
        
        let add = UIImageView(image: UIImage(named: "tags_add_cross"))
        add.contentMode = .scaleAspectFit
        contentView.addSubview(add)
        
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets.zero)
        }
        
        add.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(bg)
        }
    }
}
