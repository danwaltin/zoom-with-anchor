//
//  ScrollOffsetReader.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-03-17.
//

import Foundation
import SwiftUI

struct ScrollableOffsetReaderView: ViewModifier {
	@Binding var scrollViewPosition: CGPoint
	
	func body(content: Content) -> some View {
		ScrollView(.horizontal) {
			content
				.background(
					scrollOffsetReader(coordinateSpace: "scrollCoordinateSpace")
				)
				.onPreferenceChange(ScrollViewHorizontalOffsetKey.self) {
					scrollViewPosition.x = $0
				}
				.onPreferenceChange(ScrollViewVerticalOffsetKey.self) {
					scrollViewPosition.y = $0
				}
		}
		.coordinateSpace(name: "scrollCoordinateSpace")
	}
}

extension View {
	func scrollable(scrollViewPosition: Binding<CGPoint>) -> some View {
		modifier(ScrollableOffsetReaderView(scrollViewPosition: scrollViewPosition))
	}
}

fileprivate struct ScrollViewHorizontalOffsetKey: PreferenceKey {
	typealias Value = CGFloat
	static var defaultValue = CGFloat.zero
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value += nextValue()
	}
}

fileprivate struct ScrollViewVerticalOffsetKey: PreferenceKey {
	typealias Value = CGFloat
	static var defaultValue = CGFloat.zero
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value += nextValue()
	}
}

@ViewBuilder
fileprivate func scrollOffsetReader(coordinateSpace: String) -> some View {
	GeometryReader {
		Color.clear.preference(key: ScrollViewHorizontalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.x)
		Color.clear.preference(key: ScrollViewVerticalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.y)
	}
}

@ViewBuilder
fileprivate func horizontalScrollOffsetReader(coordinateSpace: String) -> some View {
	GeometryReader {
		Color.clear.preference(key: ScrollViewHorizontalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.x)
	}
}

@ViewBuilder
fileprivate func verticalScrollOffsetReader(coordinateSpace: String) -> some View {
	GeometryReader {
		Color.clear.preference(key: ScrollViewVerticalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.y)
	}
}
