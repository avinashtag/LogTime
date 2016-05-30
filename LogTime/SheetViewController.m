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
#import "NSDate+ZDate.h"
#import "NSString+TString.h"
#import "ModelContext.h"
#import <JGActionSheet.h>
#import "NSArray+ZArray.h"
#import <JGActionSheet.h>

@interface SheetViewController()<UIPickerViewDelegate,UIPickerViewDataSource>{
    JGActionSheet *sheet;
    NSArray *months;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPickerView *monthPicker;
@property (weak, nonatomic) IBOutlet UIView *pickerMonthView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

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
    [self fetchLogss:[[NSDate date] dateMonth]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellIdentifier";
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    Logs *log = _dataSource[indexPath.row];
    
    [cell.datelog setText:[log.stamp dateStringInFormat:@"dd-MM"]];
    [cell.timelog setText:log.logTime];
    [cell.timeRemaining setText:log.remainingTime];
    [cell.timeBreak setText:log.breakTime];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor grayColor];
    }
    else{
        cell.backgroundColor = [UIColor blueColor];
    }
    return cell;
}

- (void) fetchLogss:(NSInteger)month{
    
    NSArray *logs = [Logs logsOfMonth:month];
    [logs enumerateObjectsUsingBlock:^(Logs  *log, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!log.logTime) {
            [self left:log];
            [[ModelContext sharedContext] saveContext];
        }
    }];
    _dataSource = [[Logs logsOfMonth:month] mutableCopy];
    [self.tableView reloadData];
    
}



- (NSTimeInterval) breakTimeFetch:(Logs *)log{
    __block NSTimeInterval breakTime = 0;
    
    NSArray *logs = [Logs logsOfDate:[[NSDate date] eliminateTime]] ;
    if (logs.count>2) {
        
        [logs splitArray:^(NSArray *outTimes, NSArray *inTimes) {
            
            outTimes  = [outTimes valueForKey:@"stamp"];
            inTimes   = [inTimes valueForKey:@"stamp"];
            [inTimes enumerateObjectsUsingBlock:^(NSDate *inTime, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    return ;
                }
                
                @try {
                    breakTime += [inTime timeIntervalSinceDate:outTimes[idx]];
                } @catch (NSException *exception) {
                    
                }
            }];
        }];
    }
    log.breakTime = [self stringFromTimeInterval:breakTime];
    return breakTime;
}

- (NSTimeInterval) lapse:(Logs *)log{
    
    __block NSTimeInterval lapsed = 0;
    NSArray *logs = [Logs logsOfDate:[[NSDate date] eliminateTime]] ;
    if (logs.count>0) {
        NSDate *firstIn = [[logs firstObject] valueForKeyPath:@"stamp"];
        lapsed  = [firstIn timeIntervalSinceNow];
        lapsed -= [self breakTimeFetch:log];
    }
    log.logTime = [self stringFromTimeInterval:lapsed];
    return lapsed;
}
- (void) left:(Logs *)log{
    __block NSTimeInterval remaining = [[@"27-05-2016 00:00:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"] timeIntervalSinceDate:[@"27-05-2016 09:00:00" dateInFormat:@"dd-MM-yyyy HH:mm:ss"]];
    remaining -= [self lapse:log];
    log.remainingTime = [self stringFromTimeInterval:remaining];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (IBAction)cancel:(id)sender {
    [sheet dismissAnimated:YES];
}
- (IBAction)done:(id)sender {
    
    [sheet dismissAnimated:YES];
    [_monthLabel setText:[months objectAtIndex:[self.monthPicker selectedRowInComponent:0]] ];
    [self fetchLogss:[self.monthPicker selectedRowInComponent:0]+1];
}
- (IBAction)openMonthPicker:(id)sender {
    
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:@"" message:@"" contentView:self.pickerMonthView];
    sheet = [JGActionSheet actionSheetWithSections:@[section]];
    [sheet showInView:self.view animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return months.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return months[row];
}
@end
