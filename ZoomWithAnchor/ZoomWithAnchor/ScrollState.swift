//
//  ScrollState.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-15.
//

import Foundation

struct ScrollState {
	var anchorPositionInViewPort: CGFloat = 0
	var relativeAnchorPositionInViewPort: CGFloat = 0
	var relativeAnchorPositionInContent: CGFloat = 0
	var zoom: Double = 1
	var scrollOffset: CGFloat = 0
	
	mutating func resetToDefault() {
		anchorPositionInViewPort = 0
		relativeAnchorPositionInViewPort = 0
		relativeAnchorPositionInContent = 0
		zoom = 1
		scrollOffset = 0
	}
}
