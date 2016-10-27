# Todo app guide [in Swift 3]

This document is a guide on how to buld a iOS TODO list app using Skygear with Swift. It contains the following features:

* Basic user sign-up / login
* Adding todo items
* Editing todo items
* Synchronizing items across devices

## Sample code

We will break down the app development into 5 steps as listed below.

- Step0: Initial Scaffolded project [Download zip](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step0.zip)
- Step1: Basic UI and displaying todo items in a list [Download zip](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step1.zip)
- Step2: Adding "Edit" and "+" Button [Download zip](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step2.zip)
- Step3: Saving todo items to the cloud [Download zip](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step3.zip)
- Step4: Adding the item detail UI - we can edit items now [Download zip](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step4.zip)
- Step5: Synchronizing todo items without app refresh [Download zip](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step5.zip)

## Step 0: Scaffolding the iOS app with Skygear

### Setting up the Skygear Server: Signup at portal.skygear.io
1. You can [sign up](https://portal.skygear.io/signup) for the Skygear backend
2. Under the "INFO" tab in the portal, you can obtain your Skygear server endpoint and the API Key. You will need them to connect your app to the server

### Scaffolding the app
Open terminal and execute the following command:

`pod lib create --silent --template-url=https://github.com/SkygearIO/skygear-Scaffolding-iOS.git "SkygearTodoList"`

- You will need to answer the questions as prompted
- After running the script, a scarffolding app with signup and login features will be created.

If you encounter problems in the above step, you can also download the scaffolded project zip here: [Download Project zip of Step 0](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step0.zip)


### Testing the sign-up and login feature

To ensure the iOS app has been set up properly, you can test signing up as a new user or logging in with an existing user. 

If you downloaded the scaffolded zip directly, you will need to fill in the app endpoint and API Key info in the file `AppDelegate.swift`.

## Step 1: Basic todo list UI

### Creating the Todo list UI

Then we will need to build the UI.

Drag the following things to the Story board:

* UITabViewController, and set it as the entry point
* Add the previous login view as one of the Tab Bar Items to the Tab view.
* Add a NavigationController, as one of the Tab Bar Items to the Tab view.
* A UITableViewController is automatically added, as the default root view controller of the Navigation Controller

The Storyboard now should look like this:

![](img/storyboard1.png)

You can download the sample and see the how the project should look like here: [Download Project zip of Step 1](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step1.zip)


### Displaying the existing todo items in the tableview

We will use a table view to show the todo items. Create a `UITableViewController` Class and name it `TodoTableViewController`.

There are a few functions in `TodoTableViewController` we will need to implement:

`func numberOfSections(in tableView: UITableView) -> Int {`

`func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int`

`func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell`

The implementation is already included in the Step 1: [Download Project zip of Step 1](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step1.zip)


## Step 2: Adding and editing todo items via the "Edit" and "Add" button

We now wish to add 2 buttons: 
1. "Edit" button, to edit or delete an item
2. "+" button, to add button


### "Edit" button

You can uncomment the codes for the "Edit" button to show the button:

```
// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
// self.navigationItem.rightBarButtonItem = self.editButtonItem()
```

Imagine we want to have the edit button on the top left instead of the right, you can change the line to:

`self.navigationItem.leftBarButtonItem = self.editButtonItem()`

### "Add" button

To add the "Add" button, use the following code:

```
let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
```

We now can see the buttons appear on the todo list page: [Download Project zip of Step 2](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step2.zip)


### Saving to todo items to the cloud when user adds a new item

To save the todo item record, we will implement the `insertNewObject()`

We will save the item as a `SKYRecord(recordType: "todo")`, and set its value for each key we wish to save. 

```
    func insertNewObject(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Todo item", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            
            // Cloud save
            let title = alertController.textFields![0].text
            let todo = SKYRecord(recordType: "todo")
            todo?.setObject(title!, forKey: "title" as NSCopying!)
            todo?.setObject(SKYSequence(), forKey: "order" as NSCopying!)
            todo?.setObject(false, forKey: "done" as NSCopying!)
            
            self.privateDB?.save(todo, completion: { (record, error) in
                if (error != nil) {
                    print("error saving todo: \(error)")
                    return
                }
                
                self.objects.insert(todo!, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            })
        }))
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        self.present(alertController, animated: true, completion: nil)
    }

```

Now every todo item will be saved to the cloud. You can retrieve them when logging in through another device.
[Download Project zip of Step 3](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step3.zip)


## Step 4: Creating the details UI

### Deleting Items

As we query `todo` items on the criteria `done==false`, we can mark `done` as `true` in order to delete a todo item.

It can be achieved with the following code in the `tableView`.



```
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let todo = objects[(indexPath as NSIndexPath).row] as! SKYRecord
            todo.setObject(true, forKey: "done" as NSCopying!)
            self.privateDB?.save(todo, completion: { (record, error) in
                if (error != nil) {
                    print("error saving todo: \(error)")
                    return
                }
                
                self.objects.remove(at: (indexPath as NSIndexPath).row) as! SKYRecord
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
```

### Editing items

To allow editing a todo item, we need to add a View Controller to the Storyboard, and create a `DetailViewController` class.

We will add a view controller in the storyboard.

![](img/storyboard2.png)

We only need two simple text fields in this view.

Connect the segue from the cell in the `TodoTableViewController`, and choose the `show` option. When the user taps the cell, it will show the detail view.

In `DetailViewController.swift`, we will need to do the following two things:

1. Fill in the data
2. Listen for field changes and save the record.


We can now edit the items in the detail view and mark the item as deleted. You can download the sample project here: [Download Project zip of Step 4](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step4.zip)

## Step 5: Synchronizing the todo list

## Sync the todo list with query subscription

We will implement the data synchronization using the Skygear query change subscription.

The steps are:

1. Register the device for push notification
2. Define the query change subscription and add the listener
3. Add code to handle the changes

Register in application delegate

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    some code…
    
    // This will prompt the user for permission to send remote notification
        application.registerUserNotificationSettings(UIUserNotificationSettings())
        application.registerForRemoteNotifications()
    
    return true
}
```


```
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("Registered for Push notifications with token: \(deviceToken)");
}
```

```
SKYContainer.default().registerDeviceCompletionHandler { (deviceID, error) in
    if error != nil {
        print("Failed to register device: \(error)")
        return
    }
            
    // You should put subscription creation logic in the following method
    self.addSubscription(deviceID!)
}
```

Update action

```
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    some code…
    
    SKYContainer.default().delegate = self
    
    some code..
}
```

We need to set the AppDelegate to implement `SKYContainerDelegate`

And we need to implement `didReceiveNotification` in `AppDelegate` 

```
func container(_ container: SKYContainer!, didReceive notification: SKYNotification!) {
    print("received notification = \(notification)");
    NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedNotificationFromSkygaer), object: notification)
}
```

Add query subscription

```
func addSubscription(_ deviceID: String) {
    let query = SKYQuery(recordType: "todo", predicate: nil)
    let subscription = SKYSubscription(query: query, subscriptionID: "my todos")
    
    let operation = SKYModifySubscriptionsOperation(deviceID: deviceID, subscriptionsToSave: [subscription])
    operation?.deviceID = deviceID
    operation?.modifySubscriptionsCompletionBlock = { (savedSubscriptions, operationError) in
        DispatchQueue.main.async {
            if operationError != nil {
                print(operationError)
            }
        }
    };
    SKYContainer.default().privateCloudDatabase.execute(operation)
}
```

In `TodoTableViewController`, let's tell the table view controller to update the data when there is remote notifications. We will do this in `viewDidLoad`.

```
override func viewDidLoad() {
    some code...
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ReceivedNotificationFromSkygaer), object: nil, queue: OperationQueue.main) { (notification) in
        self.updateData()
    }
    
    some code...
}
```

You will be able to see the synchronization result in the demo project:
[Download Project zip of Step 5](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step5.zip)


## Done!
We now have a full-featured todo list app:

* Basic user sign-up / login
* Adding todo items
* Editing todo items
* Synchronizing items across devices

You can download the complete project here: [Download Project zip of Step 5](https://github.com/skygear-demo/swift-meetup-todo-app/archive/step5.zip)


Thanks :)
