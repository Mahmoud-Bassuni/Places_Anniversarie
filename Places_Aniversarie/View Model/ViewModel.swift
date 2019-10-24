//
//  ViewModel.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import Foundation
struct BrokenRule {
    var proprityName : String
    var message : String
}
protocol ViewModel {
    var brokenRules : [String] { get set }
    var isValid : Bool { get }
}
