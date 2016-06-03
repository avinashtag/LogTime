//
//  HomeViewController.m
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import "HomeViewController.h"
#import "ModelContext.h"
#import "Logs.h"
#import "ShowDataViewController.h"
#import "NSDate+ZDate.h"
#import "NSArray+ZArray.h"
#import "NSString+TString.h"
#import "NSObject+ATObject.h"
#import "LModel.h"


@interface HomeViewController (){
    ShowDataViewController *showData;
    dispatch_source_t refresh;
    LModel *localLog;
}

@property (weak, nonatomic) IBOutlet UILabel *lapsedTime;
@property (weak, nonatomic) IBOutlet UILabel *remainingTime;
@property (weak, nonatomic) IBOutlet UILabel *breakTime;
@property (weak, nonatomic) IBOutlet UIButton *stamp;
@property (weak, nonatomic) IBOutlet UILabel *logOutTime;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Baapu MCD";
    localLog = [[LModel alloc]init];
    localLog.stamp = [NSDate date];
    [_stamp.layer setCornerRadius:_stamp.frame.size.width/2];
    [_stamp setTitle:@"STAMP" forState:UIControlStateNormal];
    [_stamp.layer setBorderWidth:3.0];
    [_stamp.layer setBorderColor:[UIColor blueColor].CGColor];
    refresh = [self createGCDTimer:1 queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) eventHandler:^{
    
        [self left];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_lapsedTime setText:[self stringFromTimeInterval:localLog.logTime]];
            [_breakTime setText:[self stringFromTimeInterval:localLog.breakTime]];
            [_remainingTime setText:[self stringFromTimeInterval:localLog.remainingTime]];
            [self expectedLogOut];
//            [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@", [[NSDate date] dateStringInFormat:@"dd-MM-yyyy"], ]
//            NSDate *logout = [localLog.logout dateByAddingTimeInterval:localLog.logTime+localLog.remainingTime];
            
//            [_breakTime setText:[logout dateStringInFormat:@"%@HH:mm:ss"]];
        });
    }];
    dispatch_resume(refresh);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showAll:(id)sender {
    
    showData = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ShowDataViewController class])];
    [self.navigationController pushViewController:showData animated:YES];
}

- (IBAction)markStamp:(id)sender{
    
        Logs *log = (Logs *)[[ModelContext sharedContext ] insertEntity:[Logs class]];
        log.stamp = [NSDate date];
    [[ModelContext sharedContext] saveContext];
}

- (NSTimeInterval) breakTimeFetch{
    
    __block NSTimeInterval breakTime = 0;
    
    NSArray *logs = [Logs logsOfDate:[[NSDate date] eliminateTime]] ;
    if (logs.count>2) {
        
        [logs splitArray:^(NSArray *outTimes, NSArray *inTimes) {
            
            outTimes  = [outTimes valueForKey:@"stamp"];
            inTimes   = [inTimes valueForKey:@"stamp"];
            [inTimes enumerateObjectsUsingBlock:^(NSDate *inTime, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    localLog.logout = inTime;
                    return ;
                }
                
                @try {
                    breakTime += [inTime timeIntervalSinceDate:outTimes[idx-1]];
                } @catch (NSException *exception) {
                    
                }
            }];
        }];
    }
    return breakTime;
}

- (NSTimeInterval) lapse{
    
    
    
    __block NSTimeInterval lapsed = 0;
    NSArray *logs = [Logs logsOfDate:[[NSDate date] eliminateTime]] ;
    if (logs.count>0) {
        NSDate *firstIn = [[logs firstObject] valueForKeyPath:@"stamp"];
        if (logs.count>1) {
            lapsed  = [[[logs lastObject] valueForKeyPath:@"stamp"] timeIntervalSinceDate:firstIn];
        }
        else
            lapsed  = [[NSDate date] timeIntervalSinceDate:firstIn];

        localLog.breakTime = [self breakTimeFetch];
        lapsed -= localLog.breakTime;
    }
    return lapsed;
}


- (void) left{
    
    __block NSTimeInterval remaining = [[@"27-05-2016 08:30:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"] timeIntervalSinceDate:[@"27-05-2016 00:00:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"]];
    localLog.logTime = [self lapse];
    remaining -= localLog.logTime;
    localLog.remainingTime = remaining;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds] ;
    if ([time containsString:@"-"]) {
        return [NSString stringWithFormat:@"-%@",[time stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    }
    return time;
}
- (void) expectedLogOut{
    
    NSTimeInterval workHr = [[@"27-05-2016 08:30:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"] timeIntervalSinceDate:[@"27-05-2016 00:00:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"]];
    @try {
        Logs *log = [Logs logsOfDate:[[NSDate date] eliminateTime]][0] ;
        NSDate *ex = [[log.stamp dateByAddingTimeInterval:workHr] dateByAddingTimeInterval:localLog.breakTime];
        [_logOutTime setText:[ex dateStringInFormat:@"HH:mm:ss"]];

    } @catch (NSException *exception) {
        
        
        
    }
    
}

@end
