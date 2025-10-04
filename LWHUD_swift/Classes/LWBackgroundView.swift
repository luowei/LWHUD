//
//  LWBackgroundView.swift
//  LWHUD
//
//  Swift implementation of background view
//

import UIKit

open class LWBackgroundView: UIView {

    // MARK: - Properties

    public var style: LWHUDBackgroundStyle = .blur {
        didSet {
            if style != oldValue {
                updateForBackgroundStyle()
            }
        }
    }

    public var blurEffectStyle: UIBlurEffect.Style = .light {
        didSet {
            if blurEffectStyle != oldValue {
                updateForBackgroundStyle()
            }
        }
    }

    public var color: UIColor = UIColor(white: 0.8, alpha: 0.6) {
        didSet {
            if color != oldValue {
                updateViews(for: color)
            }
        }
    }

    // MARK: - Private Properties

    private var effectView: UIVisualEffectView?
    private var toolbar: UIToolbar?

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        style = .blur
        blurEffectStyle = .light
        color = UIColor(white: 0.8, alpha: 0.6)
        clipsToBounds = true
        updateForBackgroundStyle()
    }

    // MARK: - Layout

    open override var intrinsicContentSize: CGSize {
        return .zero
    }

    // MARK: - Private Methods

    private func updateForBackgroundStyle() {
        if style == .blur {
            let effect = UIBlurEffect(style: blurEffectStyle)
            let newEffectView = UIVisualEffectView(effect: effect)
            newEffectView.frame = bounds
            newEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(newEffectView)
            backgroundColor = color
            layer.allowsGroupOpacity = false
            effectView = newEffectView

            toolbar?.removeFromSuperview()
            toolbar = nil
        } else {
            effectView?.removeFromSuperview()
            effectView = nil
            toolbar?.removeFromSuperview()
            toolbar = nil
            backgroundColor = color
        }
    }

    private func updateViews(for color: UIColor) {
        if style == .blur {
            backgroundColor = color
        } else {
            backgroundColor = color
        }
    }
}

// MARK: - LWHUDRoundedButton

class LWHUDRoundedButton: UIButton {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.0
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.borderWidth = 1.0
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = ceil(bounds.height / 2)
    }

    override var intrinsicContentSize: CGSize {
        if allControlEvents.isEmpty {
            return .zero
        }
        var size = super.intrinsicContentSize
        size.width += 20
        return size
    }

    // MARK: - Appearance

    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        isHighlighted = isHighlighted
        layer.borderColor = color?.cgColor
    }

    override var isHighlighted: Bool {
        didSet {
            let baseColor = titleColor(for: .selected)
            backgroundColor = isHighlighted ? baseColor?.withAlphaComponent(0.1) : .clear
        }
    }
}
