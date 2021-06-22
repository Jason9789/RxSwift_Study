import Foundation

public enum Event<Element> {
    /// Next element is produced.
    case next(Element)
    
    /// Sequence terminated with an error.
    case error(Swift.Error)
    
    /// Sequence completed successfully.
    case completed
    
}
