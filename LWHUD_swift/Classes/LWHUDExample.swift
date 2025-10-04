//
//  LWHUDExample.swift
//  LWHUD
//
//  Example usage of LWHUD in Swift
//

import UIKit
import SwiftUI

// MARK: - UIKit Examples

class LWHUDExampleViewController: UIViewController {

    func examples() {
        // MARK: Basic Usage

        // Show simple activity indicator
        let hud = LWHUD.showHUD(addedTo: view, animated: true)
        hud.label.text = "Loading..."

        // Hide after work is done
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            LWHUD.hideHUD(for: self.view, animated: true)
        }

        // MARK: Convenience Methods

        // Show activity with text
        showActivity(text: "Loading...")

        // Show success message
        showSuccess("Operation completed!")

        // Show error message
        showError("Something went wrong")

        // Show text only
        showText("Hello, World!", detailText: "This is a detail message")

        // MARK: Progress Indicator

        // Show determinate progress
        let progressHUD = LWHUD.showProgress(0.0, text: "Downloading...", in: view)

        // Update progress
        var progress: Float = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.05
            progressHUD.updateProgress(progress, text: "Downloading \(Int(progress * 100))%")

            if progress >= 1.0 {
                timer.invalidate()
                progressHUD.hide(animated: true)
            }
        }

        // MARK: Different Modes

        // Indeterminate (default spinning indicator)
        let indeterminateHUD = LWHUD.showHUD(addedTo: view, animated: true)
        indeterminateHUD.mode = .indeterminate
        indeterminateHUD.label.text = "Loading..."

        // Determinate (circular progress)
        let determinateHUD = LWHUD.showHUD(addedTo: view, animated: true)
        determinateHUD.mode = .determinate
        determinateHUD.progress = 0.5
        determinateHUD.label.text = "50%"

        // Annular determinate (ring progress)
        let annularHUD = LWHUD.showHUD(addedTo: view, animated: true)
        annularHUD.mode = .annularDeterminate
        annularHUD.progress = 0.75

        // Horizontal bar
        let barHUD = LWHUD.showHUD(addedTo: view, animated: true)
        barHUD.mode = .determinateHorizontalBar
        barHUD.progress = 0.3

        // Custom view
        let customHUD = LWHUD.showHUD(addedTo: view, animated: true)
        customHUD.mode = .customView
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        imageView.tintColor = .white
        customHUD.customView = imageView

        // Text only
        let textHUD = LWHUD.showHUD(addedTo: view, animated: true)
        textHUD.mode = .text
        textHUD.label.text = "Success!"
        textHUD.detailsLabel.text = "Operation completed"

        // MARK: Customization

        let customizedHUD = LWHUD.showHUD(addedTo: view, animated: true)
        customizedHUD.label.text = "Custom HUD"

        // Change colors
        customizedHUD.contentColor = .systemBlue

        // Change background
        customizedHUD.bezelView.style = .blur
        customizedHUD.bezelView.blurEffectStyle = .dark
        customizedHUD.bezelView.color = UIColor.black.withAlphaComponent(0.8)

        // Adjust offset
        customizedHUD.offset = CGPoint(x: 0, y: -100)

        // Set minimum size
        customizedHUD.minSize = CGSize(width: 150, height: 150)

        // Make square
        customizedHUD.isSquare = true

        // Change animation type
        customizedHUD.animationType = .zoomIn

        // MARK: Grace Time and Minimum Show Time

        let timedHUD = LWHUD.showHUD(addedTo: view, animated: true)
        timedHUD.graceTime = 0.5  // Don't show if task completes within 0.5s
        timedHUD.minShowTime = 1.0  // Show for at least 1 second

        // MARK: With NSProgress

        let progress = Progress(totalUnitCount: 100)
        let progressHUD2 = LWHUD.showHUD(addedTo: view, animated: true)
        progressHUD2.mode = .determinate
        progressHUD2.progressObject = progress

        // Update progress
        DispatchQueue.global().async {
            for i in 0...100 {
                Thread.sleep(forTimeInterval: 0.05)
                progress.completedUnitCount = Int64(i)
            }
            DispatchQueue.main.async {
                progressHUD2.hide(animated: true)
            }
        }

        // MARK: Completion Block

        let completionHUD = LWHUD.showHUD(addedTo: view, animated: true)
        completionHUD.completionBlock = {
            print("HUD was hidden")
        }
        completionHUD.hide(animated: true, afterDelay: 2.0)

        // MARK: Delegate

        class HUDDelegate: NSObject, LWHUDDelegate {
            func hudWasHidden(_ hud: LWHUD) {
                print("HUD was hidden via delegate")
            }
        }

        let delegateHUD = LWHUD.showHUD(addedTo: view, animated: true)
        delegateHUD.delegate = HUDDelegate()

        // MARK: Button

        let buttonHUD = LWHUD.showHUD(addedTo: view, animated: true)
        buttonHUD.label.text = "Processing..."
        buttonHUD.button.setTitle("Cancel", for: .normal)
        buttonHUD.button.addTarget(self, action: #selector(cancelOperation), for: .touchUpInside)
    }

    @objc func cancelOperation() {
        print("Operation cancelled")
        hideHUD()
    }
}

// MARK: - SwiftUI Examples

@available(iOS 13.0, *)
struct LWHUDExampleView: View {

    @State private var showHUD = false
    @State private var showProgress = false
    @State private var progress: Float = 0.0

    var body: some View {
        VStack(spacing: 20) {
            Button("Show Activity HUD") {
                showHUD = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showHUD = false
                }
            }

            Button("Show Progress HUD") {
                showProgress = true
                progress = 0.0
                simulateProgress()
            }

            Button("Show Native SwiftUI HUD") {
                // Use native SwiftUI HUD view
            }
        }
        .lwHUD(isPresented: $showHUD,
               mode: .indeterminate,
               text: "Loading...",
               detailText: "Please wait")
        .lwHUD(isPresented: $showProgress,
               mode: .determinate,
               text: "Downloading",
               progress: progress)
    }

    func simulateProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.05
            if progress >= 1.0 {
                timer.invalidate()
                showProgress = false
            }
        }
    }
}

// MARK: - SwiftUI Native HUD Examples

@available(iOS 13.0, *)
struct LWHUDSwiftUIExampleView: View {

    @State private var showHUD = false

    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Button("Show HUD") {
                    showHUD.toggle()
                }
                .buttonStyle(.bordered)
            }

            if showHUD {
                LWHUDView(mode: .indeterminate,
                         text: "Loading...",
                         detailText: "Please wait")
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut, value: showHUD)
    }
}

// MARK: - Preview

@available(iOS 13.0, *)
struct LWHUDExampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LWHUDExampleView()
                .previewDisplayName("UIKit Integration")

            LWHUDSwiftUIExampleView()
                .previewDisplayName("Native SwiftUI")
        }
    }
}
