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
						ZStack {
							HStack(spacing: 0) {
								Rectangle()
									.frame(width: max(0, scrollState.scrollOffset))
									.foregroundStyle(.gray)
								
								Rectangle()
									.frame(width: settings.viewPortVisibleWidth)
									.foregroundStyle(.green)
									.id("qwerty123")
								
								Rectangle()
									.frame(width: max(0, zoomedWidth - settings.viewPortVisibleWidth - scrollState.scrollOffset))
									.foregroundStyle(.gray)
							}
							
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
					}
					.scrollClipDisabled(true)
					.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
					.border(.gray)
					.coordinateSpace(name: "scrollCoordinateSpace")
					.onChange(of: scrollState.zoom) { old, new in
						print("""
	  old zoom    : \(old)
	  new zoom    : \(new)
	  zoomed width: \(zoomedWidth)
	  """)
						reader.scrollTo("qwerty123", anchor: .init(x: scrollState.relativeAnchorPositionInContent, y: 0.5))
					}
					
					Anchor(
						height: settings.viewPortHeight,
						offsetX: $scrollState.anchorPositionInViewPort)
					.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
					.border(.red)
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
