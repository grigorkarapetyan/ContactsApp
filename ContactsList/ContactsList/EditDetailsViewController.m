//
//  EditDetailsViewController.m
//  ContactsList
//
//  Created by Grigor Karapetyan on 12/18/16.
//  Copyright © 2016 Grigor Karapetyan. All rights reserved.
//

#import "EditDetailsViewController.h"
#import "DataManager.h"

@interface EditDetailsViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;
@property (weak, nonatomic) IBOutlet UIImageView *contactPhoto;

@property (nonatomic) BOOL somethingEdited;

@end

@implementation EditDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                initWithTitle:@"Cancel"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = cancelButton;
    
    
    if ([DataManager sharedManager].editingRequest){
        
        self.contact = [DataManager sharedManager].currentContact;
        self.firstNameTextField.text = self.contact.firstName;
        self.lastNameTextField.text = self.contact.lastName;
        self.mobNumberTextField.text = self.contact.mobileNumber;
        self.emailAddressTextField.text = self.contact.emailAddress;
        self.addressTextField.text = self.contact.address;
        self.birthDatePicker.date = self.contact.birthDate;
        self.contactPhoto.image = [UIImage imageWithData:self.contact.photo];
        
    }
}

- (IBAction)savingContact:(id)sender {
    
    // checking if need edit old contact or add new one
    
    if ([DataManager sharedManager].editingRequest) {
        if (self.somethingEdited) {
            if ([self validationCondition]) {
                if ([self mailValidation:self.emailAddressTextField.text]) {
                    MyContact *editedContact = [[MyContact alloc] init];
                    editedContact.firstName = self.firstNameTextField.text;
                    editedContact.lastName = self.lastNameTextField.text;
                    editedContact.mobileNumber = self.mobNumberTextField.text;
                    editedContact.emailAddress = self.emailAddressTextField.text;
                    editedContact.address = self.addressTextField.text;
                    editedContact.birthDate = self.birthDatePicker.date;
                    editedContact.photo = UIImageJPEGRepresentation(self.contactPhoto.image,1.0);

                    [[DataManager sharedManager] editOldContact:self.contact withContact:editedContact];
            
                    UIViewController *listVC = [self.storyboard instantiateViewControllerWithIdentifier:@"listVC"];
                    [self.navigationController setViewControllers:@[listVC] animated:YES];
                    [[DataManager sharedManager] setEditingRequest:NO];
                } else {
                    [self emailValidationAlert];
                }
        } else {
            [self validationAlert];
        }
        }
    } else {
 //              first time adding contact
    if ([self validationCondition]) {
        if ([self mailValidation:self.emailAddressTextField.text]){
            MyContact *newContact = [[MyContact alloc] init];
            newContact.firstName = self.firstNameTextField.text;
            newContact.lastName = self.lastNameTextField.text;
            newContact.mobileNumber = self.mobNumberTextField.text;
            newContact.emailAddress = self.emailAddressTextField.text;
            newContact.address = self.addressTextField.text;
            newContact.birthDate = self.birthDatePicker.date;
            newContact.photo = UIImageJPEGRepresentation(self.contactPhoto.image,1.0);
            
            
            [[DataManager sharedManager] addNewContact:newContact];
            
            UIViewController *listVC = [self.storyboard instantiateViewControllerWithIdentifier:@"listVC"];
            [self.navigationController setViewControllers:@[listVC] animated:YES];
        } else {
            [self emailValidationAlert];
        }
    } else {
        [self validationAlert];
    }
    }
}

- (BOOL)validationCondition {
    if (![self.firstNameTextField.text isEqualToString:@""] && ![self.lastNameTextField.text isEqualToString:@""] && ![self.mobNumberTextField.text isEqualToString:@""] && ![self.emailAddressTextField.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)validationAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete data"
                                                                   message:@"Full name,email,mob.number required"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
// Email validation

- (BOOL)mailValidation:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}
- (void)emailValidationAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid email"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

// Setting photo

- (IBAction)changePhoto {
    [self settingPhoto];
}

- (void)settingPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    self.contactPhoto.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.somethingEdited = YES;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// Something edited

- (IBAction)editingInfoChanged:(id)sender {
    self.somethingEdited = YES;
}

// CHECKING editing request 
//- (void)viewDidAppear:(BOOL)animated {
//    if ([DataManager sharedManager].editingRequest){
//        NSLog(@"editing request : YES");
//    } else {
//        NSLog(@"editing request : NO");
//    }
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    if ([DataManager sharedManager].editingRequest){
//        NSLog(@"editing request : YES");
//    } else {
//        NSLog(@"editing request : NO");
//    }
//}

@end
