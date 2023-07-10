import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = HomeViewController()
        let navVC = UINavigationController(rootViewController: vc)
        window.rootViewController = navVC
        
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }
}

// Extensing UIColor class to adopt HEX colors
extension UIColor {
    convenience init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt64 = 0
        
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        if formattedHex.count == 6 {
            formattedHex = "FF" + formattedHex
        }
        
        if let red = UInt8(exactly: (rgbValue & 0xFF0000) >> 16),
           let green = UInt8(exactly: (rgbValue & 0x00FF00) >> 8),
           let blue = UInt8(exactly: (rgbValue & 0x0000FF) >> 0) {
                self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            return nil
        }
    }
}
