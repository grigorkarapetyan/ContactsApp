//
//  Contact+CoreDataProperties.h
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/18/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Contact+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

+ (NSFetchRequest<Contact *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *mobileNumber;
@property (nullable, nonatomic, copy) NSString *emailAddress;
@property (nullable, nonatomic, copy) NSDate *birthDate;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, retain) NSData *photo;

@end

NS_ASSUME_NONNULL_END
