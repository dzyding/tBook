//
//  DayDetailController.swift
//  tBook
//
//  Created by dzy_PC on 2018/7/30.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

enum DetailType {
    case today      //今天
    case section(String, String)    //区间
}

class DayDetailController: UIViewController {
    
    weak var dateLabel: UILabel?
    
    weak var tableView: UITableView?
    
    weak var topLastLabel: UILabel?
    
    var vcType: DetailType
    
    var datas: [InfoModel] = []
    
    var disposeBag = DisposeBag()
    
    init(_ vcType: DetailType) {
        self.vcType = vcType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dzy_title("当日详情")
        topUIStep()
        bottomUIStep()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - UITableViewDelegate
extension DayDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}

//MARK: - UI
extension DayDetailController {
    func topUIStep() {
        var time: String = ""
        var total: Int = 0
        switch vcType {
        case .today:
            let str = Date().description
            let end = str.index(str.startIndex, offsetBy: 10)
            time = str[...end].description
            //今天的所有信息
            datas = SqliteHelper.default
                .db_searchFromDate(start: time)
            //今天总工作时间
            total = datas.reduce(0) { (before, model) -> Int in
                before + (model.time ?? 0)
            }
        case let .section(start, end):
            time = start + " - " + end
            //区间的所有信息
            datas = SqliteHelper.default
                .db_searchFromDate(start: start, end: end)
            //总工作时间
            total = datas.reduce(0) { (before, model) -> Int in
                before + (model.time ?? 0)
            }
        }
        
        let date = UILabel()
        date.text = time
        date.font = dzy_FontBlod(22)
        date.textColor = FONT_BLACK
        view.addSubview(date)
        self.dateLabel = date
        
        let typeLabel = UILabel()
        typeLabel.font = dzy_Font(20)
        typeLabel.textColor = FONT_DARKGRAY
        typeLabel.text = "类别"
        view.addSubview(typeLabel)
        
        let msgLabel = UILabel()
        msgLabel.font = dzy_Font(20)
        msgLabel.textColor = FONT_DARKGRAY
        msgLabel.text = "分钟 / 百分比"
        view.addSubview(msgLabel)
        
        func getTypeLabel(_ index: Int) {
            guard let type = InfoType(rawValue: index) else {return}
            let result = datas.filter({
                $0.type == type
            })
                .reduce(0) { (before: Int, model: InfoModel) -> Int in
                    before + (model.time ?? 0)
            }
            
            let label = UILabel()
            label.text = type.name
            label.font = dzy_Font(17)
            label.textColor = type.color
            view.addSubview(label)
            
            let msg = UILabel()
            msg.text = String(format: "%ld / %.0lf%%",
                              arguments: [
                                result,
                                (Double(result) / Double(total)) * 100.0
                ])
            msg.font = dzy_Font(17)
            msg.textColor = type.color
            view.addSubview(msg)
            
            //最后一个
            if index == 5 {
                topLastLabel = label
            }
            
            label.snp.makeConstraints { (make) in
                make.centerX.equalTo(typeLabel)
                make.height.equalTo(20)
                make.top.equalTo(typeLabel.snp.bottom).offset(10 + (30 * (index - 1)))
            }
            
            msg.snp.makeConstraints { (make) in
                make.centerX.equalTo(msgLabel)
                make.height.equalTo(label)
                make.centerY.equalTo(label)
            }
        }
        
        (0...5).forEach { (index) in
            getTypeLabel(index)
        }
        
        date.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(view)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.top.equalTo(date.snp.bottom).offset(30)
        }
        
        msgLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-50)
            make.top.equalTo(typeLabel)
        }
    }
    
    func bottomUIStep() {
        guard let label = topLastLabel else {return}
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.register(MsgDetailCell.self, forCellReuseIdentifier: kMsgDetailCell)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(30)
            make.bottom.equalTo(-20)
            make.left.right.equalTo(0)
        }
        
        Observable.just(datas)
            .bind(to: tableView.rx.items(cellIdentifier: kMsgDetailCell, cellType: MsgDetailCell.self)) { (_, model, cell) in
                cell.detailUpdateViews(model)
            }
            .disposed(by: disposeBag)
    }
}
