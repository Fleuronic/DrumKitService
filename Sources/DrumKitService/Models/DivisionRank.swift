// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.DivisionRank
import struct DrumKit.Division
import struct Catena.IDFields
import protocol Catena.Valued

public extension DivisionRank {
	typealias ID = Identifier<Identified>
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedDivisionRank
}

// MARK: -
public struct IdentifiedDivisionRank: Sendable {
	public let id: DivisionRank.ID
	public let value: DivisionRank
	public let division: Division.Identified
}

// MARK: -
extension DivisionRank.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension DivisionRank.Identified: Valued {
	// MARK: Valued
	public typealias Value = DivisionRank
}

extension DivisionRank.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case rank
		case division
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.rank * .rank,
		\.division --> .division
	)

	public static let schemaName = "division_ranks"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.rank, ascending: true)]
	}
}

// MARK: -
private extension DivisionRank.Identified {
	init(
		id: DivisionRank.ID,
		rank: Int,
		division: Division.Identified
	) {
		self.init(
			id: id,
			value: .init(rank: rank),
			division: division
		)
	}
}
