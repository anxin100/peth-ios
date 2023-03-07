//
//  RootViewController.swift
//  Peth
//
//  Created by qiangl on 28.02.2023.
//

import Foundation
import UIKit
import SnapKit
import WebKit

class RootViewController: UIViewController, WKNavigationDelegate {
  private var _vueView: VueView?

  override func viewDidLoad() {
    self.view.addSubview(self.vueView)
    vueView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(0)
    }
  }

  private var configuration: WKWebViewConfiguration {
    let configuration = WKWebViewConfiguration()
    let preferences = WKPreferences()
    preferences.javaScriptCanOpenWindowsAutomatically = true
    preferences.setValue("TRUE", forKey: "allowFileAccessFromFileURLS")
    preferences.javaScriptEnabled = true
    configuration.setValue("TRUE", forKey: "allowFileAccessFromFileURLS")
    configuration.preferences = preferences
    let controller = WKUserContentController()
    configuration.userContentController = controller
    return configuration
  }

  public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    webView.reload()
  }

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

  }

  private var vueView: VueView {
    get {
      if let vueView = _vueView {
        return vueView
      }
      let view = VueView(frame: .zero, configuration: configuration)
      _vueView = view
      _vueView?.setupUserContentController(walletRpcBus: RpcBus(requestHandler: RequestHandler(), responseHandler: ResponseHandler()))
      view.loadFile(Bundle.main.path(forResource: "indel", ofType: "html", inDirectory: "xxx/dist") ?? "") //路径
      return view
    }
  }

}
