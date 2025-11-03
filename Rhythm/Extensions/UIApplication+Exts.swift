//
//  UIApplication+Exts.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
