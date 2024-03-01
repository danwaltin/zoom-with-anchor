//
//  Zoomer.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-01.
//

import SwiftUI


struct Zoomer: View {
	
	private static let noZoom: Double = 1
	@Binding var zoom: Double
	let minZoom: Double
	let maxZoom: Double

	var body: some View {
		VStack {
			Slider(
				value: $zoom,
				in: minZoom...maxZoom
			){
				Text("Zoom level")
			} minimumValueLabel: {
				Text(minZoom, format: .number.precision(.fractionLength(1)))
			} maximumValueLabel: {
				Text(maxZoom, format: .number.precision(.fractionLength(1)))
			}
		}
	}
}
#Preview {
	Zoomer(zoom: .constant(1), minZoom: 0.1, maxZoom: 5)
}
