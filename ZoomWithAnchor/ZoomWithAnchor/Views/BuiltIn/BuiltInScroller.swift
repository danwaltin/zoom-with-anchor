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
		VStack {
			Zoomer(
				zoom: $scrollState.zoom,
				settings: settings)
			.frame(width: 200)

			ScrollViewReader { reader in
				ZStack {
					ScrollView(.horizontal) {
						Ruler(
							numberOfSegments: 10,
							color: .green)
						.frame(width: zoomedWidth, height: settings.contentHeight)
						.background(
							scrollOffsetReader(coordinateSpace: "scrollCoordinateSpace")
						)
						.onPreferenceChange(ScrollViewHorizontalOffsetKey.self) {
							scrollState.scrollOffset = $0
						}
					}
					.scrollClipDisabled(true)
					.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
					.border(.gray)
					.coordinateSpace(name: "scrollCoordinateSpace")
					Anchor(
						height: settings.viewPortHeight,
						offsetX: $scrollState.anchorPositionInViewPort)
					.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
				}
			}
		}
		.onChange(of: scrollState.anchorPositionInViewPort) {
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
	BuiltInScroller(settings: .init(), scrollState: .init())
}
