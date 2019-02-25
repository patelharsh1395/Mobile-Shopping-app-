//
//  Customer.swift
//  Group1_W2019_3004
//
//  Created by Harsh on 2019-02-19.
//  Copyright © 2019 Harsh. All rights reserved.
//

import Foundation



class Customer : User
{
    static var counter = 0
    var custid : Int!
    var customerName : String!
    var address : String!
    var email : String!
    var creaditCardInfo : Int!
    var current_add_id = 0
  //  var shippingInfo : String!
    let shopping_cart = ShoppingCart.getShoppingCart()
   var orders : [Orders]!
    static var cust_arr = [Customer]()
    
    
    
    
    override private init()
    {
        Customer.counter+=1
        self.custid = Customer.counter
        super.init()
    }
    
    
    
    func addOrders(od : Orders)
    {
        orders.append(od)
    }
    
    
    
    
    static func register(customerName : String, address : String, email : String, creaditCardInfo : Int , user : User ) throws -> Bool
    {
        if(!creaditCardInfo.isValidCard())
        {
            throw CustomError.INVALID(" Invalid credit card ")
        }
        
        if(address == "" || address.isEmpty)
        {
            throw CustomError.INVALID("Address cannot be empty")
        }
        let cust = Customer()
        cust.userId = user.userId
        cust.password = user.password
        cust.customerName = customerName
        cust.address = address
        cust.email = user.userId
        cust.creaditCardInfo = creaditCardInfo
        //cust.shippingInfo = shippingInfo
      
       // cust.shopping_cart =
       cust.orders = []
        
        Customer.cust_arr.append(cust)
        return true
    }
    
    
    
    
    static func login(userid: String , pass : String) throws -> Customer
    {
        var counter = 1
        for Cust in Customer.cust_arr
        {
            if(Cust.userId == userid && Cust.password == pass)
            {
                counter = 0
                return Cust
                
            }
        }
        if(counter == 1)
        {
            throw CustomError.INVALID("Invalid userid and password")
        }
        
    }
    
    
    
    
    static func updateProfile(userid : String , pass : String )
    {
        //try var cust =  Customer.login(userid: userid , pass: pass )
        
    }
    
    
    
    
    
    func placeOrder(shippingInfo : ShippingInfo ) throws
    {
        if(self.shopping_cart.readonly_checkout)
        {
                var orderTemp =  Orders.createOrder(custId: self.custid , custName: self.customerName,  si: shippingInfo , shoppringCart: self.shopping_cart.readItemFromCart)
               // print(orderTemp.custName)
               // self.shopping_cart.deleteAll()
                self.orders.append(orderTemp)
                orderTemp.placeOrder()
            self.shopping_cart.deleteAll()
        }
        else
        {
            throw CustomError.INVALID("Need to checkout from shopping cart")
        }
    }

    override func display() -> String {
        var str = ""
        if(!self.orders.isEmpty)
        {
            
                for  ord in self.orders
                {
                    ord.order_details.calcprice()
                }
        }
        else
        {
            str += "\(self.userId) , \(self.customerName) has no order history"
        }
        return str
    }
    
}
