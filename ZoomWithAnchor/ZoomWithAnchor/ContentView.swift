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
	@State var scrollState: ScrollState = .init()
	
	@State private var showSettings = true
	
	var body: some View {
		VStack {
			Zoomer(
				zoom: $scrollState.zoom,
				settings: settings)
			.frame(width: 200)
			ScrollingViewPort(
				contentWidth: zoomedWidth,
				scrollOffset: scrollState.scrollOffset,
				settings: settings,
				relativeAnchorPositionInContent: calculateRelativeAnchorPositionInContent(),
				anchorPositionInViewPort: $scrollState.anchorPositionInViewPort)
			Scroller(
				scrollOffset: $scrollState.scrollOffset,
				maxScrollOffset: zoomedWidth - settings.viewPortVisibleWidth)
			.frame(width: 400)
			Divider()
			ScrollViewReader { reader in
				Ruler(
					anchorId: "anchor2",
					relativeAnchorPosition: calculateRelativeAnchorPositionInContent(),
					numberOfSegments: 10,
					color: .green,
					width: zoomedWidth,
					height: settings.contentHeight)
				.scrollable(scrollViewPosition: $scrollState.scrollViewOffset)
				.border(.gray)
				.frame(width: settings.viewPortVisibleWidth)
				.onChange(of: scrollState.zoom) { old, new in
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
				.onChange(of: scrollState.scrollViewOffset) { old, new in
					print("scrollState.scrollViewOffset changed from \(old) to \(new)")
				}
				Button("Goto anchor") {
					reader.scrollTo("anchor2")
				}
			}
		}
		.onChange(of: scrollState.anchorPositionInViewPort) {
			updateAnchorPosition()
		}
		.onChange(of: scrollState.scrollViewOffset) {
			print("scrollViewOffset changed to :\(scrollState.scrollViewOffset)")
			updateAnchorPosition()
		}
		.onChange(of: scrollState.zoom) { oldZoom, newZoom in
			print("Outer level zoom changed from \(oldZoom) to \(newZoom)")
			let oldContentWidth = settings.contentUnzoomedWidth * oldZoom
			let relativeContentAnchor = (scrollState.scrollOffset + scrollState.anchorPositionInViewPort) / oldContentWidth
			
			let newContentWidth = settings.contentUnzoomedWidth * newZoom
			let newScrollOffset = relativeContentAnchor * newContentWidth - scrollState.anchorPositionInViewPort
			scrollState.scrollOffset = newScrollOffset
			updateAnchorPosition()
		}
		.onChange(of: scrollState.scrollOffset) {
			updateAnchorPosition()
		}
		.inspector(isPresented: $showSettings) {
			GeometryReader { g in
				VStack {
					SettingsInspector(settings: settings)
						.frame(width: g.size.width)
					Divider()
					StateInspector(state: scrollState)
						.frame(width: g.size.width)
					Spacer()
					Divider()
					HStack {
						Spacer()
						Button("Reset") {
							settings.resetToDefault()
							scrollState.resetToDefault()
						}
					}
					.padding([.bottom, .trailing])
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
	
	private func updateAnchorPosition() {
		scrollState.relativeAnchorPositionInViewPort = scrollState.anchorPositionInViewPort / settings.viewPortVisibleWidth
		scrollState.relativeAnchorPositionInContent = calculateRelativeAnchorPositionInContent()
	}
	
	private func calculateRelativeAnchorPositionInContent() -> CGFloat{
		(scrollState.scrollViewOffset.x + scrollState.anchorPositionInViewPort) / zoomedWidth
	}
	
	private var zoomedWidth: CGFloat {
		settings.contentUnzoomedWidth * scrollState.zoom
	}
	
	private func calculateRelativeAnchorPositionInContent(zoom: Double) -> CGFloat{
		let zoomedContentWidth = settings.contentUnzoomedWidth * zoom
		return (scrollState.scrollViewOffset.x + scrollState.anchorPositionInViewPort) / zoomedContentWidth
	}
}

#Preview {
	ContentView()
}

