//
//  RxMIIScrollableViewsDelegateProxy.swift
//  RxMIIScrollableViews
//
//  Created by Miida Yuki on 2017/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import MIIScrollableViews

class RxMIIScrollableViewsDelegateProxy: DelegateProxy<MIIScrollableViews, MIIScrollableViewsDelegate>, DelegateProxyType, MIIScrollableViewsDelegate {
    
    weak private(set) var scrollableViews: MIIScrollableViews?
    
    init(scrollableViews: MIIScrollableViews) {
        self.scrollableViews = scrollableViews
        super.init(parentObject: scrollableViews, delegateProxy: RxMIIScrollableViewsDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxMIIScrollableViewsDelegateProxy(scrollableViews: $0) }
    }
    
    static func currentDelegate(for object: MIIScrollableViews) -> MIIScrollableViewsDelegate? {
        return object.svDelegate
    }
    
    static func setCurrentDelegate(_ delegate: MIIScrollableViewsDelegate?, to object: MIIScrollableViews) {
        object.svDelegate = delegate
    }
    
    private var _countBehaviorSbj: BehaviorSubject<Int>?
    private var _viewDisplayedPublishSbj: PublishSubject<(viewDisplayed: UIView, index: Int)>?
    
    var countBehaviorSbj: BehaviorSubject<Int> {
        if let sbj = _countBehaviorSbj {
            return sbj
        }
        
        let sbj = BehaviorSubject<Int>(value: self.scrollableViews?.count ?? 0)
        _countBehaviorSbj = sbj
        
        return sbj
    }
    
    var viewDisplayedPublishSbj: PublishSubject<(viewDisplayed: UIView, index: Int)> {
        if let sbj = _viewDisplayedPublishSbj {
            return sbj
        }
        
        let sbj = PublishSubject<(viewDisplayed: UIView, index: Int)>()
        _viewDisplayedPublishSbj = sbj
        
        return sbj
    }
    
    public func didViewsCountChange(count: Int) {
        if let sbj = _countBehaviorSbj {
            sbj.onNext(count)
        }
        self._forwardToDelegate?.didViewsCountChange(count: count)
    }
    
    public func didViewDisplayedChange(viewDisplayed: UIView, index: Int) {
        if let sbj = _viewDisplayedPublishSbj {
            sbj.onNext((viewDisplayed, index))
        }
        self._forwardToDelegate?.didViewDisplayedChange(viewDisplayed: viewDisplayed, index: index)
    }
    
    deinit {
        if let _countBehaviorSbj = _countBehaviorSbj {
            _countBehaviorSbj.on(.completed)
        }
        
        if let _viewDisplayedPublishSbj = _viewDisplayedPublishSbj {
            _viewDisplayedPublishSbj.on(.completed)
        }
    }
}
