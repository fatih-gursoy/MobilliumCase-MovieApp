//
//  String+Extension.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import Foundation
import UIKit

extension String {
    
    func dateFormatter() -> String? {
        let dt = DateFormatter()
        dt.dateFormat = "yyyy-MM-dd"
        guard let formalDate = dt.date(from: self) else {return nil}
        dt.dateFormat = "dd.MM.yyyy"
        return dt.string(from: formalDate)
    }
    
    func customAttributedText(withString string: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: font,
                                                                                      NSAttributedString.Key.foregroundColor : UIColor.appDarkGray])
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0, length: 3))
        return attributedString
    }
}
