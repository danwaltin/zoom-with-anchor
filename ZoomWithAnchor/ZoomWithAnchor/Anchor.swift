//
//  Anchor.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-03.
//

import SwiftUI

fileprivate let handleHeight: CGFloat = 15
fileprivate let handleStartY: CGFloat = 0

fileprivate struct PlayHeadHandle : Shape {
	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: CGPoint(x: rect.minX, y: handleStartY))
			path.addLine(to: CGPoint(x: rect.minX, y: handleStartY + handleHeight * 2 / 3))
			path.addLine(to: CGPoint(x: rect.width / 2, y: handleStartY + handleHeight))
			path.addLine(to: CGPoint(x: rect.maxX, y: handleStartY + handleHeight * 2 / 3))
			path.addLine(to: CGPoint(x: rect.maxX, y: handleStartY))
			path.closeSubpath()
		}
	}
}

fileprivate struct PlayHeadLine : Shape {
	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: CGPoint(x: rect.minX + rect.width / 2, y: handleStartY + handleHeight))
			path.addLine(to: CGPoint(x: rect.minX + rect.width / 2, y: rect.height))
		}
	}
}

fileprivate struct PlayHead : View {
	let height: CGFloat
	let x: CGFloat
	let y: CGFloat

	let dragged: Bool
	
	@State var hover = false
	
	var body: some View {

		ZStack {
			PlayHeadHandle()
				.fill(color.opacity(0.3))
			PlayHeadHandle()
				.stroke(color, lineWidth: lineWidth)
			PlayHeadLine()
				.stroke(color, lineWidth: lineWidth)
		}
		.onHover {
			hover = $0
		}
		.frame(width: 10, height: height, alignment: .center)
		.position(x: x, y: y + height / 2)
	}

	private var color: Color {
		get {
			if dragged {
				return .gray.opacity(0.5)
			}
			return hover ? .blue.opacity(0.5) : .green
		}
	}

	private var lineWidth: CGFloat {
		get {
			if dragged {
				return 1
			}
			return hover ? 2 : 1
		}
	}
}

struct PlayHeadView: View {
	let height: CGFloat
	let offsetX: CGFloat
	let offsetY: CGFloat

	@State var isDragging = false
	@State var draggedToX: CGFloat = 0
	
	var body: some View {
		ZStack {
			PlayHead(height: height, x: offsetX, y: offsetY, dragged: false)
				.gesture(
					DragGesture()
						.onChanged { playHeadDragging($0) }
						.onEnded { playHeadDragEndend($0) }
				)
			
			if isDragging {
				PlayHead(height: height, x: draggedToX, y: offsetY, dragged: true)
			}
		}

	}

	private func playHeadDragging(_ gesture: DragGesture.Value) {
		isDragging = true
		draggedToX = gesture.location.x
	}
	
	private func playHeadDragEndend(_ gesture: DragGesture.Value) {
		isDragging = false
		let x = gesture.location.x // - LayoutConstants.mixTrackRowHeaderWidth

//		let positionInMix = ZoomedDuration(displayWidth: x, zoom: zoomLevel).duration
//		Self.notificationCenter.post(Notification.playPositionRequestedNotification(positionInMix: positionInMix))
	}
}

#Preview("hover false") {
	PlayHead(height: 200, x: 30, y: 10, dragged: false, hover: false)
}

#Preview("hover true") {
	PlayHead(height: 200, x: 40, y: 20, dragged: true, hover: true)
}
