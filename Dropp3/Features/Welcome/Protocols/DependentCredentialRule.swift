//
//  DependentCredentialRule.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//

import Foundation

protocol DependentCredentialRule: CredentialRule {
  associatedtype DependentCredential
  /// Dependent credential that can be used for additional validation against `credential`. Should be assumed to be valid already
  var dependentCredential: DependentCredential { get }
}
