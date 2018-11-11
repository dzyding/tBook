//
//  HomeViewController.swift
//  tBook
//
//  Created by dzy_PC on 2018/5/20.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

enum RecoedType {
    case none
    case selected(Int)
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
// 下半部分的tableView
    weak var tableView: UITableView?
    
    weak var pickerView: UIPickerView?
    
    weak var pickerBg: UIView?
    
// 按钮所在背景
    weak var topBg: UIView?
    
// 各种数据
    //当前的点击状态
    var currentType: RecoedType = .none
    //当前选中的标签数组
    var currentTagModel: InfoModel?
    //当前选中的标签
    var currentTagName: String?
    
    var disposeBag =  DisposeBag()
    
    //所有的标签
    var tags: [[String]] = [[],[],[],[],[]]
    
//当前信息的条数 (每次进入 app、或添加删除时刷新)
    var currentGuid: Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "时间账本"
        setSearchBtn()
        setTopView()
        setBottomView()
        setPickerView()
        SqliteHelper.default.db_create()
        //        FIXME: 需要考虑一下如果把最后一条数据删除了，再插入一条是否有问题
        //确保每次进入 app 只执行一次
        refreshGuid()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTags()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //    MARK: - 五个主分类按钮的响应事件
    @objc func btnAction(_ btn:UIButton) {
        if case .selected(let tag) = currentType {
            if btn.tag == tag {
                btn.isSelected = false
                currentType = .none
                delegate?.homeVcSendEndAction(currentGuid)
            }else {
                let alert = dzy_msgAlert("提示", msg: "请先结束其它事件")
                present(alert, animated: true, completion: nil)
            }
        }else {
            btn.isSelected = true
            currentType = .selected(btn.tag)
            currentGuid += 1
            if let t = InfoType(rawValue: btn.tag) {
                delegate?.homeVcSendStartAction(t, guid: currentGuid)
            }
        }
    }
    
    //    MARK: - 每次进入app刷新当前 Guid
    func refreshGuid() {
        let guid = SqliteHelper.default.db_lastGuid()
        currentGuid = guid == -1 ? 0 : guid
    }
    
    //    MARK: - 获取最新的Tags
    func refreshTags() {
        if let familyTags = Tags_Family {
            tags[InfoType.family.rawValue - 1] = familyTags
        }
        if let healthTags = Tags_Health {
            tags[InfoType.health.rawValue - 1] = healthTags
        }
        if let playTags = Tags_Play {
            tags[InfoType.play.rawValue - 1] = playTags
        }
        if let workTags = Tags_Work {
            tags[InfoType.work.rawValue - 1] = workTags
        }
        if let otherTags = Tags_Other {
            tags[InfoType.other.rawValue - 1] = otherTags
        }
    }
    
    //    MARK: - 获取最新的10条信息
    func setDataSource() {
        guard let tableView = tableView else {return}
        guard let pickerView = pickerView else {return}
        
        let guid = currentGuid >= 10 ? currentGuid - 10 : 0
        
        tableView.dataSource = nil
        let models = SqliteHelper.default.db_searchFromBool(GUID >= guid)
        
        if let first = models.first {
            checkFirstModel(first)
        }
        
        let insState = HomeMsgState(models: models)
        
        let start = rx.start
            .map({ HomeMsgCommad.start(type: $0, guid: $1) })
        
        let end = rx.end
            .map({ HomeMsgCommad.end(guid: $0) })
        
        let add = rx.addTag
            .map({ HomeMsgCommad.addTag(tag: $0, guid: $1) })
        
        Observable.of(start, end, add)
            .merge()
            .scan(insState) { (state: HomeMsgState, command: HomeMsgCommad) -> HomeMsgState in
                return state.execute(command: command)
            }
            .startWith(insState)
            .map({$0.models})
            .bind(to: tableView.rx.items(cellIdentifier: kMsgDetailCell, cellType: MsgDetailCell.self)) { [unowned self] (_, model, cell) in
                cell.updateViews(model)
                cell.handler = { [unowned self] in
                    self.showTagsAction(model)
                }
            }
            .disposed(by: disposeBag)
        
        let stringPickerAdapter =
            RxPickerViewStringAdapter<[String]>(
                components: [],
                numberOfComponents: { _,_,_  in 1 },
                numberOfRowsInComponent: { (_, _, items, _) -> Int in
                    return items.count
            },
                titleForRow: { (_, _, items, row, _) -> String? in
                    return items[row]
            }
        )
        
        rx.showTags.map { [unowned self] (type, _) -> [String] in
            return self.tags[type.rawValue - 1]
        }
        .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
        .disposed(by: disposeBag)
        
        pickerView.rx.itemSelected
            .bind(onNext: { [weak self] (arg) in
                if let type = self?.currentTagModel?.type,
                    let arr = self?.tags[type.rawValue - 1]
                {
                    self?.currentTagName = arr[arg.row]
                }
            })
            .disposed(by: disposeBag)
    }
    
