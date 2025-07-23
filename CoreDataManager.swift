//
//  CoreDataManager.swift
//  ios_tutorial
//
//  Created by Nguyen Duc on 15/07/2025.
//
import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "MusicPlayerCoreData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("ERROR: \(error)")
            }
        }
        return container
    }
    
    func play(song: CoreDataSong) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreDataSong>(entityName: "CoreDataSong")
        guard let name = song.name else { return }
        fetchRequest.predicate = NSPredicate(format: "name = %@", name as String)
        
        do {
            let updateSongs = try context.fetch(fetchRequest)
            updateSongs.first?.playCounter += 1
            try context.save()
        } catch let error {
            print("ERROR: \(error)")
        }
    }
    
    func getPlaylist() -> [CoreDataSong] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreDataSong>(entityName: "CoreDataSong")
        
        do {
            let songs = try context.fetch(fetchRequest)
            
            if songs.isEmpty {
                // Tạo songs mới bằng createSong function
                createSong(name: "Tình yêu màu nắng", fileName: "tinhYeuMauNang", performer: "Truc Nhan ft Min", thumbnail: "tinhYeuMauNang", context: context)
                createSong(name: "Lần Cuối", fileName: "lanCuoi", performer: "Ngọt", thumbnail: "lanCuoiArtWork", context: context)
                createSong(name: "Phép màu", fileName: "phepMauOST", performer: "MAYDAYs ft. Minh Tốc", thumbnail: "phepMauOst", context: context)

                
                // Fetch lại sau khi tạo
                let newSongs = try context.fetch(fetchRequest)
                return newSongs
            }
            
            return songs
        } catch let error {
            print("ERROR: \(error)")
            return []
        }
    }
    
    private func createSong(name: String, fileName: String, performer: String, thumbnail: String, context: NSManagedObjectContext) {
        let song = NSEntityDescription.insertNewObject(forEntityName: "CoreDataSong", into: context) as! CoreDataSong
        song.name = name
        song.title = fileName  
        song.performer = performer
        song.thumbnail = thumbnail
        song.playCounter = 0
        
        do {
            try context.save()
        } catch let error {
            print("ERROR: \(error)")
        }
    }
}
