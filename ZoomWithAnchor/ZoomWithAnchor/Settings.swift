//
//  Settings.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-02.
//

import Foundation

fileprivate let defaultViewPortVisibleWidth: CGFloat = 150
fileprivate let defaultContentUnzoomedWidth: CGFloat = 250

@Observable class Settings: ZoomSettings {
	let minViewPortVisibleWidth: CGFloat = 10
	let maxViewPortVisibleWidth: CGFloat = 250
	var viewPortVisibleWidth: CGFloat = defaultViewPortVisibleWidth

	let viewPortHeight: CGFloat = 100

	var minContentUnzoomedWidth: CGFloat = 20
	var maxContentUnzoomedWidth: CGFloat = 300
	var contentUnzoomedWidth: CGFloat = defaultContentUnzoomedWidth

	let contentHeight: CGFloat = 50

	let minZoom: Double = 0.5
	let maxZoom: Double = 2
	
	var maxContentWidth: CGFloat {
		contentUnzoomedWidth * maxZoom
	}
	
	func resetToDefault() {
		viewPortVisibleWidth = defaultViewPortVisibleWidth
		contentUnzoomedWidth = defaultContentUnzoomedWidth
	}
}
