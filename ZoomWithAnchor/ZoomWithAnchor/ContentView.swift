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
	@State var scrollState: ScrollState = .init()
	
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
				settings: settings,
				anchorPositionInViewPort: $scrollState.anchorPositionInViewPort)
			Scroller(
				scrollOffset: $scrollOffset,
				maxScrollOffset: zoomedWidth - settings.viewPortVisibleWidth)
			.frame(width: 400)
		}
		.inspector(isPresented: $showSettings) {
			GeometryReader { g in
				VStack {
					SettingsInspector(settings: settings)
						.frame(width: g.size.width, height: g.size.height / 2)
					Divider()
					StateInspector(state: scrollState)
						.frame(width: g.size.width, height: g.size.height / 2)
				}
			}
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

#Preview {
	ContentView()
}

