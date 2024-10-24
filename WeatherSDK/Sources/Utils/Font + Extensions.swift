//
//  Font + Extensions.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 20.10.24.
//

import SwiftUI

extension UIFont {
    static var navigationTitle: UIFont? {
        return UIFont.systemFont(ofSize: 16)
    }
}

extension Font {
    static var header: Font {
        return Font.system(size: 28,
                           weight: .bold)
    }

    static var h2: Font {
        return Font.system(size: 20,
                           weight: .bold)
    }

    static var title: Font {
        return Font.system(size: 16,
                           weight: .bold)
    }

    static var textRegular: Font {
        return Font.system(size: 16,
                           weight: .regular)
    }

    static var label: Font {
        return Font.system(size: 12,
                           weight: .regular)
    }
}
