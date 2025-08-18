// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Venue
import struct DrumKit.Address
import struct Catena.IDFields
import protocol Catena.Valued

public extension Venue {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedVenue
}

// MARK: -
public struct IdentifiedVenue: Sendable {
	public let id: Venue.ID
	public let value: Venue
	public let address: Address.Identified
}

// MARK: -
extension Venue.Identified {
	static func predicate(name: String) -> PersistDB.Predicate<Self> {
		\.value.name == name
	}
}

// MARK: -
extension Venue.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Venue.Identified: Valued {
	// MARK: Valued
	public typealias Value = Venue
}

extension Venue.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
		case host
		case address
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name,
		\.value.host * .host,
		\.address --> .address
	)

	public static let schemaName = "venues"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Venue.Identified {
	init(
		id: Venue.ID,
		name: String,
		host: String?,
		address: Address.Identified
	) {
		self.init(
			id: id,
			value: .init(
				name: name,
				host: host
			),
			address: address
		)
	}
}
