// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Country
import struct Catena.IDFields
import protocol Catena.Valued

public extension Country {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedCountry
}

// MARK: -
public struct IdentifiedCountry: Sendable {
	public let id: Country.ID
	public let value: Country
}

// MARK: -
extension Country.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Country.Identified: Valued {
	// MARK: Valued
	public typealias Value = Country
}

extension Country.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name
	)

	public static let schemaName = "countries"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Country.Identified {
	init(
		id: Country.ID,
		name: String
	) {
		self.init(
			id: id,
			value: .init(name: name)
		)
	}
}
// MARK: -