//
//  PlacesDB.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import Foundation
import Firebase

class PlacesDB {
    static let shared = PlacesDB()
    private init() {}
    let placesReference = Database.database().reference().child("places")
    let placesPics = Storage.storage().reference()
}
