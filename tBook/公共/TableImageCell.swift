//
//  TableImageCell.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/11/15.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

let kTableImageCell = "TableImageCell"

class TableImageCell: UITableViewCell {
    
    weak var imgView: UIImageView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        contentView.addSubview(imgView)
        self.imgView = imgView
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets.zero)
        }
    }
}
