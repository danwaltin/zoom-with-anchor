//
//  Ruler.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-01.
//

import SwiftUI

struct Ruler: View {
	
	private let mainTickHeight: CGFloat = 20
	private let subTickHeight: CGFloat = 10

	private let numberOfSegments: Int
	private let zoom: Double
	private let color: Color = .green
	
	private let segments: [Int]
	
	init(numberOfSegments: Int, zoom: Double) {
		self.numberOfSegments = numberOfSegments
		self.zoom = zoom
		segments = Array(0..<(numberOfSegments + 1))
	}
	
	var body: some View {
		GeometryReader { g in
			ZStack {
				ForEach(segments, id: \.self) { i in
					tick(
						number: i,
						x: mainTickWidth(g.size) * CGFloat(i),
						heightContainer: g.size.height,
						tickHeight: mainTickHeight
					)

					if zoom >= 2 {
						tick(
							x: mainTickWidth(g.size) / 2 + mainTickWidth(g.size) * CGFloat(i),
							heightContainer: g.size.height,
							tickHeight: subTickHeight)

					}

					if zoom >= 3 {
						tick(
							x: mainTickWidth(g.size) / 4 + mainTickWidth(g.size) * CGFloat(i),
							heightContainer: g.size.height,
							tickHeight: subTickHeight)

						tick(
							x: mainTickWidth(g.size) * 3 / 4 + mainTickWidth(g.size) * CGFloat(i),
							heightContainer: g.size.height,
							tickHeight: subTickHeight)
					}
				}
			}
		}
		.background(
			Rectangle()
				.fill(.background)
		)
	}
	
	private func mainTickWidth(_ parentSize: CGSize) -> CGFloat {
		parentSize.width / CGFloat(numberOfSegments)
	}
	
	private func tick(number: Int, x: CGFloat, heightContainer: CGFloat, tickHeight: CGFloat) -> some View {
		ZStack {
			Text("\(number)")
				.font(.footnote)
				.foregroundStyle(color)
				.position(x: x,
						  y: (heightContainer - tickHeight) - 10)

			tick(x: x, heightContainer: heightContainer, tickHeight: tickHeight)
		}
	}
	
	private func tick(x: CGFloat, heightContainer: CGFloat, tickHeight: CGFloat) -> some View {
		Path { path in
			path.move(to: CGPoint(x: x, y: heightContainer))
			path.addLine(to: CGPoint(x: x, y: heightContainer - tickHeight))
		}
		.stroke(color, lineWidth: 1)
	}
}

#Preview("Zoom 1") {
	Ruler(numberOfSegments: 10, zoom: 1)
}

#Preview("Zoom 4") {
	Ruler(numberOfSegments: 10, zoom: 4)
}
