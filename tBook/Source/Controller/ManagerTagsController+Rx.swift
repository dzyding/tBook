//
//  ManagerTagsController+Rx.swift
//  tBook
//
//  Created by 森泓投资 on 2018/6/28.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import Foundation

@objc protocol ManagerTagsControllerDelegate {
    func tagsVc(_ collectionView: UICollectionView, didDeleteCellAt indexPath: IndexPath)
    func tagsVc(_ collectionView: UICollectionView, didEditCellAt indexPath: IndexPath)
    func tagsVc(_ tagName: String, addTagDidClick indexPath: IndexPath)
}

extension ManagerTagsController: HasDelegate {
    typealias Delegate = ManagerTagsControllerDelegate
}

class RxManagerTagsControllerDelegateProxy
    :DelegateProxy<ManagerTagsController, ManagerTagsControllerDelegate>,
    DelegateProxyType,
    ManagerTagsControllerDelegate {

    weak private(set) var vc: ManagerTagsController?
    
    internal lazy var didDeleteSubject = PublishSubject<IndexPath>()
    
    internal lazy var didEidtSubject = PublishSubject<IndexPath>()
    
    internal lazy var addTagSubject = PublishSubject<(String ,IndexPath)>()
    
    public init(vc: ParentObject) {
        self.vc = vc
        super.init(parentObject: vc, delegateProxy: RxManagerTagsControllerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxManagerTagsControllerDelegateProxy(vc: $0) }
    }
    
    func tagsVc(_ collectionView: UICollectionView, didDeleteCellAt indexPath: IndexPath) {
        _forwardToDelegate?.tagsVc(collectionView, didDeleteCellAt: indexPath)
        didDeleteSubject.onNext(indexPath)
    }
    
    func tagsVc(_ collectionView: UICollectionView, didEditCellAt indexPath: IndexPath) {
        _forwardToDelegate?.tagsVc(collectionView, didEditCellAt: indexPath)
        didEidtSubject.onNext(indexPath)
    }
    
    func tagsVc(_ tagName: String, addTagDidClick indexPath: IndexPath) {
        _forwardToDelegate?.tagsVc(tagName, addTagDidClick: indexPath)
        addTagSubject.onNext((tagName, indexPath))
    }
    
    deinit {
        didDeleteSubject.onCompleted()
    }
}

extension Reactive where Base: ManagerTagsController {
    var deleteItem: Observable<IndexPath> {
        return RxManagerTagsControllerDelegateProxy.proxy(for: base)
            .didDeleteSubject.asObserver()
    }
    
    var editItem: Observable<IndexPath> {
        return RxManagerTagsControllerDelegateProxy.proxy(for: base)
            .didEidtSubject.asObserver()
    }
    
    var addItem: Observable<(String, IndexPath)> {
        return RxManagerTagsControllerDelegateProxy.proxy(for: base)
            .addTagSubject.asObserver()
    }
}
