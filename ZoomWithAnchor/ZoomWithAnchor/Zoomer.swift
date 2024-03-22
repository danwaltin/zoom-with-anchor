//
//  Zoomer.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-01.
//

import SwiftUI

fileprivate let minZoom: Double = 0.5
fileprivate let maxZoom: Double = 4

struct Zoomer: View {
	
	static let noZoom: Double = 1
	private let zoomStep: Double = 0.5
	
	@Binding var zoom: Double
	
	var body: some View {
		HStack {
			Button(action: {zoom -= zoomStep}) {
				Image(systemName: "minus")
			}
			.buttonStyle(.borderless)
			.controlSize(.extraLarge)
			.keyboardShortcut("-", modifiers: .command)
			
			Slider(
				value: $zoom,
				in: minZoom...maxZoom,
				label: {EmptyView()},
				minimumValueLabel: {Text(minZoom, format: .number.precision(.fractionLength(1)))},
				maximumValueLabel: {Text(maxZoom, format: .number.precision(.fractionLength(1)))},
				onEditingChanged: {_ in}
			)
			.controlSize(.mini)
			
			
			Button(action: {zoom += zoomStep}) {
				Image(systemName: "plus")
			}
			.buttonStyle(.borderless)
			.controlSize(.extraLarge)
			.keyboardShortcut("+", modifiers: .command)
			
			Button("Reset") {
				zoom = Self.noZoom
			}
			.controlSize(.small)
			.keyboardShortcut("0", modifiers: .command)
		}
	}
}
#Preview {
	Zoomer(zoom: .constant(1))
}
