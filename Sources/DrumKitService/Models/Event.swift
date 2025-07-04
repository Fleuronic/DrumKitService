// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Event
import struct Catena.IDFields
import protocol Catena.Valued

public extension Event {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedEvent
}

// MARK: -
public struct IdentifiedEvent: Sendable {
	public let id: Event.ID
	public let value: Event
}

// MARK: -
extension Event.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Event.Identified: Valued {
	// MARK: Valued
	public typealias Value = Event
}

extension Event.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case date
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.date * .date
	)

	public static let schemaName = "events"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.date, ascending: true)]
	}
}

// MARK: -
private extension Event.Identified {
	init(
		id: Event.ID,
		date: Date
	) {
		self.init(
			id: id,
			value: .init(date: date)
		)
	}
}
