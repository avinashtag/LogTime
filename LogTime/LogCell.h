//
//  LogCell.h
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *time;


@property (nonatomic, weak) IBOutlet UILabel *datelog;
@property (nonatomic, weak) IBOutlet UILabel *timelog;
@property (nonatomic, weak) IBOutlet UILabel *timeRemaining;
@property (nonatomic, weak) IBOutlet UILabel *timeBreak;





@end
