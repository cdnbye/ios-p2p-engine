//
//  ContentView.swift
//  swiftui-demo
//
//  Created by timmy on 2024/11/27.
//

import SwiftUI
import AVKit
import AVFoundation
import SwarmCloudKit

class VideoViewModel : ObservableObject {
    @Published var urlString : String? {
        didSet {
            guard let urlString = urlString else {
                return
            }
            let proxiedUrl = P2pEngine.shared.parseStreamUrl(urlString)
            print("proxiedUrl \(proxiedUrl)")
            guard let url = URL(string: proxiedUrl) else {
                return
            }
            player = AVPlayer(url: url)
            player.seek(to: .zero)
            player.play()
        }
    }
    var player = AVPlayer()
}

struct ContentView: View {
    
    private var URL_VOD: String = "https://storage.googleapis.com/wvtemp/rkuroiwa/hls_single_segment/sintel_1080p_single_segment.m3u8"
    private var URL_Live: String = "https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/level_0.m3u8"
    
    @State private var isPlaying: Bool = false
    @State private var offload: Double = 0
    @State private var uploaded: Double = 0
    @State private var httpDownloaded: Double = 0
    @State private var serverConnected: Bool = false
    @State private var peers: Int = 0
    @State private var peerId: String = ""
    @State private var customUrl: String = ""
    
    @StateObject var viewModel = VideoViewModel()
    
    private var ratio: Double {
        if offload+httpDownloaded == 0.0 {
            return 0
        }
        return Double(offload/(httpDownloaded+offload))*100
    }
    
    private func play(_ urlStr: String) {
        viewModel.player.pause()
        clear()
        viewModel.urlString = urlStr
    }
    
    private func clear() {
        peerId = ""
        peers = 0
        offload = 0
        uploaded = 0
        serverConnected = false
        httpDownloaded = 0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                VideoPlayer(player: viewModel.player)
                    .onDisappear {
                        viewModel.player.pause()
                    }
                #if os(iOS)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                #elseif os(macOS)
                    .frame(width: NSScreen.main?.frame.width ?? 0, height: 200)
                #endif
                
                TextField(
                  "input custom m3u8..",
                  text: $customUrl,
                  onCommit: {
                      play(customUrl)
                  }
                ).background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 5).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 1)
                    ).textFieldStyle(.roundedBorder).lineLimit(2)
                
                HStack {
                    Text("Offload: \(String(format:"%.2f", offload))MB")
                        .labelStyle(.green)
                    
                    Spacer(minLength: 20)
                    Text("P2P Ration: \(String(format:"%.1f", ratio))")
                        .labelStyle(.brown)
                }
                
                HStack {
                    Text("Upload: \(String(format:"%.2f", uploaded))MB")
                        .labelStyle(.blue)
                    Spacer(minLength: 20)
                    Text("Connected: \(String(serverConnected))")
                        .labelStyle(.red)
                }
                
                HStack {
                    Text("Peers: \(peers)")
                        .labelStyle(.purple)
                    Spacer(minLength: 20)
                    Text("Version: \(P2pEngine.VERSION)")
                        .labelStyle(.pink)
                }
                
                Text("Peer ID: \(peerId)").frame(maxWidth: .infinity).labelStyle(.yellow)
                
                HStack {
                    Button("HLS_VOD") {
                        play(URL_VOD)
                    }.buttonStyle()
                    Spacer()
                    Button("HLS_LIVE") {
                        play(URL_Live)
                    }.buttonStyle()
                }.padding()
            }
            
        }.onAppear {
            startMonitoring()
        }
        
    }
    
    func startMonitoring() {
        let monitor = P2pStatisticsMonitor(queue: .main)
        monitor.onPeers = { peers in
            self.peers = peers.count
        }
        monitor.onP2pUploaded = { value in
            self.uploaded += Double(value)/1024
        }
        monitor.onP2pDownloaded = { value, speed in
            self.offload += Double(value)/1024
        }
        monitor.onHttpDownloaded = { value in
            self.httpDownloaded += Double(value)/1024
        }
        monitor.onServerConnected = { connected in
            self.serverConnected = connected
            if connected {
                peerId = P2pEngine.shared.peerId
            }
        }
        P2pEngine.shared.p2pStatisticsMonitor = monitor
    }
}

extension View {
    
    func labelStyle(_ borderColor: Color) -> some View {
        font(.custom("Arial", size: 18))
        .padding(10)
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    func buttonStyle() -> some View {
        padding().buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule).controlSize(.large)
    }
    
}



#Preview {
    ContentView()
}
