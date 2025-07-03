// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Address
import struct DrumKit.Location
import struct DrumKit.ZIPCode
import struct Catena.IDFields
import protocol Catena.Valued

public extension Address {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedAddress
}

// MARK: -
public struct IdentifiedAddress: Sendable {
	public let id: Address.ID
	public let value: Address
	public let location: Location.Identified
	public let zipCode: ZIPCode.Identified
}

// MARK: -
extension Address.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Address.Identified: Valued {
	// MARK: Valued
	public typealias Value = Address
}

extension Address.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case streetAddress = "street_address"
		case location
		case zipCode = "zip_code"
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.streetAddress * .streetAddress,
		\.location --> .location,
		\.zipCode --> .zipCode
	)

	public static let schemaName = "venues"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.streetAddress, ascending: true)]
	}
}

// MARK: -
private extension Address.Identified {
	init(
		id: Address.ID,
		streetAddress: String,
		location: Location.Identified,
		zipCode: ZIPCode.Identified
	) {
		self.init(
			id: id,
			value: .init(streetAddress: streetAddress),
			location: location,
			zipCode: zipCode
		)
	}
}
