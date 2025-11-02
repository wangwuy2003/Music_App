//
//  SwipeBackHelper.swift
//  Rhythm
//
//  Created by Apple on 2/11/25.
//


import SwiftUI

extension View {
    func enableSwipeBack() -> some View {
        self.background(
            SwipeBackHelper()
        )
    }
}

private struct SwipeBackHelper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = controller.navigationController {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
                navigationController.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
