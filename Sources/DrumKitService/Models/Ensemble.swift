// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Ensemble
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
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name
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
		name: String
	) {
		self.init(
			id: id,
			value: .init(name: name)
		)
	}
}
// MARK: -