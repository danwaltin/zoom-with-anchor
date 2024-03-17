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
				stateInformation("Anchor/relative anchor in view port", state.anchorPositionInViewPort, state.relativeAnchorPositionInViewPort)
				stateInformation("Relative anchor in content", state.relativeAnchorPositionInContent)
				stateInformation("Zoom", state.zoom)
				stateInformation("Scroll offset", state.scrollOffset)
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
			NumericText(value, decimals: 3)
		}
		.padding(.bottom, 5)
	}
	
	@ViewBuilder
	private func stateInformation(_ caption: String, _ value1: CGFloat, _ value2: CGFloat) -> some View {
		VStack(alignment: .leading) {
			Text("\(caption):")
				.font(.caption)
			HStack {
				NumericText(value1, decimals: 3)
				Text("/")
				NumericText(value2, decimals: 3)
			}
		}
		.padding(.bottom, 5)
	}
}


#Preview {
	StateInspector(state: .init())
}
