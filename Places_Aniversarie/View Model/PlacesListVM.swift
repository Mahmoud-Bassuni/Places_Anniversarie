//
//  PlacesListVM.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/24/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import Foundation
class PlacesListVM 
{
    var delegate : PlacesListVMProtocol?
    var places : [PlaceModel] = []
    var _placesDBServices : PlacesDBServices!
    init(contectDB : PlacesDBServices) {
        _placesDBServices = contectDB
    }
    func selectAllPlaces()
    {
        delegate?.showLoading()
        _placesDBServices.fetchPlaces()
            {
                data in
                DispatchQueue.global(qos: .background).async {
                    guard let snapDict = data.value as? [String: [String: Any]] else {
                        self.delegate?.hideLoading()
                        return  }
                    for snap in snapDict {
                        guard let place = PlaceModel(placeId: snap.key,dict: snap.value) else { continue }
                        self.places.append(place)
                        self.delegate?.bindData()
                    }
                }
        }
    }
    // by default ARC will deallocate  but we need to  make sure thats all object will deleted
    deinit {
        places = []
        delegate = nil
        _placesDBServices = nil
    }
}
