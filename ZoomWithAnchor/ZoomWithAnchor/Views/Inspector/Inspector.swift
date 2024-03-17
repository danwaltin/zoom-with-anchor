//
//  Inspector.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct Inspector: View {
	@Bindable var settings: Settings
	let scrollStateHomeMade: ScrollState
	let scrollStateBuiltIn: ScrollState
	let scrollStateNSWrapped: ScrollState

	let reset: () -> Void
	
	var body: some View {
		GeometryReader { g in
			ScrollView {
				SettingsInspector(settings: settings)
					.frame(width: g.size.width)
				Divider()
				Text("Home made scroll view")
				StateInspector(state: scrollStateHomeMade)
					.frame(width: g.size.width)
				Divider()
				Text("Built in ScrollView")
				StateInspector(state: scrollStateBuiltIn)
					.frame(width: g.size.width)
				Divider()
				Text("Wrapped NSScrollView")
				StateInspector(state: scrollStateNSWrapped)
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
	Inspector(settings: .init(), scrollStateHomeMade: .init(), scrollStateBuiltIn: .init(), scrollStateNSWrapped: .init(), reset: {})
}
