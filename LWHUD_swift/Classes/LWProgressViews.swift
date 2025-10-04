//
//  LWProgressViews.swift
//  LWHUD
//
//  Swift implementation of progress views
//

import UIKit

// MARK: - LWRoundProgressView

open class LWRoundProgressView: UIView, LWProgressView {

    // MARK: - Properties

    public var progress: Float = 0.0 {
        didSet {
            if progress != oldValue {
                setNeedsDisplay()
            }
        }
    }

    public var progressTintColor: UIColor = .white {
        didSet {
            if progressTintColor != oldValue {
                setNeedsDisplay()
            }
        }
    }

    public var backgroundTintColor: UIColor = UIColor(white: 1.0, alpha: 0.1) {
        didSet {
            if backgroundTintColor != oldValue {
                setNeedsDisplay()
            }
        }
    }

    public var isAnnular: Bool = false {
        didSet {
            if isAnnular != oldValue {
                setNeedsDisplay()
            }
        }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
    }

    private func commonInit() {
        backgroundColor = .clear
        isOpaque = false
    }

    // MARK: - Layout

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 37, height: 37)
    }

    // MARK: - Drawing

    open override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let lineWidth: CGFloat = isAnnular ? 2.0 : 2.0
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (bounds.width - lineWidth) / 2
        let startAngle = -CGFloat.pi / 2

        if isAnnular {
            // Draw background
            let processBackgroundPath = UIBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .butt
            let endAngle = 2 * CGFloat.pi + startAngle
            processBackgroundPath.addArc(withCenter: center, radius: radius,
                                        startAngle: startAngle, endAngle: endAngle, clockwise: true)
            backgroundTintColor.set()
            processBackgroundPath.stroke()

            // Draw progress
            let processPath = UIBezierPath()
            processPath.lineCapStyle = .square
            processPath.lineWidth = lineWidth
            let progressEndAngle = CGFloat(progress) * 2 * CGFloat.pi + startAngle
            processPath.addArc(withCenter: center, radius: radius,
                              startAngle: startAngle, endAngle: progressEndAngle, clockwise: true)
            progressTintColor.set()
            processPath.stroke()
        } else {
            // Draw background
            let circleRect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
            progressTintColor.setStroke()
            backgroundTintColor.setFill()
            context.setLineWidth(lineWidth)
            context.strokeEllipse(in: circleRect)

            // Draw progress
            let processPath = UIBezierPath()
            processPath.lineCapStyle = .butt
            processPath.lineWidth = lineWidth * 2
            let processRadius = (bounds.width / 2) - (processPath.lineWidth / 2)
            let progressEndAngle = CGFloat(progress) * 2 * CGFloat.pi + startAngle
            processPath.addArc(withCenter: center, radius: processRadius,
                              startAngle: startAngle, endAngle: progressEndAngle, clockwise: true)
            context.setBlendMode(.copy)
            progressTintColor.set()
            processPath.stroke()
        }
    }
}

// MARK: - LWBarProgressView

open class LWBarProgressView: UIView, LWProgressView {

    // MARK: - Properties

    public var progress: Float = 0.0 {
        didSet {
            if progress != oldValue {
                setNeedsDisplay()
            }
        }
    }

    public var lineColor: UIColor = .white {
        didSet {
            if lineColor != oldValue {
                setNeedsDisplay()
            }
        }
    }

    public var progressRemainingColor: UIColor = .clear {
        didSet {
            if progressRemainingColor != oldValue {
                setNeedsDisplay()
            }
        }
    }

    public var progressColor: UIColor = .white {
        didSet {
            if progressColor != oldValue {
                setNeedsDisplay()
            }
        }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    }

    private func commonInit() {
        backgroundColor = .clear
        isOpaque = false
    }

