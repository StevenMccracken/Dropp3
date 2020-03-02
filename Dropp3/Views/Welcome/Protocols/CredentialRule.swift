//
//  CredentialRule.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/22/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

protocol CredentialRule {
  associatedtype Credential
  var credential: Credential { get }
  var isValid: Bool { get }
}

protocol DependentCredentialRule: CredentialRule {
  associatedtype DependentCredential
  /// Dependent credential that can be used for additional validation against `credential`. Should be assumed to be valid already for simplicity
  var dependentCredential: DependentCredential { get }
}
