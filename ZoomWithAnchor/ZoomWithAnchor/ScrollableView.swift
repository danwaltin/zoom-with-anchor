//
//  ScrollableView.swift
//  ZoomWithAnchor
//
//  Created by Dan Waltin on 2024-04-14.
//
import SwiftUI

struct ScrollableView: ViewModifier {
	@Binding var scrollViewPosition: CGPoint

	func body(content: Content) -> some View {
		ScrollView([.vertical, .horizontal]) {
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

struct ScrollViewHorizontalOffsetKey: PreferenceKey {
	typealias Value = CGFloat
	static var defaultValue = CGFloat.zero
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value += nextValue()
	}
}

struct ScrollViewVerticalOffsetKey: PreferenceKey {
	typealias Value = CGFloat
	static var defaultValue = CGFloat.zero
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value += nextValue()
	}
}

@ViewBuilder
func scrollOffsetReader(coordinateSpace: String) -> some View {
	GeometryReader {
		Color.clear.preference(key: ScrollViewHorizontalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.x)
		Color.clear.preference(key: ScrollViewVerticalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.y)
	}
}

@ViewBuilder
func horizontalScrollOffsetReader(coordinateSpace: String) -> some View {
	GeometryReader {
		Color.clear.preference(key: ScrollViewHorizontalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.x)
	}
}

@ViewBuilder
func verticalScrollOffsetReader(coordinateSpace: String) -> some View {
	GeometryReader {
		Color.clear.preference(key: ScrollViewVerticalOffsetKey.self, value: -$0.frame(in: .named(coordinateSpace)).origin.y)
	}
}
