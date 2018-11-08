//
//  GMStepper.swift
//  GMStepper
//
//  Created by Gunay Mert Karadogan on 1/7/15.
//  Copyright © 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

@IBDesignable public class GMStepper: UIControl {
    public enum GMStepperType : Int {
        case EditableTextField
        case StaticLabel
    }
    
    public var stepperType : GMStepperType {
        
        didSet {
            label.isHidden = true
            textField.isHidden = true
            
            switch (self.stepperType) {
            case .EditableTextField:
                self.textField.isHidden = false
            case .StaticLabel:
                self.label.isHidden = false
            }
        }
    }
    
    fileprivate func updateText(text: String) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.text = text
        case .StaticLabel:
            self.label.text = text
        }
    }
    
    fileprivate func updateTextColor(color: UIColor) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.textColor = color
        case .StaticLabel:
            self.label.textColor = color
        }
    }
    
    fileprivate func updateBackgroundColor(color: UIColor) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.backgroundColor = color
        case .StaticLabel:
            self.label.backgroundColor = color
        }
    }
    
    fileprivate func updateTextFont(font: UIFont) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.font = font
        case .StaticLabel:
            self.label.font = font
        }
    }
    
    fileprivate func updateCornerRadius(radius: CGFloat) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.layer.cornerRadius = radius
        case .StaticLabel:
            self.label.layer.cornerRadius = radius
        }
    }
    
    fileprivate func updateBorderWidth(width: CGFloat) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.layer.borderWidth = width
        case .StaticLabel:
            self.label.layer.borderWidth = width
        }
    }
    
    fileprivate func updateBorderColor(color: UIColor) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.layer.borderColor = color.cgColor
        case .StaticLabel:
            self.label.layer.borderColor = color.cgColor
        }
    }
    
    fileprivate func updateAdjustsFontSizeToFitWidth(value: Bool) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            self.textField.adjustsFontSizeToFitWidth = value
        case .StaticLabel:
            self.label.adjustsFontSizeToFitWidth = value
        }
    }
    
    fileprivate func updateMinimumScaleFactor(minimumScaleFactor: CGFloat) -> Void {
        switch (self.stepperType) {
        case .EditableTextField:
            print("textfield not support minimumScaleFactor")
//            self.textField.contentScaleFactor = minimumScaleFactor
        case .StaticLabel:
            self.label.minimumScaleFactor = minimumScaleFactor
        }
    }
    
    /// Current value of the stepper. Defaults to 0.
    @objc @IBInspectable public var value: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))

            let isInteger = floor(value) == value
            
            //
            // If we have items, we will display them as steps
            //
            
            if isInteger && stepValue == 1.0 && items.count > 0 {
                self.updateText(text: items[Int(value)])
            }
            else if showIntegerIfDoubleIsInteger && isInteger {
                self.updateText(text: String(stringInterpolationSegment: Int(value)))
            } else {
                if self.manualControDigitsCount {
                    self.updateText(text: String(format: "%.\(digitsCountAfterDecimalPoint)f", value))
                } else {
                    self.updateText(text: String(stringInterpolationSegment: value))
                }
            }

            if oldValue != value {
                sendActions(for: .valueChanged)
            }
        }
    }

    /// Minimum value. Must be less than maximumValue. Defaults to 0.
    @objc @IBInspectable public var minimumValue: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }

    /// Maximum value. Must be more than minimumValue. Defaults to 100.
    @objc @IBInspectable public var maximumValue: Double = 100 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }

    /// Step/Increment value as in UIStepper. Defaults to 1.
    @objc @IBInspectable public var stepValue: Double = 1

    /// The same as UIStepper's autorepeat. If true, holding on the buttons or keeping the pan gesture alters the value repeatedly. Defaults to true.
    @objc @IBInspectable public var autorepeat: Bool = true

    /// If the value is integer, it is shown without floating point.
    @objc @IBInspectable public var showIntegerIfDoubleIsInteger: Bool = true

    /// Text on the left button. Be sure that it fits in the button. Defaults to "−".
    @objc @IBInspectable public var leftButtonText: String = "−" {
        didSet {
            leftButton.setTitle(leftButtonText, for: .normal)
        }
    }
    
    @objc @IBInspectable public var manualControDigitsCount: Bool = false
    @objc @IBInspectable public var digitsCountAfterDecimalPoint: Int = 0 {
        didSet {
            if digitsCountAfterDecimalPoint != 0 {
                self.keyboardType = .decimalPad
            } else {
                self.keyboardType = .numberPad
            }
        }
    }

    /// Text on the right button. Be sure that it fits in the button. Defaults to "+".
    @objc @IBInspectable public var rightButtonText: String = "+" {
        didSet {
            rightButton.setTitle(rightButtonText, for: .normal)
        }
    }

    /// Text color of the buttons. Defaults to white.
    @objc @IBInspectable public var buttonsTextColor: UIColor = UIColor.white {
        didSet {
            for button in [leftButton, rightButton] {
                button.setTitleColor(buttonsTextColor, for: .normal)
            }
        }
    }

    /// Background color of the buttons. Defaults to dark blue.
    @objc @IBInspectable public var buttonsBackgroundColor: UIColor = UIColor(red:0.21, green:0.5, blue:0.74, alpha:1) {
        didSet {
            for button in [leftButton, rightButton] {
                button.backgroundColor = buttonsBackgroundColor
            }
            backgroundColor = buttonsBackgroundColor
        }
    }

    /// Font of the buttons. Defaults to AvenirNext-Bold, 20.0 points in size.
    @objc public var buttonsFont = UIFont(name: "AvenirNext-Bold", size: 20.0)! {
        didSet {
            for button in [leftButton, rightButton] {
                button.titleLabel?.font = buttonsFont
            }
        }
    }

    /// Text color of the middle label. Defaults to white.
    @objc @IBInspectable public var labelTextColor: UIColor = UIColor.white {
        didSet {
            self.updateTextColor(color: labelTextColor)
        }
    }

    /// Text color of the middle label. Defaults to lighter blue.
    @objc @IBInspectable public var labelBackgroundColor: UIColor = UIColor(red:0.26, green:0.6, blue:0.87, alpha:1) {
        didSet {
            self.updateBackgroundColor(color: labelBackgroundColor)
        }
    }

    /// Font of the middle label. Defaults to AvenirNext-Bold, 25.0 points in size.
    @objc public var labelFont = UIFont(name: "AvenirNext-Bold", size: 25.0)! {
        didSet {
            self.updateTextFont(font: labelFont)
        }
    }
       /// Corner radius of the middle label. Defaults to 0.
    @objc @IBInspectable public var labelCornerRadius: CGFloat = 0 {
        didSet {
            self.updateCornerRadius(radius: labelCornerRadius)
        }
    }

    /// Corner radius of the stepper's layer. Defaults to 4.0.
    @objc @IBInspectable public var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    /// Border width of the stepper and middle label's layer. Defaults to 0.0.
    @objc @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            self.updateBorderWidth(width: borderWidth)
        }
    }
    
    /// Color of the border of the stepper and middle label's layer. Defaults to clear color.
    @objc @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            self.updateBorderColor(color: borderColor)
        }
    }

    /// Percentage of the middle label's width. Must be between 0 and 1. Defaults to 0.5. Be sure that it is wide enough to show the value.
    @objc @IBInspectable public var labelWidthWeight: CGFloat = 0.5 {
        didSet {
            labelWidthWeight = min(1, max(0, labelWidthWeight))
            setNeedsLayout()
        }
    }
    
    @objc @IBInspectable public var adjustsFontSizeToFitWidth: Bool = false {
        didSet {
            self.updateAdjustsFontSizeToFitWidth(value: adjustsFontSizeToFitWidth)
        }
    }
    
    @objc @IBInspectable public var minimumScaleFactor: CGFloat = 0.0 {
        didSet {
            self.updateMinimumScaleFactor(minimumScaleFactor: minimumScaleFactor)
        }
    }

    /// Color of the flashing animation on the buttons in case the value hit the limit.
    @objc @IBInspectable public var limitHitAnimationColor: UIColor = UIColor(red:0.26, green:0.6, blue:0.87, alpha:1)

    /**
        Width of the sliding animation. When buttons clicked, the middle label does a slide animation towards to the clicked button. Defaults to 5.
    */
    let labelSlideLength: CGFloat = 5

    /// Duration of the sliding animation
    let labelSlideDuration = TimeInterval(0.1)

    /// Duration of the animation when the value hits the limit.
    let limitHitAnimationDuration = TimeInterval(0.1)

    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.leftButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(GMStepper.leftButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpOutside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchCancel)
        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.rightButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(GMStepper.rightButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpOutside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchCancel)
        return button
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if self.showIntegerIfDoubleIsInteger && floor(self.value) == self.value {
            label.text = String(stringInterpolationSegment: Int(self.value))
        } else {
            label.text = String(stringInterpolationSegment: self.value)
        }
        label.textColor = self.labelTextColor
        label.backgroundColor = self.labelBackgroundColor
        label.font = self.labelFont
        label.layer.cornerRadius = self.labelCornerRadius
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = true
        label.adjustsFontSizeToFitWidth = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GMStepper.handlePan))
        panRecognizer.maximumNumberOfTouches = 1
        label.addGestureRecognizer(panRecognizer)
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        if self.showIntegerIfDoubleIsInteger && floor(self.value) == self.value {
            textField.text = String(stringInterpolationSegment: Int(self.value))
        } else {
            textField.text = String(stringInterpolationSegment: self.value)
        }
        textField.textColor = self.labelTextColor
        textField.backgroundColor = self.labelBackgroundColor
        textField.font = self.labelFont
        textField.layer.cornerRadius = self.labelCornerRadius
        textField.layer.masksToBounds = true
        textField.isUserInteractionEnabled = true
        textField.adjustsFontSizeToFitWidth = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GMStepper.handlePan))
        panRecognizer.maximumNumberOfTouches = 1
        textField.addGestureRecognizer(panRecognizer)
        return textField
    }()

    var labelOriginalCenter: CGPoint!
    var labelMaximumCenterX: CGFloat!
    var labelMinimumCenterX: CGFloat!

    enum LabelPanState {
        case Stable, HitRightEdge, HitLeftEdge
    }
    var panState = LabelPanState.Stable

    enum StepperState {
        case Stable, ShouldIncrease, ShouldDecrease
    }
    var stepperState = StepperState.Stable {
        didSet {
            if stepperState != .Stable {
                updateValue()
                if autorepeat {
                    scheduleTimer()
                }
            }
        }
    }
    
    
    @objc public var items : [String] = [] {
        didSet {
            let isInteger = floor(value) == value
            
            //
            // If we have items, we will display them as steps
            //
            
            if isInteger && stepValue == 1.0 && items.count > 0 {
                
                var value = Int(self.value)
                
                if value >= items.count {
                    value = items.count - 1
                    self.value = Double(value)
                }
                else {
                    self.updateText(text: items[value])
                }
            }
        }
    }

    /// Timer used for autorepeat option
    var timer: Timer?

    /** When UIStepper reaches its top speed, it alters the value with a time interval of ~0.05 sec.
        The user pressing and holding on the stepper repeatedly:
        - First 2.5 sec, the stepper changes the value every 0.5 sec.
        - For the next 1.5 sec, it changes the value every 0.1 sec.
        - Then, every 0.05 sec.
    */
    let timerInterval = TimeInterval(0.02)

    /// Check the handleTimerFire: function. While it is counting the number of fires, it decreases the mod value so that the value is altered more frequently.
    var timerFireCount = 0
    var timerFireCountModulo: Int {
        if timerFireCount > 80 {
            return 1 // 0.05 sec * 1 = 0.05 sec
        } else if timerFireCount > 50 {
            return 2 // 0.05 sec * 2 = 0.1 sec
        } else {
            return 10 // 0.05 sec * 10 = 0.5 sec
        }
    }

    @objc required public init?(coder aDecoder: NSCoder) {
        self.stepperType = .EditableTextField
        super.init(coder: aDecoder)
        setup()
    }

    @objc public override init(frame: CGRect) {
        self.stepperType = .EditableTextField
        super.init(frame: frame)
        setup()
    }

    func setup() {
        addSubview(leftButton)
        addSubview(rightButton)
        self.addSubview(self.textField)
        self.addSubview(self.label)
        labelOriginalCenter = label.center
        
        label.isHidden = true
        textField.isHidden = true
        let tmp = self.stepperType
        self.stepperType = tmp
        
        textField.keyboardType = self.keyboardType
        textField.delegate = self
        
        backgroundColor = buttonsBackgroundColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(GMStepper.reset), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    public override func layoutSubviews() {
        let buttonWidth = bounds.size.width * ((1 - labelWidthWeight) / 2)
        let labelWidth = bounds.size.width * labelWidthWeight

        leftButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: bounds.size.height)
        label.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: bounds.size.height)
        textField.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: bounds.size.height)
        rightButton.frame = CGRect(x: labelWidth + buttonWidth, y: 0, width: buttonWidth, height: bounds.size.height)

        labelMaximumCenterX = label.center.x + labelSlideLength
        labelMinimumCenterX = label.center.x - labelSlideLength
        labelOriginalCenter = label.center
    }

    func updateValue() {
        if stepperState == .ShouldIncrease {
            value += stepValue
        } else if stepperState == .ShouldDecrease {
            value -= stepValue
        }   
    }

    deinit {
        resetTimer()
        NotificationCenter.default.removeObserver(self)
    }

    override public var isEnabled:Bool {
        didSet {
            self.leftButton.isEnabled = self.isEnabled
            self.rightButton.isEnabled = self.isEnabled
            self.label.isEnabled = self.isEnabled
            self.textField.isEnabled = self.isEnabled
            
            self.rightButton.setTitleColor(UIColor.lightGray, for: .disabled)
            self.label.textColor = self.isEnabled ? self.labelTextColor : UIColor.lightGray
            self.textField.textColor = self.label.textColor
        }
    }
    
    public var keyboardType : UIKeyboardType = .decimalPad {
        didSet {
            self.textField.keyboardType = keyboardType
        }
    }
    /// Useful closure for logging the timer interval. You can call this in the timer handler to test the autorepeat option. Not used in the current implementation.
