//
//  MenuViewController.swift
//  iOS_demo
//
//  Created by Timmy on 2021/7/2.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation
import AVKit
import SwarmCloudKit
 
class VideoViewController: UIViewController, UITextFieldDelegate {
    
    let HLS_LIVE_URL = "https://stream.swarmcloud.net:2096/hls/sintel/playlist.m3u8"
    let HLS_VOD_URL = "https://video.cdnbye.com/0cf6732evodtransgzp1257070836/e0d4b12e5285890803440736872/v.f100220.m3u8"
    
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    
    var playerVC = AVPlayerViewController()
    var labelOffload: UILabel?
    var labelRatio: UILabel?
    var labelUpload: UILabel?
    var labelP2pEnabled: UILabel?
    var labelPeers: UILabel?
    var labelVersion: UILabel?
    var labelPeerId: UILabel?
    
    var totalHttpDownloaded: Double = 0
    var totalP2pDownloaded: Double = 0
    var totalP2pUploaded: Double = 0
    var serverConnected: Bool = false
    var peers = [String]()
    
    var btnHlsVod: UIButton?
    var btnHlsLive: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerVC = AVPlayerViewController()
        P2pEngine.shared.playerInteractor = self
        P2pEngine.shared.hlsInterceptor = self
        self.view.addSubview(playerVC.view)
        playerVC.view.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
        
