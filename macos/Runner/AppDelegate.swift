import Cocoa
import FlutterMacOS
import Firebase

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    FIRApp.configure()
    return true
  }
}
