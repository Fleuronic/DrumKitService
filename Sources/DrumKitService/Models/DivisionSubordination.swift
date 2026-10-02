// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.DivisionSubordination
import struct DrumKit.Division
import struct DrumKit.Circuit
import struct Catena.IDFields
import protocol Catena.Valued

public extension DivisionSubordination {
	typealias ID = Identifier<Identified>
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedDivisionSubordination
}

// MARK: -
public struct IdentifiedDivisionSubordination: Sendable {
	public let id: DivisionSubordination.ID
	public let value: DivisionSubordination
	public let division: Division.Identified
	public let circuit: Circuit.Identified
}

// MARK: -
extension DivisionSubordination.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension DivisionSubordination.Identified: Valued {
	// MARK: Valued
	public typealias Value = DivisionSubordination
}

extension DivisionSubordination.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case division
		case circuit
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.division --> .division,
		\.circuit --> .circuit
	)

	public static let schemaName = "division_subordinations"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.id, ascending: true)]
	}
}

// MARK: -
private extension DivisionSubordination.Identified {
	init(
		id: DivisionSubordination.ID,
		division: Division.Identified,
		circuit: Circuit.Identified
	) {
		self.init(
			id: id,
			value: .init(),
			division: division,
			circuit: circuit
		)
	}
}
