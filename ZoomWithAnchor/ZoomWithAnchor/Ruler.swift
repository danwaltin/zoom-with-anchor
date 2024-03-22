//
//  Ruler.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-01.
//

import SwiftUI

struct Ruler: View {

	private let tickHeight: CGFloat = 20
	
	let numberOfSegments: Int
	let color: Color
	
	private let segments: [Int]
	
	init(numberOfSegments: Int, color: Color) {
		self.numberOfSegments = numberOfSegments
		self.color = color
		segments = Array(1..<numberOfSegments)
	}
	
	var body: some View {
		GeometryReader { g in
			ZStack {
				ForEach(segments, id: \.self) { i in
					tick(number: i, x: g.size.width / CGFloat(numberOfSegments) * CGFloat(i), height: g.size.height)
				}
			}
		}
		.background(
			Rectangle()
				.fill(BackgroundStyle())
		)
	}
	
	private func tick(number: Int, x: CGFloat, height: CGFloat) -> some View {
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
	Ruler(numberOfSegments: 10,
		  color: .green)
}
