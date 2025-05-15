//
//  BaseConverter.swift
//
//  Created by Draco Nguyen on 07/11/2023.
//
//

import Base_swift

protocol BaseConverter {
    associatedtype Input
    associatedtype Output
    
    func convert(input: Input) -> Output
}

class SimpleConverter<I, O>: BaseConverter {
    
    typealias Input = I
    typealias Output = O?
    
    func convert(input: I) -> O? {
        return nil
    }
}

class ListConverter<I, O>: BaseConverter {
    
    typealias Input = Array<I>
    typealias Output = List<O?>
    
    private var itemConverter: SimpleConverter<I, O>!
    
    init(itemConverter: SimpleConverter<I, O>) {
        self.itemConverter = itemConverter
    }
    
    func convert(input: Array<I>) -> List<O?> {
        let list = List<O?>()
        for itm in input {
            list.add(element: self.itemConverter.convert(input: itm))
        }
        return list
    }
}

class ArrayConverter<I, O>: BaseConverter {
    typealias Input = Array<I>
    typealias Output = Array<O?>
    
    private var itemConverter: SimpleConverter<I, O>!
    
    init(itemConverter: SimpleConverter<I, O>) {
        self.itemConverter = itemConverter
    }
    
    func convert(input: Array<I>) -> Array<O?> {
        var arr = [O?]()
        for itm in input {
            arr.append(self.itemConverter.convert(input: itm))
        }
        return arr
    }
}

class NonNilArrayConverter<I, O>: BaseConverter {
    typealias Input = Array<I>
    typealias Output = Array<O>
    
    private var itemConverter: SimpleConverter<I, O>!
    
    init(itemConverter: SimpleConverter<I, O>) {
        self.itemConverter = itemConverter
    }
    
    func convert(input: Array<I>) -> Array<O> {
        var arr = [O]()
        for itm in input {
            if let o = self.itemConverter.convert(input: itm) {
                arr.append(o)
            }
        }
        return arr
    }
}
