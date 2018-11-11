//
//  ScrollBtnView.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/5/23.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import Foundation
import UIKit

enum ScrollBtnType {
    ///按总宽度等分 (一般是屏幕宽)
    case scale
    ///按钮宽度按屏幕等分 但是滚动线条长度按title计算
    case scale_widthFit
    ///按按钮长度依次排列
    case arrange
    ///按按钮长度依次排列 小于等于四个按钮的时候等分
    case arrange_four
}

class ScrollBtnView: UIScrollView {
    //所有按钮的名字
    var btns:[String] = []
    //所有按钮的宽度
    fileprivate var widths:[CGFloat] = []
    //所有的子视图
    fileprivate var dzySubViews: [UIView] = []
    //字体大小
    var font:UIFont
    //未选中颜色
    var normalColor:UIColor {
        didSet {
            setNormalColor()
        }
    }
    //选中颜色
    var selectedColor:UIColor{
        didSet {
            setSelectedColor()
        }
    }
    //类型
    var type:ScrollBtnType
    //相应闭包
    var block: ((Int) -> ())?
    
    init(btns: Array<String>,
         frame: CGRect,
         font: UIFont = dzy_Font(15),
         normalColor: UIColor = RGB(r: 21.0, g: 21.0, b: 21.0),
         selectedColor: UIColor = .red,
         type: ScrollBtnType = .scale,
         block: ((Int) -> ())?)
    {
        self.btns = btns
        self.font = font
        self.normalColor   = normalColor
        self.selectedColor = selectedColor
        self.type  = type
        self.block = block
        super.init(frame: frame)
        bounces = false
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        createBtns()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBottomLine(_ color: UIColor) {
        let frame = CGRect(x: 0, y: dzy_h - 0.5, width: dzy_cSizeW, height: 0.5)
        let line = UIView(frame: frame)
        line.backgroundColor = color
        addSubview(line)
    }
    
    //当前选中界面
    func currentIndex() -> Int {
        var index = 0
        (100...100 + btns.count).forEach({
            if let btn = viewWithTag($0) as? UIButton,
                btn.isSelected == true
            {
                index = $0
            }
        })
        return index - 100
    }
    
    //更新按钮
    func updateSubViews(_ btns: [String]) {
        self.btns = btns
        dzySubViews.forEach({$0.removeFromSuperview()})
        dzySubViews = []
        widths = []
        createBtns()
    }
    
    //创建按钮
    fileprivate func createBtns() {
        var x:CGFloat = 0;
        for str in btns {
            var btnW :CGFloat = 0
            var lineW:CGFloat = 0
            if type == .arrange {
                lineW = dzy_strSize(str: str, font: font, width: dzy_w).width + 10
                widths.append(lineW)
                btnW  = lineW
            }else if type == .arrange_four {
                lineW = dzy_strSize(str: str, font: font, width: dzy_w).width + 10
                widths.append(lineW)
                if btns.count > 4 {
                    btnW  = Screen_W / 4.0
                }else {
                    btnW  = Screen_W / CGFloat(btns.count)
                }
            }else if type == .scale_widthFit {
                //线的宽度和按钮的宽度不一样
                lineW = dzy_strSize(str: str, font: font, width: dzy_w).width + 10
                widths.append(lineW)
                btnW = dzy_w / CGFloat(btns.count)
            }else {
                lineW = dzy_w / CGFloat(btns.count)
                widths.append(lineW)
                btnW = lineW
            }
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: 0, width: btnW, height: dzy_h)
            btn.titleLabel?.font = font
            btn.setTitle(str, for: .normal)
            btn.setTitleColor(normalColor, for: .normal)
            btn.setTitleColor(selectedColor, for: .selected)
            btn.tag = 100 + btns.index(of: str)!
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            addSubview(btn)
            dzySubViews.append(btn)
            x += btnW
            if btn.tag == 100 {
                let line = createRedLine(lineW: lineW, btnW: btnW)
                dzySubViews.append(line)
            }
        }
        contentSize = CGSize(width: x, height: dzy_h)
    }
    
    fileprivate func createRedLine(lineW: CGFloat, btnW:CGFloat) -> UIView {
        let line = UIView(frame: CGRect(x: btnW / 2.0 - lineW / 2.0, y: dzy_h - 2, width: lineW, height: 1.5))
        line.backgroundColor = selectedColor
        line.tag = 999
        addSubview(line)
        return line
    }
    
    @objc fileprivate func btnClick(_ button: UIButton) {
        if button.isSelected {
            if let block = self.block {
                block(button.tag - 100)
            }
            return
        }
        //全部取消选中
        for x in 0...btns.count {
            let index = x + 100
            if let btn = viewWithTag(index) as? UIButton {
                btn.isSelected = false
            }
        }
        //当前按钮选中
        button.isSelected = true
        //线的滚动动画
        clickLineAnimate(button)
        if type == .arrange || type == .arrange_four {
            //点击跟随滚动的效果
            arrangeTypeScrollAnimate(button)
        }
        //回调闭包
        if let block = self.block {
            block(button.tag - 100)
        }
    }
    
    func clickLineAnimate(_ btn: UIButton) {
        if let redLine = viewWithTag(999) {
            let width  = widths[btn.tag - 100]
            let left   = btn.frame.midX - width / 2.0
            UIView .animate(withDuration: 0.5, animations: {
                redLine.frame = CGRect(x: left, y: self.dzy_h - 2, width: width, height: 1.5)
            })
        }
    }
    
    func arrangeTypeScrollAnimate(_ btn: UIButton) {
        if contentSize.width <= dzy_w {
            return
        }
        if btn.frame.midX <= dzy_w / 2.0 {
            setContentOffset(.zero, animated: true)
        }else if contentSize.width - btn.center.x <= dzy_w / 2.0 {
            let x = contentSize.width - dzy_w
            setContentOffset(CGPoint(x: x, y: 0), animated: true)
        }else {
            let x = btn.dzy_x - (dzy_w - btn.dzy_w) / 2.0
            setContentOffset(CGPoint(x: x, y: 0), animated: true)
        }
    }
    
    fileprivate func setNormalColor() {
        for x in 0...btns.count {
            let index = x + 100
            if let btn = viewWithTag(index) as? UIButton {
                btn.setTitleColor(normalColor, for: .normal)
            }
        }
    }
    
    func setSelectedColor() {
        for x in 0...btns.count {
            let index = x + 100
            if let btn = viewWithTag(index) as? UIButton {
                btn.setTitleColor(selectedColor, for: .selected)
            }
        }
        if let redLine = viewWithTag(999) {
            redLine.backgroundColor = selectedColor
        }
    }
    
    func setSelectBtn(x:Int) {
        let index = x + 100
        if let btn = viewWithTag(index) as? UIButton {
            btn.sendActions(for: .touchUpInside)
        }
    }
}
