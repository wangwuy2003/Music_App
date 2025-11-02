//
//  LottieView.swift
//  LocalTune
//
//  Created by Apple on 27/10/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    var fileName: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.play(toProgress: 1, loopMode: LottieLoopMode.repeat(10)) { isFinished in
            if isFinished {
                print("animation completed")
            } else {
                print("animation canceled")
            }
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
