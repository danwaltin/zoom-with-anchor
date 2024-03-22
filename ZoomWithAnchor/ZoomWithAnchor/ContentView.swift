//
//  ContentView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-02-29.
//

import SwiftUI

fileprivate let unzoomedContentWidth: CGFloat = 400
fileprivate let contentHeight: CGFloat = 50

fileprivate let viewPortWidth: CGFloat = 300
fileprivate let viewPortHeight: CGFloat = 100

struct ContentView: View {
	@State var zoom: Double = Zoomer.noZoom
	
	@State var contentWidth = unzoomedContentWidth
	@State var anchorViewPortOffset: CGFloat = 0

	var body: some View {
		VStack {
			Zoomer(
				zoom: $zoom)
			.frame(width: viewPortWidth)
			
			ZStack {
				ScrollView(.horizontal) {
					Ruler(numberOfSegments: 10, zoom: zoom)
					.frame(width: contentWidth, height: contentHeight)
				}
				.scrollClipDisabled(true)
				.frame(width: viewPortWidth, height: viewPortHeight)
				.border(.gray)
				.onChange(of: zoom) {
					contentWidth = zoom * unzoomedContentWidth
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

