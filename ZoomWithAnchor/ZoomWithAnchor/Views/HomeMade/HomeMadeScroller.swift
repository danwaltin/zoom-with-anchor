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
		VStack {
			Zoomer(
				zoom: $scrollState.zoom,
				settings: settings)
			.frame(width: 200)

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
		.onChange(of: scrollState.anchorPositionInViewPort) {
			updateAnchorPosition()
		}
		.onChange(of: scrollState.zoom) { oldZoom, newZoom in
			let oldContentWidth = settings.contentUnzoomedWidth * oldZoom
			let relativeContentAnchor = (scrollState.scrollOffset + scrollState.anchorPositionInViewPort) / oldContentWidth
			
			let newContentWidth = settings.contentUnzoomedWidth * newZoom
			let newScrollOffset = relativeContentAnchor * newContentWidth - scrollState.anchorPositionInViewPort
			scrollState.scrollOffset = newScrollOffset
			updateAnchorPosition()
		}
		.onChange(of: scrollState.scrollOffset) {
			updateAnchorPosition()
		}

	}
	
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * scrollState.zoom
	}

	private func updateAnchorPosition() {
		scrollState.relativeAnchorPositionInViewPort = scrollState.anchorPositionInViewPort / settings.viewPortVisibleWidth
		scrollState.relativeAnchorPositionInContent = calculateRelativeAnchorPositionInContent()
	}

	private func calculateRelativeAnchorPositionInContent() -> CGFloat{
		(scrollState.scrollOffset + scrollState.anchorPositionInViewPort) / zoomedWidth
	}
}

#Preview {
	HomeMadeScroller(settings: .init(), scrollState: .init())
}
