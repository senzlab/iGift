//
//  SenzDb.swift
//  iGift
//
//  Created by eranga on 5/8/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation
import SQLite

class SenzDb {
    static let instance = SenzDb()
    private let db: Connection?

    // user table
    private let users = Table("users")
    private let _uid = Expression<Int64>("id")
    private let zid = Expression<String>("zid")
    private let phone = Expression<String>("phone")
    private let isActive = Expression<Bool>("is_active")
    private let isRequester = Expression<Bool>("is_requester")

    // promize table
    private let igifts = Table("igifts")
    private let _gid = Expression<Int64>("id")
    private let uid = Expression<String>("uid")
    private let user = Expression<String>("user")
    private let timestamp = Expression<Int64>("timestamp")
    private let isMyIgift = Expression<Bool>("is_my_igift")
    private let isViewed = Expression<Bool>("is_viewed")
    private let cid = Expression<String>("cid")
    private let account = Expression<String>("account")
    private let amount = Expression<String>("amount")
    private let blob = Expression<String>("blob")
    private let state = Expression<String>("state")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/Promize.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }

        createTableUser()
        createTableIgift()
    }

    func createTableUser() {
        do {
            try db!.run(users.create(ifNotExists: true) { table in
                table.column(_uid, primaryKey: true)
                table.column(zid, unique: true)
                table.column(phone)
                table.column(isActive)
                table.column(isRequester)
            })
        } catch {
            print("Unable to create table")
        }
    }

    func createTableIgift() {
        do {
            try db!.run(igifts.create(ifNotExists: true) { table in
                table.column(_gid, primaryKey: true)
                table.column(uid, unique: true)
                table.column(user)
                table.column(timestamp)
                table.column(isMyIgift)
                table.column(isViewed)
                table.column(cid)
                table.column(account)
                table.column(amount)
                table.column(blob)
                table.column(state)
            })
        } catch {
            print("Unable to create table")
        }
    }

    func createUser(user: User) -> Int64 {
        do {
            let insert = users.insert(
                zid <- user.zid,
                phone <- user.phone,
                isActive <- user.isActive,
                isRequester <- user.isRequester
            )
            return try db!.run(insert)
        } catch {
            print("Query fail, createUser")
        }

        return -1
    }

    func markAsActive(id:String) -> Bool {
        do {
            let u = users.filter(zid == id)
            let update = u.update([isActive <- true])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }

        return false
    }

    func deleteUser(id: String) -> Bool {
        do {
            let u = users.filter(zid == id)
            try db!.run(u.delete())

            return true
        } catch {
            print("Delete failed")
        }

        return false
    }

    func getUsers(active: Bool) -> [User] {
        var l = [User]()
        let q = active ? users.filter(isActive == active) : self.users
        do {
            for i in try db!.prepare(q) {
                let u = User(id: i[_uid])
                u.zid = i[zid]
                u.phone = i[phone]
                u.isActive = i[isActive]
                u.isRequester = i[isRequester]
                l.append(u)
            }
        } catch {
            print("Query fail, getUsers")
        }

        return l
    }
    
    func hasUsers() -> Bool {
        do {
            let q = self.users.limit(1)
            for _ in try db!.prepare(q) {
                return true
            }
        } catch {
            print("Query fail, getUsers")
        }
        
        return false
    }
    
    func getUser(phn: String) -> User! {
        let q = users.filter(zid == phn).limit(1)
        do {
            for i in try db!.prepare(q) {
                let u = User(id: i[_uid])
                u.zid = i[zid]
                u.phone = i[phone]
                u.isActive = i[isActive]
                u.isRequester = i[isRequester]
                return u
            }
        } catch {
            return nil
        }
        
        return nil
    }

    func createIgift(igift: Igift) -> Int64 {
        do {
            let insert = igifts.insert(
                uid <- igift.uid,
                user <- igift.user,
                timestamp <- igift.timestamp,
                isMyIgift <- igift.isMyIgift,
                isViewed <- igift.isViewed,
                cid <- igift.cid,
                account <- igift.account,
                amount <- igift.amount,
                blob <- igift.blob,
                state <- igift.state
            )
            return try db!.run(insert)
        } catch {
            print("Query fail, createIgift")
        }

        return -1
    }

    func markAsViewed(id: String) -> Bool {
        do {
            let u = igifts.filter(uid == id)
            let update = u.update([isViewed <- true])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }

        return false
    }

    func markAsRedeemed(id: String, acc: String) -> Bool {
        do {
            let u = igifts.filter(uid == id)
            let update = u.update([state <- "REDEEM", account <- acc])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }

        return false
    }

    func getIgifts(myGifts: Bool) -> [Igift] {
        var l = [Igift]()
        do {
            let q = igifts.filter(isMyIgift == myGifts).order(timestamp.desc)
            for i in try db!.prepare(q) {
                let ig = Igift(id: i[_gid])
                ig.uid = i[uid]
                ig.user = i[user]
                ig.timestamp = i[timestamp]
                ig.isMyIgift = i[isMyIgift]
                ig.isViewed = i[isViewed]
                ig.cid = i[cid]
                ig.account = i[account]
                ig.amount = i[amount]
                ig.state = i[state]
                l.append(ig)
            }
        } catch {
            print("Query fail, getUsers")
        }

        return l
    }
    
    func hasIgiftsToRedeem(phone: String) -> Bool {
        do {
            let q = igifts.filter(user == phone && isMyIgift == false && state == "TRANSFER").limit(1)
            for _ in try db!.prepare(q) {
                return true
            }
        } catch {
            print("Query fail, getUsers")
        }
        
        return false
    }
    
    func deleteIgiftsOfUser(phone: String) -> Bool {
        do {
            let igs = igifts.filter(user == phone)
            try db!.run(igs.delete())
            
            return true
        } catch {
            print("Delete failed")
        }
        
        return false
    }

    func updateIgift() {

    }

}

