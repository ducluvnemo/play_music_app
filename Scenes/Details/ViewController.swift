//
//  ViewController.swift
//  ios_tutorial
//
//  Created by Nguyen Duc on 14/07/2025.
//
import UIKit
import AVFoundation
import MediaPlayer
import CoreData

final class ViewController: UIViewController {
    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    
    private var player: AVAudioPlayer?
    private var songs = [CoreDataSong]()
    private var currentIndex = 0
    private var isPlaying = true

    private var playerProgressUpdateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup after loading the view.
//        songs = CoreDataManager.shared.getPlaylist()
        configure()
    }
    
    private func configure() {
        guard !songs.isEmpty, currentIndex >= 0, currentIndex < songs.count else {
            print("Invalid songs data or currentIndex")
            return
        }
        
        guard isViewLoaded else {
            print("View not loaded yet")
            return
        }
        
        stopProgressTimer()
        
        let url = Bundle.main.url(forResource: songs[currentIndex].title, withExtension: "mp3")
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setMode(.default)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            guard let url = url else {
                print("Cannot find audio file: \(songs[currentIndex].title ?? "unknown").mp3")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                guard let slider = self.slider,
                      let thumbNailImageView = self.thumbNailImageView,
                      let titleLabel = self.titleLabel,
                      let performerLabel = self.performerLabel,
                      let playPauseButton = self.playPauseButton else {
                    print("Some IBOutlets are not connected")
                    return
                }
                
                slider.minimumValue = 0
                slider.maximumValue = Float(player.duration)
                slider.value = 0
                
                slider.removeTarget(self, action: #selector(self.didSlideSlider(_:)), for: .valueChanged)
                slider.addTarget(self, action: #selector(self.didSlideSlider(_:)), for: .valueChanged)
                
                // Update UI
                let currentSong = self.songs[self.currentIndex]
                
                thumbNailImageView.image = UIImage(named: currentSong.thumbnail ?? "")
                titleLabel.text = currentSong.name
                performerLabel.text = currentSong.performer
                
                // Update button image
                playPauseButton.setImage(UIImage(named: self.isPlaying ? "pauseButton" : "playButton"), for: .normal)
            }
            
            player.play()
            isPlaying = true
            
            startProgressTimer()
            
        } catch {
            print("Error initializing player: \(error)")
        }
    }
    
    private func startProgressTimer() {
        playerProgressUpdateTimer?.invalidate()
        playerProgressUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateSliderProgress()
        }
    }
    
    private func stopProgressTimer() {
        playerProgressUpdateTimer?.invalidate()
        playerProgressUpdateTimer = nil
    }
    
    private func updateSliderProgress() {
        guard let player = player else { return }
        slider.value = Float(player.currentTime)
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let type = event?.subtype else { return }
        switch type {
        case .remoteControlPlay:
            player?.play()
            isPlaying = true
            startProgressTimer()
        case .remoteControlPause:
            player?.pause()
            isPlaying = false
            stopProgressTimer()
        case .remoteControlStop:
            player?.stop()
            isPlaying = false
            stopProgressTimer()
        case .remoteControlNextTrack:
            nextButtonTapped(self)
        case .remoteControlPreviousTrack:
            previousTapped(self)
        default:
            break
        }
        
        // Update button image
        playPauseButton.setImage(UIImage(named: isPlaying ? "pauseButton" : "playButton"), for: .normal)
    }
    
    @objc private func didSlideSlider(_ slider: UISlider) {
        stopProgressTimer()
        player?.currentTime = TimeInterval(slider.value)
        
        if isPlaying {
            startProgressTimer()
        }
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopProgressTimer()
        } else {
            player.play()
            isPlaying = true
            startProgressTimer()
        }
        
        playPauseButton.setImage(UIImage(named: isPlaying ? "pauseButton" : "playButton"), for: .normal)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        stopProgressTimer()
        
        if (currentIndex < songs.count - 1){
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        
        isPlaying = true
        configure()
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        stopProgressTimer()
        
        if (currentIndex > 0){
            currentIndex -= 1
        } else {
            currentIndex = songs.count - 1
        }
        
        isPlaying = true
        configure()
    }
    
    func configSong(songs: [CoreDataSong], index: Int) {
        stopProgressTimer()
        
        self.songs = songs
        self.currentIndex = index
        
        if isViewLoaded {
            configure()
        }
    }
    
    deinit {
        stopProgressTimer()
    }
}
