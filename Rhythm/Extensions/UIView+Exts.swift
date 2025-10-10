//
//  UIView+Extts.swift
//  Rhythm
//
//  Created by Apple on 10/10/25.
//

import UIKit

extension UIView {
    func allSubviews() -> [UIView] {
        return subviews + subviews.flatMap { $0.allSubviews() }
    }
}

func findSearchBar() -> UISearchBar? {
    // Lấy UIWindow hiện tại
    let keyWindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }

    // Duyệt view hierarchy để tìm UISearchBar
    return keyWindow?.allSubviews().compactMap { $0 as? UISearchBar }.first
}
