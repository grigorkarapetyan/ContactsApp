//
//  MyContact.h
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/18/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyContact : NSObject
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *mobileNumber;
@property (nonatomic,copy) NSString *emailAddress;
@property (nonatomic,copy) NSDate *birthDate;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSData *photo;

@end
