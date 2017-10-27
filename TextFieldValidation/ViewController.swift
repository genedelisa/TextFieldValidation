//
//  ViewController.swift
//  TextFieldValidation
//
//  Created by Gene De Lisa on 10/26/17.
//  Copyright © 2017 Gene De Lisa. All rights reserved.
//

import Cocoa

class FRNSTextField : NSTextField {
    override var acceptsFirstResponder: Bool { return true }
}

@objcMembers
class ViewController: NSViewController {
    
    @IBOutlet var givenNameTextField: NSTextField!
    
    @IBOutlet var familyNameTextField: NSTextField!
    
    @IBOutlet var ageTextField: NSTextField!
    
    @IBOutlet var submitButton: NSButton!
    
    @objc dynamic var givenName:String?
    @objc dynamic var familyName:String?
    @objc dynamic var age:Int = 0
    
    var person:Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // probably injected
        self.person = Person()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func submitAction(_ sender: NSButton) {
        self.givenName = givenNameTextField.stringValue
        self.familyName = familyNameTextField.stringValue
        if let age = Int(ageTextField.stringValue) {
            self.age = age
        } else {
            displayAlert(messageText: "Invalid Age value",
                         informativeText: "'\(ageTextField.stringValue)' is a bad number")
        }
        Swift.print("""
            given:\(self.givenName ?? "No given")
            family: \(self.familyName ?? "No family")
            age: \(self.age)
            """)
        Swift.print("\(person!)")
    }
    
    func displayAlert(messageText: String, informativeText: String) {
        let alert = NSAlert()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.alertStyle = .warning
        alert.addButton(withTitle: NSLocalizedString("OK", comment: "OK"))
        alert.runModal()
    }
    
    func displayAlert(error:Error) {
        let alert = NSAlert(error: error)
        alert.alertStyle = .critical
        alert.showsHelp = true
        alert.runModal()
    }
    
    
    override func validateValue(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey inKey: String) throws {
        Swift.print("\(#function)")
        Swift.print("inKey \(inKey)")

        switch inKey {
        case "givenName" :
            Swift.print("validating givenName")
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
//                    throw DBError.textFieldValidation("Oh bloody hell!\nA family name must be at least three characters long")
                    let error = DBError.textFieldValidation("Oh bloody hell!\nA family name must be at least three characters long")
                    displayAlert(error: error)
                    // without throwing the error, the model gets set to bad data
                    //throw error
                }
            }
        case "age" :
            Swift.print("validating age")
            if ioValue.pointee == nil {
                throw DBError.textFieldValidation("Oh bloody hell!\n\nEnter a number!")

            }
            if let s = ioValue.pointee as? String {
                let onlyDigits = CharacterSet.decimalDigits.inverted
                if s.rangeOfCharacter(from: onlyDigits) != nil {
                    throw DBError.textFieldValidation("Oh bloody hell!\n'\(s)' is not a number.\nEnter a number!")
                } else {
                    Swift.print("dig \(s)")
                }
            }
            
        default: break
        }
    }

}

//MARK: - DBError
enum DBError : Error {
    case textFieldValidation(String)
}

extension DBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .textFieldValidation(message):
            return NSLocalizedString(message,
                                     comment: "My error")
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .textFieldValidation:
            return NSLocalizedString("I don't know why.", comment: "")
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .textFieldValidation:
            return NSLocalizedString("Plug it in!.", comment: "")
        }
    }
    
    public var helpAnchor: String? {
        switch self {
        case .textFieldValidation:
            return NSLocalizedString("someHelpAnchor.", comment: "")
        }
    }
}

extension DBError: CustomNSError {
    
    public static var errorDomain: String {
        return "myDomain"
    }
    
    public var errorCode: Int {
        switch self {
        case .textFieldValidation:
            return 666
        }
    }
    
    public var errorUserInfo: [String : Any] {
        switch self {
        case .textFieldValidation:
            return [ "line": 13]
        }
    }
}


