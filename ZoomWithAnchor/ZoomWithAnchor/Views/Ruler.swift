//
//  Ruler.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-01.
//

import SwiftUI

struct Ruler: View {
	private var segmentWidth: CGFloat {width / CGFloat(numberOfSegments)}

	private let tickHeight: CGFloat = 20
	
	let anchorId: String
	let relativeAnchorPosition: CGFloat
	let numberOfSegments: Int
	let color: Color
	let width: CGFloat
	let height: CGFloat
	
	private let segments: [Int]
	
	init(anchorId: String, relativeAnchorPosition: CGFloat, numberOfSegments: Int, color: Color, width: CGFloat, height: CGFloat) {
		self.anchorId = anchorId
		self.relativeAnchorPosition = relativeAnchorPosition
		self.numberOfSegments = numberOfSegments
		self.color = color
		self.width = width
		self.height = height
		segments = Array(1..<numberOfSegments)
	}
	
	var body: some View {
		ZStack {
			HStack(spacing: 0) {
				Rectangle()
					.fill(BackgroundStyle())
					.frame(width: max(0, width * relativeAnchorPosition))
				Image(systemName: "target")
					.id(anchorId)
					.frame(width: 1, height: 1)
				Spacer()
			}
			ForEach(segments, id: \.self) { i in
				tick(number: i, x: segmentWidth * CGFloat(i))
			}
			
		}
		.frame(width: width, height: height)
		.background(
			Rectangle()
				.fill(BackgroundStyle())
		)
	}
	
	private func tick(number: Int, x: CGFloat) -> some View {
		ZStack {
			Text("\(number)")
				.font(.footnote)
				.foregroundStyle(color)
				.position(x: x,
						  y: (height - tickHeight) / 2)
			Path { path in
				path.move(to: CGPoint(x: x, y: height))
				path.addLine(to: CGPoint(x: x, y: height - tickHeight))
			}
			.stroke(color, lineWidth: 1)
		}
	}
}

#Preview("Ruler") {
	Ruler(anchorId: "x", 
		  relativeAnchorPosition: 0,
		  numberOfSegments: 10,
		  color: .green,
		  width: 200,
		  height: 50)
}
