//
//  Zoomer.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-01.
//

import SwiftUI

struct Zoomer: View {
	
	private static let noZoom: Double = 1
	private let zoomStep: Double = 0.5
	@Binding var zoom: Double
	let settings: ZoomSettings

	var body: some View {
		HStack {
			Button(action: {zoom -= zoomStep}) {
				Image(systemName: "minus")
			}
			.buttonStyle(BorderlessButtonStyle())

			Slider(value: $zoom,
				   in: settings.minZoom...settings.maxZoom,
				   label: {EmptyView()},
				   minimumValueLabel: {Text(settings.minZoom, format: .number.precision(.fractionLength(1)))},
				   maximumValueLabel: {
					   Text(settings.maxZoom, format: .number.precision(.fractionLength(1)))
				   },
				   onEditingChanged: {_ in}
			)
			.controlSize(.mini)

				
			Button(action: {zoom += zoomStep}) {
				Image(systemName: "plus")
			}
			.buttonStyle(BorderlessButtonStyle())
		}
	}
}
#Preview {
	Zoomer(zoom: .constant(1), settings: Settings())
}
