// writed by hkphh

import SwiftUI

@main
struct YourApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

// here u can change widget icon
// search some "macos sf symbols swift"

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star", accessibilityDescription: "Menu")
            button.action = #selector(showMenu)
        }
    }

    @objc func showMenu() {
        let menu = NSMenu()

// Every item here is a unique button
// If u wanna add some new, also dont forget to add new objc sendHTTPRequest[num]

        menu.addItem(NSMenuItem(title: "Enable VPN", action: #selector(sendHTTPRequest1), keyEquivalent: "1"))
        menu.addItem(NSMenuItem(title: "Disable VPN", action: #selector(sendHTTPRequest2), keyEquivalent: "2"))
//Test        menu.addItem(NSMenuItem(title: "Test", action: #selector(sendHTTPRequest3), keyEquivalent: "3"))
        
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)  // Show the menu immediately
    }

// Replace 127.0.0.1 with your Mikrotik address
// Also change numbers key (4 in jsonBody) with your rule number
// HTTP (not HTTPS) requires NSExceptionAllowsInsecureHTTPLoads key in Info.plist

    @objc func sendHTTPRequest1() {
        let jsonBody: [String: Any] = ["numbers": "4"]
        sendHTTPRequest(endpoint: "http://127.0.0.1/rest/ip/firewall/mangle/enable", jsonBody: jsonBody)
    }

// Replace 127.0.0.1 with your Mikrotik address
// Also change numbers key (4 in jsonBody) with your rule number
// HTTP (not HTTPS) requires NSExceptionAllowsInsecureHTTPLoads key in Info.plist

    @objc func sendHTTPRequest2() {
        let jsonBody: [String: Any] = ["numbers": "4"]
        sendHTTPRequest(endpoint: "http://127.0.0.1/rest/ip/firewall/mangle/disable", jsonBody: jsonBody)
    }

// Test button
//    @objc func sendHTTPRequest3() {
//        let jsonBody: [String: Any] = ["numbers": "5"]
//        sendHTTPRequest(endpoint: "http://127.0.0.1:8080", jsonBody: jsonBody)
//    }
    
    func sendHTTPRequest(endpoint: String, jsonBody: [String: Any]) {
        guard let url = URL(string: endpoint) else {
//            print("Invalid URL")
            return
        }

// here we announce http headers
// in Authorization header we should insert base64 encoded login pass from ur MikroTik in login:pass format
// if u decode base64 "YWRtaW46cGFzc3dvcmQ=" string u will get "stepa:password" string

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic c3RlcGE6cGFzc3dvcmQ=", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = jsonData
        } catch {
 //           print("Failed to encode JSON: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
 //               print("Error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
 //               print("Response Code: \(response.statusCode)")
            }
            if let data = data {
 //               print("Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
        }

        task.resume()
    }
}
