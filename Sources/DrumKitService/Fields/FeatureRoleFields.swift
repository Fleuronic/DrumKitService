// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.FeatureRole
import struct Catena.IDFields
import protocol Catena.Fields

public protocol FeatureRoleFields: Fields where Model == FeatureRole.Identified {}

// MARK: -
extension IDFields: FeatureRoleFields where Model == FeatureRole.Identified {}
