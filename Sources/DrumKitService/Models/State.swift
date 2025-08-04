// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.State
import struct DrumKit.Country
import struct Catena.IDFields
import protocol Catena.Valued

public extension State {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedState
}

// MARK: -
public struct IdentifiedState: Sendable {
	public let id: State.ID
	public let value: State
	public let country: Country.Identified
}

// MARK: -
extension State.Identified {
	static func predicate(abbreviation: String) -> PersistDB.Predicate<Self> {
		\.value.abbreviation == abbreviation
	}
}

// MARK: -
extension State.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension State.Identified: Valued {
	// MARK: Valued
	public typealias Value = State
}

extension State.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case abbreviation
		case country
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.abbreviation * .abbreviation,
		\.country --> .country
	)

	public static let schemaName = "states"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.abbreviation, ascending: true)]
	}
}

// MARK: -
private extension State.Identified {
	init(
		id: State.ID,
		abbreviation: String,
		country: Country.Identified
	) {
		self.init(
			id: id,
			value: .init(abbreviation: abbreviation),
			country: country
		)
	}
}

// MARK: -
public extension [State] {
	var abbreviation: [String] { map(\.abbreviation) }
}

// MARK: -
public extension [State.Identified] {
	var id: [State.ID] { map(\.id) }
	var value: [State] { map(\.value) }
	var country: [Country.Identified] { map(\.country) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.abbreviation * .abbreviation,
		\.country --> .country
	)
}

// MARK: -
private extension [State.Identified] {
	init(
		ids: [State.ID],
		abbreviations: [String],
		countries: [Country.Identified]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				abbreviation: abbreviations[index],
				country: countries[index]
			)
		}
	}
}
