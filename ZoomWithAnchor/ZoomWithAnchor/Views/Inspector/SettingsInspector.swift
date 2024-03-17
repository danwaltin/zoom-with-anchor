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
			NumericText(currentValue.wrappedValue, decimals: 0)
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
				NumericText(minValue, decimals: 0)
			} maximumValueLabel: {
				NumericText(maxValue, decimals: 0)
			}
			.controlSize(.small)
		}

	}
}

#Preview {
	SettingsInspector(settings: Settings())
}
