// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Slot
import struct DrumKit.Time
import struct DrumKit.Event
import struct DrumKit.Performance
import struct DrumKit.Feature
import struct Catena.IDFields
import protocol Catena.Valued

public extension Slot {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedSlot
}

// MARK: -
public struct IdentifiedSlot: Sendable {
	public let id: Slot.ID
	public let value: Slot
	public let event: Event.Identified
	public let performance: Performance.Identified
	public let feature: Feature.Identified
}

// MARK: -
extension Slot.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Slot.Identified: Valued {
	// MARK: Valued
	public typealias Value = Slot
}

extension Slot.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case time
		case event
		case performance
		case feature
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.time * .time,
		\.event --> .event,
		\.performance -?> .performance,
		\.feature -?> .feature
	)

	public static let schemaName = "slots"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.time, ascending: true)]
	}
}

// MARK: -
private extension Slot.Identified {
	init(
		id: Slot.ID,
		time: Time?,
		event: Event.Identified,
		performance: Performance.Identified,
		feature: Feature.Identified
	) {
		self.init(
			id: id,
			value: .init(time: time),
			event: event,
			performance: performance,
			feature: feature
		)
	}
}

// MARK: -
public extension [Slot] {
	var time: [Time?] { map(\.time) }
}

// MARK: -
public extension [Slot.Identified] {
	var id: [Slot.ID] { map(\.id) }
	var value: [Slot] { map(\.value) }
	var performance: [Performance.Identified] { map(\.performance) }
	var feature: [Feature.Identified] { map(\.feature) }

	// MARK: Model
	static var schema: Schema<Self> {
		let id = \Self.id * .id
		return .init(
			Self.init,
			id,
			\Self.value.time * .time,
			\Self.performance -?> .performance,
			\Self.feature -?> .feature
		)
	}
}

// MARK: -
private extension [Slot.Identified] {
	init(
		ids: [Slot.ID],
		times: [Time?],
		performances: [Performance.Identified],
		features: [Feature.Identified]
	) {
		let events: [Event.Identified] = []
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				time: times[index],
				event: events[index],
				performance: performances[index],
				feature: features[index]
			)
		}
	}
}
