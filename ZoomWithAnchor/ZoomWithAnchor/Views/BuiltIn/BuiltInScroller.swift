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
	
	@State var zoomedWidth: CGFloat

	init(settings: Settings, scrollState: ScrollState) {
		self.settings = settings
		self.scrollState = scrollState
		self.zoomedWidth = settings.contentUnzoomedWidth * scrollState.zoom
	}

	var body: some View {
		VStack {
			Zoomer(
				zoom: $scrollState.zoom,
				settings: settings)
			.frame(width: 200)
			.onChange(of: scrollState.zoom) {
				zoomedWidth = settings.contentUnzoomedWidth * scrollState.zoom
			}

			ScrollViewReader { reader in
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
			}
		}
	}
}

#Preview {
	BuiltInScroller(settings: .init(), scrollState: .init())
}