        showStatisticsView()
        showButtonView()
        startMonitoring()
    }
    
    @objc func startMonitoring() {
        let monitor = P2pStatisticsMonitor()
        monitor.onPeers = { peers in
            self.peers = peers
            self.updateStatistics()
        }
        monitor.onP2pUploaded = { value in
            self.totalP2pUploaded += Double(value)/1024
            self.updateStatistics()
        }
        monitor.onP2pDownloaded = { value, speed in
            self.totalP2pDownloaded += Double(value)/1024
            self.updateStatistics()
        }
        monitor.onHttpDownloaded = { value in
            self.totalHttpDownloaded += Double(value)/1024
            self.updateStatistics()
        }
        monitor.onServerConnected = { connected in
            self.serverConnected = connected
            self.updateStatistics()
        }
        P2pEngine.shared.p2pStatisticsMonitor = monitor
    }
    
    func showStatisticsView() {
        let statsView = UIView()
        statsView.autoresizesSubviews = true
        self.view.addSubview(statsView)
        statsView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(300)
            make.height.equalToSuperview().offset(300)
            make.width.equalToSuperview()
        }
        
        let width = SCREEN_WIDTH/2-30;
        let height = 40
        
        let textField = UITextField()
        statsView.addSubview(textField)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder="input custom m3u8..."
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(height)
            make.width.equalTo(SCREEN_WIDTH-50)
        }
        
        let labelOffload = UILabel()
        labelOffload.layer.borderColor = UIColor.green.cgColor
        statsView.addSubview(labelOffload)
        self.labelOffload = labelOffload
        labelOffload.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(height+20)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelRatio = UILabel()
        labelRatio.layer.borderColor = UIColor.darkGray.cgColor
        statsView.addSubview(labelRatio)
        self.labelRatio = labelRatio
        labelRatio.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
            make.top.equalToSuperview().offset(height+20)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelUpload = UILabel()
        labelUpload.layer.borderColor = UIColor.blue.cgColor
        statsView.addSubview(labelUpload)
        self.labelUpload = labelUpload
        labelUpload.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(2*height+30)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelP2pEnabled = UILabel()
        labelP2pEnabled.layer.borderColor = UIColor.red.cgColor
        statsView.addSubview(labelP2pEnabled)
        self.labelP2pEnabled = labelP2pEnabled
        labelP2pEnabled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
            make.top.equalToSuperview().offset(2*height+30)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelPeers = UILabel()
        labelPeers.layer.borderColor = UIColor.purple.cgColor
        statsView.addSubview(labelPeers)
        self.labelPeers = labelPeers
        labelPeers.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(3*height+40)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelVersion = UILabel()
        labelVersion.layer.borderColor = UIColor.brown.cgColor
        labelVersion.text = "Version: \(P2pEngine.VERSION)"
        statsView.addSubview(labelVersion)
        self.labelVersion = labelVersion
        labelVersion.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
            make.top.equalToSuperview().offset(3*height+40)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelPeerId = UILabel()
        labelPeerId.layer.borderColor = UIColor.green.cgColor
        statsView.addSubview(labelPeerId)
        self.labelPeerId = labelPeerId
        labelPeerId.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(4*height+50)
            make.height.equalTo(height)
            make.width.equalTo(SCREEN_WIDTH-50)
        }
        
        for label in statsView.subviews {
            if ((label as? UILabel) != nil) {
                (label as! UILabel).textAlignment = .center
                label.layer.masksToBounds = true;
                label.layer.cornerRadius = 10;
                label.layer.borderWidth = 2;
            }
            
        }
        
        updateStatistics()
    }
 
    func updateStatistics() {
        var ratio: Double = 0
        if ((self.totalHttpDownloaded + self.totalP2pDownloaded) != 0) {
            ratio = self.totalP2pDownloaded/(self.totalP2pDownloaded+self.totalHttpDownloaded);
        }
        self.labelOffload?.text = "Offload: \(String(format:"%.2f", self.totalP2pDownloaded))MB"
        self.labelUpload?.text = "Upload: \(String(format:"%.2f", self.totalP2pUploaded))MB"
        self.labelRatio?.text = "P2P Ratio: \(String(format:"%.0f", ratio*100))%"
        self.labelPeers?.text = "Peers: \(self.peers.count)"
        self.labelPeerId?.text = "Peer ID: \(P2pEngine.shared.peerId)"
        self.labelP2pEnabled?.text = "Connected: \(self.serverConnected ? "Yes" : "No")"
    }
    
    func showButtonView() {
        let btnView = UIView()
        btnView.autoresizesSubviews = true
        self.view.addSubview(btnView)
        btnView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(560)
            make.height.equalToSuperview().offset(100)
            make.width.equalToSuperview().offset(SCREEN_WIDTH)
        }
        
        let height: CGFloat = 40;
        let width: CGFloat = SCREEN_WIDTH/2-30;
        
        let btnHlsVod = UIButton()
        btnHlsVod.backgroundColor = .green
        btnHlsVod.setTitle("HLS_VOD", for: .normal)
        btnHlsVod.addTarget(self, action: #selector(btnHlsVodClick(button:)), for: .touchUpInside)
        btnView.addSubview(btnHlsVod)
        self.btnHlsVod = btnHlsVod
        btnHlsVod.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let btnHlsLive = UIButton()
        btnHlsLive.backgroundColor = .purple
        btnHlsLive.setTitle("HLS_LIVE", for: .normal)
        btnHlsLive.addTarget(self, action: #selector(btnHlsLiveClick(button:)), for: .touchUpInside)
        btnView.addSubview(btnHlsLive)
        self.btnHlsLive = btnHlsLive
        btnHlsLive.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        for btn in btnView.subviews {
            btn.layer.masksToBounds = true;
            btn.layer.cornerRadius = 10;
        }
        
    }
    
    @objc func btnHlsVodClick(button: UIButton) {
        startPlayWithUrl(url: HLS_VOD_URL)
    }
    
    @objc func btnHlsLiveClick(button: UIButton) {
        startPlayWithUrl(url: HLS_LIVE_URL)
    }
    
    func startPlayWithUrl(url: String) {
        let proxyUrl = P2pEngine.shared.parseStreamUrl(url)
        self.playerVC.player?.pause()
        self.playerVC.player = nil
        self.playerVC.player = AVPlayer(url: URL(string: proxyUrl)!)
        self.playerVC.player?.play()
        
        clearData()
        updateStatistics()
    }
    
    func clearData() {
        self.totalHttpDownloaded = 0
        self.totalP2pDownloaded = 0
        self.totalP2pUploaded = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        self.playerVC.player?.pause()
        self.playerVC.player = nil
        P2pEngine.shared.stopP2p()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text != nil && textField.text?.isEmpty != true) {
            startPlayWithUrl(url: textField.text!)
        }
            return true
    }

}

extension VideoViewController: PlayerInteractor {
    
    func onCurrentPosition() -> TimeInterval {
        return CMTimeGetSeconds(self.playerVC.player!.currentTime())
    }
    
    func onBufferedDuration() -> TimeInterval {
        let currentTime = CMTimeGetSeconds(self.playerVC.player!.currentTime())
        var bufferedDuration: Double = 0.0
        let timeRanges = self.playerVC.player!.currentItem!.loadedTimeRanges
        for value in timeRanges {
            let timeRange = value.timeRangeValue
            let start = CMTimeGetSeconds(timeRange.start)
            let end = start + CMTimeGetSeconds(timeRange.duration);
            if (currentTime >= start && currentTime <= end) {
                bufferedDuration = end - currentTime;
                break;
            }
        }
        return bufferedDuration;
    }
    
}

extension VideoViewController: HlsInterceptor {
    
    func shouldBypassSegment(url: String) -> Bool {
        return false
    }
    
    func interceptPlaylist(data: Data, url: String) -> Data {
        return data
    }
    
    func isMediaSegment(url: String) -> Bool {
        return false
    }
    
}
