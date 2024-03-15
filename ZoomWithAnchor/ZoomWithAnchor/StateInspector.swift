//
//  StateInspector.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-15.
//

import SwiftUI

struct StateInspector: View {
	let state: ScrollState
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				stateInformation("Anchor in view port:", state.anchorPositionInViewPort)
				stateInformation("Relative anchor in view port:", state.relativeAnchorPositionInViewPort)
				stateInformation("Relative anchor in content:", state.relativeAnchorPositionInContent)
				stateInformation("Zoom:", state.zoom)
				stateInformation("Scroll offset:", state.scrollOffset)
			}
			.padding()
			Spacer()
		}
	}
	
	@ViewBuilder
	private func stateInformation(_ caption: String, _ value: CGFloat) -> some View {
		VStack(alignment: .leading) {
			Text("\(caption):")
				.font(.caption)
			Text("\(value)")
		}
		.padding(.bottom, 5)
	}
}


#Preview {
	StateInspector(state: .init())
}
