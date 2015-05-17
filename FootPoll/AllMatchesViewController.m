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
#import "PollView.h"
#import "PollResultView.h"
#import "CRToastManager.h"
#import "CRToast.h"
#import "AFHTTPRequestOperationManager.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>
#import <Haneke/Haneke.h>
#import "MyStatsViewController.h"

@interface AllMatchesViewController ()<UITableViewDataSource,UITableViewDelegate,floatMenuDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@property (nonatomic, strong)UIRefreshControl* refreshControl;

@end

@implementation AllMatchesViewController
{
    NSArray* dataSource;
    VCFloatingActionButton *addButton;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"MyStatsSeg"])
    {
        MyStatsViewController* dst = (MyStatsViewController*)[segue destinationViewController];
        [dst setLoggedUser:self.loggedUser];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:18];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    
    [self loadData];

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loadData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.view addSubview:addButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dataSource objectAtIndex:section] objectForKey:@"games"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"gameCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
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
    return dataSource.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((UIButton*)[cell viewWithTag:9]).layer.borderWidth = 1;
    ((UIButton*)[cell viewWithTag:9]).layer.cornerRadius = 10;
    ((UIButton*)[cell viewWithTag:9]).layer.borderColor = [[UIColor alloc]initWithWhite:1 alpha:1].CGColor;
    ((UIButton*)[cell viewWithTag:9]).titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];

    [((UIButton*)[cell viewWithTag:9]) addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    ((UILabel*)[cell viewWithTag:1]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
   // ((UILabel*)[cell viewWithTag:3]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:5]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:6]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:7]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    ((UILabel*)[cell viewWithTag:8]).font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    
    
    NSDictionary* currentGame = [[[dataSource objectAtIndex:indexPath.section] objectForKey:@"games"] objectAtIndex:indexPath.row];
    
    
    if([[currentGame objectForKey:@"status"] isEqualToString:@"لم تبدأ"])
    {
        [((UIButton*)[cell viewWithTag:9]) setTitle:@"توقع الأن و إربح !" forState:UIControlStateNormal];
    }else if([[currentGame objectForKey:@"status"] isEqualToString:@"الأن"])
    {
        [((UIButton*)[cell viewWithTag:9]) setTitle:@"شاهد التوقعات" forState:UIControlStateNormal];
    }else
    {
        [((UIButton*)[cell viewWithTag:9]) setTitle: @"شاهد الرابح" forState:UIControlStateNormal];
    }
    
    
    [((UILabel*)[cell viewWithTag:1]) setText:[currentGame objectForKey:@"teamOneName"]];
    [((UIImageView*)[cell viewWithTag:2]) hnk_setImageFromURL:[NSURL URLWithString:[currentGame objectForKey:@"teamOneFlag"]]];
    
    [((UILabel*)[cell viewWithTag:5]) setText:[currentGame objectForKey:@"teamTwoName"]];
    [((UIImageView*)[cell viewWithTag:4]) hnk_setImageFromURL:[NSURL URLWithString:[currentGame objectForKey:@"teamTwoFlag"]]];
    
    [((UILabel*)[cell viewWithTag:8]) setText:[currentGame objectForKey:@"clock"]];
    [((UILabel*)[cell viewWithTag:7]) setText:[currentGame objectForKey:@"votes"]];
    [((UILabel*)[cell viewWithTag:6]) setText:[currentGame objectForKey:@"status"]];
    [((UILabel*)[cell viewWithTag:3]) setText:[currentGame objectForKey:@"score"]];
    
    
    
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
    tempLabel.text= [[dataSource objectAtIndex:section]objectForKey:@"champion"];
    tempLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    tempLabel.textAlignment = NSTextAlignmentLeft;
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"دوري أبطال أوروبا";
}




- (void)checkButtonTapped:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSLog(@"%li",(long)indexPath.row);
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if([[((UIButton*)[cell viewWithTag:9]).titleLabel text]isEqualToString:@"توقع الأن و إربح !"])
        {
            self.bouncingBalls = [PQFBouncingBalls createModalLoader];
            self.bouncingBalls.jumpAmount = 50;
            self.bouncingBalls.zoomAmount = 20;
            self.bouncingBalls.separation = 20;
            [self.bouncingBalls showLoader];
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary* params = @{@"gameID":[[[[dataSource objectAtIndex:indexPath.section] objectForKey:@"games"] objectAtIndex:indexPath.row] objectForKey:@"id"],@"userID":[self.loggedUser objectForKey:@"id"]};
            
            [manager POST:@"http://moh2013.com/arabDevs/FootPoll/getMyVoteForGame.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString* scoreEnetredBefore  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                [self.bouncingBalls removeLoader];
                
                PollView* pollView = [[PollView alloc]init];
                pollView = [pollView initWithNib];
                [pollView setFrame:cell.contentView.frame];
                
                [pollView initUI];
                
                if(scoreEnetredBefore.length == 0)
                {
                    pollView.clubOneScore.text = @"-";
                    pollView.clubTwoScore.text = @"-";
                }else
                {
                    NSArray* scores = [scoreEnetredBefore componentsSeparatedByString:@"-"];
                    pollView.clubOneScore.text = [scores objectAtIndex:0];
                    pollView.clubTwoScore.text = [scores objectAtIndex:1];
                }
                
                [pollView.clubOneFlag setImage:[((UIImageView*)[cell viewWithTag:2]) image]];
                [pollView.clubTwoFlag setImage:[((UIImageView*)[cell viewWithTag:4]) image]];
                
                [pollView.clubOneName setText:[((UILabel*)[cell viewWithTag:1]) text]];
                [pollView.clubTwoName setText:[((UILabel*)[cell viewWithTag:5]) text]];
                
                pollView.gameID = [[[[dataSource objectAtIndex:indexPath.section] objectForKey:@"games"]objectAtIndex:indexPath.row] objectForKey:@"id"];
                pollView.userID = [self.loggedUser objectForKey:@"id"];
                
                [cell.layer removeAllAnimations];
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.type = kCATransitionMoveIn;
                transition.subtype = kCATransitionFromRight;
                [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [cell.layer addAnimation:transition forKey:nil];
                
                [cell addSubview:pollView];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.bouncingBalls removeLoader];
                NSLog(@"Error: %@", error);
            }];
        }else if([[((UIButton*)[cell viewWithTag:9]).titleLabel text]isEqualToString:@"شاهد التوقعات"])
        {
            self.bouncingBalls = [PQFBouncingBalls createModalLoader];
            self.bouncingBalls.jumpAmount = 50;
            self.bouncingBalls.zoomAmount = 20;
            self.bouncingBalls.separation = 20;
            [self.bouncingBalls showLoader];
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary* params = @{@"gameID":[[[[dataSource objectAtIndex:indexPath.section] objectForKey:@"games"] objectAtIndex:indexPath.row] objectForKey:@"id"]};
            
            [manager POST:@"http://moh2013.com/arabDevs/FootPoll/getVotesForGame.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [self.bouncingBalls removeLoader];
               
                
                NSArray* votes = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if(votes.count == 0)
                {
                    NSDictionary *options = @{
                                              kCRToastTextKey : @"لا يوجد توقعات لهذه المباراة",
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
                    PollResultView* pollView = [[PollResultView alloc]init];
                    pollView = [pollView initWithNib];
                    [pollView setFrame:cell.contentView.frame];
                    [pollView setVotes:votes];
                    
                    [pollView initUI];
                    
                    [cell.layer removeAllAnimations];
                
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.5;
                    transition.type = kCATransitionMoveIn;
                    transition.subtype = kCATransitionFromRight;
                    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                    [cell.layer addAnimation:transition forKey:nil];
                
                    [cell addSubview:pollView];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.bouncingBalls removeLoader];
                NSLog(@"Error: %@", error);
            }];

        }else if([[((UIButton*)[cell viewWithTag:9]).titleLabel text]isEqualToString:@"شاهد الرابح"])
        {
            self.bouncingBalls = [PQFBouncingBalls createModalLoader];
            self.bouncingBalls.jumpAmount = 50;
            self.bouncingBalls.zoomAmount = 20;
            self.bouncingBalls.separation = 20;
            [self.bouncingBalls showLoader];
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary* params = @{@"gameID":[[[[dataSource objectAtIndex:indexPath.section] objectForKey:@"games"] objectAtIndex:indexPath.row] objectForKey:@"id"]};
            
            [manager POST:@"http://moh2013.com/arabDevs/FootPoll/getWinnerForGame.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self.bouncingBalls removeLoader];
                
                
                NSArray* votes = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if(votes.count == 0)
                {
                    NSDictionary *options = @{
                                              kCRToastTextKey : @"لا يوجد رابح لهذه المباراة",
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
                    NSDictionary *options = @{
                                              kCRToastTextKey : [[votes objectAtIndex:0] objectForKey:@"username"],
                                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                              kCRToastBackgroundColorKey : [UIColor blueColor],
                                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                              };
                    [CRToastManager showNotificationWithOptions:options
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.bouncingBalls removeLoader];
                NSLog(@"Error: %@", error);
            }];
        }
    }
}

#pragma mark menu delegate
-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{
    NSLog(@"Floating action tapped index %tu",row);
    if(row == 0)
    {
        [self performSegueWithIdentifier:@"MyStatsSeg" sender:self];
    }else if(row == 1)
    {
        [self performSegueWithIdentifier:@"RankingSeg" sender:self];
    }else if(row == 2)
    {
        [self performSegueWithIdentifier:@"WinnersSeg" sender:self];
    }
}


-(void)loadData
{
    [self.refreshControl endRefreshing];
    
    
    self.bouncingBalls = [PQFBouncingBalls createModalLoader];
    self.bouncingBalls.jumpAmount = 50;
    self.bouncingBalls.zoomAmount = 20;
    self.bouncingBalls.separation = 20;
    [self.bouncingBalls showLoader];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://moh2013.com/arabDevs/FootPoll/getGames.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self.bouncingBalls removeLoader];
        if(responseArray.count == 0)
        {
            NSDictionary *options = @{
                                      kCRToastTextKey : @"لا يوجد مباريات لليوم",
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
