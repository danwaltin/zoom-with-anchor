//
//  ContentView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-02-29.
//

import SwiftUI

struct Settings {
	
}
struct ContentView: View {
	
	private static let noZoom: Double = 1
	private let minZoom: Double = 0.5
	private let maxZoom: Double = 2
	
	@State var zoom: Double = noZoom

	var body: some View {
		Zoomer(zoom: $zoom, minZoom: minZoom, maxZoom: maxZoom)
			.frame(width: 200)
		ScrollingViewPort()
	}
}

struct ScrollingViewPort: View {
	private let viewPortVisibleWidth: CGFloat = 150
	private let viewPortHeight: CGFloat = 100
	private let rulerWidth: CGFloat = 400
	private let rulerHeight: CGFloat = 50
	
	@State var scrollOffset: CGFloat = 0
	
	var body: some View {
		ZStack {
			Ruler(numberOfSegments: 10, color: .green, width: rulerWidth, height: rulerHeight)
				.border(.gray)
				.offset(.init(width: rulerOffset, height: 0))
			viewPort(visibleWidth: viewPortVisibleWidth, totalWidth: viewPortVisibleWidth + 2 * rulerWidth, height: viewPortHeight)
		}
		.frame(width: 2 * max(viewPortVisibleWidth, rulerWidth))

		Scroller(scrollOffset: $scrollOffset, maxScrollOffset: rulerWidth)
			.frame(width: 400)

	}
	
	private var rulerOffset: CGFloat {
		rulerWidth / 2 - viewPortVisibleWidth / 2 - scrollOffset
	}
	
	@ViewBuilder
	private func viewPort(visibleWidth: CGFloat, totalWidth: CGFloat, height: CGFloat) -> some View {
		HStack(spacing: 0) {
			viewPortSegment(width: totalWidth / 2 - visibleWidth / 2, height: height, opacity: 0.8)
			viewPortSegment(width: visibleWidth, height: height, opacity: 0.0)
				.border(Color(white: 0.8))
			
			viewPortSegment(width: totalWidth / 2 - visibleWidth / 2 , height: height, opacity: 0.8)
		}
	}
	
	@ViewBuilder
	private func viewPortSegment(width: CGFloat, height: CGFloat, opacity: Double) -> some View {
		Path()
			.frame(width: width, height: height)
			.background(
				Rectangle()
					.fill(.background)
					.opacity(opacity)
			)
	}

}

#Preview {
	ContentView()
		.padding()
}

