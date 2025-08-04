// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Show
import struct Catena.IDFields
import protocol Catena.Valued

public extension Show {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedShow
}

// MARK: -
public struct IdentifiedShow: Sendable {
	public let id: Show.ID
	public let value: Show
}

// MARK: -
extension Show.Identified {
	static func predicate(name: String) -> PersistDB.Predicate<Self> {
		\.value.name == name
	}
}

// MARK: -
extension Show.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Show.Identified: Valued {
	// MARK: Valued
	public typealias Value = Show
}

extension Show.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name
	)

	public static let schemaName = "shows"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Show.Identified {
	init(
		id: Show.ID,
		name: String
	) {
		self.init(
			id: id,
			value: .init(name: name)
		)
	}
}
// MARK: -