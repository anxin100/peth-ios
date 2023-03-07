//
//  WebView.swift
//  Peth
//
//  Created by qiangl on 23.02.2023.
//

import Foundation
import WebKit

public class VueView: WKWebView {
  private var vueHandler: VueHandler?

  public func call(response: String) {
    evaluateJavaScript("rpcTransport.call('\(response)')", completionHandler: nil)
  }

  public func handle(response: String) {
    evaluateJavaScript("rpcTransport.handle(`\(response)`)", completionHandler: nil)
  }

  public func loadFile(_ filePath: String) {
    load(URLRequest(url: URL(fileURLWithPath: filePath)))
  }

  func setupUserContentController(walletRpcBus: RpcBus) {
    let vuehandler = VueHandler(rpcBus: walletRpcBus)
    self.vueHandler = vuehandler
    let userContentController = configuration.userContentController
    let sourceFile = Bundle.main.path(forResource: "", ofType: "js")!
    let source = (try? String(contentsOfFile: sourceFile)) ?? ""
    let userScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    userContentController.addUserScript(userScript)
    userContentController.add(vuehandler, name: "request")
    userContentController.add(vuehandler, name: "response")
    configuration.userContentController = userContentController
  }
}

private class VueHandler: NSObject, WKScriptMessageHandler {
  private let rpcBus: RpcBus

  init(rpcBus: RpcBus) {
    self.rpcBus = rpcBus
    super.init()
  }

  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let msg = message.body as? String {
      if msg.contains("call") {
        self.rpcBus.call(request: msg)
      } else if msg.contains("handle") {
        self.rpcBus.handle(response: msg)
      }
    }
  }

}


struct RpcBus {
  private var responseHandler: ResponseHandler
  private var requestHandler: RequestHandler

  init(requestHandler: RequestHandler, responseHandler: ResponseHandler) {
    self.requestHandler = requestHandler
    self.responseHandler = responseHandler
  }

  func call(request: String) {
    print("call \(request)")
    if let rpcRequest = RpcRequest(from: request) {
      print("request \(rpcRequest)")
      self.requestHandler.request(for: rpcRequest)
    }
  }

  func handle(response: String) {
    print("handle \(response)")
    if let rpcResponse = RpcResponse(from: response) {
      print("response \(rpcResponse)")
      self.responseHandler.response(for: rpcResponse)
    }

  }

}


class RpcResponse {
  init?(from response: String) {
    guard let dic = String.getDictionaryFromJSONString(jsonString: response),
          let method = dic["method"] as? String,
          let id = dic["id"] as? String else {
      return nil
    }
    self.method = method
    self.id = id
    if let result = dic["result"] {
      self.result =  result
    }

    if let error =  dic["error"] {
      self.error = error
    }

  }
  private let method: String
  private let id: String
  private var result: Any?
  private var error: Any?
}

class RpcRequest {
  init?(from request: String) {
    guard let dic = String.getDictionaryFromJSONString(jsonString: request),
          let method = dic["method"] as? String,
          let id = dic["id"] as? String,
          let params = dic["params"] as? [Any] else {
            return nil
    }
    self.method = method
    self.id = id
    self.params = params
  }


  private let method: String
  private let id: String
  private let params: [Any]
}

extension String {
    static func getDictionaryFromJSONString(jsonString: String?) -> [String: Any]? {
        let jsonData = jsonString?.data(using: .utf8)
        if let data = jsonData,
           let decoded = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]),
           let jsonObject = decoded as? [String: AnyObject] {
            return jsonObject
        } else {
            return nil
        }
    }
}

class RequestHandler {

  func request(for request: RpcRequest) {

  }
}

class ResponseHandler {
  func response(for response: RpcResponse) {

  }
}


