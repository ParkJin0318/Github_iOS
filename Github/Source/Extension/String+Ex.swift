//
//  String+Ex.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit

extension String {
    
    func toAttributed(color: UIColor, font: UIFont, align: NSTextAlignment = .left) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = align
            
        return NSAttributedString(string: self,
                                  attributes: [NSAttributedString.Key.font: font,
                                               NSAttributedString.Key.foregroundColor: color,
                                               NSAttributedString.Key.paragraphStyle: paragraph])
    }
}
