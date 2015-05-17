//
//  LeaderBoardViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/12/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CRToastManager.h"
#import "CRToast.h"
#import "AFHTTPRequestOperationManager.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>
#import <Haneke/Haneke.h>

@interface LeaderBoardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;

@end

@implementation LeaderBoardViewController
{
    NSArray* dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:18];

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];

    [self loadData];

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



#pragma table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"rankingCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
   

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((UILabel*)[cell viewWithTag:2]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:3]).font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    ((UILabel*)[cell viewWithTag:4]).text = [NSString stringWithFormat:@"%li",(long)indexPath.row+1];
    
    ((UIView*)[cell viewWithTag:1]).layer.borderColor = [UIColor colorWithRed:1 green:0.549 blue:0 alpha:1].CGColor;
    ((UIView*)[cell viewWithTag:1]).layer.borderWidth = 1.0f;
    
    NSDictionary* currentDict = [dataSource objectAtIndex:indexPath.row];
    ((UILabel*)[cell viewWithTag:2]).text = [currentDict objectForKey:@"username"];
    ((UILabel*)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@ : %@",@"عدد التوقعات الرابحة",[currentDict objectForKey:@"winningCount"]];
    
}




-(void)loadData
{
    self.bouncingBalls = [PQFBouncingBalls createModalLoader];
    self.bouncingBalls.jumpAmount = 50;
    self.bouncingBalls.zoomAmount = 20;
    self.bouncingBalls.separation = 20;
    [self.bouncingBalls showLoader];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://moh2013.com/arabDevs/FootPoll/getLeaderBoard.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self.bouncingBalls removeLoader];
        if(responseArray.count == 0)
        {
            NSDictionary *options = @{
                                      kCRToastTextKey : @"لا يوجد رابحين إلى الأن",
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
            dataSource = [[NSArray alloc]initWithArray:responseArray copyItems:YES];
            [self.tableView reloadData];
            [self.tableView setNeedsDisplay];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.bouncingBalls removeLoader];
        NSLog(@"Error: %@", error);
    }];
}


@end
