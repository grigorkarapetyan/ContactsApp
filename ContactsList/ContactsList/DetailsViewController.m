//
//  DetailsViewController.m
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/18/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//

#import "DetailsViewController.h"
#import "DataManager.h"
#import "EditDetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mobNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contactPhoto;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                initWithTitle:@"Back"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    
    self.contact = [DataManager sharedManager].currentContact;
    
    self.firstNameLabel.text = self.contact.firstName;
    self.lastNameLabel.text = self.contact.lastName;
    self.mobNumberLabel.text = self.contact.mobileNumber;
    self.addressLabel.text = self.contact.address;
    self.mailAddressLabel.text = self.contact.emailAddress;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    self.birthDateLabel.text = [formatter stringFromDate:self.contact.birthDate];
    if (self.contact.photo) {
        self.contactPhoto.image = [UIImage imageWithData:self.contact.photo];
    }
}

- (IBAction)startForEdit:(id)sender {
    [self performSegueWithIdentifier:@"goForEdit" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goForEdit"]) {
        EditDetailsViewController *editVC = [segue destinationViewController];
        [[DataManager sharedManager] setEditingRequest:YES];
    };
}
- (void)viewDidAppear:(BOOL)animated {
    [[DataManager sharedManager] setEditingRequest:NO];

}

@end
