//
//  LWHUD+Extensions.swift
//  LWHUD
//
//  Convenience extensions and helpers
//

import UIKit

// MARK: - LWHUD Convenience Methods

public extension LWHUD {

    /// Show a simple activity indicator HUD
    @discardableResult
    class func showActivity(in view: UIView, text: String? = nil) -> LWHUD {
        let hud = showHUD(addedTo: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = text
        return hud
    }

    /// Show a text-only HUD
    @discardableResult
    class func showText(_ text: String, in view: UIView, detailText: String? = nil, hideAfter delay: TimeInterval = 2.0) -> LWHUD {
        let hud = showHUD(addedTo: view, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.detailsLabel.text = detailText
        hud.hide(animated: true, afterDelay: delay)
        return hud
    }

    /// Show a success HUD with checkmark
    @discardableResult
    class func showSuccess(_ text: String, in view: UIView, hideAfter delay: TimeInterval = 2.0) -> LWHUD {
        let hud = showHUD(addedTo: view, animated: true)
        hud.mode = .customView
        hud.customView = createCheckmarkView()
        hud.label.text = text
        hud.hide(animated: true, afterDelay: delay)
        return hud
    }

    /// Show an error HUD with X mark
    @discardableResult
    class func showError(_ text: String, in view: UIView, hideAfter delay: TimeInterval = 2.0) -> LWHUD {
        let hud = showHUD(addedTo: view, animated: true)
        hud.mode = .customView
        hud.customView = createCrossView()
        hud.label.text = text
        hud.hide(animated: true, afterDelay: delay)
        return hud
    }

    /// Show a progress HUD
    @discardableResult
    class func showProgress(_ progress: Float, text: String? = nil, in view: UIView) -> LWHUD {
        let hud = showHUD(addedTo: view, animated: true)
        hud.mode = .determinate
        hud.progress = progress
        hud.label.text = text
        return hud
    }

    /// Update progress for existing HUD
    func updateProgress(_ progress: Float, text: String? = nil) {
        self.progress = progress
        if let text = text {
            self.label.text = text
        }
    }

    // MARK: - Private Helpers

    private class func createCheckmarkView() -> UIView {
        let imageView = UIImageView(image: drawCheckmark())
        imageView.tintColor = .white
        return imageView
    }

    private class func createCrossView() -> UIView {
        let imageView = UIImageView(image: drawCross())
        imageView.tintColor = .white
        return imageView
    }

    private class func drawCheckmark() -> UIImage {
        let size = CGSize(width: 37, height: 37)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let checkmarkPath = UIBezierPath()
            checkmarkPath.move(to: CGPoint(x: 8, y: 18))
            checkmarkPath.addLine(to: CGPoint(x: 15, y: 28))
            checkmarkPath.addLine(to: CGPoint(x: 29, y: 10))

            UIColor.white.setStroke()
            checkmarkPath.lineWidth = 3
            checkmarkPath.lineCapStyle = .round
            checkmarkPath.lineJoinStyle = .round
            checkmarkPath.stroke()
        }
    }

    private class func drawCross() -> UIImage {
        let size = CGSize(width: 37, height: 37)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let crossPath = UIBezierPath()
            crossPath.move(to: CGPoint(x: 10, y: 10))
            crossPath.addLine(to: CGPoint(x: 27, y: 27))
            crossPath.move(to: CGPoint(x: 27, y: 10))
            crossPath.addLine(to: CGPoint(x: 10, y: 27))

            UIColor.white.setStroke()
            crossPath.lineWidth = 3
            crossPath.lineCapStyle = .round
            crossPath.stroke()
        }
    }
}

// MARK: - UIViewController Extension

public extension UIViewController {

    /// Show HUD in view controller's view
    @discardableResult
    func showHUD(animated: Bool = true) -> LWHUD {
        return LWHUD.showHUD(addedTo: view, animated: animated)
    }

    /// Hide HUD in view controller's view
    @discardableResult
    func hideHUD(animated: Bool = true) -> Bool {
        return LWHUD.hideHUD(for: view, animated: animated)
    }

    /// Show activity indicator
    @discardableResult
    func showActivity(text: String? = nil) -> LWHUD {
        return LWHUD.showActivity(in: view, text: text)
    }

    /// Show success message
    @discardableResult
    func showSuccess(_ text: String, hideAfter delay: TimeInterval = 2.0) -> LWHUD {
        return LWHUD.showSuccess(text, in: view, hideAfter: delay)
    }

    /// Show error message
    @discardableResult
    func showError(_ text: String, hideAfter delay: TimeInterval = 2.0) -> LWHUD {
        return LWHUD.showError(text, in: view, hideAfter: delay)
    }

    /// Show text message
    @discardableResult
    func showText(_ text: String, detailText: String? = nil, hideAfter delay: TimeInterval = 2.0) -> LWHUD {
        return LWHUD.showText(text, in: view, detailText: detailText, hideAfter: delay)
    }

    /// Show progress
    @discardableResult
    func showProgress(_ progress: Float, text: String? = nil) -> LWHUD {
        return LWHUD.showProgress(progress, text: text, in: view)
    }
}

// MARK: - Window Extension

public extension UIWindow {

    /// Get the topmost view controller
    var topViewController: UIViewController? {
        var top = rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }

    /// Show HUD on window
    @discardableResult
    func showHUD(animated: Bool = true) -> LWHUD {
        return LWHUD.showHUD(addedTo: self, animated: animated)
    }

    /// Hide HUD on window
    @discardableResult
    func hideHUD(animated: Bool = true) -> Bool {
        return LWHUD.hideHUD(for: self, animated: animated)
    }
}

// MARK: - Global Convenience Functions

/// Show HUD on key window
@discardableResult
public func showHUD(animated: Bool = true) -> LWHUD? {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
        return nil
    }
    return LWHUD.showHUD(addedTo: window, animated: animated)
}

/// Hide HUD on key window
@discardableResult
public func hideHUD(animated: Bool = true) -> Bool {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
        return false
    }
    return LWHUD.hideHUD(for: window, animated: animated)
}

/// Show activity on key window
@discardableResult
public func showActivity(text: String? = nil) -> LWHUD? {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
        return nil
    }
    return LWHUD.showActivity(in: window, text: text)
}

/// Show success on key window
@discardableResult
public func showSuccess(_ text: String, hideAfter delay: TimeInterval = 2.0) -> LWHUD? {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
        return nil
    }
    return LWHUD.showSuccess(text, in: window, hideAfter: delay)
}

/// Show error on key window
@discardableResult
public func showError(_ text: String, hideAfter delay: TimeInterval = 2.0) -> LWHUD? {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
        return nil
    }
    return LWHUD.showError(text, in: window, hideAfter: delay)
}
