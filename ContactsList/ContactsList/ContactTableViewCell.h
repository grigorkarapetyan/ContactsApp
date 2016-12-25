//
//  ContactTableViewCell.h
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/17/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactMobNumber;
@property (weak, nonatomic) IBOutlet UILabel *contactEmail;

@end
