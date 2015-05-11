//
//  ViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/10/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "LoginViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorialButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoButton;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.borderColor = [[UIColor alloc]initWithWhite:1 alpha:1].CGColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:22];
    
    self.registerButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:17];
    
    self.hintLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    
    self.tutorialButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
   
    [self animateToUp:self.loginButton delay:0.5];
    [self animateToUp:self.registerButton delay:0.6];
    [self animateToUp:self.hintLabel delay:0.65];
    
    CGRect loginOriginalFrame = self.tutorialButton.frame;
    CGRect loginToFrame = loginOriginalFrame;
    loginToFrame.origin.y = -50-self.tutorialButton.frame.size.height;
    self.tutorialButton.frame = loginToFrame;
    
    [UIView animateWithDuration:0.75
                          delay: 0.65
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.tutorialButton.frame = loginOriginalFrame;
                     }
                     completion:^(BOOL finished){}];

    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    self.loadingView.layer.cornerRadius  = 10;
    
    //[GMDCircleLoader setOnView:self.loadingView withTitle:@"رجاء الإنتظار" animated:YES];


}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = .5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.05];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    [self.logoButton.layer addAnimation:pulseAnimation forKey:nil];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.logoButton.layer removeAllAnimations];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)animateToUp:(UIView*)viewToAnimate delay:(float)delay
{
    CGRect loginOriginalFrame = viewToAnimate.frame;
    CGRect loginToFrame = loginOriginalFrame;
    loginToFrame.origin.y += self.view.frame.size.height+100;
    viewToAnimate.frame = loginToFrame;
    
    [UIView animateWithDuration:0.75
                          delay: delay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         viewToAnimate.frame = loginOriginalFrame;
                     }
                     completion:^(BOOL finished){}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonClicked:(id)sender {
    
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.autoreverses = YES;
    LoginViewController* destinationViewController = [[LoginViewController alloc]init];
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:destinationViewController animated:NO];
}

@end
