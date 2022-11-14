//
//  SpotifySignInViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/24/22.
//

import UIKit
import WebKit

class SpotifySignInViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configure = WKWebViewConfiguration()
        configure.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configure)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = self
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        guard let url = AuthManager.shared.signInURL else{
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else{
            return
        }
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else{
            return
        }
        webView.isHidden = true
        
        print("code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }

}
