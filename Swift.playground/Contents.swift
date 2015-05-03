//: Playground - noun: a place where people can play

import UIKit


//enum


let x: String?=nil


let y=Optional<String>.Some("hello")

println(y)


//Array
var a = Array<String>()
var b=[String]()
let animals=["Giraffe","Cow","Doggie","Bird"]
//animals.append("Ostrich")
a.append("Ostrich")

for animal in animals{
    println("\(animal)")
}


//Dictionary
var pac10teamRankings=Dictionary<String,Int>()
var pac10teamRankings2=[String:Int]()

pac10teamRankings=["Standford":1,"Cal":10]
let ranking = pac10teamRankings["Ohio State"]

for (key, value) in pac10teamRankings {
    println("\(key) = \(value)")
}


//Range
let array=["a","b","c","d"]

let subArray1=array[2...3]
let subArray2=array[2..<3]
for i in 27...104 {
    println("")
}

let ab:String=",".join(array)

var array2=["a","b","c","d"]
array2 += ["e"]

println("\(array2.first!)")
println("\(array2.last!)")

var array3=[6,3,2,8,1,5]
//array3.sort({return $0 < $1})
array3.sort({(op1,op2) in op1 < op2})
//array3.sort{$0 < $1}
println("\(array3)")
array3.sorted({return $0<$1})

println("\(array2)")
//array2.filter({op1 in op1 == "e"})
let array2_2=array2.filter{$0 != "b"}
println("\(array2_2)")

let array3_2=array3.filter{$0 % 2 == 0}
println("\(array3_2)")
//array2 += ["a","b","c"]

let stringified = [1,2,3].map{"\($0)"}
println("\(stringified)")

let sum = [1,2,3].reduce(0){$0 + $1}
println("\(sum)")



let s=String(52)
let s2="\(37.5)"
//let s3=String(52.5)
let n = 10

//assert(n==9, "message")
//assert(1==0, "message")
let prefix1 = prefix(array3,3)
//println("\(prefix1)")
let re = reverse(array)
reverse(array2)

var str="abcdefg"
reverse(str)
String(reverse(str))
//let backwardsString = String(reverse(array))

