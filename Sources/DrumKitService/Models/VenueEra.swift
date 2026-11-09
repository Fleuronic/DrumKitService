// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.VenueEra
import struct DrumKit.Venue
import struct Catena.IDFields
import protocol Catena.Valued

public extension VenueEra {
	typealias ID = Identifier<Identified>
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedVenueEra
}

// MARK: -
public struct IdentifiedVenueEra: Sendable {
	public let id: VenueEra.ID
	public let value: VenueEra
	public let venue: Venue.Identified
}

// MARK: -
extension VenueEra.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension VenueEra.Identified: Valued {
	// MARK: Valued
	public typealias Value = VenueEra
}

extension VenueEra.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case fromYear = "from_year"
		case throughYear = "through_year"
		case name
		case venue
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.fromYear * .fromYear,
		\.value.throughYear * .throughYear,
		\.value.name * .name,
		\.venue --> .venue
	)

	public static let schemaName = "venue_eras"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.fromYear, ascending: true)]
	}
}

// MARK: -
private extension VenueEra.Identified {
	init(
		id: VenueEra.ID,
		fromYear: Int?,
		throughYear: Int?,
		name: String,
		venue: Venue.Identified
	) {
		self.init(
			id: id,
			value: .init(
				fromYear: fromYear,
				throughYear: throughYear,
				name: name
			),
			venue: venue
		)
	}
}
