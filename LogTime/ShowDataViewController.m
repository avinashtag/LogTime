//
//  ShowDataViewController.m
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import "ShowDataViewController.h"
#import "LogCell.h"
#import "Logs.h"
#import "NSDate+ZDate.h"
#import "NSString+TString.h"
#import "ModelContext.h"
#import <JGActionSheet.h>


@interface ShowDataViewController (){
    JGActionSheet *sheet;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UITableView *logsTable;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *selectorDate;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation ShowDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedDate = [NSDate date];
    [_dateLabel setText:[_selectedDate dateStringInFormat:@"dd-MMM"]];
    [self fetchLogs];
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

- (void) fetchLogs{
   
    _dataSource = [[Logs logsOfDate:[_selectedDate eliminateTime]] mutableCopy];
    if (!_dataSource.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"No value in database" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.logsTable reloadData];
}
- (IBAction)openDateSelector:(id)sender {
    
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:@"" message:@"" contentView:self.selectorDate];
    sheet = [JGActionSheet actionSheetWithSections:@[section]];
    [sheet showInView:self.view animated:YES];
}
- (IBAction)cancel:(id)sender {
    [sheet dismissAnimated:YES];
}
- (IBAction)done:(id)sender {
    [sheet dismissAnimated:YES];
    _selectedDate = [self.datePicker date];
    [_dateLabel setText:[_selectedDate dateStringInFormat:@"dd-MMM"]];
}


@end
