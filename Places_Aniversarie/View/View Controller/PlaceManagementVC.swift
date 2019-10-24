//
//  PlaceManagementVC.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import UIKit
import MapKit
import SVProgressHUD
class PlaceManagementVC: UIViewController {
    // Outlets  -----------------
    @IBOutlet weak var placeNamePropTxt: BindingTextField!
        {
        didSet { placeNamePropTxt.bind(callBack: { self.vm.model.name = $0})}
    }
    @IBOutlet weak var latPropTxt: BindingTextField!
        {
        didSet { latPropTxt.bind(callBack: { self.vm.model.lat = Double($0)})}
    }
    @IBOutlet weak var lngPropTxt: BindingTextField!
        {
        didSet { lngPropTxt.bind(callBack: { self.vm.model.lng = Double($0)})}
    }
    @IBOutlet weak var anniversariesPropTxt: BindingTextField!
        {
        didSet { anniversariesPropTxt.bind(callBack: { self.vm.model.anniversaries = $0})}
    }
    @IBOutlet var placePicProp: CustomImageView!
    @IBOutlet var savePropBtn: UIButton!
    @IBOutlet var showMapPropBtn: UIButton!
    @IBOutlet var deletePlacePropBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    //
    // objects ---------------
    var imagePicker:UIImagePickerController!
    var vm : PlaceManagementVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerConfig()
    }
    @IBAction func selectPicAction(_ sender: Any) {
        alertWithTwoAction(title: "alert", message: "please choose",
                           ButtonTitle1: "take picture" ,
                           ButtonTitle2: "use gallery",
                           action1: {self.imagePicker.sourceType = .camera
                            self.present(self.imagePicker, animated: true, completion: nil)},
                           action2: {self.imagePicker.sourceType = .photoLibrary
                            self.present(self.imagePicker, animated: true, completion: nil)})

    }
    @IBAction func savePlaceAction(_ sender: Any) {
        if(vm.isValid)
        {
            vm.model.image = self.placePicProp.image!.jpegData(compressionQuality: 0.75) // compress the picture to decrease size
            vm.addNewPlaces()
        }
        else{
            alert(title: "Validation", message: vm.validationMessage, complete: {})
        }
    }
    @IBAction func showMapAction(_ sender: Any) {
        if let _mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapScreen") as? MapVC {
            if let navigator = navigationController {
                _mapVC.locationCoordinate =  CLLocationCoordinate2D(latitude: vm.model.lat, longitude: vm.model.lng)
                navigator.pushViewController(_mapVC, animated: true)
            }
        }
    }
    @IBAction func deletePlaceAction(_ sender: Any) {
        vm.deletePalce()
    }
    override func viewWillAppear(_ animated: Bool) {
        //  the app call viewWillAppear again when user open camera and take pic
        guard self.imagePicker.sourceType != .camera else {return}
        super.viewWillAppear(animated)
        addKeyboardboaObserver() // handle scroll in landscape mode
        if(vm == nil){ // insert new place
            vm = PlaceManagementVM(_placeModel: PlaceModel(), contectDB: PlacesDBServices())
            showMapPropBtn.isHidden = true
            deletePlacePropBtn.isHidden = true
        }
        else // update place
        {
            placeNamePropTxt.text = vm.model.name
            latPropTxt.text = String(vm.model.lat)
            lngPropTxt.text = String(vm.model.lng)
            anniversariesPropTxt.text = vm.model.anniversaries
            guard vm.model.imageUrl != nil else { return}
            self.placePicProp.loadImageUsingUrlString(urlString: vm.model.imageUrl)
        }
        vm.delegate = self
    }
    func clearTextFields()
    {
        self.placeNamePropTxt.text = ""
        self.latPropTxt.text = ""
        self.lngPropTxt.text = ""
        self.anniversariesPropTxt.text = ""
        self.placePicProp.image = UIImage(named: "download")
    }

}
extension PlaceManagementVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerConfig()
    {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.placePicProp.image = UIImage(named: "download")
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.placePicProp.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
}
// handle scroll in landscape mode -------------------
extension PlaceManagementVC {

    func addKeyboardboaObserver()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    func removeKeyboardboaObserver()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        UIResponder.removeObserver(self, forKeyPath: UIResponder.keyboardWillHideNotification.rawValue, context: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!

        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue ).cgRectValue

        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            self.scrollView.contentInset = UIEdgeInsets.zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        self.scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

}
// -------------------
extension PlaceManagementVC : PlaceManagementVMProtocol
{
    func showLoading() {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "")
        }
    }
    func hideLoading() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    func showAlert(message : String) {
        hideLoading()
        alert(title: "alert",message: message, complete: {
            if(self.vm.model.id != nil) // if update mode redirect to places list screen
            {
                if let _PlaceListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "placeListScreen") as? PlaceListVC {
                    if let navigator = self.navigationController {
                        navigator.pushViewController(_PlaceListVC, animated: true)
                    }
                }
            }
            else { // if insert mode clear the old place and start to inter new place
                self.clearTextFields()
            }
        })

    }
}
