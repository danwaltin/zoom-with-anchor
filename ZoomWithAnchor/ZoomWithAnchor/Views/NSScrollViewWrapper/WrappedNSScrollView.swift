//
//  WrappedNSScrollView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

fileprivate class ScrollViewContainer: ObservableObject {
	var scrollView: NSScrollView?
}

struct NSScrollViewWrapper<Content: View>: NSViewRepresentable {
	typealias NSViewType = NSScrollView
	
	@Binding var contentWidth: CGFloat
	
	@ViewBuilder var content: Content
	
	@StateObject fileprivate var scrollViewContainer = ScrollViewContainer()
	
	func makeNSView(context: Context) -> NSScrollView {
		let view = NSScrollView()
		
		// Configure your NSScrollView here
		// For example:
		view.hasHorizontalScroller = true
		view.hasVerticalScroller = false
		view.autohidesScrollers = false
		
		let document = NSHostingView(rootView: content)
		document.translatesAutoresizingMaskIntoConstraints = false
		view.documentView = document
		
		scrollViewContainer.scrollView = view
		view.contentView.clipsToBounds = false
		return view
	}
		
	func updateNSView(_ nsView: NSScrollView, context: Context) {
		// You might update the NSScrollView here based on changes in the SwiftUI view
		// For example, you could adjust scroller visibility or content size dynamically
		// This method is called when the SwiftUI view needs to be updated.

		let currentBounds = nsView.contentView.bounds
		let newBoundsSize = NSSize(width: max(0, currentBounds.width - 10), height: currentBounds.height)
		let newBoundsOrigin = NSPoint(x: currentBounds.origin.x + 10, y: currentBounds.origin.y)
		nsView.contentView.setBoundsSize(newBoundsSize)
		nsView.contentView.setBoundsOrigin(newBoundsOrigin)
	}
}
struct WrappedNSScrollView: View {
	let settings: Settings
	@Bindable var scrollState: ScrollState

	@State var zoomedWidth: CGFloat = 250
	
	init(settings: Settings, scrollState: ScrollState) {
		self.settings = settings
		self.scrollState = scrollState
		self.zoomedWidth = settings.contentUnzoomedWidth * scrollState.zoom
	}
	
	var body: some View {
		VStack {
			Zoomer(
				zoom: $scrollState.zoom,
				settings: settings)
			.frame(width: 200)
			.onChange(of: scrollState.zoom) {
				zoomedWidth = settings.contentUnzoomedWidth * scrollState.zoom
			}
			NSScrollViewWrapper(contentWidth: $zoomedWidth) {
				Ruler(
					numberOfSegments: 10,
					color: .green)
				.frame(width: zoomedWidth, height: settings.contentHeight)
				.border(.red)
			}
			.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
		}
	}
}

#Preview {
    WrappedNSScrollView(settings: .init(), scrollState: .init())
}
