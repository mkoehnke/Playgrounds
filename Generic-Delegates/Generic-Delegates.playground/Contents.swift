//: Playground - noun: a place where people can play

import Foundation


protocol StackDelegate  {
    associatedtype ElementType
    func didPushElement(element: ElementType, stack: Stack<ElementType>)
    func didPopElement(element: ElementType, stack: Stack<ElementType>)
}

struct StackDelegateThunk<Element> : StackDelegate {
    private let _didPushElement : (Element, Stack<Element>) -> Void
    private let _didPopElement : (Element, Stack<Element>) -> Void
    
    init<P : StackDelegate where P.ElementType == Element>(_ delegate : P) {
        _didPushElement = delegate.didPushElement
        _didPopElement = delegate.didPopElement
    }
    
    func didPushElement(element: Element, stack: Stack<Element>) {
        _didPushElement(element, stack)
    }
    
    func didPopElement(element: Element, stack: Stack<Element>) {
        _didPopElement(element, stack)
    }
}

struct Stack<Element> {
    var items = [Element]()
    
    private(set) var delegate : StackDelegateThunk<Element>?
    
    mutating func setDelegate<P:StackDelegate where P.ElementType == Element>(delegate: P) {
        self.delegate = StackDelegateThunk<Element>(delegate)
    }
    
    mutating func push(item: Element) {
        items.append(item)
        delegate?.didPushElement(item, stack: self)
    }
    mutating func pop() -> Element {
        let item =  items.removeLast()
        delegate?.didPopElement(item, stack: self)
        return item
    }
}

struct StackObserver<Element> : StackDelegate {
    typealias ElementType = Element
    
    func didPushElement(element: ElementType, stack: Stack<ElementType>) {
        print(element)
    }
    
    func didPopElement(element: ElementType, stack: Stack<ElementType>) {
        print(element)
    }
}

let observer = StackObserver<Int>()

var stack1 = Stack<Int>()
stack1.setDelegate(observer)
stack1.push(1)
stack1.pop()
stack1.push(2)

var stack2 = Stack<Int>()
stack2.setDelegate(observer)
stack2.push(3)
