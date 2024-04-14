//
//  NSWrappedScrollView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-31.
//

import SwiftUI

fileprivate class ScrollViewContainer: ObservableObject {
	var scrollView: NSScrollView?
}

struct NSScrollViewWrapper<Content: View>: NSViewRepresentable {
	typealias NSViewType = NSScrollView
	
//	@Binding var contentWidth: CGFloat
	
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

		
		//nsView.contentView.setBoundsSize(NSSize(width: contentWidth, height: nsView.contentView.bounds.height))
		//nsView.contentView.setFrameSize(NSSize(width: contentWidth, height: nsView.contentView.frame.height))

//		nsView.documentView?.setFrameSize(NSSize(width: contentWidth, height: nsView.contentView.frame.height))
//		let newX = nsView.contentView.bounds.origin.x + 50
//		let newY = nsView.contentView.bounds.origin.y
//		nsView.contentView.scroll(to: NSPoint(x: newX, y: newY))
//		nsView.reflectScrolledClipView(nsView.contentView)
		//nsView.needsDisplay = true
	}
}

struct WrappedNSScrollView: View {
	@Binding var zoom: Double
	let contentWidth: CGFloat

	var body: some View {
		NSScrollViewWrapper() {
			Ruler(
				numberOfSegments: 10,
				zoom: zoom)
			.frame(width: contentWidth, height: 50)
			.border(.red)
		}
		.frame(width: viewPortWidth, height: viewPortHeight)
	}
}

#Preview {
	WrappedNSScrollView(zoom: .constant(1.0), contentWidth: 100)
}
