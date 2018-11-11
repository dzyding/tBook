//
//  SingleImageViewController.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/11/3.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    fileprivate var imgName: String
    
    init(_ imgName: String) {
        self.imgName = imgName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let image = UIImage(named: imgName) {
            let size = image.size
            let width = Screen_W
            var height: CGFloat = 0
            if size.width <= Screen_W {
                height = size.height
            }else {
                height = (Screen_W / size.width) * size.height
            }
            
            let imgView = UIImageView(image: image)
            imgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            imgView.contentMode = .scaleAspectFit
            
            var frame = Screen_B
            frame.size.height -= NaviH
            let scrollView = UIScrollView(frame: frame)
            scrollView.contentSize = CGSize(width: width, height: height)
            scrollView.backgroundColor = .white
            scrollView.bounces = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.addSubview(imgView)
            view.addSubview(scrollView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
