//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Valentina Abramova on 31/07/2019.
//  Copyright © 2019 Valentina Abramova. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}

