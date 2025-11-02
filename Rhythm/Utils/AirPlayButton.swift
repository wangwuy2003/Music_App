//
//  AirPlayButton.swift
//  Rhythm
//
//  Created by Apple on 1/11/25.
//

import AVKit
import SwiftUI

struct AirPlayButton: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let view = AVRoutePickerView()
        view.activeTintColor = .accent
        view.tintColor = UIColor.white
        view.prioritizesVideoDevices = false
        return view
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}
