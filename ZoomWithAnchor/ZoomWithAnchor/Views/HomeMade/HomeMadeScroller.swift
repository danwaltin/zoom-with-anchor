//
//  HomeMadeScroller.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct HomeMadeScroller: View {
	let settings: Settings
	@Bindable var scrollState: ScrollState
	
	var body: some View {
		ScrollingViewPort(
			contentWidth: zoomedWidth,
			scrollOffset: scrollState.scrollOffset,
			settings: settings,
			relativeAnchorPositionInContent: calculateRelativeAnchorPositionInContent(),
			anchorPositionInViewPort: $scrollState.anchorPositionInViewPort)
		Scroller(
			scrollOffset: $scrollState.scrollOffset,
			maxScrollOffset: zoomedWidth - settings.viewPortVisibleWidth)
		.frame(width: 400)
	}
	
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * scrollState.zoom
	}

	private func calculateRelativeAnchorPositionInContent() -> CGFloat{
		(scrollState.scrollViewOffset.x + scrollState.anchorPositionInViewPort) / zoomedWidth
	}
}

#Preview {
	HomeMadeScroller(settings: .init(), scrollState: .init())
}
