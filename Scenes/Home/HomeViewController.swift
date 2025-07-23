//
//  HomeViewController.swift
//  ios_tutorial
//
//  Created by Nguyen Duc on 14/07/2025.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var songs: [CoreDataSong] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configTableView()
        
        let localStorage = UserDefaults.standard
        let session = URLSession.shared
    }
    
    private func configTableView() {
        songs = Song.getPlaylist()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as? SongTableViewCell
        else { return UITableViewCell() }
        
        let coreDataSong = songs[indexPath.row]
        let song = Song(
            name: coreDataSong.name ?? "",
            title: coreDataSong.title ?? "",
            performer: coreDataSong.performer ?? "",
            thumbnail: coreDataSong.thumbnail ?? ""
        )
        cell.configCell(song: song)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("Selected song at index: \(indexPath.row)")
        print("Song title: \(songs[indexPath.row].title ?? "Unknown")")
        
        guard let storyboard = storyboard else {
            print("Storyboard is nil")
            return
        }
        
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        print("ViewController created successfully")
        
        detailViewController.configSong(songs: songs, index: indexPath.row)
        
        guard let navigationController = navigationController else {
            print("NavigationController is nil")
            return
        }
        
        navigationController.pushViewController(detailViewController, animated: true)
        print("Pushed to ViewController")
    }
}
