//
//  SheetViewController.m
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import "SheetViewController.h"
#import "LogCell.h"
#import "Logs.h"
#import "LogsMonth.h"
#import "NSDate+ZDate.h"
#import "NSString+TString.h"
#import "ModelContext.h"
#import <JGActionSheet.h>
#import "NSArray+ZArray.h"
#import <JGActionSheet.h>

@interface SheetViewController()<UIPickerViewDelegate,UIPickerViewDataSource>{
    JGActionSheet *sheet;
    NSArray *months;
    NSArray *years;
}

@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIView *footer;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPickerView *monthPicker;
@property (weak, nonatomic) IBOutlet UIView *pickerMonthView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRemainingHours;

@end

@implementation SheetViewController


- (void) viewDidLoad{
    [super viewDidLoad];
    months = @[
               @"January",
               @"February",
               @"March",
               @"April",
               @"May",
               @"June",
               @"July",
               @"August",
               @"September",
               @"October",
               @"November",
               @"December",
               ];
    years = @[
               @"2016",
               @"2017",
               ];
    [_monthLabel setText:[[NSDate date] dateStringInFormat:@"MMM/yyyy"] ];

    [self fetchLogss:[NSDate date]];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _header;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    [self remainigHours];
    return _footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellIdentifier";
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    LogsMonth *log = _dataSource[indexPath.row];
    
    [cell.datelog setText:[[log.stamp dateStringInFormat:@"dd-EEE"] uppercaseString]];
    [cell.timelog setText:[self stringFromTimeInterval:log.logTime.doubleValue]];
    [cell.timeRemaining setText:[self stringFromTimeInterval:log.remainingTime.doubleValue]];
    [cell.timeBreak setText:[self stringFromTimeInterval:log.breakTime.doubleValue]];
    cell.backgroundColor = [UIColor blueColor];
    
    if (log.remainingTime.doubleValue > 0) {
        cell.backgroundColor = [UIColor redColor];
    }
    else{
        cell.backgroundColor = [UIColor greenColor];
    }
    
    
    if ([[[log.stamp dateStringInFormat:@"EEE"] uppercaseString] isEqualToString:@"SUN"] || [[[log.stamp dateStringInFormat:@"EEE"] uppercaseString] isEqualToString:@"SAT"]) {
        cell.backgroundColor = [UIColor blackColor];
    }

    return cell;
}

- (void) fetchLogss:(NSDate *)dateSelected{
    
    
    _dataSource = [[NSMutableArray alloc]init];
    
    NSArray *dates = [dateSelected datesInMonth];

    for (NSDate *date in dates) {
        
        LogsMonth *monthlog = [LogsMonth logsOfMonth:date];
        
        
        __block NSTimeInterval breakTime = 0;
        
        NSArray *logs = [Logs logsOfDate:[date eliminateTime]] ;
        if (logs.count>2) {
            
            [logs splitArray:^(NSArray *outTimes, NSArray *inTimes) {
                
                outTimes  = [outTimes valueForKey:@"stamp"];
                inTimes   = [inTimes valueForKey:@"stamp"];
                [inTimes enumerateObjectsUsingBlock:^(NSDate *inTime, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == 0) {
                        return ;
                    }
                    
                    @try {
                        breakTime += [inTime timeIntervalSinceDate:outTimes[idx-1]];
                    } @catch (NSException *exception) {
                        
                    }
                }];
            }];
        }
        
        monthlog.stamp = date;
        monthlog.breakTime = @(breakTime);
        [self left:monthlog breaktime:breakTime];
    
    }
    [[ModelContext sharedContext] saveContext];
        

    
    _dataSource = [[LogsMonth logsFrom:dates.firstObject to:dates.lastObject ] mutableCopy];
    [self.tableView reloadData];
    [self check];
}

- (NSTimeInterval) lapse:(LogsMonth *)log breaktime:(NSTimeInterval)breakTime{
    
    __block NSTimeInterval lapsed = 0;
    NSArray *logs = [Logs logsOfDate:[log.stamp eliminateTime]] ;
    if (logs.count>0) {
        NSDate *firstIn = [[logs firstObject] valueForKeyPath:@"stamp"];
        lapsed  = [[[logs lastObject] valueForKeyPath:@"stamp"] timeIntervalSinceDate:firstIn];
        lapsed -= breakTime;
    }
    log.logTime = @(lapsed);
    return lapsed;
}

- (void) left:(LogsMonth *)log breaktime:(NSTimeInterval)breakTime{
    __block NSTimeInterval remaining = [[@"27-05-2016 08:30:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"] timeIntervalSinceDate:[@"27-05-2016 00:00:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"]];
    remaining -= [self lapse:log breaktime:breakTime];
    log.remainingTime = @(remaining);
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

- (IBAction)cancel:(id)sender {
    [sheet dismissAnimated:YES];
}
- (IBAction)done:(id)sender {
    
    [sheet dismissAnimated:YES];
    
    NSString *dateString = [NSString stringWithFormat:@"01/%@/%@",months[[self.monthPicker selectedRowInComponent:0]], years[[self.monthPicker selectedRowInComponent:1]]];
    NSDate *selectedDate = [dateString dateInFormat:@"dd/MMMM/yyyy"];
    [_monthLabel setText:[selectedDate dateStringInFormat:@"MMM/yyyy"] ];
    [self fetchLogss:selectedDate];
}
- (IBAction)openMonthPicker:(id)sender {
    
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:@"" message:@"" contentView:self.pickerMonthView];
    sheet = [JGActionSheet actionSheetWithSections:@[section]];
    [sheet showInView:self.view animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return (component==0) ? months.count : years.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return (component==0) ? months[row] : years[row];
}


- (void) check{
    
    NSArray *logs = [LogsMonth logsFrom:[[NSDate date] startDateOfMonth] to:[NSDate date]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.logTime > 0"];
    NSArray *filteredLogs = [logs filteredArrayUsingPredicate:predicate];
    
    NSTimeInterval totalExpected = [[@"27-05-2016 09:00:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"] timeIntervalSinceDate:[@"27-05-2016 00:00:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"]];
    totalExpected *= filteredLogs.count;
    
    NSTimeInterval total = [[filteredLogs valueForKeyPath:@"@sum.logTime"] doubleValue];
    if (total>totalExpected) {
        NSLog(@"OK");
    }
    else{
        NSLog(@"Not Ok");
    }
    
}

- (void) remainigHours{
    
    if (_dataSource.count) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.logTime > 0"];
        NSArray *filteredLogs = [_dataSource filteredArrayUsingPredicate:predicate];

        NSTimeInterval remain = [[filteredLogs valueForKeyPath:@"@sum.remainingTime"] doubleValue];
        [_totalRemainingHours setText:[self stringFromTimeInterval:remain]];
    }
}
@end
