//
//  HomeViewController+Rx.swift
//  tBook
//
//  Created by 森泓投资 on 2018/6/29.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import Foundation

@objc protocol HomeViewControllerDelegate {
    func homeVcSendStartAction(_ type: InfoType, guid: Int64)
    func homeVcSendEndAction(_ guid: Int64)
    func homeVcShowTagsAction(_ type: InfoType, guid: Int64)
    func homeVcAddTagAction(_ tag: String, guid: Int64)
}

extension HomeViewController: HasDelegate {
    typealias Delegate = HomeViewControllerDelegate
}

class RxHomeViewControllerDelegateProxy
    :DelegateProxy<HomeViewController, HomeViewControllerDelegate>,
    DelegateProxyType,
    HomeViewControllerDelegate {
    
    weak private(set) var vc: HomeViewController?
    
    internal lazy var startSubject = PublishSubject<(InfoType, Int64)>()
    
    internal lazy var endSubject = PublishSubject<Int64>()
    
    internal lazy var showTagsSubject = PublishSubject<(InfoType, Int64)>()
    
    internal lazy var addTagSubject = PublishSubject<(String, Int64)>()
    
    public init(vc: ParentObject) {
        self.vc = vc
        super.init(parentObject: vc, delegateProxy: RxHomeViewControllerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxHomeViewControllerDelegateProxy(vc: $0) }
    }
    
    func homeVcSendEndAction(_ guid: Int64) {
        _forwardToDelegate?.homeVcSendEndAction(guid)
        endSubject.onNext(guid)
    }
    
    func homeVcSendStartAction(_ type: InfoType, guid: Int64) {
        _forwardToDelegate?.homeVcSendStartAction(type, guid: guid)
        startSubject.onNext((type, guid))
    }
    
    func homeVcShowTagsAction(_ type: InfoType, guid: Int64) {
        _forwardToDelegate?.homeVcShowTagsAction(type, guid: guid)
        showTagsSubject.onNext((type, guid))
    }
    
    func homeVcAddTagAction(_ tag: String, guid: Int64) {
        _forwardToDelegate?.homeVcAddTagAction(tag, guid: guid)
        addTagSubject.onNext((tag, guid))
    }
    
    deinit {
        endSubject.onCompleted()
        startSubject.onCompleted()
        showTagsSubject.onCompleted()
        addTagSubject.onCompleted()
    }
}

extension Reactive where Base: HomeViewController {
    var start: Observable<(InfoType, Int64)> {
        return RxHomeViewControllerDelegateProxy.proxy(for: base)
            .startSubject.asObserver()
    }
    
    var end: Observable<Int64> {
        return RxHomeViewControllerDelegateProxy.proxy(for: base)
            .endSubject.asObserver()
    }
    
    var showTags: Observable<(InfoType, Int64)> {
        return RxHomeViewControllerDelegateProxy.proxy(for: base)
            .showTagsSubject.asObserver()
    }
    
    var addTag: Observable<(String, Int64)> {
        return RxHomeViewControllerDelegateProxy.proxy(for: base)
            .addTagSubject.asObserver()
    }
}
