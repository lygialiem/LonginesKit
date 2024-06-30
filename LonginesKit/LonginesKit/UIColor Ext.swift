//
//  UIColor Ext.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import UIKit

extension UIColor {
    
    public convenience init(red: Int, green: Int, blue: Int, editAlpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: editAlpha)
    }

    public  convenience init(rgb: Int, alpha: CGFloat = 1) {
        self.init(red: (rgb >> 16) & 0xff,
                  green: (rgb >> 8) & 0xff,
                  blue: rgb & 0xff,
                  editAlpha: alpha)
    }

    public var toHexString: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let a: CGFloat = components?[3] ?? 1.0

        let hexString = String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(a * 255)), lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

infix operator |: AdditionPrecedence
extension UIColor {
    
    public static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
            }
        } else {
            return darkMode
        }
    }
}

extension UIColor {
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xf) * 17, (int & 0xf) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xff, int & 0xff)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xff, int >> 8 & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    enum SGHexAlpha: String {
        case _100 = "FF"
        case _99 = "FC"
        case _98 = "FA"
        case _97 = "F7"
        case _96 = "F5"
        case _95 = "F2"
        case _94 = "F0"
        case _93 = "ED"
        case _92 = "EB"
        case _91 = "E8"
        case _90 = "E6"
        case _89 = "E3"
        case _88 = "E0"
        case _87 = "DE"
        case _86 = "DB"
        case _85 = "D9"
        case _84 = "D6"
        case _83 = "D4"
        case _82 = "D1"
        case _81 = "CF"
        case _80 = "CC"
        case _79 = "C9"
        case _78 = "C7"
        case _77 = "C4"
        case _76 = "C2"
        case _75 = "BF"
        case _74 = "BD"
        case _73 = "BA"
        case _72 = "B8"
        case _71 = "B5"
        case _70 = "B3"
        case _69 = "B0"
        case _68 = "AD"
        case _67 = "AB"
        case _66 = "A8"
        case _65 = "A6"
        case _64 = "A3"
        case _63 = "A1"
        case _62 = "9E"
        case _61 = "9C"
        case _60 = "99"
        case _59 = "96"
        case _58 = "94"
        case _57 = "91"
        case _56 = "8F"
        case _55 = "8C"
        case _54 = "8A"
        case _53 = "87"
        case _52 = "85"
        case _51 = "82"
        case _50 = "80"
        case _49 = "7D"
        case _48 = "7A"
        case _47 = "78"
        case _46 = "75"
        case _45 = "73"
        case _44 = "70"
        case _43 = "6E"
        case _42 = "6B"
        case _41 = "69"
        case _40 = "66"
        case _39 = "63"
        case _38 = "61"
        case _37 = "5E"
        case _36 = "5C"
        case _35 = "59"
        case _34 = "57"
        case _33 = "54"
        case _32 = "52"
        case _31 = "4F"
        case _30 = "4D"
        case _29 = "4A"
        case _28 = "47"
        case _27 = "45"
        case _26 = "42"
        case _25 = "40"
        case _24 = "3D"
        case _23 = "3B"
        case _22 = "38"
        case _21 = "36"
        case _20 = "33"
        case _19 = "30"
        case _18 = "2E"
        case _17 = "2B"
        case _16 = "29"
        case _15 = "26"
        case _14 = "24"
        case _13 = "21"
        case _12 = "1F"
        case _11 = "1C"
        case _10 = "1A"
        case _9 = "17"
        case _8 = "14"
        case _7 = "12"
        case _6 = "0F"
        case _5 = "0D"
        case _4 = "0A"
        case _3 = "08"
        case _2 = "05"
        case _1 = "03"
        case _0 = "00"
    }
}

