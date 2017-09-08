//
//  SHViewController.h
//  SegmentTableView
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 jyn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SHViewController : UIViewController


/**
 添加要左右滑动的viewController
 使用viewController能够更好的

 @param childVCArray vc数组
 @param headerView 头视图
 @param segmentHeight segment高度
 */
- (void)addChildVCWithArray:(NSArray <UIViewController *> *)childVCArray
                 headerView:(UIView *)headerView
              segmentHeight:(CGFloat)segmentHeight;

/**
 切换vc时调用，index为要显示的vc下表
 */
@property (nonatomic , copy) void(^viewControllerScrollToIndex)(NSInteger index);

@end
