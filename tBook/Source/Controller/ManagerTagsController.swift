//
//  ManagerTagsController.swift
//  tBook
//
//  Created by dzy_PC on 2018/6/26.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import UIKit

class ManagerTagsController: UIViewController {
    
    weak var delegate: ManagerTagsControllerDelegate?
    
    fileprivate weak var collectionView: UICollectionView?
    //添加tag的输入框
    fileprivate weak var textField: UITextField?
    
    var tags: [[String]] = []
    
    fileprivate var dataSource: RxCollectionViewSectionedReloadDataSource<ManagerTagsSectionModel>?
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        dzy_title("标签管理")
        view.backgroundColor = .white
        setCollectionView()
        setCollectionViewDataSource()
        setAddAlert()
        loadData()
    }
    
    func addTagAction(_ indexPath: IndexPath) {
        guard let text = textField?.text, !text.isEmpty  else {
            dzy_error("请输入标签！")
            return
        }
        delegate?.tagsVc(text, addTagDidClick: indexPath)
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        collectionView.register(ManagerTagsCell.self, forCellWithReuseIdentifier: kManagerTagsCell)
        collectionView.register(ManagerAddTagCell.self, forCellWithReuseIdentifier: kManagerAddTagCell)
        collectionView.register(ManagerTagsHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kManagerTagsHeadView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.bottom.right.equalTo(0)
        }
    }
    
    func setCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<ManagerTagsSectionModel>(configureCell: { [unowned self] (dataSource, collectionView, indexPath, itemModel) -> UICollectionViewCell in
            switch itemModel.cellType {
            case .normal,
                 .edit :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kManagerTagsCell, for: indexPath) as! ManagerTagsCell
                cell.updateViews(itemModel)
                cell.deleteHandler = { [unowned self] in
                    self.delegate?.tagsVc(collectionView, didDeleteCellAt: indexPath)
                }
                cell.edithandler = { [unowned self] in
                    self.delegate?.tagsVc(collectionView, didEditCellAt: indexPath)
                }
                return cell
            case .add:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kManagerAddTagCell, for: indexPath) as! ManagerAddTagCell
                return cell
            }
        }, configureSupplementaryView: { (dataSource, collectionView, type, indexPath) -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kManagerTagsHeadView, for: indexPath) as! ManagerTagsHeadView
            header.title?.text = dataSource.sectionModels[indexPath.section].title
            return header
        }, moveItem: { (_, _, _) in
            
        }) { (_, _) -> Bool in
            return false
        }
    }
    
    func setAddAlert() {
        guard let collectionView = collectionView else {return}
        collectionView.rx.itemSelected
            .filter({
                $0.row == collectionView.numberOfItems(inSection: $0.section) - 1
            })
            .bind { [unowned self] (indexPath) in
                let alert = dzy_normalAlert("提示", msg: "请输入标签", sureClick: { [unowned self] (_) in
                   self.addTagAction(indexPath)
                }, cancelClick: nil)
                alert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "请输入"
                    textField.font = dzy_Font(14)
                    textField.textColor = FONT_BLACK
                })
                self.textField = alert.textFields?.first
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func loadData() {
        guard let collectionView = collectionView else {return}
        guard let dataSource = dataSource else {return}
        
        let deleteCommand = rx.deleteItem
            .map({ManagerTagsCommand.deleteItem(index: $0)})
        
        let editCommand = rx.editItem
            .map({ManagerTagsCommand.editItem(index: $0)})
        
        let addCommand = rx.addItem
            .map({ManagerTagsCommand.addItem(name: $0.0, index: $0.1)})
        
        var index = 0
        var tagsModel: [ManagerTagsSectionModel] = []
        for arr in tags {
            index += 1
            if let type = InfoType(rawValue: index) {
                var result = arr.map({
                    ManagerTagsItemModel(title: $0, cellType: .normal)
                })
                result.append(ManagerTagsItemModel(title: nil, cellType: .add))
                tagsModel.append(ManagerTagsSectionModel(title: type.name, items: result))
            }else {
                tagsModel.append(ManagerTagsSectionModel(title: "", items: []))
            }
        }
        
        let state = ManagerTagsState(sections: tagsModel)
        
        Observable.of(deleteCommand, addCommand, editCommand)
            .merge()
            .scan(state) { (state: ManagerTagsState, command: ManagerTagsCommand) -> ManagerTagsState in
                return state.execute(command: command)
            }
            .startWith(state) //让其一开始就有数据
            .map({$0.sections})
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    deinit {
        dzy_log("销毁")
    }
}

extension ManagerTagsController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10.0
        let width = (Screen_W - padding * 5) / 4.0
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Screen_W, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

enum ManagerTagsCommand {
    case deleteItem(index: IndexPath)
    case addItem(name: String, index: IndexPath)
    case editItem(index: IndexPath)
}

struct ManagerTagsState {
    fileprivate var sections: [ManagerTagsSectionModel]
    
    init(sections: [ManagerTagsSectionModel]) {
        self.sections = sections
    }
    
    func execute(command: ManagerTagsCommand) -> ManagerTagsState {
        switch command {
        case .deleteItem(index: let indexPath):
            var temp = sections
            temp[indexPath.section].items.remove(at: indexPath.row)
            if let type = InfoType(rawValue: indexPath.section + 1) {
                refreshTags(type, arr: temp[indexPath.section].items.compactMap({$0.title}))
            }
            return ManagerTagsState(sections: temp)
        case let .addItem(name: tagName, index: indexPath):
            var temp = sections
            let itemModel = ManagerTagsItemModel(title: tagName, cellType: .normal)
            temp[indexPath.section].items.insert(itemModel, at: temp[indexPath.section].items.count - 1)
            if let type = InfoType(rawValue: indexPath.section + 1) {
                refreshTags(type, arr: temp[indexPath.section].items.compactMap({$0.title}))
            }
            return ManagerTagsState(sections: temp)
        case .editItem(index: let indexPath):
            var temp = sections
            temp[indexPath.section].items[indexPath.row].cellType =
                temp[indexPath.section].items[indexPath.row].cellType == .edit ? .normal : .edit
            return ManagerTagsState(sections: temp)
        }
    }
    
    func refreshTags(_ type: InfoType, arr: [String]) {
        switch type {
        case .family:
            Tags_Family = arr
        case .health:
            Tags_Health = arr
        case .other:
            Tags_Other = arr
        case .play:
            Tags_Play = arr
        case .work:
            Tags_Work = arr
        }
    }
}
