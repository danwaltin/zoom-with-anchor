//
//  WrappedNSScrollView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct NSScrollViewWrapper<Content: View>: NSViewRepresentable {
	typealias NSViewType = NSScrollView
	
	var content: Content
	
	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}
	
	func makeNSView(context: Context) -> NSScrollView {
		let view = NSScrollView()
		
		// Configure your NSScrollView here
		// For example:
		view.hasHorizontalScroller = true
		view.hasVerticalScroller = true
		view.autohidesScrollers = false
		
		let document = NSHostingView(rootView: content)
		document.translatesAutoresizingMaskIntoConstraints = false
		view.documentView = document
		
		return view
	}
		
	func updateNSView(_ nsView: NSScrollView, context: Context) {
		// You might update the NSScrollView here based on changes in the SwiftUI view
		// For example, you could adjust scroller visibility or content size dynamically
		// This method is called when the SwiftUI view needs to be updated.
	}
}
struct WrappedNSScrollView: View {
	let settings: Settings
	@Bindable var scrollState: ScrollState

	var body: some View {
		VStack {
			Zoomer(
				zoom: $scrollState.zoom,
				settings: settings)
			.frame(width: 200)
			NSScrollViewWrapper {
				Ruler(
					numberOfSegments: 10,
					color: .green)
				.frame(width: zoomedWidth, height: settings.contentHeight)
			}
			.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
		}
	}
	
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * scrollState.zoom
	}

}

#Preview {
    WrappedNSScrollView(settings: .init(), scrollState: .init())
}
