//
//  WrappedNSScrollView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct NSScrollViewWrapper<Content: View>: NSViewRepresentable {
	typealias NSViewType = NSScrollView
	
	@Binding var contentWidth: CGFloat
	
	@ViewBuilder var content: Content
	
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
		
		view.contentView.clipsToBounds = false
		return view
	}
		
	func updateNSView(_ nsView: NSScrollView, context: Context) {
		// You might update the NSScrollView here based on changes in the SwiftUI view
		// For example, you could adjust scroller visibility or content size dynamically
		// This method is called when the SwiftUI view needs to be updated.
		print("Updating nsview, frame = \(nsView.contentView.frame)")
		print("New width              = \(contentWidth)")

		let newSize = CGSize(width: contentWidth, height: nsView.contentView.frame.height)
		
		nsView.contentView.setFrameSize(newSize)
		print("Width after             = \(nsView.contentView.frame.width)")
	}
}
struct WrappedNSScrollView: View {
	let settings: Settings
	@Bindable var scrollState: ScrollState

	@State var zoomedWidth: CGFloat
	
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
			}
			.frame(width: settings.viewPortVisibleWidth, height: settings.viewPortHeight)
		}
	}
}

#Preview {
    WrappedNSScrollView(settings: .init(), scrollState: .init())
}
