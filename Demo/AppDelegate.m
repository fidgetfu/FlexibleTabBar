
#import "AppDelegate.h"
#import "ListView.h"
#import "FTB-Settings.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(void)customiseAppearance {
    // CUSTOMISE NAV BARS
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                       forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundColor:BUTTON_BG];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage alloc]
                            forToolbarPosition:UIToolbarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setBackgroundColor:BUTTON_BG];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      BUTTON_FG,
      NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:22.0f],
      NSFontAttributeName,
      nil]];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customiseAppearance];
    
    // SET UP TAB BAR CONTROLLER
    
    // 1st view
	ListView *ListView1 = [[ListView alloc] initWithStyle:UITableViewStylePlain];
    ListView1.managedObjectContext = self.managedObjectContext;
    ListView1.title = @"rocket";
    UINavigationController * navigationController1 = [[UINavigationController alloc]
                                                     initWithRootViewController:ListView1];
    // 2nd view
	ListView *ListView2 = [[ListView alloc] initWithStyle:UITableViewStylePlain];
    ListView2.title = @"clock";
	ListView2.managedObjectContext = self.managedObjectContext;
    UINavigationController * navigationController2 = [[UINavigationController alloc]
                                                     initWithRootViewController:ListView2];
    
    // 3rd 4th and 5th views
	ListView *ListView3 = [[ListView alloc] initWithStyle:UITableViewStylePlain];
    ListView3.title = @"tag";

	NSArray *viewControllers = @[navigationController1, navigationController2, ListView3];
	FlexibleTabBarController *tabBarController = [[FlexibleTabBarController alloc] init];

	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;

	// Uncomment this to select "Tab 2".
	//tabBarController.selectedIndex = 1;
	// Uncomment this to select "Tab 3".
	//tabBarController.selectedViewController = ListView3;

    // CREATE THE WINDOW
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (BOOL)flex_tabBarController:(FlexibleTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
	
	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);
	return YES;
}

- (void)flex_tabBarController:(FlexibleTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

# pragma mark - Core Data

- (void)insertNewObject:(id)sender
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
    
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
