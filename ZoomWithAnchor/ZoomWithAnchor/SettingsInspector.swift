//
//  SettingsInspector.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-02.
//

import SwiftUI

struct SettingsInspector: View {
	@Bindable var settings: Settings
	
	var body: some View {
		VStack {
			HStack {
				Text("View port width")
					.font(.headline)
				text(settings.viewPortVisibleWidth)
				Spacer()
			}
			HStack(alignment: .center) {
				Slider(
					value: $settings.viewPortVisibleWidth,
					in: 0...max(settings.minViewPortVisibleWidth, settings.maxViewPortVisibleWidth)
				) {}
				minimumValueLabel: {
					text(settings.minViewPortVisibleWidth)
				} maximumValueLabel: {
					text(settings.maxViewPortVisibleWidth)
				}
			}
			
			Spacer()
			
			Button("Reset") {
				settings.resetToDefault()
			}
		}
		.padding()

	}
	
	@ViewBuilder
	private func text(_ value: CGFloat) -> some View {
		Text(value, format: .number.precision(.fractionLength(0)))
	}
}

#Preview {
	SettingsInspector(settings: Settings())
}
