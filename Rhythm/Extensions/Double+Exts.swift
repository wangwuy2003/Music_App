//
//  Double+Exts.swift
//  Rhythm
//
//  Created by MacMini A6 on 20/10/25.
//


import Foundation

extension Double {
  func asStringInMinute(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
