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
		VStack {
			HStack {
				Text("Anchor in view port:")
				Spacer()
				Text("\(state.anchorPositionInViewPort)")
			}
			.padding()
			Spacer()
		}
    }
}

#Preview {
	StateInspector(state: .init())
}
