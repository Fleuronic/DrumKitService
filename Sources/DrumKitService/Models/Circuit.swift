// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Circuit
import struct Catena.IDFields
import protocol Catena.Valued

public extension Circuit {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedCircuit
}

// MARK: -
public struct IdentifiedCircuit: Sendable {
	public let id: Circuit.ID
	public let value: Circuit
}

// MARK: -
extension Circuit.Identified {
	static func predicate(abbreviation: String) -> PersistDB.Predicate<Self> {
		\.value.abbreviation == abbreviation
	}
}

// MARK: -
extension Circuit.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Circuit.Identified: Valued {
	// MARK: Valued
	public typealias Value = Circuit
}

extension Circuit.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
		case abbreviation
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name,
		\.value.abbreviation * .abbreviation
	)

	public static let schemaName = "circuits"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Circuit.Identified {
	init(
		id: Circuit.ID,
		name: String,
		abbreviation: String?
	) {
		self.init(
			id: id,
			value: .init(
				name: name,
				abbreviation: abbreviation
			)
		)
	}
}

// MARK: -
public extension [Circuit] {
	var name: [String] { map(\.name) }
	var abbreviation: [String?] { map(\.abbreviation) }
}

// MARK: -
public extension [Circuit.Identified] {
	var id: [Circuit.ID] { map(\.id) }
	var value: [Circuit] { map(\.value) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.name * .name,
		\.value.abbreviation * .abbreviation
	)
}

// MARK: -
private extension [Circuit.Identified] {
	init(
		ids: [Circuit.ID],
		names: [String],
		abbreviations: [String?]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				name: names[index],
				abbreviation: abbreviations[index]
			)
		}
	}
}
