import Swift
import Foundation

/*:

The Principles of OOD in Swift 1.2
==================================

A short cheat-sheet with Xcode 6.3 Playground ([OOD-Principles-In-Swift.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle](#-the-single-responsibility-principle)
* [The Open Closed Principle](#-the-open-closed-principle)
* [The Liskov Substitution Principle](#-the-liskov-substitution-principle)
* [The Interface Segregation Principle](#-the-interface-segregation-principle)
* [The Dependency Inversion Principle](#-the-dependency-inversion-principle)

*//*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change.

Example:
*/

protocol CanBeOpened {
    func open()
}

protocol CanBeClosed {
    func close()
}

// I'm the door. I have an encapsulated state and you can change it using methods.
class Door : CanBeOpened,CanBeClosed {
    private var stateOpen = false

    func open() {
        stateOpen = true
    }

    func close() {
        stateOpen = false
    }
}

// I'm only responsible for opening, no idea what's inside or how to close.
class DoorOpener {
    let door:CanBeOpened

    init(door: CanBeOpened) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
class DoorCloser {
    let door:CanBeClosed

    init(door: CanBeClosed) {
        self.door = door
    }

    func execute() {
        door.close()
    }
}

let door = Door()
let doorOpener = DoorOpener(door: door)
let doorCloser = DoorCloser(door: door)
doorOpener.execute()
doorCloser.execute()
/*:
# ✋ The Open Closed Principle

You should be able to extend a classes behavior, without modifying it.

*/

protocol CanShoot {
    func shoot() -> String
}

// I'm a laser beam. I can shoot.
class LaserBeam : CanShoot {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// I have weapons and trust me I can fire them all at once. Boom! Boom! Boom!
class WeaponsComposite {

    let weapons:[CanShoot]

    init(_ weapons:[CanShoot]) {
        self.weapons = weapons
    }

    func shoot() -> [String] {
        return weapons.map { $0.shoot() }
    }
}

let laser = LaserBeam()
var weapons = WeaponsComposite([laser])

weapons.shoot()

// I'm a rocket launcher. I can shoot a rocket.
// NOTE: To add rocket launcher support I don't need to change anything in existing classes.
class RocketLauncher : CanShoot {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite([laser, rocket])
weapons.shoot()
/*:
# 👥 The Liskov Substitution Principle

Derived classes must be substitutable for their base classes.

*/

let requestKey:NSString = "NSURLRequestKey"

// I'm a NSError subclass. I provide additional functionality but don't mess with original ones.
class RequestError : NSError {

    var request : NSURLRequest? {
        return self.userInfo?[requestKey] as? NSURLRequest
    }
}

// I fail to fetch data and will return RequestError.
func fetchData(request:NSURLRequest) -> (data:NSData?, error:RequestError?) {

    let userInfo:[NSObject:AnyObject] = [ requestKey : request ]

    return (nil, RequestError(domain:"DOMAIN", code: 1, userInfo: userInfo))
}

// I don't know what RequestError is and will fail and return a NSError.
func willReturnObjectOrError() -> (object:AnyObject?, error:NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request)

    return (result.data , result.error)
}

let result = willReturnObjectOrError()

// Ok. This is a perfect NSError instance from my perspective.
let error:Int? = result.error?.code

// But hey! What's that? It's also a RequestError! Nice!
if let requestError = result.error as? RequestError {
    requestError.request;
}
/*:
# 🚧 The Interface Segregation Principle

Make fine grained interfaces that are client specific.

*//*:
# 🚧 The Dependency Inversion Principle

Depend on abstractions, not on concretions.

*//*:
Info
====

📖 Descriptions from: [Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

*/