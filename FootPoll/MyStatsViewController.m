//
//  MyStatsViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/11/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "MyStatsViewController.h"
#import "PNChart.h"
#import "CRToastManager.h"
#import "CRToast.h"
#import "AFHTTPRequestOperationManager.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>
#import <Haneke/Haneke.h>

@interface MyStatsViewController ()
@property (weak, nonatomic) IBOutlet UIView *holderView;
@property (nonatomic, strong) PNBarChart * barChart;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *rabkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailRealLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteRealLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankingRealLabel;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation MyStatsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:18];
    
    self.userNameLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:18];
    self.userNameLabel.text = [self.loggedUser objectForKey:@"username"];
    
    self.emailLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.emailRealLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.emailRealLabel.text = [self.loggedUser objectForKey:@"email"];
    
    self.rankingRealLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.rabkingLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];

    self.favoriteLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.favoriteRealLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.favoriteRealLabel.text = [self.loggedUser objectForKey:@"club"];
   
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    
    self.bouncingBalls = [PQFBouncingBalls createModalLoader];
    self.bouncingBalls.jumpAmount = 50;
    self.bouncingBalls.zoomAmount = 20;
    self.bouncingBalls.separation = 20;
    [self.bouncingBalls showLoader];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary* params = @{@"userID":[self.loggedUser objectForKey:@"id"]};
    
    [manager POST:@"http://moh2013.com/arabDevs/FootPoll/getMyStats.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        int totalVotes = [[[responseArray objectAtIndex:0] objectForKey:@"countVotes"] intValue];
        int winningVotes = [[[responseArray objectAtIndex:1] objectForKey:@"countVotes"] intValue];
        int rightVotes = [[[responseArray objectAtIndex:2] objectForKey:@"countVotes"] intValue];
        int rightLosing = rightVotes-winningVotes;
        int wrongVotes = totalVotes-rightVotes;
        
        [self.bouncingBalls removeLoader];
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(5, 25, self.holderView.frame.size.width-10, self.holderView.frame.size.height-50)];
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.yLabelFormatter = ^(CGFloat yValue){
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
            return labelText;
        };
        self.barChart.barWidth = 20.0;
        self.barChart.labelMarginTop = 5.0;
        [self.barChart setXLabels:@[@"توقعات صحيحة\nرابحة",@"توقعات صحيحة\nغير رابحة",@"توقعات خاطئة"]];
        self.barChart.rotateForXAxisText = true ;
        [self.barChart setBarBackgroundColor:[UIColor clearColor]];
        
        [self.barChart setYValues:@[[[NSNumber alloc]initWithInt:rightVotes],[[NSNumber alloc]initWithInt:rightLosing],[[NSNumber alloc]initWithInt:wrongVotes]]];
        [self.barChart setStrokeColors:@[[UIColor colorWithRed:0.901 green:0.494 blue:0.133 alpha:1],[UIColor colorWithRed:0.945 green:0.768 blue:0.058 alpha:1],[UIColor colorWithRed:0.498 green:0.549 blue:0.552 alpha:1]]];
        
        self.barChart.labelTextColor = [UIColor whiteColor];
        self.barChart.showLabel = YES;
        
        [self.barChart strokeChart];
        
        
        [self.holderView addSubview:self.barChart];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.bouncingBalls removeLoader];
        NSLog(@"Error: %@", error);
    }];
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

@end
