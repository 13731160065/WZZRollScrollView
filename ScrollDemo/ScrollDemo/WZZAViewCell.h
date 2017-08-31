//
//  WZZAViewCell.h
//  ScrollDemo
//
//  Created by 王泽众 on 2017/8/29.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZAViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *alabel;

- (void)cellOffset;

@end
