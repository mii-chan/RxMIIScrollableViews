//
//  ViewController.swift
//  Demo
//
//  Created by Miida Yuki on 2017/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import MIIScrollableViews
import RxMIIScrollableViews

class ViewController: UIViewController {
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var scrollableViews: MIIScrollableViews!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - UIBarButtonItems
    @IBOutlet weak var addImageButton: UIBarButtonItem!
    @IBOutlet weak var removeImageButton: UIBarButtonItem!
    
    // MARK: - UISwitches
    @IBOutlet weak var tapSwitch: UISwitch!
    @IBOutlet weak var doubleTapSwitch: UISwitch!
    @IBOutlet weak var panSwitch: UISwitch!
    @IBOutlet weak var pinchSwitch: UISwitch!
    @IBOutlet weak var longPressSwitch: UISwitch!
    
    private let imageNames = ["img1", "img2", "img3", "img4", "img5"]
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add all gestures
        scrollableViews.addAllGesturesToViews()
        
        // MARK: - Rx
        // MARK: - Page Control        
        scrollableViews.rx.count
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        scrollableViews.rx.viewDisplayed
            .map { $1 }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        // MARK: - UISwitch actions
        // Tap Switch
        let tapSwitchValueChanged = tapSwitch.rx.isOn
            .share(replay: 1)
        
        tapSwitchValueChanged
            .bind(to: scrollableViews.rx.shouldAddTapGesture)
            .disposed(by: disposeBag)

        clearTextWhenFlagIsOff(tapSwitchValueChanged)

        // Double Tap Switch
        let doubleTapSwitchValueChanged = doubleTapSwitch.rx.isOn.share(replay: 1)
        
        doubleTapSwitchValueChanged
            .bind(to: scrollableViews.rx.shouldAddDoubleTapGesture)
            .disposed(by: disposeBag)
        
        clearTextWhenFlagIsOff(doubleTapSwitchValueChanged)
        
        // Pan Switch
        let panSwitchValueChanged = panSwitch.rx.isOn.share(replay: 1)
        
        panSwitchValueChanged
            .bind(to: scrollableViews.rx.shouldAddPanGesture)
            .disposed(by: disposeBag)
        
        clearTextWhenFlagIsOff(panSwitchValueChanged)
        
        // Pinch Switch
        let pinchSwitchValueChanged = pinchSwitch.rx.isOn.share(replay: 1)
        
        pinchSwitchValueChanged
            .bind(to: scrollableViews.rx.shouldAddPinchGesture)
            .disposed(by: disposeBag)
        
        clearTextWhenFlagIsOff(pinchSwitchValueChanged)
        
        // Long Press Switch
        let longPressSwitchValueChanged = longPressSwitch.rx.isOn.share(replay: 1)
        
        longPressSwitchValueChanged
            .bind(to: scrollableViews.rx.shouldAddLongPressGesture)
            .disposed(by: disposeBag)
        
        clearTextWhenFlagIsOff(longPressSwitchValueChanged)
        
        // Gestures
        // Tap
        scrollableViews.rx.tap
            .map { "Tap index : \($0.index)" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Double Tap
        scrollableViews.rx.doubleTap
            .map { "Double Tap index : \($0.index)" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Pan
        scrollableViews.rx.pan
            .map { "Pan index : \($0.index)" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Pinch
        scrollableViews.rx.pinch
            .map { "Pinch index : \($0.index)" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // LongPress
        scrollableViews.rx.longPress
            .map { "Long Press index : \($0.index)" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - UIBarButtonItem actions
        // Add Image Button
        let addImageButtonTapped = addImageButton.rx.tap
            .map { [weak self] _ in self?.scrollableViews.count != 0 ? (self?.pageControl.currentPage)! + 1 : 0 }
            .share(replay: 1)
        
        addImageButtonTapped
            .subscribe { [weak self] event in
                self?.scrollableViews.insert((self?.generateRandomImageView())!, at: event.element!)
            }.disposed(by: disposeBag)
        
        addImageButtonTapped
            .map { "Add Image to index : \($0)" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Remove Image Button
        let removeImageButtonTapped = removeImageButton.rx.tap
            .filter { [weak self] _ in self?.scrollableViews.count != nil }
            .filter { [weak self] _ in (self?.scrollableViews.count)! > 0 }
            .filter { [weak self] _ in self?.pageControl.currentPage != nil }
            .map { [weak self] _ in (self?.pageControl.currentPage)! }
            .share(replay: 1)
        
        removeImageButtonTapped
            .subscribe { [weak self] event in
                self?.scrollableViews.remove(at: event.element!)
            }.disposed(by: disposeBag)
        
        removeImageButtonTapped
            .map { "Remove Image from index : \($0)" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
        
        removeImageButtonTapped
            .filter { $0 == 0 }
            .map { _ in "" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add Initial Image
        scrollableViews.append(generateRandomImageView())
    }
    
    // MARK: - Private Methods
    private func generateRandomImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: imageNames[Int(arc4random_uniform(UInt32(imageNames.count)))]))
    }
    
    private func clearTextWhenFlagIsOff(_ flag: Observable<Bool>) {
        flag.filter { !$0 }.map { _ in "" }
            .bind(to: actionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
