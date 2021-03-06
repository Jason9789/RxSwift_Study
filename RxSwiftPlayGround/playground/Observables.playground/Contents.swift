import UIKit
import Foundation
import RxSwift
import RxCocoa

// MARK:- just, of, from
example(of: "just, of, from") {
    
    // 1
    let one = 1
    let two = 2
    let three = 3
    
    // 2
    let observable = Observable<Int>.just(one)
    let observable2 = Observable<Int>.of(one, two, three)
    let observable3 = Observable.of([one, two, three])
    let observable4 = Observable.from([one, two, three])
    
    let observer = NotificationCenter.default.addObserver(
        forName: UIResponder.keyboardDidChangeFrameNotification,
        object: nil,
        queue: nil) { notification in
        // Handle receiving notification
    }
    
    let sequence = 0..<3
    
    var iterator = sequence.makeIterator()
    
    while let n = iterator.next() {
        print(n)
    }
}

// MARK:- Subscribe
example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
    
    observable.subscribe(onNext: { element in
        print(element)
    })
}

// MARK:- Empty
example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(
        // 1
        onNext: { element in
            print(element)
        },
        
        // 2
        onCompleted: {
            print("Completed")
        }
    )
}

// MARK:- Never
example(of: "never") {
    let observable = Observable<Void>.never()
    
    observable.subscribe(
        onNext: { element in
            print(element)
        },
        
        onCompleted: {
            print("Completed")
        }
    )
}


// MARK:- Range
example(of: "range") {
    // 1
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable
        .subscribe(onNext: { i in
            // 2
            let n = Double(i)
            
            let fibonacci = Int(
                ((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded()
            )
            
            print(fibonacci)
        })
}


// MARK:- Dispose
example(of: "dispose") {
    // 1
    let observable = Observable.of("A", "B", "C")
    
    // 2
    let subscription = observable.subscribe { event in
        // 3
        print(event)
    }
    
    subscription.dispose()
}


// MARK:- DisposeBag
example(of: "DisposeBag") {
    // 1
    let disposeBag = DisposeBag()
    
    // 2
    Observable.of("A", "B", "C")
        .subscribe { // 3
            print($0)
        }
        .disposed(by: disposeBag)
}

// MARK:- Create
example(of: "create") {
    
    enum MyError: Error {
        case anError
    }
    
    let bag = DisposeBag()
    
    Observable<String>.create { observer in
        // 1
        observer.onNext("1")
        
//        observer.onError(MyError.anError)
        
        // 2
//        observer.onCompleted()
        
        // 3
        observer.onNext("?")
        
        // 4
        return Disposables.create()
    }
    .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
//    .disposed(by: bag)
}


// MARK:- Deferred
example(of: "deferred") {
    let bag = DisposeBag()
    
    // 1
    var flip = false
    
    // 2
    let factory: Observable<Int> = Observable.deferred {
        
        // 3
        flip.toggle()
        
        // 4
        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        }).disposed(by: bag)
        
        print()
    }
}


// MARK:- Single
example(of: "Single") {
    // 1
    let bag = DisposeBag()
    
    // 2
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    // 3
    func loadText(from name: String) -> Single<String> {
        // 4
        return Single.create { single in
            // 1
            let disposable = Disposables.create()
            
            // 2
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            // 3
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            // 4
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            // 5
            single(.success(contents))
            return disposable
        }
    }
    
    // 1
    loadText(from: "Copyright")
    
    // 2
        .subscribe {
            // 3
            switch $0 {
            case .success(let string):
                print(string)
                
            case .error(let error):
                print(error)
            }
        }.disposed(by: bag)
}