//    lazy var printTimerGaps: () -> () = {
//        var prevTime: CFAbsoluteTime?
//
//        return { _ in
//            var now = CFAbsoluteTimeGetCurrent()
//            if let prevTime = prevTime {
//                print(now - prevTime)
//            }
//            prevTime = now
//        }
//    }()
}

// MARK: Pan Gesture
extension GMStepper {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            leftButton.isEnabled = false
            rightButton.isEnabled = false
        case .changed:
            var targetView : UIView!
            switch (self.stepperType) {
            case .EditableTextField:
                targetView = self.textField
            case .StaticLabel:
                targetView = self.label
            }
            
            let translation = gesture.translation(in: targetView)
            gesture.setTranslation(CGPoint.zero, in: targetView)

            let slidingRight = gesture.velocity(in: targetView).x > 0
            let slidingLeft = gesture.velocity(in: targetView).x < 0

            // Move the label with pan
            if slidingRight {
                targetView.center.x = min(labelMaximumCenterX, targetView.center.x + translation.x)
            } else if slidingLeft {
                targetView.center.x = max(labelMinimumCenterX, targetView.center.x + translation.x)
            }

            // When the label hits the edges, increase/decrease value and change button backgrounds
            if targetView.center.x == labelMaximumCenterX {
                // If not hit the right edge before, increase the value and start the timer. If already hit the edge, do nothing. Timer will handle it.
                if panState != .HitRightEdge {
                    stepperState = .ShouldIncrease
                    panState = .HitRightEdge
                }
                
                animateLimitHitIfNeeded()
            } else if targetView.center.x == labelMinimumCenterX {
                if panState != .HitLeftEdge {
                    stepperState = .ShouldDecrease
                    panState = .HitLeftEdge
                }

                animateLimitHitIfNeeded()
            } else {
                panState = .Stable
                stepperState = .Stable
                resetTimer()

                self.rightButton.backgroundColor = self.buttonsBackgroundColor
                self.leftButton.backgroundColor = self.buttonsBackgroundColor
            }
        case .ended, .cancelled, .failed:
            reset()
        default:
            break
        }
    }

    @objc func reset() {
        panState = .Stable
        stepperState = .Stable
        resetTimer()

        leftButton.isEnabled = true
        rightButton.isEnabled = true
        label.isUserInteractionEnabled = true
        textField.isUserInteractionEnabled = true

        UIView.animate(withDuration: self.labelSlideDuration, animations: {
            self.label.center = self.labelOriginalCenter
            self.textField.center = self.labelOriginalCenter
            self.rightButton.backgroundColor = self.buttonsBackgroundColor
            self.leftButton.backgroundColor = self.buttonsBackgroundColor
        })
    }
}

