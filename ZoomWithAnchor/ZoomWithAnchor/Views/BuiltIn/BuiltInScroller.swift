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
				ScrollView(.horizontal) {
					Ruler(
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
				.scrollClipDisabled(true)
				.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
				.border(.gray)
				.coordinateSpace(name: "scrollCoordinateSpace")
			}
		}
	}
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * scrollState.zoom
	}
}

#Preview {
	BuiltInScroller(settings: .init(), scrollState: .init())
}
