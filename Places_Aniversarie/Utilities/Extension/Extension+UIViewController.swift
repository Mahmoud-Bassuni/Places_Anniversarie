//
//  Extension+UIViewController.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {

    func alert(title : String, message : String , complete :@escaping ()->())
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            complete()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func alertWithTwoAction(title : String, message : String ,ButtonTitle1 : String, ButtonTitle2 : String, action1 :@escaping ()->() , action2 :@escaping ()->()){

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: ButtonTitle1, style: UIAlertAction.Style.default, handler: { (action) in
              action1()
          }))
        alert.addAction(UIAlertAction(title: ButtonTitle2, style: UIAlertAction.Style.default, handler: { (action) in
                    action2()
                }))

          

          self.present(alert, animated: true, completion: nil)
      }

}
