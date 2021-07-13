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
import SwarmCloudSDK
 
class VideoViewController: UIViewController, SWCP2pEngineDelegate {
    
    let HLS_LIVE_URL = "https://wowza.peer5.com/live/smil:bbb_abr.smil/chunklist_b591000.m3u8"
//    let HLS_VOD_URL = "https://video.dious.cc/20200707/g5EIwDkS/1000kb/hls/index.m3u8"
//    let HLS_VOD_URL = "https://cdn.theoplayer.com/video/elephants-dream/playlist.m3u8"
    let HLS_VOD_URL = "https://video.cdnbye.com/0cf6732evodtransgzp1257070836/e0d4b12e5285890803440736872/v.f100220.m3u8"
//    let MP4_URL_1 = "https://huya-w20.huya.com/2027/357649831/1300/e0a4cd303b58bab74f809be7f2d09113.mp4"
//    let MP4_URL_2 = "https://scdn.common.00cdn.com/p2p/cloud-1080p.mp4"
    
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
    var btnMp4_2: UIButton?
    var btnMp4_1: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerVC = AVPlayerViewController()
        SWCP2pEngine.sharedInstance().delegate = self
        self.view.addSubview(playerVC.view)
        playerVC.view.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMsg), name: Notification.Name(rawValue: kP2pEngineDidReceiveStatistics), object: nil)
        showStatisticsView()
        showButtonView()
    }
    
    @objc func didReceiveMsg(note:Notification) {
        let dict = note.object as! Dictionary<String, Any>
        print("didReceiveMsg \(dict)")
        if ((dict["httpDownloaded"]) != nil) {
            self.totalHttpDownloaded += dict["httpDownloaded"] as! Double/1024
        } else if ((dict["p2pDownloaded"]) != nil) {
            self.totalP2pDownloaded += dict["p2pDownloaded"] as! Double/1024
        } else if ((dict["p2pUploaded"]) != nil) {
            self.totalP2pUploaded += dict["p2pUploaded"] as! Double/1024
        } else if ((dict["peers"]) != nil) {
            self.peers = dict["peers"] as! Array<String>
        } else if ((dict["serverConnected"]) != nil) {
            self.serverConnected = dict["serverConnected"] as! Bool
        }
        DispatchQueue.main.async {
            self.updateStatistics()
        }
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
        
        let labelOffload = UILabel()
        labelOffload.layer.borderColor = UIColor.green.cgColor
        statsView.addSubview(labelOffload)
        self.labelOffload = labelOffload
        labelOffload.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelRatio = UILabel()
        labelRatio.layer.borderColor = UIColor.darkGray.cgColor
        statsView.addSubview(labelRatio)
        self.labelRatio = labelRatio
        labelRatio.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelUpload = UILabel()
        labelUpload.layer.borderColor = UIColor.blue.cgColor
        statsView.addSubview(labelUpload)
        self.labelUpload = labelUpload
        labelUpload.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(height+20)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelP2pEnabled = UILabel()
        labelP2pEnabled.layer.borderColor = UIColor.red.cgColor
        statsView.addSubview(labelP2pEnabled)
        self.labelP2pEnabled = labelP2pEnabled
        labelP2pEnabled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
            make.top.equalToSuperview().offset(height+20)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelPeers = UILabel()
        labelPeers.layer.borderColor = UIColor.purple.cgColor
        statsView.addSubview(labelPeers)
        self.labelPeers = labelPeers
        labelPeers.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(2*height+30)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelVersion = UILabel()
        labelVersion.layer.borderColor = UIColor.brown.cgColor
        labelVersion.text = "Version: \(SWCP2pEngine.engineVersion)"
        statsView.addSubview(labelVersion)
        self.labelVersion = labelVersion
        labelVersion.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
            make.top.equalToSuperview().offset(2*height+30)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
        
        let labelPeerId = UILabel()
        labelPeerId.layer.borderColor = UIColor.green.cgColor
        statsView.addSubview(labelPeerId)
        self.labelPeerId = labelPeerId
        labelPeerId.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(3*height+40)
            make.height.equalTo(height)
            make.width.equalTo(SCREEN_WIDTH-50)
        }
        
        for label in statsView.subviews {
            (label as! UILabel).textAlignment = .center
            label.layer.masksToBounds = true;
            label.layer.cornerRadius = 10;
            label.layer.borderWidth = 2;
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
        self.labelPeerId?.text = "Peer ID: \(SWCP2pEngine.sharedInstance().peerId)"
        self.labelP2pEnabled?.text = "Connected: \(self.serverConnected ? "Yes" : "No")"
    }
    
    func showButtonView() {
        let btnView = UIView()
        btnView.autoresizesSubviews = true
        self.view.addSubview(btnView)
        btnView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(510)
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
        
//        let btnMp4_1 = UIButton()
//        btnMp4_1.backgroundColor = .cyan
//        btnMp4_1.setTitle("MP4_1", for: .normal)
//        btnMp4_1.addTarget(self, action: #selector(btnMp4_1Click(button:)), for: .touchUpInside)
//        btnView.addSubview(btnMp4_1)
//        self.btnMp4_1 = btnMp4_1
//        btnMp4_1.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(10)
//            make.top.equalToSuperview().offset(height+10)
//            make.height.equalTo(height)
//            make.width.equalTo(width)
//        }
//
//        let btnMp4_2 = UIButton()
//        btnMp4_2.backgroundColor = .orange
//        btnMp4_2.setTitle("MP4_2", for: .normal)
//        btnMp4_2.addTarget(self, action: #selector(btnMp4_2Click(button:)), for: .touchUpInside)
//        btnView.addSubview(btnMp4_2)
//        self.btnMp4_2 = btnMp4_2
//        btnMp4_2.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(SCREEN_WIDTH-width-30)
//            make.top.equalToSuperview().offset(height+10)
//            make.height.equalTo(height)
//            make.width.equalTo(width)
//        }
        
        for btn in btnView.subviews {
            btn.layer.masksToBounds = true;
            btn.layer.cornerRadius = 10;
        }
    }
    
    @objc func btnHlsVodClick(button: UIButton) {
        startPlayWithUrl(url: URL(string: HLS_VOD_URL)!)
    }
    
    @objc func btnHlsLiveClick(button: UIButton) {
        startPlayWithUrl(url: URL(string: HLS_LIVE_URL)!)
    }
    
//    @objc func btnMp4_1Click(button: UIButton) {
//        startPlayWithUrl(url: URL(string: MP4_URL_1)!)
//    }
//
//    @objc func btnMp4_2Click(button: UIButton) {
//        startPlayWithUrl(url: URL(string: MP4_URL_2)!)
//    }
    
    func startPlayWithUrl(url: URL) {
        let proxyUrl = SWCP2pEngine.sharedInstance().parse(streamURL: url)
        self.playerVC.player = nil
        self.playerVC.player = AVPlayer(url: proxyUrl)
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
        SWCP2pEngine.sharedInstance().stopP2p()
    }
}
