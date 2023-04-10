//
//  CustomPageControl.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 10.04.2023.
//

import UIKit

class CustomPageControl: UIPageControl {
    var currentPageIndicatorSize: CGSize = CGSize(width: 24, height: 8)
    var pageIndicatorSize: CGSize = CGSize(width: 8, height: 8)

    override func layoutSubviews() {
        super.layoutSubviews()

        let totalWidth = CGFloat(numberOfPages - 1) * (pageIndicatorSize.width + 8) + currentPageIndicatorSize.width
        let x = (bounds.width - totalWidth) / 2

        for (index, subview) in subviews.enumerated() {
            let width = index == currentPage ? currentPageIndicatorSize.width : pageIndicatorSize.width
            let height = index == currentPage ? currentPageIndicatorSize.height : pageIndicatorSize.height
            subview.frame = CGRect(x: x + CGFloat(index) * (pageIndicatorSize.width + 8), y: (bounds.height - height) / 2, width: width, height: height)
            subview.layer.cornerRadius = height / 2
            self.setNeedsDisplay()
        }
    }
}

