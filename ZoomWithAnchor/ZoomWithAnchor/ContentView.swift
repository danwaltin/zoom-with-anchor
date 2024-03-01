//
//  ContentView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-02-29.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		ScrollView(.horizontal) {
			Ruler()
		}
		.padding()
		.border(.green, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
		.padding()
	}
}

struct Ruler: View {
	private let height: CGFloat = 50
	private let width: CGFloat = 500

	private static let numberOfSegments = 10
	private let numberOfTicks = 9
	
	private let segments = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	
	var body: some View {
		Group {
			Rectangle()
				.foregroundStyle(.gray)
				.frame(width: width, height: height)
			ZStack {
				ForEach(segments, id: \.self) { i in
					tick(x: 50.0 * CGFloat(i), height: 10)
						.offset(CGSize(width: 0, height: -height))
				}
			}
		}
	}
	private func tick(x: CGFloat, height: CGFloat) -> some View {
		Path { path in
			path.move(to: CGPoint(x: x, y: 0))
			path.addLine(to: CGPoint(x: x, y: height))
		}
		.stroke(Color.white, lineWidth: 1)
		
	}
}

#Preview {
	ContentView()
}
