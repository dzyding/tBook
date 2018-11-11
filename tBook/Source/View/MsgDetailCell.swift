//
//  MsgDetailCell.swift
//  tBook
//
//  Created by 森泓投资 on 2018/6/20.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

let kMsgDetailCell = "MsgDetailCell"

public class MsgDetailCell: UITableViewCell {
    
    fileprivate weak var type: UILabel?
    
    fileprivate weak var memo: UILabel?
    
    fileprivate weak var setMemo: UIButton?
    
    fileprivate weak var startTime: UILabel?
    
    fileprivate weak var endTime: UILabel?
    
    fileprivate weak var addMemo: UIButton?
    
    fileprivate var disposeBag = DisposeBag()
    
    var handler: (()->())?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        uiStep()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(_ model: InfoModel) {
        type?.text = "类型：" + (model.type?.name ?? "")
        type?.textColor = model.type?.color
        startTime?.text = model.start
        endTime?.text   = (model.end ?? "-")
        if let tag = model.tag {
            addMemo?.isHidden   = true
            memo?.text          = "标签：" + tag
        }else {
            addMemo?.isHidden = false
            memo?.text          = "标签：" + "-"
        }
    }
    
    func detailUpdateViews(_ model: InfoModel) {
        type?.text = "类型：" + (model.type?.name ?? "")
        type?.textColor = model.type?.color
        startTime?.text = model.start
        endTime?.text   = (model.end ?? "-")
        addMemo?.isHidden   = true
        if let tag = model.tag {
            memo?.text          = "标签：" + tag
        }else {
            memo?.text          = "暂无标签"
        }
    }
    
    func uiStep() {
        let bgView = UIImageView(image: UIImage(named: "detail-borer"))
        bgView.isUserInteractionEnabled = true
        contentView.addSubview(bgView)
        
        let type = UILabel()
        type.textColor = FONT_BLACK
        type.font = dzy_Font(17)
        type.text = "类别：工作"
        bgView.addSubview(type)
        self.type = type
        
        let startL = UILabel()
        startL.font = dzy_Font(15)
        startL.textColor = FONT_BLACK
        startL.text = "开始时间："
        bgView.addSubview(startL)
        
        let endL = UILabel()
        endL.font = dzy_Font(15)
        endL.textColor = FONT_BLACK
        endL.text = "结束时间："
        bgView.addSubview(endL)
        
        let start = UILabel()
        start.textColor = FONT_DARKGRAY
        start.font = dzy_Font(15)
        bgView.addSubview(start)
        self.startTime = start
        
        let end = UILabel()
        end.textColor = FONT_DARKGRAY
        end.font = dzy_Font(15)
        bgView.addSubview(end)
        self.endTime = end
        
        let memo = UILabel()
        memo.textColor = FONT_DARKGRAY
        memo.font = dzy_Font(17)
        memo.text = "标签：-"
        bgView.addSubview(memo)
        self.memo = memo
        
        let addMemo = UIButton(type: .custom)
        addMemo.setTitle("设置标签", for: .normal)
        addMemo.titleLabel?.font = dzy_Font(17)
        addMemo.setTitleColor(COLOR_L_BLUE, for: .normal)
        addMemo.backgroundColor = .white
        addMemo.adjustsImageWhenHighlighted = false
        bgView.addSubview(addMemo)
        addMemo.isHidden = true
        self.addMemo = addMemo
        
        addMemo.rx.tap
            .bind { [unowned self] (_) in
                self.handler?()
            }
            .disposed(by: disposeBag)
        
        
        let padding = 7
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(4, 8, 4, 8))
        }
        
        type.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(UI_W(30))
        }
        
        startL.snp.makeConstraints { (make) in
            make.top.equalTo(type.snp.bottom).offset(padding)
            make.left.equalTo(type)
        }
        
        endL.snp.makeConstraints { (make) in
            make.top.equalTo(startL.snp.bottom).offset(padding)
            make.left.equalTo(type)
        }
        
        memo.snp.makeConstraints { (make) in
            make.top.equalTo(type)
            make.right.equalTo(UI_W(-45))
        }
        
        addMemo.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(memo)
            make.width.equalTo(UI_W(80))
            make.height.equalTo(25)
        }
        
        start.snp.makeConstraints { (make) in
            make.top.equalTo(memo.snp.bottom).offset(padding)
            make.right.equalTo(memo)
        }
        
        end.snp.makeConstraints { (make) in
            make.top.equalTo(start.snp.bottom).offset(padding)
            make.left.equalTo(start)
        }
    }
}