// MARK: Button Events
extension GMStepper {
    @objc func leftButtonTouchDown(button: UIButton) {
        rightButton.isEnabled = false
        label.isUserInteractionEnabled = false
        textField.isUserInteractionEnabled = false
        resetTimer()

        if value == minimumValue {
            animateLimitHitIfNeeded()
        } else {
            stepperState = .ShouldDecrease
            animateSlideLeft()
        }

    }

    @objc func rightButtonTouchDown(button: UIButton) {
        leftButton.isEnabled = false
        label.isUserInteractionEnabled = false
        textField.isUserInteractionEnabled = false
        resetTimer()

        if value == maximumValue {
            animateLimitHitIfNeeded()
        } else {
            stepperState = .ShouldIncrease
            animateSlideRight()
        }
    }

    @objc func buttonTouchUp(button: UIButton) {
        reset()
    }
}

// MARK: Animations
extension GMStepper {

    func animateSlideLeft() {
        UIView.animate(withDuration: labelSlideDuration) {
            switch (self.stepperType) {
            case .EditableTextField:
                self.textField.center.x -= self.labelSlideLength
            case .StaticLabel:
                self.label.center.x -= self.labelSlideLength
            }
            
        }
    }

    func animateSlideRight() {
        UIView.animate(withDuration: labelSlideDuration) {
            switch (self.stepperType) {
            case .EditableTextField:
                self.textField.center.x += self.labelSlideLength
            case .StaticLabel:
                self.label.center.x += self.labelSlideLength
            }
        }
    }

