// written by hkphh

import SwiftUI

// Mikrotik ip-address

let routerIp: String = "192.168.0.254"

// Base64 user:pass string
// if u decode base64 "YWRtaW46cGFzc3dvcmQ=" string u will get "stepa:password" string

let credBase64: String = "YWRtaW46cGFzc3dvcmQ="

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
    var domainTextField: NSTextField?

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
        menu.addItem(NSMenuItem.separator())

        let domainItem = NSMenuItem()
        let domainView = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 25))
        
        domainTextField = NSTextField(frame: NSRect(x: 10, y: 0, width: 140, height: 24))
        domainTextField?.placeholderString = "Add domain here"
        domainView.addSubview(domainTextField!)
        
        let addButton = NSButton(title: "Add", target: self, action: #selector(addDomainToVPN))
        addButton.frame = NSRect(x: 150, y: 0, width: 50, height: 20)
        domainView.addSubview(addButton)
        
        domainItem.view = domainView
        menu.addItem(domainItem)

        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)  // Show the menu immediately
    }

    // Also change jsonBody with your rule number or anything else
    // HTTP (not HTTPS) requires NSExceptionAllowsInsecureHTTPLoads key in Info.plist
    
    @objc func sendHTTPRequest1() {
        let jsonBody: [String: Any] = ["numbers": "4"]
        sendHTTPRequest(endpoint: "http://\(routerIp)/rest/ip/firewall/mangle/enable", jsonBody: jsonBody, method: "POST")
    }

    @objc func sendHTTPRequest2() {
        let jsonBody: [String: Any] = ["numbers": "4"]
        sendHTTPRequest(endpoint: "http://\(routerIp)/rest/ip/firewall/mangle/disable", jsonBody: jsonBody, method: "POST")
    }

    @objc func addDomainToVPN() {
        guard let domain = domainTextField?.stringValue, !domain.isEmpty else {
//            print("Domain field is empty")
            return
        }
        let jsonBody: [String: Any] = ["address": domain, "list": "AL-VPN"]
        sendHTTPRequest(endpoint: "http://\(routerIp)/rest/ip/firewall/address-list", jsonBody: jsonBody, method: "PUT")
        
        // Clear text field after button click
        domainTextField?.stringValue = ""
    }
    
    func sendHTTPRequest(endpoint: String, jsonBody: [String: Any], method: String) {
        guard let url = URL(string: endpoint) else {
//            print("Invalid URL")
            return
        }

        // here we announce http headers
        // in Authorization header we should insert base64 encoded login & pass from ur MikroTik in login:pass format
        // if u decode base64 "YWRtaW46cGFzc3dvcmQ=" string u will get "stepa:password" string
        // var credBase64 located upper
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(credBase64)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = jsonData
        } catch {
//            print("Failed to encode JSON: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
//                print("Error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
//                print("Response Code: \(response.statusCode)")
            }
            if let data = data {
//                print("Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
        }

        task.resume()
    }
}

