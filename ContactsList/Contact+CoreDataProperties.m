//
//  Contact+CoreDataProperties.m
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/18/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Contact+CoreDataProperties.h"

@implementation Contact (CoreDataProperties)

+ (NSFetchRequest<Contact *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic mobileNumber;
@dynamic emailAddress;
@dynamic birthDate;
@dynamic address;
@dynamic photo;

@end
