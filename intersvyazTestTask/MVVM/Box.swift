//
//  Box.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 11.06.2022.
//

import Foundation

@propertyWrapper class Box<T: Equatable> {
  private var publisher: Publisher<T> = Publisher()

  var wrappedValue: T {
    didSet {
      guard wrappedValue != oldValue else { return }
      publisher.thread.async { self.publisher.listener?(self.wrappedValue) }
    }
  }

  var projectedValue: Publisher<T> {
    get { publisher }
  }

  init(wrappedValue: T) {
    self.wrappedValue = wrappedValue
  }
}

class Publisher<T> {
  typealias Listener = (T) -> Void
  var thread: DispatchQueue = .main
  var listener: Listener?

  @discardableResult
  func sink(_ listener: @escaping Listener) -> Self {
    self.listener = listener
    return self
  }

  @discardableResult
  func on(_ thread: DispatchQueue) -> Self {
    self.thread = thread
    return self
  }
}
