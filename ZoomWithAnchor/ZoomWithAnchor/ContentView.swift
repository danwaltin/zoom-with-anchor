//
//  ContentView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-02-29.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		ZStack {
			viewPort()
				.border(.gray)
			Ruler(numberOfSegments: 10, color: .green, width: 400, height: 50)
				.border(.gray)
		}
	}
	
	@ViewBuilder
	private func viewPort() -> some View {
		Path()
		.frame(width: 100, height: 100)
		.background(
			Rectangle()
				.fill(BackgroundStyle())
		)
	}
}



#Preview {
	ContentView()
		.padding()
}

