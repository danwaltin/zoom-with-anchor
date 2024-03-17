//
//  BuiltInScroller.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct BuiltInScroller: View {
	let settings: Settings
	@Bindable var scrollState: ScrollState
	
	var body: some View {
		ScrollViewReader { reader in
			Ruler(
				anchorId: "anchor2",
				relativeAnchorPosition: calculateRelativeAnchorPositionInContent(),
				numberOfSegments: 10,
				color: .green,
				width: zoomedWidth,
				height: settings.contentHeight)
//			.scrollable(scrollViewPosition: $scrollState.scrollViewOffset)
			.border(.gray)
			.frame(width: settings.viewPortVisibleWidth)
			Button("Goto anchor") {
				reader.scrollTo("anchor2")
			}
		}
	}
	
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * scrollState.zoom
	}

	private func calculateRelativeAnchorPositionInContent() -> CGFloat{
		(scrollState.scrollOffset + scrollState.anchorPositionInViewPort) / zoomedWidth
	}
	
}

#Preview {
	BuiltInScroller(settings: .init(), scrollState: .init())
}
