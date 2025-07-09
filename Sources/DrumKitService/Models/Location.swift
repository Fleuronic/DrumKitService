// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Location
import struct DrumKit.State
import struct Catena.IDFields
import protocol Catena.Valued

public extension Location {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedLocation
}

// MARK: -
public struct IdentifiedLocation: Sendable {
	public let id: Location.ID
	public let value: Location
	public let state: State.Identified
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
		case state
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.city * .city,
		\.state --> .state
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
		city: String,
		state: State.Identified
	) {
		self.init(
			id: id,
			value: .init(city: city),
			state: state
		)
	}
}

// MARK: -
public extension [Location] {
	var city: [String] { map(\.city) }
}

// MARK: -
public extension [Location.Identified] {
	var id: [Location.ID] { map(\.id) }
	var value: [Location] { map(\.value) }
	var state: [State.Identified] { map(\.state) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.city * .city,
		\.state --> .state
	)
}

// MARK: -
private extension [Location.Identified] {
	init(
		ids: [Location.ID],
		cities: [String],
		states: [State.Identified]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				city: cities[index],
				state: states[index]
			)
		}
	}
}
