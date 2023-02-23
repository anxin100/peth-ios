//
//  KeyChainStorage.swift
//  peth
//
//  Created by qiangl on 21.02.2023.
//

import Foundation
import KeychainSwift

protocol Storage {
  func setItem(key: String, item: String)
  func getItem(key: String)
  func removeItem(key: String)
}

class KeyChainStorage {
  private static let prefix = "peth_miner"
  private static let ps = "peth$$memonic"
  private let keychain = KeychainSwift(keyPrefix: KeyChainStorage.prefix)
  
  func setItem(key: String, item: String) -> Bool {
    if key.isEmpty || item.isEmpty {
      return false
    }

    guard let data: Data = item.data(using: .utf8) else {
      return false
    }
    let encryptData = RNCryptor.encrypt(data: data, withPassword: KeyChainStorage.ps)
    let keychainString = KeyChainString(key: key, keychain: keychain)
    keychainString.value = String(data: encryptData, encoding: .utf8)
    return keychain.set(item, forKey: key)
  }
  
  func getItem(key: String) -> String? {
    if key.isEmpty {
      return nil
    }
    let keychainString = KeyChainString(key: key, keychain: keychain)
    guard let value = keychainString.value,
          let data = value.data(using: .utf8) else {
      return nil
    }
    do {
     let decryptData = try RNCryptor.decrypt(data: data, withPassword: KeyChainStorage.ps)
      return String(data: decryptData, encoding: .utf8)
    } catch {
      return nil
    }
  }
  
  func removeItem(key: String) -> Bool {
    let keychianString = KeyChainString(key: key, keychain: keychain)
    keychianString.value = nil
    guard let value = keychianString.value else {
       return true
    }
    print("Delete item for key: \(key) failed! value = \(value)")
    return false
  }
  
}

