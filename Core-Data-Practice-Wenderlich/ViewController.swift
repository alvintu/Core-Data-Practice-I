//
//  ViewController.swift
//  Core-Data-Practice-Wenderlich
//
//  Created by Jo Tu on 11/4/16.
//  Copyright © 2016 alvorithms. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var names = [String]()
    var people = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        self.automaticallyAdjustsScrollViewInsets = false
        //set a title and register UITableViewCell class with the tableview
        //when we dequeue a cell, the table view will return a cell of the correct type
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let person = people[indexPath.row]
        print(people[indexPath.row])
        
        cell!.textLabel!.text = person.valueForKey("name") as? String
        
        
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        //1 - before you can do anything with core data, ou need a managed object context. same with fetching.
        //pull up app delegate then graph reference to its managed object context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2-NSFetchRequest is the class responsible for fetching from Core Data. Fetch requests are both powerful and flexible. YOu can use requests to fetch a set of bjects that meet particular critera. Fetch requests have several qualifiers that refine the set of results they reutrn. For now, you should know that NSEntityDescription is one of these qualifiers(required).
    //setting a fetchrequest's entity property(or initalizing it with entityName) fetches ALL objects of a particular entity
    //we fetch all Person entities here
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3-hand fetch request over to the managed object context to the heavy lifting
    //executeFetchquest() returns array of managed objdcts that meets criteria specificied by fetch request
        do{
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }

    @IBAction func addName(sender: AnyObject) {
   
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title:"Save",style:.Default, handler: {(action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.saveName(textField!.text!)
            print(textField!.text!)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action:UIAlertAction) -> Void  in
            }
        
        alert.addTextFieldWithConfigurationHandler{
            (textField:UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.view.setNeedsLayout()
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveName(name:String){
        
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
    let managedContext = appDelegate.managedObjectContext
        
    let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
    let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
    person.setValue(name, forKey: "name")

        
    do {
        try managedContext.save()
        people.append(person)
        print(people.count)
    } catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)")
        }
        
    
    }
}

