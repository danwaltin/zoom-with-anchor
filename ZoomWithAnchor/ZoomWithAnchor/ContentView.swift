//
//  ContentView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-02-29.
//

import SwiftUI

protocol ZoomSettings {
	var minZoom: Double {get}
	var maxZoom: Double {get}
}

struct ContentView: View {
	
	private static let noZoom: Double = 1
	
	@State var settings = Settings()
	
	@State var zoom: Double = noZoom
	@State var scrollOffset: CGFloat = 0
	
	@State private var showSettings = true
	
	var body: some View {
		VStack {
			Zoomer(
				zoom: $zoom,
				settings: settings)
			.frame(width: 200)
			ScrollingViewPort(
				contentWidth: zoomedWidth,
				scrollOffset: scrollOffset,
				settings: settings)
			Scroller(
				scrollOffset: $scrollOffset,
				maxScrollOffset: zoomedWidth - settings.viewPortVisibleWidth)
			.frame(width: 400)
		}
		.inspector(isPresented: $showSettings) {
			SettingsInspector(settings: settings)
		}
		.toolbar(content: {
			Spacer()
			Button {
				showSettings.toggle()
			} label: {
				Image(systemName: "sidebar.trailing")
			}
		})
	}
	
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * zoom
	}
}

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
	ContentView()
}

