//
//  Mystifier.swift
//  SecureString
//
//  Created by Sagar Desai on 18/06/17.
//  Copyright © 2017 Sagar Desai. All rights reserved.
//

import Foundation

class Mystifier: NSObject {

    // MARK: - Variables
    
    /// The salt used to Mystify and reveal the string.
    private var salt: String = "MyAppMystifier"
    
    
    // MARK: - Initialization
    
    init(withSalt salt: [AnyObject]) {
        self.salt = salt.description
    }
    
    
    // MARK: - Instance Methods
    
    /**
     This method mystifies the string passed in using the salt
     that was used when the Mystifier was initialized.
     
     - parameter string: the string to mystify
     
     - returns: the mystified string in a byte array
     */
    func bytesByMystifyingString(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var encrypted = [UInt8]()
        
        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % length])
        }
        
        #if DEVELOPMENT
            print("Salt used: \(self.salt)\n")
            print("// Original \"\(string)\"")
            print("let key: [UInt8] = \(encrypted)\n")
        #endif
        
        return encrypted
    }
    
    /**
     This method reveals the original string from the mystified
     byte array passed in. The salt must be the same as the one
     used to encrypt it in the first place.
     
     - parameter key: the byte array to reveal
     
     - returns: the original string
     */
    func reveal(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var decrypted = [UInt8]()
        
        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        
        return String(bytes: decrypted, encoding: .utf8)!
    }

}

