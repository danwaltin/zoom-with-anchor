//
//  BuiltInScroller.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

fileprivate let unzoomedContentWidth: CGFloat = 250
fileprivate let contentHeight: CGFloat = 50

fileprivate let viewPortWidth: CGFloat = 200
fileprivate let viewPortHeight: CGFloat = 100

struct BuiltInScroller: View {
	let settings: Settings
	@Bindable var scrollState: ScrollState
	
	@State var contentWidth = unzoomedContentWidth
	@State var anchorViewLeftPosition: CGFloat = 0
	
	@State var anchorViewPortOffset: CGFloat = 0
	@State var anchorContentOffset: CGFloat = 0
	
	var body: some View {
		VStack {
			Zoomer(
				zoom: $scrollState.zoom,
				settings: settings)
			.frame(width: 200)
			
			
			ScrollViewReader { reader in
				Button("Scroll to zoom anchor") {
					let relativeAnchorPosition = anchorViewPortOffset / viewPortWidth
					reader.scrollTo("qwerty123", anchor: .init(x: relativeAnchorPosition, y: 0.5))
				}
				ZStack {
					ScrollView(.horizontal) {
						ZStack {
							HStack(spacing: 0) {
								Rectangle()
									.frame(width: max(0, anchorViewLeftPosition))
									.foregroundStyle(.gray)
								
								Rectangle()
									.frame(width: viewPortWidth)
									.foregroundStyle(.green)
									.id("qwerty123")
								
								Spacer()
//								Rectangle()
//									.frame(width: max(0, contentWidth - viewPortWidth - anchorViewLeftPosition))
//									.foregroundStyle(.gray)
							}
							.opacity(0.1)

							Ruler(
								numberOfSegments: 10,
								color: .green)
							.frame(width: contentWidth, height: contentHeight)
							.background(
								scrollOffsetReader(coordinateSpace: "scrollCoordinateSpace")
							)
							.onPreferenceChange(ScrollViewHorizontalOffsetKey.self) {
								scrollState.scrollOffset = $0
							}
						}
					}
					.scrollClipDisabled(true)
					.frame(width: viewPortWidth, height: viewPortHeight)
					.border(.gray)
					.coordinateSpace(name: "scrollCoordinateSpace")
					.onChange(of: scrollState.zoom) { oldZoom, newZoom in
						contentWidth = newZoom * unzoomedContentWidth
						anchorViewLeftPosition = newZoom * anchorContentOffset
					}
					
					Anchor(
						height: viewPortHeight,
						offsetX: $anchorViewPortOffset)
					.frame(width: viewPortWidth, height: viewPortHeight)
				}
			}
		}
		.onChange(of: anchorViewPortOffset) {
			updateAnchorPosition()
		}
		.onChange(of: scrollState.scrollOffset) {
			updateAnchorPosition()
		}
	}
	
	private func updateAnchorPosition() {
		anchorViewLeftPosition = scrollState.scrollOffset
		anchorContentOffset = scrollState.scrollOffset + anchorViewPortOffset
	}
}

#Preview {
	BuiltInScroller(settings: .init(), scrollState: .init())
}
