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
			ScrollView(.horizontal) {
				Ruler(
					anchorId: "anchor2",
					relativeAnchorPosition: calculateRelativeAnchorPositionInContent(),
					numberOfSegments: 10,
					color: .green,
					width: zoomedWidth,
					height: settings.contentHeight)
				.background(
					scrollOffsetReader(coordinateSpace: "scrollCoordinateSpace")
				)
				.onPreferenceChange(ScrollViewHorizontalOffsetKey.self) {
					scrollState.scrollOffset = $0
				}
			}
			.frame(width: settings.viewPortVisibleWidth, height: settings.contentHeight)
			.border(.gray)
			Button("Goto anchor") {
				reader.scrollTo("anchor2")
			}
			.coordinateSpace(name: "scrollCoordinateSpace")
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
