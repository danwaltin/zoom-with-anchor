//
//  Scroller.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-01.
//

import SwiftUI

struct Scroller: View {
	@Binding var scrollOffset: CGFloat
	let maxScrollOffset: CGFloat
	
	var body: some View {
		VStack {
			Slider(
				value: $scrollOffset,
				in: 0...maxScrollOffset
			){
				Text("Scroll")
			}
		}
	}
}

#Preview {
	Scroller(scrollOffset: .constant(0), maxScrollOffset: 200)
}
