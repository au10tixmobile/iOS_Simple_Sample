//

//  Copyright © 2019 Anton Sakovych. All rights reserved.
//

import UIKit

extension String {
    
    var capitalizedFirstChar: String {
        guard let firstChar = first else {
            return ""
        }
        return String(firstChar).uppercased() + dropFirst()
    }
    
    var noNilFloat: Float {
        return Float(decimalDigits()) ?? 0
    }
    
    var noNilInteger: Int {
        return Int(decimalDigits()) ?? 0
    }
    
    var floatValue: Float? {
        return Float(decimalDigits())
    }
    
    var underlined: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    var mutAttributed: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    var creditCardFormated: String {
        return inserting(separator: " ", every: 4)
    }
    
    mutating func insert(separator: String, every n: Int, reversed: Bool = false) {
        if reversed {
            self = String(String(self.reversed()).inserting(separator: separator, every: n).reversed())
        } else {
            for index in indices.reversed() where index != startIndex &&
                distance(from: startIndex, to: index) % n == 0 {
                    insert(contentsOf: separator, at: index)
            }
        }
    }
    
    func inserting(separator: String, every n: Int, reversed: Bool = false) -> String {
        var string = self
        string.insert(separator: separator, every: n, reversed: reversed)
        return string
    }
    
    func digitsOnly() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func decimalDigits() -> String {
        return components(separatedBy: CharacterSet.init(charactersIn: "0123456789.").inverted).joined()
    }
    
    func width(withConstraintedHeight height: CGFloat = .greatestFiniteMagnitude, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func height(withConstrainedWidth width: CGFloat = .greatestFiniteMagnitude, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func size(with font: UIFont,
              width: CGFloat = .greatestFiniteMagnitude,
              height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        
        return CGSize(width: self.width(withConstraintedHeight: height, font: font),
                      height: self.height(withConstrainedWidth: width, font: font))
    }
    
    func attributedTextWith(font: UIFont,
                            color: UIColor,
                            withLetter spacing: CGFloat = -0.41) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes([.kern: spacing, .font: font, .foregroundColor: color], range: range)
        return attributedString
    }

    func replaceStringTaget(by start: String = "<§", end: String = "§>", toNewFont: UIFont, mainFont: UIFont) -> NSAttributedString {
        var indices = [String]()
        var selfCopied = self
        var position = selfCopied.startIndex

        while let startRangeIndex = selfCopied.range(of: start, range: position..<endIndex),
            let endRangeIndex = selfCopied.range(of: end, range: startRangeIndex.upperBound..<endIndex) {
                let startRange = startRangeIndex.upperBound
                let endRange = endRangeIndex.lowerBound
                
                if startRange != endRange {
                    indices.append(String(selfCopied[startRange..<endRange]))
                }
                let offset = end.distance(from: end.startIndex, to: end.endIndex) - 1
                guard let after = index(endRange, offsetBy: offset, limitedBy: endIndex) else {
                    break
                }
                position = index(after: after)
        }
        
        selfCopied = selfCopied.replacingOccurrences(of: start, with: "").replacingOccurrences(of: end, with: "")

        let attributedResult = selfCopied.attributedTextWith(font: mainFont, color: .black)
        
        indices.forEach({ string in
            let range = (selfCopied as NSString).range(of: string)
            attributedResult.addAttribute(.font, value: toNewFont, range: range)
        })

        return attributedResult
    }
}

extension NSAttributedString {
    
    func width(withConstraintedHeight height: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func height(withConstrainedWidth width: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func size(with font: UIFont, width: CGFloat = 0, height: CGFloat = 0) -> CGSize {
        let width = width == 0 ? CGFloat.greatestFiniteMagnitude : width
        let height = height == 0 ? CGFloat.greatestFiniteMagnitude : height
        
        return CGSize(width: self.width(withConstraintedHeight: height),
                      height: self.height(withConstrainedWidth: width))
    }

}

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        guard let self = self else {
            return true
        }
        return self.isEmpty
    }
    
    var floatValue: Float? {
        return self?.floatValue
    }
    
    var noNilFloat: Float {
        return self?.noNilFloat ?? 0
    }
    
    var noNilInteger: Int {
        return self?.noNilInteger ?? 0
    }
}
