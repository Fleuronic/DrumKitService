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
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name
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
		name: String
	) {
		self.init(
			id: id,
			value: .init(name: name)
		)
	}
}
// MARK: -