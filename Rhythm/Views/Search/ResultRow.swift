//
//  ResultRow.swift
//  Rhythm
//
//  Created by Apple on 10/10/25.
//

import SwiftUI

enum SearchResult {
    case song(title: String, subtitle: String, duration: String, stat: String)
    case playlist(title: String, subtitle: String, tracks: Int)
    case artist(title: String, followers: String)
}

struct ResultRow: View {
    let result: SearchResult
    
    var body: some View {
        switch result {
        case let .song(title, subtitle, duration, stat):
            HStack(spacing: 12) {
                // thumbnail
                Image("coverImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(.rect(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).foregroundStyle(.white).font(.headline)
                    Text(subtitle).foregroundStyle(.white.opacity(0.7)).font(.subheadline)
                }
                Spacer()
                Button {
                    // play
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.accent)
                }
                .padding(.leading, 6)
                VStack(alignment: .trailing, spacing: 2) {
                    Text(duration).foregroundStyle(.white).font(.subheadline)
                    Text(stat).foregroundStyle(.white.opacity(0.6)).font(.caption)
                }
                
            }
            
        case let .playlist(title, subtitle, tracks):
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.08)))
                    .frame(width: 52, height: 52)
                    .overlay(Image("coverImage"))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).foregroundStyle(.white).font(.headline)
                    Text(subtitle).foregroundStyle(.white.opacity(0.7)).font(.subheadline)
                }
                Spacer()
                Text("\(tracks) tracks")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
        case let .artist(title, followers):
            HStack(spacing: 12) {
                Circle().fill(.white.opacity(0.2)).frame(width: 52, height: 52)
                    .overlay(Image(systemName: "person.fill"))
                Text(title).foregroundStyle(.white).font(.headline)
                
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    Text("\(followers) followers")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
    }
}
