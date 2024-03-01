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
	
	let numberOfSegments: Int
	let color: Color
	let width: CGFloat
	let height: CGFloat
	
	private let segments: [Int]
	
	init(numberOfSegments: Int, color: Color, width: CGFloat, height: CGFloat) {
		self.numberOfSegments = numberOfSegments
		self.color = color
		self.width = width
		self.height = height
		segments = Array(1..<numberOfSegments)
	}
	
	var body: some View {
		ZStack {
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
	Ruler(numberOfSegments: 10, color: .green, width: 200, height: 50)
}
