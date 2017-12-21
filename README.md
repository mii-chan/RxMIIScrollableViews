# RxMIIScrollableViews
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](/LICENSE)

RxSwift Extension for [MIIScrollableViews](https://github.com/mii-chan/MIIScrollableViews)

![RxMIIScrollableViews Demo](https://github.com/mii-chan/RxMIIScrollableViews/blob/media/demo.gif)

## About
`RxMIIScrollableViews` is a RxSwift Extension for [MIIScrollableViews](https://github.com/mii-chan/MIIScrollableViews)

`MIIScrollableViews` makes it much easier to manage UIViews in UIScrollView. Also supports various types of gestures (Tap, Double Tap, Pan, Pinch and Long Press).

## Requirements
* iOS 8.0+
* Xcode 9.0
* Swift 4

* This library depends on the following libraries.
 - [RxSwift(4.0+)](https://github.com/ReactiveX/RxSwift)
 - [MIIScrollableViews(latest)](https://github.com/mii-chan/MIIScrollableViews)

## Installation
### Carthage
```
github "mii-chan/RxMIIScrollableViews"
```

## Usage
### Reactive wrappers

```swift
// Bind to UIPageControl
scrollableViews.rx.count
    .bind(to: pageControl.rx.numberOfPages)
    .disposed(by: disposeBag)

scrollableViews.rx.viewDisplayed
    .map { $1 }
    .bind(to: pageControl.rx.currentPage)
    .disposed(by: disposeBag)

// Tap gesture
scrollableViews.rx.tap
    .map { "Tap index : \($0.index)" }
    .bind(to: label.rx.text)
    .disposed(by: disposeBag)
```

Name | Description
---|:---:|
count | Reactive wrapper for delegate method `didViewsCountChange` <br><br> Internally use `BehaviorSubject` to emit the values
viewDisplayed | Reactive wrapper for delegate method `didViewDisplayedChange` <br><br> Internally use `PublishSubject` to emit the values
tap | Reactive wrapper for delegate method `didTap`
doubleTap | Reactive wrapper for delegate method `didDoubleTap`
pan | Reactive wrapper for delegate method `didPan`
pinch | Reactive wrapper for delegate method `didPinch`
longPress | Reactive wrapper for delegate method `didLongPress`

#### Bindable sinks

```swift
// UISwitch to control Pan gesture
let panSwitchValueChanged = panSwitch.rx.isOn.share(replay: 1)

// Bind to `shouldAddPanGesture`
panSwitchValueChanged
    .bind(to: scrollableViews.rx.shouldAddPanGesture)
    .disposed(by: disposeBag)

// Clear text when the switch is off
panSwitchValueChanged
    .filter { !$0 }
    .map { _ in "" }
    .bind(to: label.rx.text)
    .disposed(by: disposeBag)
```

Name | Description |
---|:---:|
animated | Bindable sink for `animated` property
shouldAddTapGesture | Bindable sink for `shouldAddTapGesture` property
shouldAddDoubleTapGesture | Bindable sink for `shouldAddDoubleTapGesture` property
shouldAddPanGesture | Bindable sink for `shouldAddPanGesture` property
shouldAddPinchGesture | Bindable sink for `shouldAddPinchGesture` property
shouldAddLongPressGesture | Bindable sink for `shouldAddLongPressGesture` property

## Demo
This library includes Demo project to see how it works.

**Photo Credit** <br>
All materials are downloaded from [PAKUTASO](https://www.pakutaso.com/). If you continue to use the photos, you need to download them yourself from the Official Website or agree to the [Terms of Use](https://www.pakutaso.com/userpolicy.html). If you do not agree, you are not permitted to use the photos.

## License
MIT License, see [LICENSE](/LICENSE).