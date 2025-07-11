// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Placement
import struct DrumKit.Division
import struct Catena.IDFields
import protocol Catena.Valued

public extension Placement {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedPlacement
}

// MARK: -
public struct IdentifiedPlacement: Sendable {
	public let id: Placement.ID
	public let value: Placement
	public let division: Division.Identified
}

// MARK: -
extension Placement.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Placement.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case rank
		case score
		case division
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.rank * .rank,
		\.value.score * .score,
		\.division -?> .division
	)

	public static let schemaName = "placements"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.id, ascending: true)]
	}
}

// MARK: -
private extension Placement.Identified {
	init(
		id: Placement.ID,
		rank: Int,
		score: Double,
		division: Division.Identified
	) {
		self.init(
			id: id,
			value: .init(
				rank: rank,
				score: score
			),
			division: division
		)
	}
}

// MARK: -
public extension [Placement] {
	var rank: [Int] { map(\.rank) }
	var score: [Double] { map(\.score) }
}

// MARK: -
public extension [Placement.Identified] {
	var id: [Placement.ID] { map(\.id) }
	var value: [Placement] { map(\.value) }
	var division: [Division.Identified] { map(\.division) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.rank * .rank,
		\.value.score * .score,
		\.division -?> .division
	)
}

// MARK: -
private extension [Placement.Identified] {
	init(
		ids: [Placement.ID],
		ranks: [Int],
		scores: [Double],
		divisions: [Division.Identified]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				value: .init(
					rank: ranks[index],
					score: scores[index]
				),
				division: divisions[index]
			)
		}
	}
}
