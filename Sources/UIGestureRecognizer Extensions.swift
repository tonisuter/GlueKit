//
//  UIGestureRecognizer Extensions.swift
//  GlueKit
//
//  Created by Károly Lőrentey on 2016-03-16.
//  Copyright © 2016 Károly Lőrentey. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIGestureRecognizer {
    public var observableState: AnyObservableValue<UIGestureRecognizerState> {
        return ObservableGestureRecognizerState(self).anyObservableValue
    }
}

private class ObservableGestureRecognizerState: _BaseObservableValue<UIGestureRecognizerState> {
    private let _gestureRecognizer: UIGestureRecognizer
    private var _value: UIGestureRecognizerState? = nil

    init(_ gestureRecognizer: UIGestureRecognizer) {
        _gestureRecognizer = gestureRecognizer
    }

    override var value: UIGestureRecognizerState {
        return _gestureRecognizer.state
    }

    override func activate() {
        _value = _gestureRecognizer.state
        _gestureRecognizer.addTarget(self, action: #selector(ObservableGestureRecognizerState.gestureRecognizerDidFire))
    }

    override func deactivate() {
        _gestureRecognizer.removeTarget(self, action: #selector(ObservableGestureRecognizerState.gestureRecognizerDidFire))
        _value = nil
    }

    @objc func gestureRecognizerDidFire() {
        beginTransaction()
        let old = _value!
        _value = _gestureRecognizer.state
        sendChange(ValueChange(from: old, to: _value!))
        endTransaction()
    }
}
#endif
