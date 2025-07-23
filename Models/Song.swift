//
//  Song.swift
//  ios_tutorial
//
//  Created by Nguyen Duc on 14/07/2025.
//

import Foundation
import CoreData

struct Song {
    let name: String
    let title: String
    let performer: String
    let thumbnail: String
    
    static func getPlaylist() -> [CoreDataSong] {
        return CoreDataManager.shared.getPlaylist()
    }
}

	
