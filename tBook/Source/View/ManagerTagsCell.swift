//
//  ManagerTagsCell.swift
//  tBook
//
//  Created by dzy_PC on 2018/6/26.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

let kManagerTagsCell = "ManagerTagsCell"

class ManagerTagsCell: UICollectionViewCell {
    
    var deleteHandler: (()->())?
    
    var edithandler: (()->())?
    
    fileprivate weak var title: UILabel?
    
    fileprivate weak var editBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        basicStep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(_ model: ManagerTagsItemModel) {
        title?.text = model.title
        editBtn?.isHidden = model.cellType == .edit ? false : true
    }
    
    @objc func longPress(_ long: UILongPressGestureRecognizer) {
        if case .began = long.state {
            edithandler?()
        }
    }
    
    @objc func deleteAction() {
        deleteHandler?()
    }
    
    func basicStep() {
        let bg = UIImageView(image: UIImage(named: "m-tags"))
        contentView.addSubview(bg)
        
        let title = UILabel()
        title.font = dzy_Font(15)
        title.textColor = .white
        title.textAlignment = .center
        contentView.addSubview(title)
        self.title = title
        
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "tags_cross"), for: .normal)
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        contentView.addSubview(btn)
        btn.isHidden = true
        self.editBtn = btn
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        contentView.addGestureRecognizer(long)
        
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets.zero)
        }
        
        title.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
        
        btn.snp.makeConstraints { (make) in
            make.width.height.equalTo(21)
            make.right.equalTo(5)
            make.top.equalTo(-5)
        }
    }
}
