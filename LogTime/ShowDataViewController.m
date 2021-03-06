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
#import "SheetViewController.h"


@interface ShowDataViewController (){
    JGActionSheet *sheet;
    SheetViewController *sheetController;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UITableView *logsTable;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *selectorDate;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateSelectorPrevView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimeSelector;
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
    if (log.mark.boolValue) {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Logs *log = _dataSource[indexPath.row];
        log.mark = @(!log.mark.boolValue);
        [[ModelContext sharedContext] saveContext];
        [tableView reloadData];
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
//        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"Mark";
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
    [self fetchLogs];
}

- (IBAction)showAll:(id)sender {
    
    sheetController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SheetViewController class])];
    [self.navigationController pushViewController:sheetController animated:YES];
}

- (IBAction)logNewEntry:(id)sender {
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:@"" message:@"" contentView:self.dateSelectorPrevView];
    sheet = [JGActionSheet actionSheetWithSections:@[section]];
    [sheet showInView:self.view animated:YES];

}

- (IBAction)dateTimeCancel:(id)sender {
    [sheet dismissAnimated:YES];

}
- (IBAction)dateTimeSelected:(id)sender {
    [sheet dismissAnimated:YES];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure to log the entry." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        Logs *log = (Logs *)[[ModelContext sharedContext ] insertEntity:[Logs class]];
        log.stamp = self.dateTimeSelector.date;
        [[ModelContext sharedContext] saveContext];
        [self fetchLogs];
    }];
    [controller addAction:cancel];
    [controller addAction:yes];
    [self presentViewController:controller animated:yes completion:nil];
    
}

@end
