import SwiftUI
import UIKit

enum AppColor {
    static let blue = Color(uiColor: .appBlue)
    static let gray = Color(uiColor: .appGray)
    static let red = Color(uiColor: .appRed)
    static let lightGray = Color(red: 230 / 255, green: 232 / 255, blue: 235 / 255)

    static let background = Color(uiColor: .appBackground)
    static let text = Color(uiColor: .appText)
    static let searchBar = Color(uiColor: .appSearchBar)

    static let white = Color.white
    static let black = Color(red: 29 / 255, green: 27 / 255, blue: 32 / 255)
    static let card = Color(red: 247 / 255, green: 247 / 255, blue: 248 / 255)
}

extension UIColor {
    static let appBlue = UIColor(red: 55 / 255, green: 114 / 255, blue: 229 / 255, alpha: 1)
    static let appGray = UIColor(red: 174 / 255, green: 175 / 255, blue: 180 / 255, alpha: 1)
    static let appRed = UIColor(red: 245 / 255, green: 107 / 255, blue: 108 / 255, alpha: 1)

    static let appBackground = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 1)
            : .white
    }

    static let appText = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? .white
            : UIColor(red: 29 / 255, green: 27 / 255, blue: 32 / 255, alpha: 1)
    }

    static let appSearchBar = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 46 / 255, green: 47 / 255, blue: 53 / 255, alpha: 1)
            : UIColor(red: 118 / 255, green: 118 / 255, blue: 128 / 255, alpha: 0.12)
    }
}

@MainActor
enum AppAppearance {
    static func configure() {
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = .appBackground
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab
        UITabBar.appearance().unselectedItemTintColor = .appGray

        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = .appBackground
        nav.shadowColor = .clear
        nav.titleTextAttributes = [.foregroundColor: UIColor.appText]
        nav.largeTitleTextAttributes = [.foregroundColor: UIColor.appText]
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance = nav
        UINavigationBar.appearance().tintColor = .appText
    }
}
