//
//  LoginViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/10/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "LoginViewController.h"
#import "CRToastManager.h"
#import "CRToast.h"
#import "AFHTTPRequestOperationManager.h"
#import "AllMatchesViewController.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation LoginViewController
{
    NSDictionary* loggedUser;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"loginSeg"])
    {
        AllMatchesViewController* dst = (AllMatchesViewController*)[segue destinationViewController];
        [dst setLoggedUser:loggedUser];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.borderColor = [[UIColor alloc]initWithWhite:1 alpha:1].CGColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:22];
    
    
    self.forgetPasswordButton.layer.borderWidth = 1;
    self.forgetPasswordButton.layer.cornerRadius = 5;
    self.forgetPasswordButton.layer.borderColor = [UIColor colorWithRed:1 green:0.549 blue:0 alpha:1].CGColor;
    self.forgetPasswordButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    
    self.hintLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];

    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:18];
    
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"إسم المستخدم" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.691 green:0.691 blue:0.691 alpha:1]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"كلمة السر" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.691 green:0.691 blue:0.691 alpha:1]}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissClicked:(id)sender {
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.75;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonClicked:(id)sender {
    
    self.bouncingBalls = [PQFBouncingBalls createModalLoader];
    self.bouncingBalls.jumpAmount = 50;
    self.bouncingBalls.zoomAmount = 20;
    self.bouncingBalls.separation = 20;
    [self.bouncingBalls showLoader];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"userName": self.userNameTextField.text,@"userPassword": self.passwordTextField.text};
    [manager POST:@"http://moh2013.com/arabDevs/FootPoll/login.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self.bouncingBalls removeLoader];
        if(responseArray.count == 0)
        {
            NSDictionary *options = @{
                                      kCRToastTextKey : @"إسم المستخدم أو كلمة السر خطأ",
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : [UIColor redColor],
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                      };
            [CRToastManager showNotificationWithOptions:options
                                        completionBlock:^{
                                            NSLog(@"Completed");
                                        }];
        }else
        {
            [self.bouncingBalls removeLoader];
            loggedUser = [responseArray objectAtIndex:0];
            [self performSegueWithIdentifier:@"loginSeg" sender:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.bouncingBalls removeLoader];
        NSLog(@"Error: %@", error);
    }];
}
@end
