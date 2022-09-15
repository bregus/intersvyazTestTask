//
//  Box.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 11.06.2022.
//

import Foundation

class Box<T> {
  typealias Listener = () -> Void
  var listener: Listener?
  var value: T {
    didSet { listener?() }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(_ listener: @escaping Listener) {
    self.listener = listener
    self.listener?()
  }
}
