//
//  AllMatchesViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/11/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "AllMatchesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "VCFloatingActionButton.h"

@interface AllMatchesViewController ()<UITableViewDataSource,UITableViewDelegate,floatMenuDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AllMatchesViewController
{
    NSArray* dataSource;
    VCFloatingActionButton *addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:18];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 20, 44, 44);
    
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus"] andPressedImage:[UIImage imageNamed:@"cross"] withScrollview:self.tableView];
    
    //    NSDictionary *optionsDictionary = @{@"fb-icon":@"Facebook",@"twitter-icon":@"Twitter",@"google-icon":@"Google Plus",@"linkedin-icon":@"Linked in"};
    //    addButton.menuItemSet = optionsDictionary;
    
    
    addButton.imageArray = @[@"Mind Map-100",@"Ratings Filled-100",@"Olympic Medal-100"];
    addButton.labelArray = @[@"إحصائياتي",@"ترتيب المشتركين",@"تاريخ الرابحين"];
    
    
    
    addButton.hideWhileScrolling = YES;
    addButton.delegate = self;
    
    [self.view addSubview:addButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"gameCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((UIButton*)[cell viewWithTag:9]).layer.borderWidth = 1;
    ((UIButton*)[cell viewWithTag:9]).layer.cornerRadius = 10;
    ((UIButton*)[cell viewWithTag:9]).layer.borderColor = [[UIColor alloc]initWithWhite:1 alpha:1].CGColor;
    ((UIButton*)[cell viewWithTag:9]).titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    

    ((UILabel*)[cell viewWithTag:1]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
   // ((UILabel*)[cell viewWithTag:3]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:5]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:6]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:7]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:8]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    
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
    tempLabel.text= @"دوري أبطال أوروبا";
    tempLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    tempLabel.textAlignment = NSTextAlignmentLeft;
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"دوري أبطال أوروبا";
}

#pragma mark menu delegate
-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{
    NSLog(@"Floating action tapped index %tu",row);
    if(row == 0)
    {
        [self performSegueWithIdentifier:@"MyStatsSeg" sender:self];
    }
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
