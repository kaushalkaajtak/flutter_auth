import Flutter
import UIKit

public class FlutterAuthPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_auth", binaryMessenger: registrar.messenger())
    let instance = FlutterAuthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS app " + UIDevice.current.systemVersion)
  }
}
