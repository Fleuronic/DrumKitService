// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.FeatureRole
import struct DrumKit.Feature
import struct Catena.IDFields
import protocol Catena.Valued

public extension FeatureRole {
	typealias ID = Identifier<Identified>
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedFeatureRole
}

// MARK: -
public struct IdentifiedFeatureRole: Sendable {
	public let id: FeatureRole.ID
	public let value: FeatureRole
	public let feature: Feature.Identified
}

// MARK: -
extension FeatureRole.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension FeatureRole.Identified: Valued {
	// MARK: Valued
	public typealias Value = FeatureRole
}

extension FeatureRole.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case role
		case feature
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.role * .role,
		\.feature --> .feature
	)

	public static let schemaName = "feature_roles"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.role, ascending: true)]
	}
}

// MARK: -
private extension FeatureRole.Identified {
	init(
		id: FeatureRole.ID,
		role: String,
		feature: Feature.Identified
	) {
		self.init(
			id: id,
			value: .init(role: role),
			feature: feature
		)
	}
}
