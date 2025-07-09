// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Performance
import struct DrumKit.Corps
import struct DrumKit.Placement
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
	public let placement: Placement.Identified!
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
		case placement
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.corps -?> .corps,
		\.placement -?> .placement
	)

	public static let schemaName = "performances"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.id, ascending: true)]
	}
}

// MARK: -
public extension [Performance.Identified] {
	var id: [Performance.ID] { map(\.id) }
	var corps: [Corps.Identified] { map(\.corps) }
	var placement: [Placement.Identified] { map(\.placement) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.corps -?> .corps,
		\.placement -?> .placement
	)
}

// MARK: -
private extension [Performance.Identified] {
	init(
		ids: [Performance.ID],
		corps: [Corps.Identified],
		placements: [Placement.Identified]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				corps: corps[index],
				placement: placements[index]
			)
		}
	}
}