    //    MARK: - 点击设置标签
    func showTagsAction(_ model: InfoModel) {
        guard let pickerBg = pickerBg else {return}
        currentTagModel = model
        
        if let type = model.type {
            let arr = tags[type.rawValue - 1]
            if arr.isEmpty {
                let alert = dzy_normalAlert("提示", msg: "该类别中暂无标签，是否前往添加", sureClick: { [unowned self] _ in
                    self.goToTagsManagerVC()
                    }, cancelClick: nil)
                DispatchQueue.main.async { [unowned self] in
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
                //相当于初始化, 每次显示的时候更改
                if pickerBg.isHidden == true {
                    currentTagName = arr.first
                }
                pickerBg.isHidden = !pickerBg.isHidden
                delegate?.homeVcShowTagsAction(type, guid: currentGuid)
            }
        }
    }
    
    //    MARK: - 插入标签信息
    func addTagMsg() {
        guard let msg = currentTagName else {
            dzy_error("请选择合适的标签信息")
            return
        }
        if let guid = currentTagModel?.guid {
            pickerBg?.isHidden = true
            delegate?.homeVcAddTagAction(msg, guid: guid)
        }
    }
    
    //    MARK: - 判断如果是第一次
    func checkFirstModel(_ model: InfoModel) {
        if model.end == nil,
            let type = model.type
        {
            let tag = type.rawValue
            if let btn = topBg?.viewWithTag(tag) as? UIButton {
                btn.isSelected = true
                currentType = .selected(tag)
            }
        }
    }
    
    //    MARK: - 前往标签管理界面
    func goToTagsManagerVC() {
        pickerBg?.isHidden = true
        let vc = ManagerTagsController()
        vc.tags = tags
        dzy_push(vc)
    }
    
    //    MARK: - 前往搜索界面
    @objc func search() {
        let vc = SearchViewController()
        dzy_push(vc)
    }
}

enum HomeMsgCommad {
    case start(type: InfoType, guid: Int64)
    case end(guid: Int64)
    case addTag(tag: String, guid: Int64)
}

struct HomeMsgState {
    var models: [InfoModel]
    
    init(models: [InfoModel]) {
        self.models = models
    }
    
    func execute(command: HomeMsgCommad) -> HomeMsgState {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"

        switch command {
        case .start(type: let type, guid: let guid):
            var temp = models
            let date = format.string(from: Date())
            let model = InfoModel(guid: guid, type: type, start: date, end: nil, time: nil, tag: nil)
            temp.insert(model, at: 0)
            SqliteHelper.default.db_insert(model)
            return HomeMsgState(models: temp)
        case .end(guid: let guid):
            var temp = models
            if let index = temp.index(where: {$0.guid == guid}),
                let startStr = temp[index].start,
                let start = format.date(from: startStr)
            {
                let end = Date()
                let time = Int(end.timeIntervalSince(start) / 60.0)
                temp[index].end = format.string(from: end)
                temp[index].time = time
                SqliteHelper.default.db_update(temp[index])
            }
            return HomeMsgState(models: temp)
        case let .addTag(tag, guid):
            var temp = models
            if let index = temp.index(where: {$0.guid == guid}) {
                temp[index].tag = tag
                SqliteHelper.default.db_update(temp[index])
            }
            return HomeMsgState(models: temp)
        }
        
    }
}

//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}

//MARK: - UI
extension HomeViewController {
    
