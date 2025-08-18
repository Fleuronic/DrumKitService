// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Ensemble
import struct DrumKit.Location
import struct Catena.IDFields
import protocol Catena.Valued

public extension Ensemble {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedEnsemble
}

// MARK: -
public struct IdentifiedEnsemble: Sendable {
	public let id: Ensemble.ID
	public let value: Ensemble
	public let location: Location.Identified
}

// MARK: -
extension Ensemble.Identified {
	static func predicate(name: String) -> PersistDB.Predicate<Self> {
		\.value.name == name
	}
}

// MARK: -
extension Ensemble.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Ensemble.Identified: Valued {
	// MARK: Valued
	public typealias Value = Ensemble
}

extension Ensemble.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
		case location
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name,
		\.location -?> .location
	)

	public static let schemaName = "ensembles"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Ensemble.Identified {
	init(
		id: Ensemble.ID,
		name: String,
		location: Location.Identified
	) {
		self.init(
			id: id,
			value: .init(name: name),
			location: location
		)
	}
}

// MARK: -
public extension [Ensemble] {
	var name: [String] { map(\.name) }
}

// MARK: -
public extension [Ensemble.Identified] {
	var id: [Ensemble.ID] { map(\.id) }
	var value: [Ensemble] { map(\.value) }
	var location: [Location.Identified] { map(\.location) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.name * .name,
		\.location -?> .location
	)
}

// MARK: -
private extension [Ensemble.Identified] {
	init(
		ids: [Ensemble.ID],
		names: [String],
		locations: [Location.Identified]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				name: names[index],
				location: locations[index]
			)
		}
	}
}
