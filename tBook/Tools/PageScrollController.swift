//
//  PageScrollController.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2018/1/16.
//  Copyright © 2018年 EFOOD7. All rights reserved.
//

import UIKit

class PageScrollController: UIViewController {
    
    var titles: [String] {
        return []
    }
    
    var btnsView: ScrollBtnView?
    
    var scrollView: UIScrollView?
    
    /**
     各种默认属性
     */
    ///按钮滚动视图的frame
    var btnsFrame: CGRect {
        return CGRect(x: 0, y: 0, width: Screen_W, height: UI_H(41))
    }
    ///是否为根控制器
    var ifRoot: Bool {
        return false
    }
    ///naviBar是否透明
    var ifTranslucent: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBtnsView()
        setChildVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dzy_adjustsScrollViewInsets(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        btnsView?.bounds = CGRect(x: 0, y: 0, width: btnsFrame.width, height: btnsFrame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func btnsViewClick(_ index: Int) {
        let x = CGFloat(index) * Screen_W
        scrollView?.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    func initBtnsView() {
        let btnsView = ScrollBtnView(btns: titles, frame: btnsFrame, font: dzy_Font(16), normalColor: FONT_DARKGRAY, selectedColor: MAIN_COLOR, type: .scale_widthFit) { [unowned self] (index) in
            self.btnsViewClick(index)
        }
        btnsView.setSelectBtn(x: 0)
        btnsView.setBottomLine(LINE_DARK)
        view.addSubview(btnsView)
        self.btnsView = btnsView
    }
    
    func setChildVC() {
        var height = Screen_H - btnsFrame.height
        if ifRoot {height -= TabH}
        if ifTranslucent {height -= NaviH}
        let frame = CGRect(x: 0, y: btnsFrame.maxY, width: Screen_W, height: height)
        let scrollView = UIScrollView(frame: frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: Screen_W * CGFloat(titles.count), height: 1)
        scrollView.delegate = self
        view.addSubview(scrollView)
        self.scrollView = scrollView
    }
}

extension PageScrollController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = Int(x / Screen_W)
        btnsView?.setSelectBtn(x: page)
    }
}
