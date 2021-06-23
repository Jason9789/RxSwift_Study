import Foundation
import RxSwift
import RxCocoa

// MARK:- ignore Elements
// onCompleted를 호출해주어야 subscribe 내부가 작동한다.
example(of: "ignoreElements") {
    // 1
    let strikes = PublishSubject<String>()
    
    let bag = DisposeBag()
    
    // 2
    strikes.ignoreElements()
        .subscribe { _ in
            print("You're out!")
        }.disposed(by: bag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onCompleted()
}

// MARK:- elementAt
// elementAt의 사이즈를 2로 설정했기 때문에
// strikes의 사이즈가 3이 되었을 때 자동으로 onCompleted 된다.
example(of: "elementAt") {
    // 1
    let strikes = PublishSubject<String>()
    
    let bag = DisposeBag()
    
    // 2
    strikes.elementAt(2)
        .subscribe(onNext: { _ in
            print("You're out!")
        }).disposed(by: bag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
}


// MARK:- Filter
// 말 그대로 필터. 값을 걸러준다.
example(of: "filter") {
    let bag = DisposeBag()
    
    // 1
    Observable.of(1, 2, 3, 4, 5, 6)
        // 2
        .filter { $0.isMultiple(of: 2) }
        // 3
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}


// MARK:- skip
// skip(n)의 n의 값에 따라서 n의 다음 주소부터 값을 emit 하게 된다.
example(of: "skip") {
    let bag = DisposeBag()
    
    // 1
    Observable.of("A", "B", "C", "D", "E", "F")
        // 2
        .skip(3)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}

// MARK:- skipWhile
// 정확히 뭐지?
example(of: "skipWhile") {
    let bag = DisposeBag()
    
    // 1
    Observable.of(2, 2, 3, 4, 4)
        // 2
        .skipWhile { $0.isMultiple(of: 2) }
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}

// MARK:- skipUntil
// trigger가 나오기 전까지 값을 emit 하지 않는다.
example(of: "skipUntil") {
    let bag = DisposeBag()
    
    // 1
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    // 2
    subject
        .skipUntil(trigger)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
    
    subject.onNext("A")
    subject.onNext("B")
    
    trigger.onNext("A")
    
    subject.onNext("C")
}

// MARK:- take
// take(n)은 앞에서부터 n까지의 값을 emit 한다.
example(of: "take") {
    let bag = DisposeBag()
    
    // 1
    Observable.of(1, 2, 3, 4, 5, 6)
        // 2
        .take(3)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}

// MARK:- takeWhile
example(of: "takeWhile") {
    let bag = DisposeBag()
    
    // 1
    Observable.of(2, 2, 4, 4, 6, 6)
        // 2
        .enumerated()
        // 3
        .takeWhile { index, integer in
            // 4
            integer.isMultiple(of: 2) && index < 3
        }
        // 5
        .map(\.element)
        // 6
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}

// MARK:- takeUntil
example(of: "takeUntil") {
    let bag = DisposeBag()
    
    // 1
    Observable.of(1, 2, 3, 4, 5)
        // 2
//        .takeUntil(.exclusive) { $0.isMultiple(of: 4) }
        .takeUntil(.inclusive) { $0.isMultiple(of: 4) }
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}

// MARK:- takeUntil trigger
// trigger가 나오기 전까지의 값들을 emit 한다.
example(of: "takeUntil trigger") {
    let bag = DisposeBag()
    
    // 1
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    // 2
    subject
        .takeUntil(trigger)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
    
    // 3
    subject.onNext("1")
    subject.onNext("2")
    
    trigger.onNext("X")
    
    subject.onNext("3")
}


// MARK:- distinct Until Changed
// 다른 값이 나오기 전까지의 중복된 값들을 다 처리해줌.
example(of: "distinctUntilChanged") {
    let bag = DisposeBag()
    
    // 1
    Observable.of("A", "A", "B", "B", "A")
        // 2
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}

// MARK:- distinct Until Changed(_:)
example(of: "distinctUntilChanged(_:)") {
    let bag = DisposeBag()
    
    // 1
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    // 2
    Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
        // 3
        .distinctUntilChanged { a, b in
            // 4
            guard
                let aWords = formatter
                    .string(from: a)?
                    .components(separatedBy: " "),
                let bWords = formatter
                    .string(from: b)?
                    .components(separatedBy: " ")
            else {
                return false
            }
            
            var containMatch = false
            
            // 5
            for aWord in aWords where bWords.contains(aWord) {
                containMatch = true
                break
            }
            
            return containMatch
        }
    
    // 4
        .subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
}
