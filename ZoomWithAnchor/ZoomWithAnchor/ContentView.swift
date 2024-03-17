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
	
	@State private var showSettings = true
	
	var body: some View {
		VStack {
			Zoomer(
				zoom: $scrollStateHomeMade.zoom,
				settings: settings)
			.frame(width: 200)
			HomeMadeScroller(settings: settings, scrollState: scrollStateHomeMade)
			Divider()
			ScrollViewReader { reader in
				Ruler(
					anchorId: "anchor2",
					relativeAnchorPosition: calculateRelativeAnchorPositionInContent(),
					numberOfSegments: 10,
					color: .green,
					width: zoomedWidth,
					height: settings.contentHeight)
				.scrollable(scrollViewPosition: $scrollStateHomeMade.scrollViewOffset)
				.border(.gray)
				.frame(width: settings.viewPortVisibleWidth)
				.onChange(of: scrollStateHomeMade.zoom) { old, new in
					let oldContentWidth = settings.contentUnzoomedWidth * old
					let newContentWidth = settings.contentUnzoomedWidth * new
					let diff = newContentWidth - oldContentWidth
					let relativeDiff = diff / settings.viewPortVisibleWidth
					
					let oldContentRelativeAnchor = calculateRelativeAnchorPositionInContent(zoom: old)
					let newContentRelativeAnchor = calculateRelativeAnchorPositionInContent(zoom: new)
					print("""
						Inner level zoom changed from \(old) to \(new)
						Content width change         : \(diff)
						Relative content width change: \(relativeDiff)
						Old content relative anchor  : \(oldContentRelativeAnchor)
						New content relative anchor  : \(newContentRelativeAnchor)
					""")
					
					reader.scrollTo(
						"anchor2")
				}
				.onChange(of: scrollStateHomeMade.scrollViewOffset) { old, new in
					print("scrollState.scrollViewOffset changed from \(old) to \(new)")
				}
				Button("Goto anchor") {
					reader.scrollTo("anchor2")
				}
			}
		}
		.onChange(of: scrollStateHomeMade.anchorPositionInViewPort) {
			updateAnchorPosition()
		}
		.onChange(of: scrollStateHomeMade.scrollViewOffset) {
			print("scrollViewOffset changed to :\(scrollStateHomeMade.scrollViewOffset)")
			updateAnchorPosition()
		}
		.onChange(of: scrollStateHomeMade.zoom) { oldZoom, newZoom in
			print("Outer level zoom changed from \(oldZoom) to \(newZoom)")
			let oldContentWidth = settings.contentUnzoomedWidth * oldZoom
			let relativeContentAnchor = (scrollStateHomeMade.scrollOffset + scrollStateHomeMade.anchorPositionInViewPort) / oldContentWidth
			
			let newContentWidth = settings.contentUnzoomedWidth * newZoom
			let newScrollOffset = relativeContentAnchor * newContentWidth - scrollStateHomeMade.anchorPositionInViewPort
			scrollStateHomeMade.scrollOffset = newScrollOffset
			updateAnchorPosition()
		}
		.onChange(of: scrollStateHomeMade.scrollOffset) {
			updateAnchorPosition()
		}
		.inspector(isPresented: $showSettings) {
			Inspector(settings: settings, scrollStateHomeMade: scrollStateHomeMade, scrollStateBuiltIn: scrollStateHomeMade) {
				settings.resetToDefault()
				scrollStateHomeMade.resetToDefault()
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
	
	private func updateAnchorPosition() {
		scrollStateHomeMade.relativeAnchorPositionInViewPort = scrollStateHomeMade.anchorPositionInViewPort / settings.viewPortVisibleWidth
		scrollStateHomeMade.relativeAnchorPositionInContent = calculateRelativeAnchorPositionInContent()
	}
	
	private func calculateRelativeAnchorPositionInContent() -> CGFloat{
		(scrollStateHomeMade.scrollViewOffset.x + scrollStateHomeMade.anchorPositionInViewPort) / zoomedWidth
	}
	
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * scrollStateHomeMade.zoom
	}
	
	private func calculateRelativeAnchorPositionInContent(zoom: Double) -> CGFloat{
		let zoomedContentWidth = settings.contentUnzoomedWidth * zoom
		return (scrollStateHomeMade.scrollViewOffset.x + scrollStateHomeMade.anchorPositionInViewPort) / zoomedContentWidth
	}
}

#Preview {
	ContentView()
}

