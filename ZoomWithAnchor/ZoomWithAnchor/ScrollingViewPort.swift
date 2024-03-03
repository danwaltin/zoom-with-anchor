//
//  ScrollingViewPort.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-02.
//

import SwiftUI

struct ScrollingViewPort: View {
	let contentWidth: CGFloat
	let scrollOffset: CGFloat
	let settings: Settings
	
	var body: some View {
		ZStack {
			Ruler(
				numberOfSegments: 10,
				color: .green,
				width: contentWidth,
				height: settings.contentHeight)
			.border(.gray)
			.offset(.init(width: rulerOffset, height: 0))
			viewPort()
		}
		.frame(width: 2 * max(settings.viewPortVisibleWidth, contentWidth))
	}
	
	private var rulerOffset: CGFloat {
		contentWidth / 2 - settings.viewPortVisibleWidth / 2 - scrollOffset
	}
	
	@ViewBuilder
	private func viewPort() -> some View {
			ZStack {
				HStack(spacing: 0) {
					viewPortSegment(
						width: settings.maxContentWidth - settings.viewPortVisibleWidth,
						height: settings.viewPortHeight,
						opacity: 0.6)
					
					viewPortSegment(
						width: settings.viewPortVisibleWidth,
						height: settings.viewPortHeight,
						opacity: 0.0)
					.border(Color(white: 0.8))
					
					viewPortSegment(
						width: settings.maxContentWidth - settings.viewPortVisibleWidth,
						height: settings.viewPortHeight,
						opacity: 0.6)
				}
				GeometryReader { g in
					PlayHeadView(
						height: settings.viewPortHeight,
						offsetX: settings.maxContentWidth - settings.viewPortVisibleWidth,
						offsetY: g.size.height / 2 - settings.viewPortHeight / 2)
					.border(.red)
					
				}
		}
	}
	
	@ViewBuilder
	private func viewPortSegment(width: CGFloat, height: CGFloat, opacity: Double) -> some View {
		Path()
			.frame(width: max(0, width), height: height)
			.background(
				Rectangle()
					.fill(.background)
					.opacity(opacity)
			)
	}
	
}

#Preview {
	ScrollingViewPort(contentWidth: 200, scrollOffset: 0, settings: Settings())
}
