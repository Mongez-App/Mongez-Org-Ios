import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    public let url: URL
    public let headers: [String: String]?
    
    public init(url: URL, headers: [String: String]? = nil) {
        self.url = url
        self.headers = headers
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        var request = URLRequest(url: url)
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        uiView.load(request)
    }
}
