//
//  CollectionImageCell.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/7/21.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

let kCollectionImageCell = "CollectionImageCell"

class CollectionImageCell: UICollectionViewCell {
    
    weak var imgView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "banner-jf")
        contentView.addSubview(imgView)
        self.imgView = imgView
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets.zero)
        }
    }
}
