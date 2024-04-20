//
//  ContentView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-02-29.
//

import SwiftUI

fileprivate let unzoomedContentWidth: CGFloat = 400
fileprivate let contentHeight: CGFloat = 50

let viewPortWidth: CGFloat = 300
let viewPortHeight: CGFloat = 100

struct ContentView: View {
	@State var zoom: Double = Zoomer.noZoom
	@State var isLiveZooming = false

	@State var contentWidth = unzoomedContentWidth
	@State var anchorViewPortOffset: CGFloat = 0

	@State var anchorPaddingWidth: CGFloat = 0
	@State var contentOffset: CGFloat = 0
	
	@State var scrollViewPosition: CGPoint = .zero

	@State var clipScrollContent = true
	
	var body: some View {
		VStack {
			Zoomer(
				zoom: $zoom,
				isLiveZooming: $isLiveZooming)
			.frame(width: viewPortWidth)
			
			Toggle("Show entire content", isOn: $clipScrollContent)
			
			ZStack {
				ScrollViewReader { scrollProxy in
					ScrollView(.horizontal) {
						ZStack {
							GeometryReader { g in
								HStack(spacing: 0) {
									Rectangle()
										.frame(width: max(0, anchorPaddingWidth), height: 100)
										.foregroundStyle(.yellow)
									Rectangle()
										.id("scrollAnchor")
										.frame(width: 10, height: 100)
										.background(.gray)
								}
							}
							Ruler(numberOfSegments: 10, zoom: zoom)
								.gesture(pinchToZoom)
								.frame(width: contentWidth, height: contentHeight)
								.offset(x: -contentOffset)
						}
						.background(
							scrollOffsetReader(coordinateSpace: "scrollCoordinateSpace")
						)
						.onPreferenceChange(ScrollViewHorizontalOffsetKey.self) {
							scrollViewPosition.x = $0
						}
						.onPreferenceChange(ScrollViewVerticalOffsetKey.self) {
							scrollViewPosition.y = $0
						}
					}
					.coordinateSpace(name: "scrollCoordinateSpace")
					.scrollClipDisabled(clipScrollContent)
					.frame(width: viewPortWidth, height: viewPortHeight)
					.border(.gray)
					.onChange(of: zoom) { oldZoom, newZoom in
						contentWidth = newZoom * unzoomedContentWidth
						if isLiveZooming {
							let offset = (newZoom / oldZoom) * (contentOffset + scrollViewPosition.x + anchorViewPortOffset) - (scrollViewPosition.x + anchorViewPortOffset)
							contentOffset = offset
						}
												
						let offset = (newZoom / oldZoom) * (scrollViewPosition.x + anchorViewPortOffset) - anchorViewPortOffset
						anchorPaddingWidth = max(0, offset)
					}
					.onChange(of: isLiveZooming) {
						if !isLiveZooming {
							anchorPaddingWidth += contentOffset
						}
						contentOffset = 0
					}
					.onChange(of: anchorPaddingWidth) {
						if !isLiveZooming {
							scrollProxy.scrollTo("scrollAnchor", anchor: .leading)
						}
					}
				}
				Anchor(
					height: viewPortHeight,
					offsetX: $anchorViewPortOffset)
				.frame(width: viewPortWidth, height: viewPortHeight)
			}
		}
	}
	
	@State var pinchStart: Double = 0
	
	var pinchToZoom: some Gesture {
		MagnificationGesture()
			.onChanged { amount in
				if pinchStart == 0 { // detect when we start a new pinch gesture
					pinchStart = zoom
					isLiveZooming = true
				}
				
				if amount >= 1 {
					// increasing the zoom value
					zoom = amount - 1 + pinchStart
				} else {
					// decreasing the zoom value
					// here we shall go from pinchStart, which can be > 1, to zero
					zoom = pinchStart * amount
				}
			}
			.onEnded { amount in
				pinchStart = 0
				isLiveZooming = false
			}
	}

}

#Preview {
	ContentView()
}

