// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Location
import struct DrumKit.State
import struct DrumKit.Country
import struct Catena.IDFields
import protocol Catena.Valued

public extension Location {
	typealias ID = Identifier<Identified>
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedLocation
}

// MARK: -
public struct IdentifiedLocation: Sendable {
	public let id: Location.ID
	public let value: Location
	public let state: State.Identified
	public let country: Country.Identified
}

// MARK: -
public extension Location.Identified {
	static func predicate(
		city: String?,
		state: String
	) -> PersistDB.Predicate<Self> {
		\.value.city == city && \.state.value.abbreviation == state
	}

	static func predicate(countryOnlyIn country: String) -> PersistDB.Predicate<Self> {
		\.value.city == nil && \.country.value.name == country
	}
}

// MARK: -
extension Location.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Location.Identified: Valued {
	// MARK: Valued
	public typealias Value = Location
}

extension Location.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case city
		case timeZone = "time_zone"
		case state
		case country
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.city * .city,
		\.value.timeZone * .timeZone,
		\.state --> .state,
		\.country --> .country
	)

	public static let schemaName = "locations"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.city, ascending: true)]
	}
}

// MARK: -
private extension Location.Identified {
	init(
		id: Location.ID,
		city: String?,
		timeZone: String?,
		state: State.Identified,
		country: Country.Identified
	) {
		self.init(
			id: id,
			value: .init(
				city: city,
				timeZone: timeZone
			),
			state: state,
			country: country
		)
	}
}

// MARK: -
public extension [Location] {
	var city: [String?] { map(\.city) }
	var timeZone: [String?] { map(\.timeZone) }
}

// MARK: -
public extension [Location.Identified] {
	var id: [Location.ID] { map(\.id) }
	var value: [Location] { map(\.value) }
	var state: [State.Identified] { map(\.state) }
	var country: [Country.Identified] { map(\.country) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.city * .city,
		\.value.timeZone * .timeZone,
		\.state --> .state,
		\.country --> .country
	)
}

// MARK: -
private extension [Location.Identified] {
	init(
		ids: [Location.ID],
		cities: [String?],
		timeZones: [String?],
		states: [State.Identified],
		countries: [Country.Identified]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				city: cities[index],
				timeZone: timeZones[index],
				state: states[index],
				country: countries[index]
			)
		}
	}
}
