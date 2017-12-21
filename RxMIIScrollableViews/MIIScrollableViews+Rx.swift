//
//  MIIScrollableViews+Rx.swift
//  RxMIIScrollableViews
//
//  Created by Miida Yuki on 2017/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import MIIScrollableViews

extension Reactive where Base: MIIScrollableViews {
    
    /// Reactive wrapper for `svDelegate`
    public var svDelegate: DelegateProxy<MIIScrollableViews, MIIScrollableViewsDelegate> {
        return RxMIIScrollableViewsDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for delegate method `didViewsCountChange`
    public var count: ControlEvent<Int> {
        let source = RxMIIScrollableViewsDelegateProxy.proxy(for: base).countBehaviorSbj
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `didViewDisplayedChange`
    public var viewDisplayed: ControlEvent<(viewDisplayed: UIView, index: Int)> {
        let source = RxMIIScrollableViewsDelegateProxy.proxy(for: base).viewDisplayedPublishSbj
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `didTap`
    public var tap: ControlEvent<(view: UIView, index: Int, gesture: MIIScrollableViews.Tap)> {
        return createGestureControlEvent(MIIScrollableViews.Tap.self, selector: #selector(MIIScrollableViewsDelegate.didTap(view:index:gesture:)))
    }
    
    /// Reactive wrapper for delegate method `didDoubleTap`
    public var doubleTap: ControlEvent<(view: UIView, index: Int, gesture: MIIScrollableViews.Tap)> {
        return createGestureControlEvent(MIIScrollableViews.Tap.self, selector: #selector(MIIScrollableViewsDelegate.didDoubleTap(view:index:gesture:)))
    }
    
    /// Reactive wrapper for delegate method `didPan`
    public var pan: ControlEvent<(view: UIView, index: Int, gesture: MIIScrollableViews.Pan)> {
        return createGestureControlEvent(MIIScrollableViews.Pan.self, selector: #selector(MIIScrollableViewsDelegate.didPan(view:index:gesture:)))
    }
    
    /// Reactive wrapper for delegate method `didPinch`
    public var pinch: ControlEvent<(view: UIView, index: Int, gesture: MIIScrollableViews.Pinch)> {
        return createGestureControlEvent(MIIScrollableViews.Pinch.self, selector: #selector(MIIScrollableViewsDelegate.didPinch(view:index:gesture:)))
    }
    
    /// Reactive wrapper for delegate method `didLongPress`
    public var longPress: ControlEvent<(view: UIView, index: Int, gesture: MIIScrollableViews.LongPress)> {
        return createGestureControlEvent(MIIScrollableViews.LongPress.self, selector: #selector(MIIScrollableViewsDelegate.didLongPress(view:index:gesture:)))
    }
    
    /// Bindable sink for `animated` property
    public var animated: Binder<Bool> {
        return Binder(self.base) { scrollableViews, value in
            scrollableViews.animated = value
        }
    }
    
    /// Bindable sink for `shouldAddTapGesture` property
    public var shouldAddTapGesture: Binder<Bool> {
        return Binder(self.base) { scrollableViews, value in
            scrollableViews.shouldAddTapGesture = value
        }
    }
    
    /// Bindable sink for `shouldAddDoubleTapGesture` property
    public var shouldAddDoubleTapGesture: Binder<Bool> {
        return Binder(self.base) { scrollableViews, value in
            scrollableViews.shouldAddDoubleTapGesture = value
        }
    }
    
    /// Bindable sink for `shouldAddPanGesture` property
    public var shouldAddPanGesture: Binder<Bool> {
        return Binder(self.base) { scrollableViews, value in
            scrollableViews.shouldAddPanGesture = value
        }
    }
    
    /// Bindable sink for `shouldAddPinchGesture` property
    public var shouldAddPinchGesture: Binder<Bool> {
        return Binder(self.base) { scrollableViews, value in
            scrollableViews.shouldAddPinchGesture = value
        }
    }
    
    /// Bindable sink for `shouldAddLongPressGesture` property
    public var shouldAddLongPressGesture: Binder<Bool> {
        return Binder(self.base) { scrollableViews, value in
            scrollableViews.shouldAddLongPressGesture = value
        }
    }
    
    private func createGestureControlEvent<T: UIGestureRecognizer>(_ type: T.Type, selector: Selector) -> ControlEvent<(view: UIView, index: Int, gesture: T)> {
        let source = svDelegate.methodInvoked(selector)
            .map { value -> (view: UIView, index: Int, gesture: T) in
                return (
                    try castOrThrow(UIView.self, value[0] as AnyObject),
                    try castOrThrow(Int.self, value[1]),
                    try castOrThrow(T.self, value[2])
                )
        }
        return ControlEvent(events: source)
    }
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
