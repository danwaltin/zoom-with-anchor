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

	let relativeAnchorPositionInContent: CGFloat
	@Binding var anchorPositionInViewPort: CGFloat
	
	var body: some View {
		ZStack {
			scrollViewContent()
			viewPort()
		}
		.frame(width: 2 * max(settings.viewPortVisibleWidth, contentWidth))
		.onChange(of: anchorPositionInViewPort) {
			assureAnchorWithinVisibleView()
		}
		.onChange(of: settings.viewPortVisibleWidth) {
			assureAnchorWithinVisibleView()
		}
	}
	
	private func assureAnchorWithinVisibleView() {
		if anchorPositionInViewPort > settings.viewPortVisibleWidth {
			anchorPositionInViewPort = settings.viewPortVisibleWidth
		}
		if anchorPositionInViewPort < 0 {
			anchorPositionInViewPort = 0
		}

	}
	
	private var rulerOffset: CGFloat {
		contentWidth / 2 - settings.viewPortVisibleWidth / 2 - scrollOffset
	}
	
	@ViewBuilder
	private func scrollViewContent() -> some View {
		Ruler(
			anchorId: "ankare",
			relativeAnchorPosition: 0,
			numberOfSegments: 10,
			color: .green,
			width: contentWidth,
			height: settings.contentHeight)
		.border(.gray)
		.offset(.init(width: rulerOffset, height: 0))
	}

	@ViewBuilder
	private func viewPort() -> some View {
		HStack(spacing: 0) {
			viewPortSegment(
				width: settings.maxContentWidth - settings.viewPortVisibleWidth,
				height: settings.viewPortHeight,
				opacity: 0.6)
			
			ZStack {
				viewPortSegment(
					width: settings.viewPortVisibleWidth,
					height: settings.viewPortHeight,
					opacity: 0.0)
				.border(Color(white: 0.8))
				Anchor(
					height: settings.viewPortHeight,
					offsetX: $anchorPositionInViewPort)
				.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
			}
			viewPortSegment(
				width: settings.maxContentWidth - settings.viewPortVisibleWidth,
				height: settings.viewPortHeight,
				opacity: 0.6)
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
	ScrollingViewPort(contentWidth: 200,
					  scrollOffset: 0,
					  settings: Settings(),
					  relativeAnchorPositionInContent: 0,
					  anchorPositionInViewPort: .constant(0))
}