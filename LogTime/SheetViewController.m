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

@interface SheetViewController()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SheetViewController


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
    cell.time.text = [log.stamp dateStringInFormat:@"HH:mm:ss"];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor grayColor];
        [cell.time setTextColor:[UIColor whiteColor]];
    }
    else{
        cell.backgroundColor = [UIColor blueColor];
        [cell.time setTextColor:[UIColor whiteColor]];
    }
    return cell;
}

- (void) fetchLogss{
    
    NSArray *logs = [Logs logsOfMonth:[[NSDate date] dateMonth]];
    
}


@end
