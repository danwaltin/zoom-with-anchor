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
	let settings: ZoomSettings

	var body: some View {
		Slider(
			value: $zoom,
			in: settings.minZoom...settings.maxZoom
		){
			Text("Zoom")
		} minimumValueLabel: {
			Text(settings.minZoom, format: .number.precision(.fractionLength(1)))
		} maximumValueLabel: {
			Text(settings.maxZoom, format: .number.precision(.fractionLength(1)))
		}
		.help("Zoom level")
	}
}
#Preview {
	Zoomer(zoom: .constant(1), settings: Settings())
}
