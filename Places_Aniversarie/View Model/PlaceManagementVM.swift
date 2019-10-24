//
//  PlaceManagementVM.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import Foundation
class PlaceManagementVM : ViewModel
{
    var delegate : PlaceManagementVMProtocol?
    var brokenRules: [String] = []
    var validationMessage = ""
    var isValid: Bool
    {
        get {
            self.brokenRules = [String]()
            self.validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    var model : PlaceModel!
    var _placesDBServices : PlacesDBServices!
    init(_placeModel : PlaceModel , contectDB : PlacesDBServices) {
        model = _placeModel
        _placesDBServices = contectDB
    }
    func addNewPlaces()
    {
        self.delegate?.showLoading()
        self._placesDBServices.AddNewPlace(paramter: self.model)
        {
            DispatchQueue.main.async {
                self.delegate?.showAlert(message : "Done")
            }
        }
    }
    func deletePalce()
    {
        self.delegate?.showLoading()
        _placesDBServices.deletePlace(model.id)
        {
            DispatchQueue.main.async {
                self.delegate?.showAlert(message : "Done")
            }
        }
    }
    // by default ARC will deallocate  but we need to  make sure thats all object will deleted
    deinit {
        model = nil
        delegate = nil
        _placesDBServices = nil
    }
}
extension PlaceManagementVM
{
    func validate()
    {
        if (model != nil ){
            if(model.name == nil || model.name.isEmpty){
                self.brokenRules.append("please enter a valid place name")
            }
            if(model.lat == nil || model.lat == 0){
                self.brokenRules.append("please enter a valid lat")
            }
            if(model.lng == nil || model.lng == 0){
                self.brokenRules.append("please enter a valid lng")
            }
            if(model.anniversaries == nil || model.anniversaries.isEmpty){
                self.brokenRules.append("please enter a valid Anniversaries")
            }
        }
        else {
            self.brokenRules.append("there is an error")
        }
        if(brokenRules.count > 0){
            validationMessage =  brokenRules.joined(separator:"\n")
        }
    }
}
