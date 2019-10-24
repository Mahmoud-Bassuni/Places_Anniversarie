//
//  PlacesDBServices.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import Foundation
import Firebase
class PlacesDBServices
{
    func AddNewPlace(paramter : PlaceModel , _ complete : @escaping () -> ()){
        uploadImage(image: paramter.image) // upload image first then add url of image in database
        { url in
            DispatchQueue.global(qos: .background).async {
            var places : Dictionary<String , Any> = ["id" : paramter.id ?? "0"  ,"name" : paramter.name! , "lat" : paramter.lat! , "lng" : paramter.lng! , "anniversaries" : paramter.anniversaries! ,"imageUrl" : url]
            if(paramter.id != nil){ // update place
                PlacesDB.shared.placesReference.child(places["id"] as! String ).setValue(places)

            }
            else{ // insert new place
                places["id"] =  PlacesDB.shared.placesReference.childByAutoId().key
                PlacesDB.shared.placesReference.childByAutoId().setValue(places)
            }
            complete()
            }
        }
    }
    func uploadImage( image : Data , _ callBack : @escaping (String) -> ()){
        let imageName = NSUUID().uuidString
        let storage  = PlacesDB.shared.placesPics.child("\(imageName).png")
        storage.putData(image, metadata: nil , completion: {(meta,err) in
            storage.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {
                    callBack(urlText)
                }
            })
        })
    }
    func deletePlace(_ id : String ,_ complete : @escaping () -> ()){
        PlacesDB.shared.placesReference.child(id).removeValue()

        complete()
    }
    func fetchPlaces(_ callBack : @escaping (DataSnapshot) -> ()){
          DispatchQueue.global(qos: .background).async {
            PlacesDB.shared.placesReference.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            callBack(snapshot)
        })
        }
    }
}
