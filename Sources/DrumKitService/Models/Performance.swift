// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Performance
import struct DrumKit.Corps
import struct Catena.IDFields
import protocol Catena.Valued

public extension Performance {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedPerformance
}

// MARK: -
public struct IdentifiedPerformance: Sendable {
	public let id: Performance.ID
	public let corps: Corps.Identified!
}

// MARK: -
extension Performance.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Performance.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case corps
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.corps -?> .corps
	)

	public static let schemaName = "performances"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.id, ascending: true)]
	}
}
