//
//  ViewController.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import UIKit
import Firebase
import SVProgressHUD
class PlaceListVC: UIViewController {
    //IBOutlets
    @IBOutlet var placesPropTV: UITableView!
    // objects
    var vm : PlacesListVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        placesPropTV.tableFooterView = UIView()
        self.navigationItem.setHidesBackButton(true, animated:true);

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm = PlacesListVM(contectDB : PlacesDBServices())
        vm.delegate = self
        vm.selectAllPlaces()
    }
    // by default ARC will deallocate  but we need to  make sure thats all object will deleted
    deinit {
        vm = nil
    }
}
extension PlaceListVC: UITableViewDataSource ,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = vm.places[indexPath.row].name
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = vm.places[indexPath.row].anniversaries
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _PlaceManagementVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "placeManagementScreen") as? PlaceManagementVC {

            if let navigator = navigationController {
                let placeItem = self.vm.places[indexPath.row]
                let _placeManagementVM = PlaceManagementVM(_placeModel:placeItem , contectDB : PlacesDBServices())
                _PlaceManagementVC.vm =  _placeManagementVM
                navigator.pushViewController(_PlaceManagementVC, animated: true)
            }
        }
    }
}
extension PlaceListVC : PlacesListVMProtocol
{
    func hideLoading() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

    func bindData() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.placesPropTV.delegate = self
            self.placesPropTV.dataSource = self
            self.placesPropTV.reloadData()
        }
    }
    func showLoading() {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "")
        }
    }
}

