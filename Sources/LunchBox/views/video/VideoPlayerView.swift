//
//  VideoPlayerView.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import AVKit
import SwiftUI

@available(iOS 16.0, *)
struct CabinitVideoScreen: View {
    let url: URL
    var currentTime: CMTime? = nil
    
    @State var avPlayer: AVPlayer? = nil
    @State var videoPlaying = false

    var body: some View {
        _ = try? AVAudioSession.sharedInstance().setCategory(
            .playback, mode: .default, options: []
        )
        return ZStack {
                if let avp = avPlayer {
                    VideoPlayer(player: avp).full().ignoresSafeArea()
                        .onDisappear {
                            avPlayer?.replaceCurrentItem(with: nil)
                            avPlayer = nil
                        }
                } else {
                    Spacer()
                        .onAppear {
                            let avp = AVPlayer(url: url)
                            if let currentTime = currentTime, currentTime.value > 0 {
                                print("seeking to time: \(currentTime.value)")
                                avp.seek(to: currentTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                            }
                            avPlayer = avp
                            avPlayer?.play()
                        }
                }
        }.ignoresSafeArea()
    }
}
