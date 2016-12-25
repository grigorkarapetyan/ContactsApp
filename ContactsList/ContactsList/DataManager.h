//
//  DataManager.h
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/17/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MyContact.h"
#import "Contact+CoreDataClass.h"


@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) Contact *currentContact;
@property (nonatomic) BOOL editingRequest;

- (NSArray <Contact *>*)fetchAllContacts ;

- (void)addNewContact:(MyContact *) contact;
- (void)editOldContact:(Contact *) oldContact withContact:(MyContact *) contact;
- (void)deleteContact:(Contact *) contact;


// Coret data part
- (NSManagedObjectContext *)managedObjectContext ;

+ (instancetype)sharedManager;

- (void)saveContext;



@end
