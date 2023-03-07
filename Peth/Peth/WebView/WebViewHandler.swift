//
//  WebViewHandler.swift
//  Peth
//
//  Created by qiangl on 28.02.2023.
//

import Foundation

protocol WebViewHandlerProtocol {
  func handleStorageItem(key: String, item: String) -> Bool
  func handleGetStorageItem(key: String) -> String?
}

class WebViewHandler: WebViewHandlerProtocol {

  private let storage: KeyChainStorage

  init(storage: KeyChainStorage) {
    self.storage = storage
  }

  func handleStorageItem(key: String, item: String) -> Bool {
    return self.storage.setItem(key: key, item: item)
  }

  func handleGetStorageItem(key: String) -> String? {
    return self.storage.getItem(key: key)
  }
}
