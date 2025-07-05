// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Slot
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
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.time * .time
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
		time: TimeInterval?
	) {
		self.init(
			id: id,
			value: .init(time: time)
		)
	}
}
// MARK: -
