//
//  NumericText.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import SwiftUI

struct NumericText: View {
	let value: Double
	let decimals: Int
	
	init(_ value: Double, decimals: Int = 1) {
		self.value = value
		self.decimals = decimals
	}
    var body: some View {
		Text(value, format: .number.precision(.fractionLength(decimals)))
    }
}

#Preview {
	NumericText(1.234, decimals: 4)
		.padding()
}
