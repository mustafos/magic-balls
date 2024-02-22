//
//  SKWebView.swift
//  MagicBalls
//
//  Created by Mustafa Bekirov on 21.02.2024.
//

import UIKit
import WebKit
import SpriteKit

class SKWebView: SKNode {
    private var webView: WKWebView!
    
    override init() {
        super.init()
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        guard let view = webView else { return }
        addChild(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(_ request: URLRequest) {
        webView.load(request)
    }
}

