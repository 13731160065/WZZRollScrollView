//
//  WZZAViewCell.m
//  ScrollDemo
//
//  Created by 王泽众 on 2017/8/29.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import "WZZAViewCell.h"

@interface WZZAViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCon2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeftCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelRightCon;
@end

@implementation WZZAViewCell

//增加偏移量
- (void)cellOffset {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.alabel.layer setCornerRadius:10];
    [self.alabel.layer setMasksToBounds:YES];
    
    //获取cell中心y在window中的位置
    CGRect cellRectToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat cellCenterY = CGRectGetMidY(cellRectToWindow);
    CGFloat cellStartY = CGRectGetMinY(cellRectToWindow);
    CGFloat cellEndY = CGRectGetMaxY(cellRectToWindow);
    
    //获取父视图(tableview)的中心点
    CGPoint tableCenter = self.superview.center;
    //获取cell中心距离父视图中心的距离
    CGFloat cellOffsetY = cellCenterY - tableCenter.y;
    CGFloat cellABSOffsetY = cellOffsetY;
    if (cellOffsetY < 0) {
        cellABSOffsetY = -cellOffsetY;
    }
    
    CGFloat halfCellHeight = self.frame.size.height/2;
    CGFloat widthBorder = (cellABSOffsetY-halfCellHeight)*(self.frame.size.width/self.frame.size.height)/4;
    if (widthBorder < 0) {
        widthBorder = -widthBorder;
    }

    CGFloat progressHeight = halfCellHeight/cellABSOffsetY;
    
    BOOL needFixXY = YES;//是否需要设值底view的值为默认值
    if (cellStartY >= tableCenter.y) {
        //向下滑动临界点，视图向上走
        _labelCon.constant = (halfCellHeight-cellABSOffsetY);
        _labelCon2.constant = -(halfCellHeight-cellABSOffsetY);
        [_alabel setText:[NSString stringWithFormat:@"%lf", cellABSOffsetY]];
        
        _labelLeftCon.constant = widthBorder;
        _labelRightCon.constant = widthBorder;
        needFixXY = NO;
    }
    
    if (cellEndY <= tableCenter.y) {
        //向上滑动临界点，视图向下走
        _labelCon.constant = -(halfCellHeight-cellABSOffsetY);
        _labelCon2.constant = (halfCellHeight-cellABSOffsetY);
        [_alabel setText:[NSString stringWithFormat:@"%lf", cellABSOffsetY]];
        _labelLeftCon.constant = widthBorder;
        _labelRightCon.constant = widthBorder;
        needFixXY = NO;
    }
    
    if (needFixXY) {
        _labelCon.constant = 0;
        _labelCon2.constant = 0;
        _labelLeftCon.constant = 0;
        _labelRightCon.constant = 0;
    }
}

@end
