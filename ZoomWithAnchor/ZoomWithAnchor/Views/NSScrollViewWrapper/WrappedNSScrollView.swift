//
//  WrappedNSScrollView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct WrappedNSScrollView: View {
	let settings: Settings
	@Bindable var scrollState: ScrollState

	var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WrappedNSScrollView(settings: .init(), scrollState: .init())
}
