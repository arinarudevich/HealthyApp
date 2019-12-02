import Foundation
import UIKit

extension CAGradientLayer {
    
    class func primaryGradient(on view: UIView) -> UIImage? {
        print("1 creating img")

        let gradient = CAGradientLayer()
        let flareRed = UIColor(displayP3Red: 29.0/255.0, green: 151.0/255.0, blue: 108.0/255.0, alpha: 1.0)
        let flareOrange = UIColor(displayP3Red: 147.0/255.0, green: 249.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [flareRed.cgColor, flareOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        print("1 creating img")
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
