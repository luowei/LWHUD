//
//  LWHUD.swift
//  Version 2.0.0
//  Swift/SwiftUI implementation
//
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright © 2009-2024 Matej Bukovinski
//

import UIKit
import SwiftUI

public let LWProgressMaxOffset: CGFloat = 1000000.0

// MARK: - Enums

public enum LWHUDMode {
    case indeterminate
    case determinate
    case determinateHorizontalBar
    case annularDeterminate
    case customView
    case text
}

public enum LWHUDAnimation {
    case fade
    case zoom
    case zoomOut
    case zoomIn
}

public enum LWHUDBackgroundStyle {
    case solidColor
    case blur
}

public typealias LWHUDCompletionBlock = () -> Void

// MARK: - LWHUDDelegate Protocol

public protocol LWHUDDelegate: AnyObject {
    func hudWasHidden(_ hud: LWHUD)
}

// MARK: - LWHUD Class

@MainActor
open class LWHUD: UIView {

    // MARK: - Class Methods

    @discardableResult
    public class func showHUD(addedTo view: UIView, animated: Bool) -> LWHUD {
        let hud = LWHUD(view: view)
        hud.removeFromSuperViewOnHide = true
        view.addSubview(hud)
        hud.show(animated: animated)
        return hud
    }

    @discardableResult
    public class func hideHUD(for view: UIView, animated: Bool) -> Bool {
        guard let hud = LWHUD.hud(for: view) else { return false }
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: animated)
        return true
    }

    public class func hud(for view: UIView) -> LWHUD? {
        for subview in view.subviews.reversed() {
            if let hud = subview as? LWHUD, !hud.hasFinished {
                return hud
            }
        }
        return nil
    }

    // MARK: - Properties

    public weak var delegate: LWHUDDelegate?
    public var completionBlock: LWHUDCompletionBlock?

    public var graceTime: TimeInterval = 0.0
    public var minShowTime: TimeInterval = 0.0
    public var removeFromSuperViewOnHide: Bool = false

    public var mode: LWHUDMode = .indeterminate {
        didSet {
            if mode != oldValue {
                updateIndicators()
            }
        }
    }

    public var contentColor: UIColor? {
        didSet {
            if let color = contentColor {
                updateViews(for: color)
            }
        }
    }

    public var animationType: LWHUDAnimation = .fade

    public var offset: CGPoint = .zero {
        didSet {
            if offset != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    public var margin: CGFloat = 20.0 {
        didSet {
            if margin != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    public var minSize: CGSize = .zero {
        didSet {
            if minSize != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    public var isSquare: Bool = false {
        didSet {
            if isSquare != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    public var areDefaultMotionEffectsEnabled: Bool = true {
        didSet {
            if areDefaultMotionEffectsEnabled != oldValue {
                updateBezelMotionEffects()
            }
        }
    }

    public var progress: Float = 0.0 {
        didSet {
            if progress != oldValue {
                if let progressView = indicator as? LWProgressView {
                    progressView.progress = progress
                }
            }
        }
    }

    public var progressObject: Progress? {
        didSet {
            setProgressDisplayLinkEnabled(progressObject != nil)
        }
    }

    public private(set) var bezelView: LWBackgroundView!
    public private(set) var backgroundView: LWBackgroundView!
    public var customView: UIView? {
        didSet {
            if customView != oldValue && mode == .customView {
                updateIndicators()
            }
        }
    }

    public private(set) var label: UILabel!
    public private(set) var detailsLabel: UILabel!
    public private(set) var button: UIButton!

    // MARK: - Private Properties

    private var useAnimation: Bool = false
    private var hasFinished: Bool = false
    private var indicator: UIView?
    private var showStarted: Date?
    private var paddingConstraints: [NSLayoutConstraint] = []
    private var bezelConstraints: [NSLayoutConstraint] = []
    private var topSpacer: UIView!
    private var bottomSpacer: UIView!

    private var graceTimer: Timer?
    private var minShowTimer: Timer?
    private var hideDelayTimer: Timer?
    private var progressObjectDisplayLink: CADisplayLink?

    // MARK: - Initialization

    public convenience init(view: UIView) {
        self.init(frame: view.bounds)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        animationType = .fade
        mode = .indeterminate
        margin = 20.0
        areDefaultMotionEffectsEnabled = true
        contentColor = UIColor(white: 0.0, alpha: 0.7)

        isOpaque = false
        backgroundColor = .clear
        alpha = 0.0
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layer.allowsGroupOpacity = false

        setupViews()
        updateIndicators()
        registerForNotifications()
    }

    deinit {
        unregisterFromNotifications()
    }

    // MARK: - Show & Hide

    public func show(animated: Bool) {
        assert(Thread.isMainThread, "LWHUD needs to be accessed on the main thread.")

        minShowTimer?.invalidate()
        useAnimation = animated
        hasFinished = false

        if graceTime > 0.0 {
            graceTimer = Timer.scheduledTimer(withTimeInterval: graceTime, repeats: false) { [weak self] _ in
                self?.handleGraceTimer()
            }
        } else {
            showUsingAnimation(useAnimation)
        }
    }

    public func hide(animated: Bool) {
        assert(Thread.isMainThread, "LWHUD needs to be accessed on the main thread.")

        graceTimer?.invalidate()
        useAnimation = animated
        hasFinished = true

        if minShowTime > 0.0, let showStarted = showStarted {
            let interv = Date().timeIntervalSince(showStarted)
            if interv < minShowTime {
                minShowTimer = Timer.scheduledTimer(withTimeInterval: minShowTime - interv, repeats: false) { [weak self] _ in
                    self?.handleMinShowTimer()
                }
                return
            }
        }

        hideUsingAnimation(useAnimation)
    }

    public func hide(animated: Bool, afterDelay delay: TimeInterval) {
        hideDelayTimer?.invalidate()

        hideDelayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.hide(animated: animated)
        }
    }

    // MARK: - Timer Callbacks

    private func handleGraceTimer() {
        if !hasFinished {
            showUsingAnimation(useAnimation)
        }
    }

    private func handleMinShowTimer() {
        hideUsingAnimation(useAnimation)
    }

    // MARK: - Internal Show & Hide

    private func showUsingAnimation(_ animated: Bool) {
        bezelView.layer.removeAllAnimations()
        backgroundView.layer.removeAllAnimations()

        hideDelayTimer?.invalidate()

        showStarted = Date()
        alpha = 1.0

        setProgressDisplayLinkEnabled(progressObject != nil)

        if animated {
            animate(animatingIn: true, type: animationType, completion: nil)
        } else {
            bezelView.alpha = 1.0
            backgroundView.alpha = 1.0
        }
    }

    private func hideUsingAnimation(_ animated: Bool) {
        if animated && showStarted != nil {
            showStarted = nil
            animate(animatingIn: false, type: animationType) { [weak self] _ in
                self?.done()
            }
        } else {
            showStarted = nil
            bezelView.alpha = 0.0
            backgroundView.alpha = 0.0
            done()
        }
    }

    private func animate(animatingIn: Bool, type: LWHUDAnimation, completion: ((Bool) -> Void)?) {
        var animationType = type
        if type == .zoom {
            animationType = animatingIn ? .zoomIn : .zoomOut
        }

        let small = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let large = CGAffineTransform(scaleX: 1.5, y: 1.5)

        if animatingIn && bezelView.alpha == 0.0 && animationType == .zoomIn {
            bezelView.transform = small
        } else if animatingIn && bezelView.alpha == 0.0 && animationType == .zoomOut {
            bezelView.transform = large
        }

        let animations = {
            if animatingIn {
                self.bezelView.transform = .identity
            } else if !animatingIn && animationType == .zoomIn {
                self.bezelView.transform = large
            } else if !animatingIn && animationType == .zoomOut {
                self.bezelView.transform = small
            }

            self.bezelView.alpha = animatingIn ? 1.0 : 0.0
            self.backgroundView.alpha = animatingIn ? 1.0 : 0.0
        }

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0,
                      initialSpringVelocity: 0, options: .beginFromCurrentState,
                      animations: animations, completion: completion)
    }

    private func done() {
        hideDelayTimer?.invalidate()
        setProgressDisplayLinkEnabled(false)

        if hasFinished {
            alpha = 0.0
            if removeFromSuperViewOnHide {
                removeFromSuperview()
            }
        }

        completionBlock?()
        delegate?.hudWasHidden(self)
    }

    // MARK: - UI Setup

    private func setupViews() {
        let defaultColor = contentColor ?? UIColor(white: 0.0, alpha: 0.7)

        backgroundView = LWBackgroundView(frame: bounds)
        backgroundView.style = .solidColor
        backgroundView.backgroundColor = .clear
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.alpha = 0.0
        addSubview(backgroundView)

        bezelView = LWBackgroundView()
        bezelView.translatesAutoresizingMaskIntoConstraints = false
        bezelView.layer.cornerRadius = 5.0
        bezelView.alpha = 0.0
        addSubview(bezelView)
        updateBezelMotionEffects()

        label = UILabel()
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = .center
        label.textColor = defaultColor
        label.font = .boldSystemFont(ofSize: 16.0)
        label.isOpaque = false
        label.backgroundColor = .clear

        detailsLabel = UILabel()
        detailsLabel.adjustsFontSizeToFitWidth = false
        detailsLabel.textAlignment = .center
        detailsLabel.textColor = defaultColor
        detailsLabel.numberOfLines = 0
        detailsLabel.font = .boldSystemFont(ofSize: 12.0)
        detailsLabel.isOpaque = false
        detailsLabel.backgroundColor = .clear

        button = LWHUDRoundedButton(type: .custom)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 12.0)
        button.setTitleColor(defaultColor, for: .normal)

        for view in [label!, detailsLabel!, button!] {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            bezelView.addSubview(view)
        }

        topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.isHidden = true
        bezelView.addSubview(topSpacer)

        bottomSpacer = UIView()
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.isHidden = true
        bezelView.addSubview(bottomSpacer)
    }

    private func updateIndicators() {
        let isActivityIndicator = indicator is UIActivityIndicatorView
        let isRoundIndicator = indicator is LWRoundProgressView

        switch mode {
        case .indeterminate:
            if !isActivityIndicator {
                indicator?.removeFromSuperview()
                let activityIndicator = UIActivityIndicatorView(style: .large)
                activityIndicator.startAnimating()
                indicator = activityIndicator
                bezelView.addSubview(activityIndicator)
            }

        case .determinateHorizontalBar:
            indicator?.removeFromSuperview()
            let barProgress = LWBarProgressView()
            indicator = barProgress
            bezelView.addSubview(barProgress)

        case .determinate, .annularDeterminate:
            if !isRoundIndicator {
                indicator?.removeFromSuperview()
                let roundProgress = LWRoundProgressView()
                indicator = roundProgress
                bezelView.addSubview(roundProgress)
            }
            if mode == .annularDeterminate {
                (indicator as? LWRoundProgressView)?.isAnnular = true
            }

        case .customView:
            if customView != indicator {
                indicator?.removeFromSuperview()
                indicator = customView
                if let customView = customView {
                    bezelView.addSubview(customView)
                }
            }

        case .text:
            indicator?.removeFromSuperview()
            indicator = nil
        }

        indicator?.translatesAutoresizingMaskIntoConstraints = false

        if let progressView = indicator as? LWProgressView {
            progressView.progress = progress
        }

        indicator?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        indicator?.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        updateViews(for: contentColor ?? UIColor(white: 0.0, alpha: 0.7))
        setNeedsUpdateConstraints()
    }

    private func updateViews(for color: UIColor) {
        label.textColor = color
        detailsLabel.textColor = color
        button.setTitleColor(color, for: .normal)

        if let activityIndicator = indicator as? UIActivityIndicatorView {
            activityIndicator.color = color
        } else if let roundProgress = indicator as? LWRoundProgressView {
            roundProgress.progressTintColor = color
            roundProgress.backgroundTintColor = color.withAlphaComponent(0.1)
        } else if let barProgress = indicator as? LWBarProgressView {
            barProgress.progressColor = color
            barProgress.lineColor = color
        } else {
            indicator?.tintColor = color
        }
    }

    private func updateBezelMotionEffects() {
        if areDefaultMotionEffectsEnabled {
            let effectOffset: CGFloat = 10.0

            let effectX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            effectX.maximumRelativeValue = effectOffset
            effectX.minimumRelativeValue = -effectOffset

            let effectY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            effectY.maximumRelativeValue = effectOffset
            effectY.minimumRelativeValue = -effectOffset

            let group = UIMotionEffectGroup()
            group.motionEffects = [effectX, effectY]

            bezelView.addMotionEffect(group)
        } else {
            for effect in bezelView.motionEffects {
                bezelView.removeMotionEffect(effect)
            }
        }
    }

    // MARK: - Layout

    public override func updateConstraints() {
        var bezelConstraints: [NSLayoutConstraint] = []
        let metrics = ["margin": margin]

        var subviews: [UIView] = [topSpacer, label, detailsLabel, button, bottomSpacer]
        if let indicator = indicator {
            subviews.insert(indicator, at: 1)
        }

        NSLayoutConstraint.deactivate(constraints)
        NSLayoutConstraint.deactivate(topSpacer.constraints)
        NSLayoutConstraint.deactivate(bottomSpacer.constraints)
        NSLayoutConstraint.deactivate(self.bezelConstraints)

        // Center bezel
        let centerX = NSLayoutConstraint(item: bezelView!, attribute: .centerX, relatedBy: .equal,
                                        toItem: self, attribute: .centerX, multiplier: 1.0, constant: offset.x)
        let centerY = NSLayoutConstraint(item: bezelView!, attribute: .centerY, relatedBy: .equal,
                                        toItem: self, attribute: .centerY, multiplier: 1.0, constant: offset.y)
        centerX.priority = .defaultHigh
        centerY.priority = .defaultHigh
        NSLayoutConstraint.activate([centerX, centerY])

        // Minimum margins
        NSLayoutConstraint.activate([
            bezelView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: margin),
            bezelView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -margin),
            bezelView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: margin),
            bezelView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -margin)
        ])

        // Minimum size
        if minSize != .zero {
            let width = bezelView.widthAnchor.constraint(greaterThanOrEqualToConstant: minSize.width)
            let height = bezelView.heightAnchor.constraint(greaterThanOrEqualToConstant: minSize.height)
            width.priority = UILayoutPriority(997)
            height.priority = UILayoutPriority(997)
            bezelConstraints.append(contentsOf: [width, height])
        }

        // Square aspect
        if isSquare {
            let square = bezelView.heightAnchor.constraint(equalTo: bezelView.widthAnchor)
            square.priority = UILayoutPriority(997)
            bezelConstraints.append(square)
        }

        // Top and bottom spacing
        topSpacer.heightAnchor.constraint(greaterThanOrEqualToConstant: margin).isActive = true
        bottomSpacer.heightAnchor.constraint(greaterThanOrEqualToConstant: margin).isActive = true
        bezelConstraints.append(topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor))

        // Layout subviews
        var newPaddingConstraints: [NSLayoutConstraint] = []
        for (idx, view) in subviews.enumerated() {
            bezelConstraints.append(view.centerXAnchor.constraint(equalTo: bezelView.centerXAnchor))
            bezelConstraints.append(contentsOf: [
                view.leadingAnchor.constraint(greaterThanOrEqualTo: bezelView.leadingAnchor, constant: margin),
                view.trailingAnchor.constraint(lessThanOrEqualTo: bezelView.trailingAnchor, constant: -margin)
            ])

            if idx == 0 {
                bezelConstraints.append(view.topAnchor.constraint(equalTo: bezelView.topAnchor))
            } else if idx == subviews.count - 1 {
                bezelConstraints.append(view.bottomAnchor.constraint(equalTo: bezelView.bottomAnchor))
            }

            if idx > 0 {
                let padding = view.topAnchor.constraint(equalTo: subviews[idx - 1].bottomAnchor)
                bezelConstraints.append(padding)
                newPaddingConstraints.append(padding)
            }
        }

        NSLayoutConstraint.activate(bezelConstraints)
        self.bezelConstraints = bezelConstraints
        self.paddingConstraints = newPaddingConstraints
        updatePaddingConstraints()

        super.updateConstraints()
    }

    public override func layoutSubviews() {
        if !needsUpdateConstraints {
            updatePaddingConstraints()
        }
        super.layoutSubviews()
    }

    private func updatePaddingConstraints() {
        var hasVisibleAncestors = false
        for padding in paddingConstraints {
            guard let firstView = padding.firstItem as? UIView,
                  let secondView = padding.secondItem as? UIView else { continue }

            let firstVisible = !firstView.isHidden && firstView.intrinsicContentSize != .zero
            let secondVisible = !secondView.isHidden && secondView.intrinsicContentSize != .zero

            padding.constant = (firstVisible && (secondVisible || hasVisibleAncestors)) ? 4.0 : 0.0
            hasVisibleAncestors = hasVisibleAncestors || secondVisible
        }
    }

    // MARK: - NSProgress

    private func setProgressDisplayLinkEnabled(_ enabled: Bool) {
        if enabled && progressObject != nil {
            if progressObjectDisplayLink == nil {
                let link = CADisplayLink(target: self, selector: #selector(updateProgressFromProgressObject))
                link.add(to: .main, forMode: .default)
                progressObjectDisplayLink = link
            }
        } else {
            progressObjectDisplayLink?.invalidate()
            progressObjectDisplayLink = nil
        }
    }

    @objc private func updateProgressFromProgressObject() {
        if let progressObject = progressObject {
            progress = Float(progressObject.fractionCompleted)
        }
    }

    // MARK: - Notifications

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationDidChange),
                                             name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }

    private func unregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func statusBarOrientationDidChange() {
        if superview != nil {
            updateForCurrentOrientation(animated: true)
        }
    }

    private func updateForCurrentOrientation(animated: Bool) {
        if let superview = superview {
            frame = superview.bounds
        }
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateForCurrentOrientation(animated: false)
    }
}

// MARK: - Protocol for Progress Views

protocol LWProgressView {
    var progress: Float { get set }
}
