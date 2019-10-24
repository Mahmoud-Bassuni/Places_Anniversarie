//
//  PlaceModel.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import Foundation
struct PlaceModel
{
    var id, name, anniversaries , imageUrl : String!
    var lat, lng  : Double!
    var image : Data!
    init() {
    }
    init?(placeId : String! ,dict: [String: Any]) {
         guard let id = placeId,
          let name = dict["name"] as? String,
          let lat = dict["lat"] as? Double,
          let lng = dict["lng"] as? Double,
          let anniversaries = dict["anniversaries"] as? String,
          let imageUrl = dict["imageUrl"] as? String
            else { return  }
          self.id = id
          self.name = name
          self.lat = lat
          self.lng = lng
          self.anniversaries = anniversaries
          self.imageUrl = imageUrl
      }

}
