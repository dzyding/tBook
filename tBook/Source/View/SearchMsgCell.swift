//
//  SearchMsgCell.swift
//  tBook
//
//  Created by dzy_PC on 2018/7/31.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

class SearchMsgCell: UICollectionViewCell {
    fileprivate weak var title:  UILabel?
    fileprivate weak var health: UIImageView?
    fileprivate weak var other:  UIImageView?
    fileprivate weak var work:   UIImageView?
    fileprivate weak var play:   UIImageView?
    fileprivate weak var family: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIStep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func UIStep() {
        func getTypeImgView(_ name: String) -> UIImageView {
            let imgView = UIImageView(image: UIImage(named: name))
            imgView.contentMode = .scaleAspectFit
            contentView.addSubview(imgView)
            return imgView
        }
        let bg = UIImageView(image: UIImage(named: "s-border"))
        contentView.addSubview(bg)
        
        let title = UILabel()
        title.text = "2018-02-02"
        title.textColor = FONT_BLACK
        title.font = dzy_Font(15)
        contentView.addSubview(title)
        self.title = title
        
        let work = getTypeImgView("s-work")
        self.work = work
        
        
        
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets.zero)
        }
        
        title.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(contentView)
        }
    }
}
