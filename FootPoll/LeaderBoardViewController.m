//
//  LeaderBoardViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/12/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LeaderBoardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    return 100;
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
    
}


@end
