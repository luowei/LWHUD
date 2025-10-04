//
//  LWHUDSwiftUI.swift
//  LWHUD
//
//  SwiftUI integration for LWHUD
//

import SwiftUI
import UIKit

// MARK: - SwiftUI View Modifier

@available(iOS 13.0, *)
public extension View {
    /// Shows a HUD over this view
    func lwHUD(isPresented: Binding<Bool>,
               mode: LWHUDMode = .indeterminate,
               text: String? = nil,
               detailText: String? = nil,
               progress: Float = 0.0) -> some View {
        self.modifier(LWHUDViewModifier(isPresented: isPresented,
                                        mode: mode,
                                        text: text,
                                        detailText: detailText,
                                        progress: progress))
    }
}

@available(iOS 13.0, *)
private struct LWHUDViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let mode: LWHUDMode
    let text: String?
    let detailText: String?
    let progress: Float

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                LWHUDRepresentable(mode: mode,
                                  text: text,
                                  detailText: detailText,
                                  progress: progress,
                                  isPresented: $isPresented)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

// MARK: - UIViewRepresentable

@available(iOS 13.0, *)
struct LWHUDRepresentable: UIViewRepresentable {
    let mode: LWHUDMode
    let text: String?
    let detailText: String?
    let progress: Float
    @Binding var isPresented: Bool

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Find or create HUD
        let hud: LWHUD
        if let existingHUD = LWHUD.hud(for: uiView) {
            hud = existingHUD
        } else {
            hud = LWHUD(view: uiView)
            hud.removeFromSuperViewOnHide = true
            uiView.addSubview(hud)
        }

        // Configure HUD
        hud.mode = mode
        hud.label.text = text
        hud.detailsLabel.text = detailText
        hud.progress = progress

        // Show or hide
        if isPresented {
            hud.show(animated: true)
        } else {
            hud.hide(animated: true)
        }
    }
}

// MARK: - SwiftUI Native Views

@available(iOS 13.0, *)
public struct LWProgressIndicatorView: View {
    let progress: Double
    let style: ProgressStyle

    public enum ProgressStyle {
        case circular
        case annular
        case bar
    }

    public init(progress: Double, style: ProgressStyle = .circular) {
        self.progress = progress
        self.style = style
    }

    public var body: some View {
        GeometryReader { geometry in
            switch style {
            case .circular:
                CircularProgressView(progress: progress)
            case .annular:
                AnnularProgressView(progress: progress)
            case .bar:
                BarProgressView(progress: progress)
            }
        }
    }
}

@available(iOS 13.0, *)
struct CircularProgressView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 2)

            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

@available(iOS 13.0, *)
struct AnnularProgressView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 2)

            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .square))
                .rotationEffect(.degrees(-90))
        }
    }
}

@available(iOS 13.0, *)
struct BarProgressView: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .stroke(Color.white, lineWidth: 2)
                    .background(Color.clear)

                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(Color.white)
                    .frame(width: geometry.size.width * CGFloat(progress))
                    .padding(2)
            }
        }
    }
}

// MARK: - SwiftUI HUD View

@available(iOS 13.0, *)
public struct LWHUDView: View {
    let mode: LWHUDMode
    let text: String?
    let detailText: String?
    let progress: Float

    public init(mode: LWHUDMode = .indeterminate,
                text: String? = nil,
                detailText: String? = nil,
                progress: Float = 0.0) {
        self.mode = mode
        self.text = text
        self.detailText = detailText
        self.progress = progress
    }

    public var body: some View {
        VStack(spacing: 12) {
            indicatorView

            if let text = text {
                Text(text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }

            if let detailText = detailText {
                Text(detailText)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.8))
                .blur(radius: 10)
        )
    }

    @ViewBuilder
    private var indicatorView: some View {
        switch mode {
        case .indeterminate:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)

        case .determinate:
            LWProgressIndicatorView(progress: Double(progress), style: .circular)
                .frame(width: 37, height: 37)

        case .annularDeterminate:
            LWProgressIndicatorView(progress: Double(progress), style: .annular)
                .frame(width: 37, height: 37)

        case .determinateHorizontalBar:
            LWProgressIndicatorView(progress: Double(progress), style: .bar)
                .frame(width: 120, height: 10)

        case .text:
            EmptyView()

        case .customView:
            EmptyView()
        }
    }
}

// MARK: - SwiftUI Environment Key

@available(iOS 13.0, *)
struct HUDKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

@available(iOS 13.0, *)
public extension EnvironmentValues {
    var showHUD: Binding<Bool> {
        get { self[HUDKey.self] }
        set { self[HUDKey.self] = newValue }
    }
}

// MARK: - Preview Support

@available(iOS 13.0, *)
struct LWHUDView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LWHUDView(mode: .indeterminate, text: "Loading...", detailText: "Please wait")
                .previewDisplayName("Indeterminate")

            LWHUDView(mode: .determinate, text: "Loading...", progress: 0.5)
                .previewDisplayName("Determinate")

            LWHUDView(mode: .annularDeterminate, text: "Loading...", progress: 0.75)
                .previewDisplayName("Annular")

            LWHUDView(mode: .text, text: "Success!", detailText: "Operation completed")
                .previewDisplayName("Text Only")
        }
        .padding()
        .background(Color.blue)
    }
}
