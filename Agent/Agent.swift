//
//  Agent.swift
//  Agent
//
//  Created by Christoffer Hallas on 6/2/14.
//  Copyright (c) 2014 Christoffer Hallas. All rights reserved.
//

import Foundation

public class Agent {

  public typealias Headers = Dictionary<String, String>
  public typealias Response = (NSHTTPURLResponse?, AnyObject?, NSError?) -> Void

  /**
   * Members
   */

  var base: NSURL?
  var request: NSMutableURLRequest?
  let queue = NSOperationQueue()

  /**
   * Initialize
   */
  
  init(base: String) {
    self.base = NSURL(string: base)
  }

  init(method: String, url: String, headers: Headers?) {
    self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
    self.request!.HTTPMethod = method
    if (headers != nil) {
      self.request!.allHTTPHeaderFields = headers!
    }
  }

  /**
   * GET
   */

  public class func get(url: String) -> Agent {
    return Agent(method: "GET", url: url, headers: nil)
  }

  public class func get(url: String, headers: Headers) -> Agent {
    return Agent(method: "GET", url: url, headers: headers)
  }

  public class func get(url: String, done: Response) -> Agent {
    return Agent.get(url).end(done)
  }

  public class func get(url: String, headers: Headers, done: Response) -> Agent {
    return Agent.get(url, headers: headers).end(done)
  }

  /**
   * POST
   */

  public class func post(url: String) -> Agent {
    return Agent(method: "POST", url: url, headers: nil)
  }

  public class func post(url: String, headers: Headers) -> Agent {
    return Agent(method: "POST", url: url, headers: headers)
  }

  public class func post(url: String, done: Response) -> Agent {
    return Agent.post(url).end(done)
  }

  public class func post(url: String, headers: Headers, data: AnyObject) -> Agent {
    return Agent.post(url, headers: headers).send(data)
  }

  public class func post(url: String, data: AnyObject) -> Agent {
    return Agent.post(url).send(data)
  }

  public class func post(url: String, data: AnyObject, done: Response) -> Agent {
    return Agent.post(url, data: data).send(data).end(done)
  }

  public class func post(url: String, headers: Headers, data: AnyObject, done: Response) -> Agent {
    return Agent.post(url, headers: headers, data: data).send(data).end(done)
  }

  /**
   * PUT
   */

  public class func put(url: String) -> Agent {
    return Agent(method: "PUT", url: url, headers: nil)
  }

  public class func put(url: String, headers: Headers) -> Agent {
    return Agent(method: "PUT", url: url, headers: headers)
  }

  public class func put(url: String, done: Response) -> Agent {
    return Agent.put(url).end(done)
  }

  public class func put(url: String, headers: Headers, data: AnyObject) -> Agent {
      return Agent.put(url, headers: headers).send(data)
  }

  public class func put(url: String, data: AnyObject) -> Agent {
    return Agent.put(url).send(data)
  }

  public class func put(url: String, data: AnyObject, done: Response) -> Agent {
    return Agent.put(url, data: data).send(data).end(done)
  }

  public class func put(url: String, headers: Headers, data: AnyObject, done: Response) -> Agent {
    return Agent.put(url, headers: headers, data: data).send(data).end(done)
  }

  /**
   * DELETE
   */

  public class func delete(url: String) -> Agent {
    return Agent(method: "DELETE", url: url, headers: nil)
  }

  public class func delete(url: String, headers: Headers) -> Agent {
    return Agent(method: "DELETE", url: url, headers: headers)
  }

  public class func delete(url: String, done: Response) -> Agent {
    return Agent.delete(url).end(done)
  }

  public class func delete(url: String, headers: Headers, done: Response) -> Agent {
    return Agent.delete(url, headers: headers).end(done)
  }

  /**
   * Methods
   */

  func send(data: AnyObject) -> Agent {
    var error: NSError?
    let json = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &error)
    self.set("Content-Type", value: "application/json")
    self.request.HTTPBody = json
    return self
  }

  func set(header: String, value: String) -> Agent {
    self.request.setValue(value, forHTTPHeaderField: header)
    return self
  }

  func end(done: Response) -> Agent {
    let completion = { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      if error != .None {
        done(.None, data, error)
        return
      }
      var error: NSError?
      var json: AnyObject!
      if data != .None {
        json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
      }
      let res = response as! NSHTTPURLResponse
      done(res, json, error)
    }
    NSURLConnection.sendAsynchronousRequest(self.request, queue: self.queue, completionHandler: completion)
    return self
  }

}
