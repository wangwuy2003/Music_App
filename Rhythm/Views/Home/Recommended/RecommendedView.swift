//
//  RecommendedView.swift
//  Rhythm
//
//  Created by MacMini A6 on 10/11/25.
//


//import SwiftUI
//import SDWebImageSwiftUI
//
//struct RecommendedView: View {
//    @ObservedObject var vm: RecommendedViewModel
//    let onSelect: (JamendoTrack) -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            if !vm.recommendedTracks.isEmpty {
//                Text("🎧 Recommended for You")
//                    .font(.headline)
//                    .foregroundStyle(.white)
//                    .padding(.horizontal)
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 15) {
//                        ForEach(vm.recommendedTracks) { track in
//                            VStack(alignment: .leading, spacing: 6) {
//                                WebImage(url: URL(string: track.image ?? track.albumImage ?? ""))
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 120, height: 120)
//                                    .cornerRadius(12)
//                                    .shadow(radius: 3)
//                                
//                                Text(track.name)
//                                    .font(.caption)
//                                    .foregroundStyle(.white)
//                                    .lineLimit(1)
//                                
//                                Text(track.artistName ?? "")
//                                    .font(.caption2)
//                                    .foregroundStyle(.gray)
//                                    .lineLimit(1)
//                            }
//                            .onTapGesture {
//                                onSelect(track)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//        }
//    }
//}
