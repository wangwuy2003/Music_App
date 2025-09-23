//
//  MusicGenres.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//
import Foundation
import SwiftUI

enum MusicGenres: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case pop
    case hiphopRap
    case rock
    case electronic
    case party
    case chill
    case workout
    case techno
    case atHome
    case study
    case folk
    case indie
    case soul
    case country
    case healing
    
    var name: String {
        switch self {
        case .pop:                  return .localized("Pop")
        case .hiphopRap:            return .localized("Hiphop & Rap")
        case .rock:                 return .localized("Rock")
        case .electronic:           return .localized("Electronic")
        case .party:                return .localized("Party")
        case .chill:                return .localized("Chill")
        case .workout:              return .localized("Workout")
        case .techno:               return .localized("Techno")
        case .atHome:               return .localized("At Home")
        case .study:                return .localized("Study")
        case .folk:                 return .localized("Folk")
        case .indie:                return .localized("Indie")
        case .soul:                 return .localized("Soul")
        case .country:              return .localized("Country")
        case .healing:              return .localized("Healing")
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .pop:
            return LinearGradient(colors: [.pink, .purple],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        case .hiphopRap:
            return LinearGradient(colors: [.black, .gray],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case .rock:
            return LinearGradient(colors: [.red, .orange],
                                  startPoint: .leading,
                                  endPoint: .trailing)
        case .electronic:
            return LinearGradient(colors: [.blue, .purple],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        case .party:
            return LinearGradient(colors: [.yellow, .pink],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case .chill:
            return LinearGradient(colors: [.mint, .cyan],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        case .workout:
            return LinearGradient(colors: [.orange, .red],
                                  startPoint: .leading,
                                  endPoint: .trailing)
        case .techno:
            return LinearGradient(colors: [.indigo, .black],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case .atHome:
            return LinearGradient(colors: [.teal, .blue],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        case .study:
            return LinearGradient(colors: [.purple, .blue],
                                  startPoint: .leading,
                                  endPoint: .trailing)
        case .folk:
            return LinearGradient(colors: [.green, .brown],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case .indie:
            return LinearGradient(colors: [.pink, .teal],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        case .soul:
            return LinearGradient(colors: [.purple, .indigo],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case .country:
            return LinearGradient(colors: [.brown, .orange],
                                  startPoint: .leading,
                                  endPoint: .trailing)
        case .healing:
            return LinearGradient(colors: [.mint, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        }
    }
}
