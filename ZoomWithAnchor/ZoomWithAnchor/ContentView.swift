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
	
	@State var contentWidth = unzoomedContentWidth
	@State var anchorViewPortOffset: CGFloat = 0

	@State var anchorPaddingWidth: CGFloat = 0
	
	@State var scrollViewPosition: CGPoint = .zero

	var body: some View {
		VStack {
			Zoomer(
				zoom: $zoom)
			.frame(width: viewPortWidth)
			
			
			ZStack {
				ScrollViewReader { scrollProxy in
					ScrollView(.horizontal) {
						ZStack {
							GeometryReader { g in
								HStack(spacing: 0) {
									Rectangle()
										.frame(width: anchorPaddingWidth, height: 100)
										.foregroundStyle(.yellow)
									Rectangle()
										.id("scrollAnchor")
										.frame(width: 10, height: 100)
										.background(.gray)
								}
							}
							Ruler(numberOfSegments: 10, zoom: zoom)
								.frame(width: contentWidth, height: contentHeight)
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
					.scrollClipDisabled(true)
					.frame(width: viewPortWidth, height: viewPortHeight)
					.border(.gray)
					.onChange(of: zoom) { oldZoom, newZoom in
						contentWidth = newZoom * unzoomedContentWidth
						let offset = (newZoom / oldZoom) * (scrollViewPosition.x + anchorViewPortOffset) - anchorViewPortOffset
 						anchorPaddingWidth = max(0, offset)
					}
					.onChange(of: anchorPaddingWidth) {
						scrollProxy.scrollTo("scrollAnchor", anchor: .leading)
					}
				}
				Anchor(
					height: viewPortHeight,
					offsetX: $anchorViewPortOffset)
				.frame(width: viewPortWidth, height: viewPortHeight)
			}
		}
	}
}

#Preview {
	ContentView()
}

