//
//  String + Extensions.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 21.10.24.
//

import Foundation

extension String {
    var formatTime: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    var formatTimeHoursAndMinutes: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    var localized: String {
        let defaultLanguage = "en"
        if let path = Bundle.sdkBundle.path(forResource: Locale.current.language.languageCode?.identifier, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        } else if let path = Bundle.sdkBundle.path(forResource: defaultLanguage, ofType: "lproj"),
                  let defaultBundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: defaultBundle, comment: "")
        } else {
            return self
        }
    }
}
