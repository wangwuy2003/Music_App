//
//  Album.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//
import Foundation

struct Album: Identifiable {
    let id = UUID().uuidString
    let title: String
    let imageName: [String]
    
    static let sampleData: [Album] = [
        Album(title: "Chill", imageName: ["image1", "image2", "image3", "image4", "image5", "image6"]),
        Album(title: "Party", imageName: ["image1", "image2", "image3", "image4", "image5", "image6"]),
        Album(title: "Study", imageName: ["image1", "image2", "image3", "image4", "image5", "image6"]),
        Album(title: "Pop", imageName: ["image1", "image2", "image3", "image4", "image5", "image6"]),
        Album(title: "Rock", imageName: ["image1", "image2", "image3", "image4", "image5", "image6"]),
        Album(title: "Indie", imageName: ["image1", "image2", "image3", "image4", "image5", "image6"])
    ]
}
