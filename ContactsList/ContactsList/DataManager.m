//
//  DataManager.m
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/17/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}

// Fetching all contacts

- (NSArray <Contact *>*)fetchAllContacts {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                     [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    return [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}

// Adding new contact

- (void)addNewContact:(MyContact *) contact {
    NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
    Contact *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    
    newContact.firstName = contact.firstName;
    newContact.lastName = contact.lastName;
    newContact.mobileNumber = contact.mobileNumber;
    newContact.emailAddress = contact.emailAddress;
    newContact.address = contact.address;
    newContact.birthDate = contact.birthDate;
    newContact.photo = contact.photo;

    [[DataManager sharedManager] saveContext];

}

// Editing existed contact

- (void)editOldContact:(Contact *) oldContact withContact:(MyContact *) contact {
    
    oldContact.firstName = contact.firstName;
    oldContact.lastName = contact.lastName;
    oldContact.mobileNumber = contact.mobileNumber;
    oldContact.emailAddress = contact.emailAddress;
    oldContact.address = contact.address;
    oldContact.birthDate = contact.birthDate;
    oldContact.photo = contact.photo;
    
    [[DataManager sharedManager] saveContext];
}

// Deleting contact

- (void)deleteContact:(Contact *) contact {
    NSManagedObjectContext *context = [contact managedObjectContext];
    [context deleteObject:contact];
    
    [[DataManager sharedManager] saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    return context;
}

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ContactsList"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {

                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
