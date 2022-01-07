//
// Created by Edson Rocha on 05/01/22.
//

import UIKit


extension UIColor {

    static func hexUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
        )
    }


    var transparent: UIColor {
        //choose your custom rgb values
        return UIColor(red: 201 / 255, green: 14 / 255, blue: 14 / 255, alpha: 0.0)
    }
    var selectedSegment: UIColor {
        //choose your custom rgb values
        return UIColor(red: 116 / 255, green: 116 / 255, blue: 116 / 255, alpha: 0.61)
    }
    var colorLightGrayTransparent: UIColor {
        //choose your custom rgb values
        return UIColor(red: 228 / 255, green: 228 / 255, blue: 228 / 255, alpha: 0.28)
    }

    static var colorPrimary: UIColor {
        return hexUIColor(hex: "#DD5801")
    }
    static var colorPrimaryDark: UIColor {
        return hexUIColor(hex: "#0F2E67")
    }
    static var colorAccent: UIColor {
        return hexUIColor(hex: "#1176B9")
    }
    static var colorWhite: UIColor {
        return hexUIColor(hex: "#FFFFFF")
    }
    static var colorRed: UIColor {
        return hexUIColor(hex: "#FF0000")
    }
    static var colorGreen: UIColor {
        return hexUIColor(hex: "#39C60D")
    }
    static var colorLightGreen: UIColor {
        return hexUIColor(hex: "#0FEE56")
    }
    static var colorYellow: UIColor {
        return hexUIColor(hex: "#FFFF00")
    }
    static var colorBlue: UIColor {
        return hexUIColor(hex: "#1A73E8")
    }
    static var colorGray: UIColor {
        return hexUIColor(hex: "#CCCCCC")
    }
    static var colorLightGray: UIColor {
        return hexUIColor(hex: "#E4E4E4")
    }
    static var colorDrakGray: UIColor {
        return hexUIColor(hex: "#747474")
    }
    static var colorBlack: UIColor {
        return hexUIColor(hex: "#000000")
    }
    static var qzelaOrange: UIColor {
        return hexUIColor(hex: "#DD5801")
    }
    static var qzelaLightBlue: UIColor {
        return hexUIColor(hex: "#1176B9")
    }
    static var qzelaMediumBlue: UIColor {
        return hexUIColor(hex: "#084694")
    }
    static var qzelaDarkBlue: UIColor {
        return hexUIColor(hex: "#0F2E67")
    }
    static var qzelaGreen: UIColor {
        return hexUIColor(hex: "#8CC90E")
    }
    static var colorTextPrimary: UIColor {
        return hexUIColor(hex: "#212121")
    }
    static var colorSuccess: UIColor {
        return hexUIColor(hex: "#4BB543")
    }
    static var colorWarning: UIColor {
        return hexUIColor(hex: "#FFCC00")
    }
    static var colorNeutral: UIColor {
        return hexUIColor(hex: "#434343")
    }
    static var colorError: UIColor {
        return hexUIColor(hex: "#CC0000")
    }


}
