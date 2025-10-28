// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Corps
import struct DrumKit.Location
import struct Catena.IDFields
import protocol Catena.Valued

public extension Corps {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedCorps
}

// MARK: -
public struct IdentifiedCorps: Sendable {
	public let id: Corps.ID
	public let value: Corps
	public let location: Location.Identified
}

// MARK: -
extension Corps.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Corps.Identified: Valued {
	// MARK: Valued
	public typealias Value = Corps
}

extension Corps.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
		case url
		case isActive = "active"
		case location
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name,
		\.value.url * .url,
		\.value.isActive * .isActive,
		\.location --> .location
	)

	public static let schemaName = "corps"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Corps.Identified {
	init(
		id: Corps.ID,
		name: String,
		url: URL?,
		isActive: Bool,
		location: Location.Identified
	) {
		self.init(
			id: id,
			value: .init(
				name: name,
				url: url,
				isActive: isActive
			),
			location: location
		)
	}
}

// MARK: -
public extension [Corps] {
	var name: [String] { map(\.name) }
	var url: [URL?] { map(\.url) }
	var isActive: [Bool] { map(\.isActive) }
}

// MARK: -
public extension [Corps.Identified] {
	var id: [Corps.ID] { map(\.id) }
	var value: [Corps] { map(\.value) }
	var location: [Location.Identified] { map(\.location) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.name * .name,
		\.value.url * .url,
		\.value.isActive * .isActive,
		\.location --> .location
	)
}

// MARK: -
private extension [Corps.Identified] {
	init(
		ids: [Corps.ID],
		names: [String],
		urls: [URL?],
		isActiveFlags: [Bool],
		locations: [Location.Identified]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				name: names[index],
				url: urls[index],
				isActive: isActiveFlags[index],
				location: locations[index]
			)
		}
	}
}
