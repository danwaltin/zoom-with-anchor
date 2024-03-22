//
//  Anchor.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-03.
//

import SwiftUI

fileprivate let handleHeight: CGFloat = 15
fileprivate let handleStartY: CGFloat = 0

fileprivate struct AnchorHeadHandle : Shape {
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

fileprivate struct AnchorLine : Shape {
	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: CGPoint(x: rect.minX + rect.width / 2, y: handleStartY + handleHeight))
			path.addLine(to: CGPoint(x: rect.minX + rect.width / 2, y: rect.height))
		}
	}
}

fileprivate struct AnchorHead : View {
	let height: CGFloat
	let x: CGFloat
	let y: CGFloat

	let dragged: Bool
	
	@State var hover = false
	
	var body: some View {

		ZStack {
			AnchorHeadHandle()
				.fill(color.opacity(0.3))
			AnchorHeadHandle()
				.stroke(color, lineWidth: lineWidth)
			AnchorLine()
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

struct Anchor: View {
	let height: CGFloat
	@Binding var offsetX: CGFloat
	let offsetY: CGFloat = 0

	@State var isDragging = false
	@State var draggedToX: CGFloat = 0
	
	var body: some View {
		ZStack {
			AnchorHead(height: height, x: offsetX, y: offsetY, dragged: false)
				.gesture(
					DragGesture()
						.onChanged { playHeadDragging($0) }
						.onEnded { playHeadDragEndend($0) }
				)
			
			if isDragging {
				AnchorHead(height: height, x: draggedToX, y: offsetY, dragged: true)
			}
		}

	}

	private func playHeadDragging(_ gesture: DragGesture.Value) {
		isDragging = true
		draggedToX = gesture.location.x
	}
	
	private func playHeadDragEndend(_ gesture: DragGesture.Value) {
		isDragging = false
		let x = gesture.location.x
		offsetX = x
	}
}

#Preview("hover false") {
	AnchorHead(height: 200, x: 30, y: 10, dragged: false, hover: false)
}

#Preview("hover true") {
	AnchorHead(height: 200, x: 40, y: 20, dragged: true, hover: true)
}
