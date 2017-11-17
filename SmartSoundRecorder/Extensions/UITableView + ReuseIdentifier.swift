//
//  UICollectionView + ReuseIdentifier.swift
//  Syndicate
//
//  Created by Dmitriy on 9/12/17.
//  Copyright © 2017 izidev. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public static var reuseID: String {
        return String(describing: self)
    }
}