    func animateToOriginalPosition() {
        var targetView : UIView!
        switch (self.stepperType) {
        case .EditableTextField:
            targetView = self.textField
        case .StaticLabel:
            targetView = self.label
        }
        if targetView.center != self.labelOriginalCenter {
            UIView.animate(withDuration: labelSlideDuration) {
                targetView.center = self.labelOriginalCenter
            }
        }
    }

    func animateLimitHitIfNeeded() {
        if value == minimumValue {
            animateLimitHitForButton(button: leftButton)
        } else if value == maximumValue {
            animateLimitHitForButton(button: rightButton)
        }
    }

    func animateLimitHitForButton(button: UIButton){
        UIView.animate(withDuration: limitHitAnimationDuration) {
            button.backgroundColor = self.limitHitAnimationColor
        }
    }
}

// MARK: Timer
extension GMStepper {
    @objc func handleTimerFire(timer: Timer) {
        timerFireCount += 1

        if timerFireCount % timerFireCountModulo == 0 {
            updateValue()
        }
    }

    func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(GMStepper.handleTimerFire), userInfo: nil, repeats: true)
    }

    func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            timerFireCount = 0
        }
    }
}

extension GMStepper : UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.lengthOfBytes(using: .ascii) == 0 {
            return true
        }
        
        if textField.keyboardType == .numberPad {
            if let r = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) {
                return false
            }
        }
        
        return true;
    }
}
