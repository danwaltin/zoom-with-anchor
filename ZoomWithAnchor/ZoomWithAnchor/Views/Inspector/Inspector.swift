//
//  Inspector.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct Inspector: View {
	@Bindable var settings: Settings
	let state: ScrollState

	let reset: () -> Void
	
	var body: some View {
		GeometryReader { g in
			VStack {
				SettingsInspector(settings: settings)
					.frame(width: g.size.width)
				Divider()
				StateInspector(state: state)
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
		}    }
}

#Preview {
	Inspector(settings: .init(), state: .init(), reset: {})
}
