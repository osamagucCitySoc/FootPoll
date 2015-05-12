//
//  MyStatsViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/11/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "MyStatsViewController.h"
#import "PNChart.h"

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
@end

@implementation MyStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:18];
    
    self.userNameLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:18];
    
    self.emailLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.emailRealLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.rankingRealLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.rabkingLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.favoriteLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    self.favoriteRealLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
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
    [self.barChart setYValues:@[@20,@40,@35]];
    [self.barChart setStrokeColors:@[[UIColor colorWithRed:0.901 green:0.494 blue:0.133 alpha:1],[UIColor colorWithRed:0.945 green:0.768 blue:0.058 alpha:1],[UIColor colorWithRed:0.498 green:0.549 blue:0.552 alpha:1]]];
    
    self.barChart.labelTextColor = [UIColor whiteColor];
    self.barChart.showLabel = YES;

    [self.barChart strokeChart];
    
    
    [self.holderView addSubview:self.barChart];

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
