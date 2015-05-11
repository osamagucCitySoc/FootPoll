//
//  AddUserViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/11/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "AddUserViewController.h"
#define k_KEYBOARD_OFFSET 80.0


@interface AddUserViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseClubButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIView *clubChoosingView;
@property (weak, nonatomic) IBOutlet UITableView *clubChoosingTable;

@end

@implementation AddUserViewController
{
    BOOL keyboardIsShowing;
    CGFloat keyboardHeight;
    CGRect originalClubViewFrame;
    CGRect hideClubViewFrame;
    NSArray* dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.borderColor = [[UIColor alloc]initWithWhite:1 alpha:1].CGColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:22];
    
    
//    self.chooseClubButton.layer.borderWidth = 1;
//    self.chooseClubButton.layer.cornerRadius = 5;
//    self.chooseClubButton.layer.borderColor = [UIColor colorWithRed:0.593 green:0.746 blue:1 alpha:1].CGColor;
//    self.forgetPasswordButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    
    self.hintLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    
    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:18];
    
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"البريد الإلكتروني" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.691 green:0.691 blue:0.691 alpha:1]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"كلمة السر" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.691 green:0.691 blue:0.691 alpha:1]}];
    self.countryTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"فريقك المفضل" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.691 green:0.691 blue:0.691 alpha:1]}];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"إسم المستخدم" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.691 green:0.691 blue:0.691 alpha:1]}];
    
    [self.userNameTextField setDelegate:self];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"clubs" ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    dataSource = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    
    [self.clubChoosingTable reloadData];
    [self.clubChoosingTable setNeedsDisplay];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    originalClubViewFrame = self.clubChoosingView.frame;
    hideClubViewFrame = originalClubViewFrame;
    hideClubViewFrame.origin.y = self.view.frame.size.height+50;
    //self.clubChoosingView.frame = hideClubViewFrame;
    self.clubChoosingView.alpha = 0;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)keyboardWillAppear {
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewUp:NO];
    }
}

-(void)keyboardWillDisappear {
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewUp:NO];
    }
}

-(void)moveViewUp:(BOOL)bMovedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    CGRect rect = self.view.frame;
    if (bMovedUp) {
        rect.origin.y -= k_KEYBOARD_OFFSET;
        rect.size.height += k_KEYBOARD_OFFSET;
    } else {
        rect.origin.y += k_KEYBOARD_OFFSET;
        rect.size.height -= k_KEYBOARD_OFFSET;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (IBAction)dismissClicked:(id)sender {
    CATransition* transition = [CATransition animation];
    
    transition.duration = 1.3;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dataSource objectAtIndex:section] objectForKey:@"countryClubs"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"clubCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"clubName"  ascending:YES];
    NSArray* clubs = [[dataSource objectAtIndex:indexPath.section] objectForKey:@"countryClubs"];
    clubs = [clubs sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];

    
    cell.textLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    cell.textLabel.textAlignment = NSTextAlignmentRight;

    [[cell textLabel]setText:[[clubs objectAtIndex:indexPath.row] objectForKey:@"clubName"]];
    
    [cell.textLabel setNeedsDisplay];
    [cell setNeedsDisplay];
   
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor grayColor]; //here you can change the text color of header.
    tempLabel.text= [[dataSource objectAtIndex:section]objectForKey:@"countryName"];
    tempLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    tempLabel.textAlignment = NSTextAlignmentLeft;

    [tempView addSubview:tempLabel];
    
    return tempView;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[dataSource objectAtIndex:section]objectForKey:@"countryName"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.countryTextField setText:[[[self.clubChoosingTable cellForRowAtIndexPath:indexPath]textLabel]text]];
    
    [self hideClubTable];
}

- (IBAction)showClubClicked:(id)sender {
    [self showClubTable];
}
- (IBAction)hideClubClicked:(id)sender {
    [self hideClubTable];
}

-(void)showClubTable
{
    self.clubChoosingView.alpha = 0;
    
    [UIView animateWithDuration:0.75
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.clubChoosingView.alpha = 1;
                     }
                     completion:^(BOOL finished){}];
    
}

-(void)hideClubTable
{
    //self.clubChoosingView.frame = originalClubViewFrame;
    self.clubChoosingView.alpha = 1;
    
    [UIView animateWithDuration:0.75
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.clubChoosingView.alpha = 0;
                     }
                     completion:^(BOOL finished){}];

}
@end
