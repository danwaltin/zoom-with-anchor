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
			slider("View Port Width",
				   minValue: settings.minViewPortVisibleWidth,
				   maxValue: settings.maxViewPortVisibleWidth,
				   currentValue: $settings.viewPortVisibleWidth)
			Divider()
			slider("Content Unzoomed Width",
				   minValue: settings.minContentUnzoomedWidth,
				   maxValue: settings.maxContentUnzoomedWidth,
				   currentValue: $settings.contentUnzoomedWidth)
		}
		.padding()

	}
	
	@ViewBuilder
	private func slider(_ title: String, minValue: CGFloat, maxValue: CGFloat, currentValue: Binding<CGFloat>) -> some View {
		HStack {
			Text(title)
			numericText(currentValue.wrappedValue)
			Spacer()
		}
		.font(.headline)
		.foregroundStyle(.gray)

		HStack(alignment: .center) {
			Slider(
				value: currentValue,
				in: minValue...maxValue
			) {}
			minimumValueLabel: {
				numericText(minValue)
			} maximumValueLabel: {
				numericText(maxValue)
			}
			.controlSize(.small)
		}

	}
	
	@ViewBuilder
	private func numericText(_ value: CGFloat, decimals: Int = 0) -> some View {
		Text(value, format: .number.precision(.fractionLength(decimals)))
	}
}

#Preview {
	SettingsInspector(settings: Settings())
}
