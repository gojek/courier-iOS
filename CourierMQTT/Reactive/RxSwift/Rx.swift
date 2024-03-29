#if TRACE_RESOURCES
private let resourceCount = AtomicInt(0)

enum Resources {

    static var total: Int32 {
        load(resourceCount)
    }

    static func incrementTotal() -> Int32 {
        increment(resourceCount)
    }

    static func decrementTotal() -> Int32 {
        decrement(resourceCount)
    }
}
#endif

func rxAbstractMethod(file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    rxFatalError("Abstract method", file: file, line: line)
}

func rxFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    fatalError(lastMessage(), file: file, line: line)
}

func rxFatalErrorInDebug(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
    fatalError(lastMessage(), file: file, line: line)
    #else
    print("\(file):\(line): \(lastMessage())")
    #endif
}

func incrementChecked(_ i: inout Int) throws -> Int {
    if i == Int.max {
        throw RxError.overflow
    }
    defer { i += 1 }
    return i
}

func decrementChecked(_ i: inout Int) throws -> Int {
    if i == Int.min {
        throw RxError.overflow
    }
    defer { i -= 1 }
    return i
}

#if DEBUG
import Foundation
final class SynchronizationTracker {
    private let lock = RecursiveLock()

    enum SynchronizationErrorMessages: String {
        case variable = "Two different threads are trying to assign the same `Variable.value` unsynchronized.\n    This is undefined behavior because the end result (variable value) is nondeterministic and depends on the \n    operating system thread scheduler. This will cause random behavior of your program.\n"
        case `default` = "Two different unsynchronized threads are trying to send some event simultaneously.\n    This is undefined behavior because the ordering of the effects caused by these events is nondeterministic and depends on the \n    operating system thread scheduler. This will result in a random behavior of your program.\n"
    }

    private var threads = [UnsafeMutableRawPointer: Int]()

    private func synchronizationError(_ message: String) {
        #if FATAL_SYNCHRONIZATION
        rxFatalError(message)
        #else
        print(message)
        #endif
    }

    func register(synchronizationErrorMessage: SynchronizationErrorMessages) {
        lock.lock()
        defer { self.lock.unlock() }
        let pointer = Unmanaged.passUnretained(Thread.current).toOpaque()
        let count = (threads[pointer] ?? 0) + 1

        if count > 1 {
            synchronizationError(
                "⚠️ Reentrancy anomaly was detected.\n" +
                    "  > Debugging: To debug this issue you can set a breakpoint in \(#file):\(#line) and observe the call stack.\n" +
                    "  > Problem: This behavior is breaking the observable sequence grammar. `next (error | completed)?`\n" +
                    "    This behavior breaks the grammar because there is overlapping between sequence events.\n" +
                    "    Observable sequence is trying to send an event before sending of previous event has finished.\n" +
                    "  > Interpretation: This could mean that there is some kind of unexpected cyclic dependency in your code,\n" +
                    "    or that the system is not behaving in the expected way.\n" +
                    "  > Remedy: If this is the expected behavior this message can be suppressed by adding `.observe(on:MainScheduler.asyncInstance)`\n" +
                    "    or by enqueuing sequence events in some other way.\n"
            )
        }

        threads[pointer] = count

        if threads.count > 1 {
            synchronizationError(
                "⚠️ Synchronization anomaly was detected.\n" +
                    "  > Debugging: To debug this issue you can set a breakpoint in \(#file):\(#line) and observe the call stack.\n" +
                    "  > Problem: This behavior is breaking the observable sequence grammar. `next (error | completed)?`\n" +
                    "    This behavior breaks the grammar because there is overlapping between sequence events.\n" +
                    "    Observable sequence is trying to send an event before sending of previous event has finished.\n" +
                    "  > Interpretation: " + synchronizationErrorMessage.rawValue +
                    "  > Remedy: If this is the expected behavior this message can be suppressed by adding `.observe(on:MainScheduler.asyncInstance)`\n" +
                    "    or by synchronizing sequence events in some other way.\n"
            )
        }
    }

    func unregister() {
        lock.performLocked {
            let pointer = Unmanaged.passUnretained(Thread.current).toOpaque()
            self.threads[pointer] = (self.threads[pointer] ?? 1) - 1
            if self.threads[pointer] == 0 {
                self.threads[pointer] = nil
            }
        }
    }
}

#endif

enum Hooks {

    static var recordCallStackOnError: Bool = false
}
