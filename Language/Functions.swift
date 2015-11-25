//
//  Functions.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import Foundation

let images = [UIImage(named: "chinese"), UIImage(named: "korean"), nil, UIImage(named: "gear")]
var titles = ["Chinese", "Korean", "Quiz", "Settings"]
let identifiers = ["ChineseNavigationController", "KoreanNavigationController"]

// Trim duplicates from a sequence without affecting order
func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
    var buffer = [T]()
    var added = Set<T>()
    for elem in source {
        if !added.contains(elem) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
}


// Enable NSDate comparison using comparison symbols
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }




// Tint UIImage
extension UIImage {
    
    func tintWithColor(color:UIColor)->UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -self.size.height)
        
        // multiply blend mode
        CGContextSetBlendMode(context, .Multiply)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}