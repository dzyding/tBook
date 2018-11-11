//
//  SearchViewController.swift
//  tBook
//
//  Created by dzy_PC on 2018/7/30.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dzy_title("搜索")
        setTopView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //    MAKR: - 选择搜索类型
    @objc func topSelectedAction(_ btn: UIButton) {
        if btn.isSelected {return}
        
        btn.superview?.subviews.forEach({
            if let btn = $0 as? UIButton {
                btn.isSelected = false
            }
        })
        btn.isSelected = true
    }
    
    func setTopView() {
        func getBtn(_ title: String, imageName: String, tag: Int) -> UIButton {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.setBackgroundImage(UIImage(named: imageName), for: .normal)
            btn.setBackgroundImage(UIImage(named: "s-t-selected"), for: .selected)
            btn.titleLabel?.font = dzy_FontBlod(15)
            btn.setTitleColor(.white, for: .selected)
            btn.setTitleColor(FONT_BLACK, for: .normal)
            btn.adjustsImageWhenHighlighted = false
            btn.addTarget(self, action: #selector(topSelectedAction(_:)), for: .touchUpInside)
            btn.tag = tag
            return btn
        }
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        view.addSubview(bgView)
        
        let today = getBtn("单日", imageName: "s-t-left", tag: 1)
        today.isSelected = true
        bgView.addSubview(today)
        
        let section = getBtn("区间", imageName: "s-t-right", tag: 2)
        bgView.addSubview(section)
        
        bgView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.top.equalTo(30)
            make.centerX.equalTo(view)
        }
        
        today.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.left.top.bottom.equalTo(0)
        }
        
        section.snp.makeConstraints { (make) in
            make.width.equalTo(today)
            make.top.right.bottom.equalTo(0)
        }
    }
}
