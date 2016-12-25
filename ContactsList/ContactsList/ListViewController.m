//
//  ListViewController.m
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/17/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//

#import "ListViewController.h"
#import "ContactTableViewCell.h"
#import "DataManager.h"
#import <MessageUI/MessageUI.h>

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic,copy) NSArray<Contact *> *allContacts;
@property(nonatomic, assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allContacts = [[DataManager sharedManager] fetchAllContacts];
    
}

// Table view building

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    NSString *firstName = [self.allContacts[indexPath.row] firstName];
    NSString *lastName = [self.allContacts[indexPath.row] lastName];
    cell.contactName.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    cell.contactEmail.text = [self.allContacts[indexPath.row] emailAddress];
    cell.contactMobNumber.text = [self.allContacts[indexPath.row] mobileNumber];
    cell.contactImageView.image = [UIImage imageWithData:[self.allContacts[indexPath.row] photo]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;

    Contact *testContact = self.allContacts[index];
    
    [[DataManager sharedManager] setCurrentContact:testContact];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *detailsView = [UIAlertAction actionWithTitle:@"Details"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                UIViewController *individualRegistration = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsView"];
                                    [self.navigationController pushViewController:individualRegistration
                                                                         animated:YES];
                                                             } ];
    
    UIAlertAction *sendAnEmailView = [UIAlertAction actionWithTitle:@"Send an email"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            
                                                            if ([MFMailComposeViewController canSendMail]){
                                                            MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
                                                            mailVC.mailComposeDelegate = self;
                                                            
                                                            [mailVC setToRecipients:@[testContact.emailAddress]];
                                                            [mailVC setSubject:@"Mail sample"];
                                                            [mailVC setMessageBody:@"Good day!" isHTML:NO];
                                                            
                                                            [self presentViewController:mailVC animated:YES completion:nil];
                                                            } else {
                                                                NSLog(@"Mail services are not available.");
                                                                return;
                                                            }
                                                        } ];
    
    UIAlertAction *phoneCallView = [UIAlertAction actionWithTitle:@"Call"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self dialNumber:testContact.mobileNumber];
                                                        } ];
    
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alert addAction:detailsView];
    [alert addAction:sendAnEmailView];
    [alert addAction:phoneCallView];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

// Mail was sent
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Calling contact
- (void) dialNumber:(NSString*) number{
    number = [@"telprompt://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number] options:@{} completionHandler:nil];
}

//  Deleting contact
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger index = indexPath.row;
        Contact *deletedContact = self.allContacts[index];
        [[DataManager sharedManager] deleteContact:deletedContact];
        [self reload];
    }
}

- (void)reload {
    self.allContacts = [[DataManager sharedManager] fetchAllContacts];
    [self.listTableView reloadData];
}
@end
