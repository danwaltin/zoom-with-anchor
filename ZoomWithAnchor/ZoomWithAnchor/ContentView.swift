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
	@State var scrollStateHomeMade = ScrollState()
	@State var scrollStateBuiltIn = ScrollState()

	@State private var showSettings = true
	
	var body: some View {
		
		VSplitView {
			GeometryReader{ g in
				BuiltInScroller(settings: settings, scrollState: scrollStateBuiltIn)
					.frame(width: g.size.width, height: g.size.height)
			}
		}
		.inspector(isPresented: $showSettings) {
			Inspector(settings: settings, 
					  scrollStateBuiltIn: scrollStateBuiltIn) {
				settings.resetToDefault()
				scrollStateBuiltIn.resetToDefault()
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
}

#Preview {
	ContentView()
}

