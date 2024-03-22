//
//  Inspector.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct Inspector: View {
	@Bindable var settings: Settings
	let scrollStateBuiltIn: ScrollState

	let reset: () -> Void
	
	var body: some View {
		GeometryReader { g in
			ScrollView {
				SettingsInspector(settings: settings)
					.frame(width: g.size.width)
				Divider()
				Text("Built in ScrollView")
				StateInspector(state: scrollStateBuiltIn)
					.frame(width: g.size.width)
				Spacer()
				Divider()
				HStack {
					Spacer()
					Button("Reset") {
						reset()
					}
				}
				.padding([.bottom, .trailing])
			}
		}
	}
}

#Preview {
	Inspector(settings: .init(), scrollStateBuiltIn: .init(), reset: {})
}
