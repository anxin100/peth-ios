//
//  KeyChainFlowContext.swift
//  peth
//
//  Created by qiangl on 21.02.2023.
//

import Foundation
import KeychainSwift

class KeyChainString {
  init(key: String, keychain: KeychainSwift) {
    self.key = key
    self.keyChain = keychain
  }
  
  var value: String? {
    get {
      let value = keyChain.get(key)
      if value != nil, keyChain.lastResultCode == noErr {
        return value
      }
      print("Get value from keychain error \(key)")
      return nil
    }
    set {
      if let newValue = newValue {
        let result = keyChain.set(newValue, forKey: key, withAccess: .accessibleWhenUnlocked)
        if !result {
          print("Set value for key \(key) error")
        }
      } else {
        keyChain.delete(key)
        print("Remove value for key \(key)")
      }
    }
    
  }
  
  private let key: String
  private let keyChain: KeychainSwift
}
