//
//  LaunchViewController.swift
//  serveture
//
//  Created by Adam Herczeg on 2017. 02. 06..
//  Copyright © 2017. Haneke Design. All rights reserved.
//

import UIKit
import ServetureFramework

class LaunchViewController: LaunchBaseViewController {

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.checkIfLoggedIn()
	}
}

import UIKit
import AVKit
import ServetureFramework

class LaunchViewController: LaunchBaseViewController {

	private var didFinishPlaying = false

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
		playVideo()
	}

	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
		if !didFinishPlaying {
			checkIfLoggedIn()
		}
		super.viewWillDisappear(animated)
	}

	override func viewDidLayoutSubviews() {
		view.backgroundColor = Colors.splashColor
	}

	private func playVideo() {
		guard let path = Bundle.main.path(forResource: "shcweconnect_landing", ofType:"mp4") else {
			debugPrint("shcweconnect_landing.mp4 not found")
			didFinishPlaying = true
			checkIfLoggedIn()
			return
		}
		let player = AVPlayer(url: URL(fileURLWithPath: path))
		let playerLayer = AVPlayerLayer(player: player)
		playerLayer.frame = view.frame
		//playerLayer.videoGravity = .resizeAspectFill
		//playerLayer.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width * 0.8, height: view.frame.height * 0.8))
		//playerLayer.position = CGPoint(x: view.layer.bounds.midX, y: view.layer.bounds.midY)
		view.layer.addSublayer(playerLayer)
		let audioSession = AVAudioSession.sharedInstance()
		if audioSession.isOtherAudioPlaying {
			_ = try? audioSession.setCategory(.ambient, options: .mixWithOthers)
		}
		player.play()
	}

	@objc private func playerDidFinishPlaying() {
		didFinishPlaying = true
		checkIfLoggedIn()
	}
}