    func setSearchBtn() {
        let btn = UIBarButtonItem(title: "搜索", style: .plain, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem = btn
    }
    
    func setTopView() {
        let bg = UIView()
        bg.backgroundColor = .white
        view.addSubview(bg)
        topBg = bg
        
        func getBtn(_ name: String, _ imgName: String, _ tag: Int) -> UIButton {
            let btn = UIButton(type: .custom)
            btn.setTitle(name, for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.setBackgroundImage(UIImage(named: imgName), for: .normal)
            btn.setBackgroundImage(UIImage(named: "h-non"), for: .selected)
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
            btn.adjustsImageWhenHighlighted = false
            btn.tag = tag
            bg.addSubview(btn)
            return btn
        }
        
        let work = getBtn("工作", "h-work", InfoType.work.rawValue)
        let play = getBtn("娱乐", "h-play", InfoType.play.rawValue)
        let other  = getBtn("其他", "h-other" , InfoType.other.rawValue)
        let family = getBtn("家庭", "h-family", InfoType.family.rawValue)
        let health = getBtn("健康", "h-health", InfoType.health.rawValue)
        
        let x: Double = 94
        bg.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(310)
        }
        
        other.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalTo(bg)
            make.width.height.equalTo(x)
        })
        
        work.snp.makeConstraints({ (make) in
            make.bottom.equalTo(other.snp.top).offset(5)
            make.right.equalTo(other.snp.left).offset(5)
            make.width.height.equalTo(other)
        })
        
        health.snp.makeConstraints({ (make) in
            make.top.equalTo(other.snp.bottom).offset(-5)
            make.right.equalTo(work)
            make.width.height.equalTo(other)
        })
        
        play.snp.makeConstraints({ (make) in
            make.left.equalTo(other.snp.right).offset(-5)
            make.bottom.equalTo(work)
            make.width.height.equalTo(other)
        })
        
        family.snp.makeConstraints({ (make) in
            make.left.equalTo(play)
            make.top.equalTo(health)
            make.width.height.equalTo(other)
        })
    }
    
    func setBottomView() {
        guard let topView = topBg else {return}
        let today = UIButton(type: .custom)
        today.setTitle("查看今日详情", for: .normal)
        today.setTitleColor(.white, for: .normal)
        today.titleLabel?.font = dzy_FontBlod(17)
        today.backgroundColor = MAIN_COLOR
        today.layer.cornerRadius = 5
        view.addSubview(today)
        
        today.rx.tap
            .bind(onNext: { [weak self] (_) in
                let vc = DayDetailController(.today)
                self?.dzy_push(vc)
            })
            .disposed(by: disposeBag)
        
        let label = UILabel()
        label.text = "最新信息"
        label.font = dzy_FontBlod(18)
        label.textColor = FONT_DARKGRAY
        label.textAlignment = .center
        view.addSubview(label)
        
        let frame = CGRect(x: 0, y: 0, width: Screen_W, height: 100)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.register(MsgDetailCell.self, forCellReuseIdentifier: kMsgDetailCell)
        
        today.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.bottom.equalTo(-20)
            make.height.equalTo(45)
        }
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(label.snp.bottom)
            make.bottom.equalTo(today.snp.top).offset(-20)
        }
    }
    
    //    MARK: - 添加标签的picker
    func setPickerView() {
        let pickBg = UIView(frame: .zero)
        pickBg.backgroundColor = BACKGROUND_LIGHTGRAY
        view.addSubview(pickBg)
        pickBg.isHidden = true
        self.pickerBg = pickBg
        
        let sure = UIButton(type: .custom)
        sure.titleLabel?.font = dzy_Font(15)
        sure.setTitle("确定", for: .normal)
        sure.setTitleColor(.red, for: .normal)
        pickBg.addSubview(sure)
        
        let add = UIButton(type: .custom)
        add.titleLabel?.font = dzy_Font(15)
        add.setTitle("添加", for: .normal)
        add.setTitleColor(.red, for: .normal)
        pickBg.addSubview(add)
        
        sure.rx.tap
            .bind { [unowned self] (_) in
                self.addTagMsg()
            }
            .disposed(by: disposeBag)
        
        add.rx.tap
            .bind { [unowned self] (_) in
                self.goToTagsManagerVC()
            }
            .disposed(by: disposeBag)
        
        let pickerView = UIPickerView(frame: .zero)
        pickBg.addSubview(pickerView)
        self.pickerView = pickerView
        
        pickBg.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-20)
            make.height.equalTo(180)
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(150)
        }
        
        sure.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(-15)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        add.snp.makeConstraints { (make) in
            make.height.width.equalTo(sure)
            make.centerY.equalTo(sure)
            make.right.equalTo(sure.snp.left).offset(-30)
        }
    }
}