    // MARK: - Layout

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 120, height: 10)
    }

    // MARK: - Drawing

    open override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(2)
        context.setStrokeColor(lineColor.cgColor)
        context.setFillColor(progressRemainingColor.cgColor)

        // Draw background and border
        let radius = (rect.height / 2) - 2

        context.move(to: CGPoint(x: 2, y: rect.height / 2))
        context.addArc(tangent1End: CGPoint(x: 2, y: 2),
                      tangent2End: CGPoint(x: radius + 2, y: 2), radius: radius)
        context.addArc(tangent1End: CGPoint(x: rect.width - 2, y: 2),
                      tangent2End: CGPoint(x: rect.width - 2, y: rect.height / 2), radius: radius)
        context.addArc(tangent1End: CGPoint(x: rect.width - 2, y: rect.height - 2),
                      tangent2End: CGPoint(x: rect.width - radius - 2, y: rect.height - 2), radius: radius)
        context.addArc(tangent1End: CGPoint(x: 2, y: rect.height - 2),
                      tangent2End: CGPoint(x: 2, y: rect.height / 2), radius: radius)
        context.drawPath(using: .fillStroke)

        context.setFillColor(progressColor.cgColor)
        let progressRadius = radius - 2
        let amount = CGFloat(progress) * rect.width

        // Progress in the middle area
        if amount >= progressRadius + 4 && amount <= (rect.width - progressRadius - 4) {
            context.move(to: CGPoint(x: 4, y: rect.height / 2))
            context.addArc(tangent1End: CGPoint(x: 4, y: 4),
                          tangent2End: CGPoint(x: progressRadius + 4, y: 4), radius: progressRadius)
            context.addLine(to: CGPoint(x: amount, y: 4))
            context.addLine(to: CGPoint(x: amount, y: progressRadius + 4))

            context.move(to: CGPoint(x: 4, y: rect.height / 2))
            context.addArc(tangent1End: CGPoint(x: 4, y: rect.height - 4),
                          tangent2End: CGPoint(x: progressRadius + 4, y: rect.height - 4), radius: progressRadius)
            context.addLine(to: CGPoint(x: amount, y: rect.height - 4))
            context.addLine(to: CGPoint(x: amount, y: progressRadius + 4))

            context.fillPath()
        }
        // Progress in the right arc
        else if amount > progressRadius + 4 {
            let x = amount - (rect.width - progressRadius - 4)

            context.move(to: CGPoint(x: 4, y: rect.height / 2))
            context.addArc(tangent1End: CGPoint(x: 4, y: 4),
                          tangent2End: CGPoint(x: progressRadius + 4, y: 4), radius: progressRadius)
            context.addLine(to: CGPoint(x: rect.width - progressRadius - 4, y: 4))
            var angle = -acos(x / progressRadius)
            if angle.isNaN { angle = 0 }
            context.addArc(center: CGPoint(x: rect.width - progressRadius - 4, y: rect.height / 2),
                          radius: progressRadius, startAngle: .pi, endAngle: angle, clockwise: false)
            context.addLine(to: CGPoint(x: amount, y: rect.height / 2))

            context.move(to: CGPoint(x: 4, y: rect.height / 2))
            context.addArc(tangent1End: CGPoint(x: 4, y: rect.height - 4),
                          tangent2End: CGPoint(x: progressRadius + 4, y: rect.height - 4), radius: progressRadius)
            context.addLine(to: CGPoint(x: rect.width - progressRadius - 4, y: rect.height - 4))
            angle = acos(x / progressRadius)
            if angle.isNaN { angle = 0 }
            context.addArc(center: CGPoint(x: rect.width - progressRadius - 4, y: rect.height / 2),
                          radius: progressRadius, startAngle: -.pi, endAngle: angle, clockwise: true)
            context.addLine(to: CGPoint(x: amount, y: rect.height / 2))

            context.fillPath()
        }
        // Progress is in the left arc
        else if amount < progressRadius + 4 && amount > 0 {
            context.move(to: CGPoint(x: 4, y: rect.height / 2))
            context.addArc(tangent1End: CGPoint(x: 4, y: 4),
                          tangent2End: CGPoint(x: progressRadius + 4, y: 4), radius: progressRadius)
            context.addLine(to: CGPoint(x: progressRadius + 4, y: rect.height / 2))

            context.move(to: CGPoint(x: 4, y: rect.height / 2))
            context.addArc(tangent1End: CGPoint(x: 4, y: rect.height - 4),
                          tangent2End: CGPoint(x: progressRadius + 4, y: rect.height - 4), radius: progressRadius)
            context.addLine(to: CGPoint(x: progressRadius + 4, y: rect.height / 2))

            context.fillPath()
        }
    }
}
