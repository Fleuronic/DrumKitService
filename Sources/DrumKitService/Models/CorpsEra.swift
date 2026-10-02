// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.CorpsEra
import struct DrumKit.Corps
import struct DrumKit.Location
import struct DrumKit.Division
import struct Catena.IDFields
import protocol Catena.Valued

public extension CorpsEra {
	typealias ID = Identifier<Identified>
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedCorpsEra
}

// MARK: -
public struct IdentifiedCorpsEra: Sendable {
	public let id: CorpsEra.ID
	public let value: CorpsEra
	public let corps: Corps.Identified
	public let location: Location.Identified
	public let division: Division.Identified
}

// MARK: -
extension CorpsEra.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension CorpsEra.Identified: Valued {
	// MARK: Valued
	public typealias Value = CorpsEra
}

extension CorpsEra.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case fromYear = "from_year"
		case throughYear = "through_year"
		case name
		case corps
		case location
		case division
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.fromYear * .fromYear,
		\.value.throughYear * .throughYear,
		\.value.name * .name,
		\.corps --> .corps,
		\.location -?> .location,
		\.division -?> .division
	)

	public static let schemaName = "corps_eras"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.fromYear, ascending: true)]
	}
}

// MARK: -
private extension CorpsEra.Identified {
	init(
		id: CorpsEra.ID,
		fromYear: Int?,
		throughYear: Int?,
		name: String?,
		corps: Corps.Identified,
		location: Location.Identified,
		division: Division.Identified
	) {
		self.init(
			id: id,
			value: .init(
				fromYear: fromYear,
				throughYear: throughYear,
				name: name
			),
			corps: corps,
			location: location,
			division: division
		)
	}
}
