//
//  Person.swift
//  TextFieldValidation
//
//  Created by Gene De Lisa on 10/26/17.
//  Copyright © 2017 Gene De Lisa. All rights reserved.
//

import Foundation

@objcMembers
class Person : NSObject {
    dynamic var givenName:String?
    dynamic var familyName:String?
    dynamic var age:Int = 0
    
    override var description:String {
        get {
            var s = "\(givenName ?? "") "
            s += "\(familyName ?? "") "
            s += "\(age) "
            return s
        }
    }
    
    override func validateValue(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey inKey: String) throws {
        print("\(#function)")

        switch inKey {
        case "givenName" :
            if let s = ioValue.pointee as? String {
                Swift.print("s \(s)")
                if s.count < 3 {
                    throw DBError.textFieldValidation("Oh bloody hell!\nA given name must be at least three characters long")
                }
            }
        case "familyName" :
            Swift.print("validating familyName")
            if let s = ioValue.pointee as? String {
                Swift.print("s \(s)")
                if s.count < 3 {
                    throw DBError.textFieldValidation("Oh bloody hell!\nA family name must be at least three characters long")

                    // nah, don't do this
                    //let error = DBError.textFieldValidation("Oh bloody hell!\nA family name must be at least three characters long")
                    //displayAlert(error: error)
                    // without throwing the error, the model gets set to bad data
                }
            }
        case "age" :
            Swift.print("validating age")

            // you can do more than one check of course
            if ioValue.pointee == nil {
                throw DBError.textFieldValidation("Oh bloody hell!\n\nEnter a number!")
            }
            if let s = ioValue.pointee as? String {
                let onlyDigits = CharacterSet.decimalDigits.inverted
                if s.rangeOfCharacter(from: onlyDigits) != nil {
                    throw DBError.textFieldValidation("Oh bloody hell!\n'\(s)' is not a number.\nEnter a number!")
                } else {
                    Swift.print("ok, it's a digit \(s)")
                }
            }
            
        default: break
        }
    }
    
}

