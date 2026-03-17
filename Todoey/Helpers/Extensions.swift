//
//  Extensions.swift
//  Todoey
//
//  Created by Cem Akkaya on 16/03/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import UIKit

// MARK: - UIColor Extension

extension UIColor {
    
    // 1. Random Color Creator
    
    static func randomFlat() -> UIColor {
        let red = CGFloat.random(in: 0.3 ... 0.9)
        let green = CGFloat.random(in: 0.3 ... 0.9)
        let blue = CGFloat.random(in: 0.3 ... 0.9)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // 2. Converting Color to Hex Text (to save to Realm)
    
    func hexValue() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255) << 16 | (Int)(g*255) << 8 | (Int)(b*255) << 0
        
        return String(format: "#%06x", rgb).uppercased()
    }
    
    // 3. Converting Hex Text to Color (for reading in Realm)
    
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    // 4. Finding the Contrasting Text Color (For Readability)
    func contrastingText() -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // Luminance formula: Returns black text if the background is light, and white text if the background is dark.
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        
        return luminance > 0.5 ? UIColor.black : UIColor.white
    }
    
    // 5. Generating a Lighter Version of the Color (for the Gradient)
    
    // Percentage: Between 0.0% and 100.0%. The larger the value, the closer it gets to white.
    func lighter(by persentage: CGFloat = 30.0) -> UIColor? {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        
        // We get the current HSB (Color, Saturation, Brightness) values ​​of the color.
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            
            // We "lighten" the color by increasing the brightness value (we keep it fixed at a maximum of 100%)
            return UIColor(hue: hue, saturation: saturation, brightness: min(1.0, brightness - persentage / 100.0), alpha: alpha)
        }
        return nil
    }
}

// MARK: - UIViewController Extension (Alert Manager)

extension UIViewController {
    func presentAddAlert(title: String, placeholder: String, completion: @escaping (String) -> Void) {
        var textField = UITextField()
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
            completion(text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = placeholder
            textField = alertTextField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
