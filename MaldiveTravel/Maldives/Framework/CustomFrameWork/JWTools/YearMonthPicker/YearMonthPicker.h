//
//  YearMonthPicker.h
//  shashou
//
//  Created by Tian Wei You on 16/7/21.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
// Identifiers of components
#define MONTH ( 0 )
#define YEAR ( 1 )

// Identifies for component views
#define LABEL_TAG 43

typedef void(^changeMonthYearBlock)(NSString *,NSString *);

@interface YearMonthPicker : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic,copy)changeMonthYearBlock getMonthYearBlock;
@property (nonatomic, strong, readonly) NSDate *date;
-(void)selectToday;


@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

@property (nonatomic, copy) NSString *monthStr;
@property (nonatomic, copy) NSString *yearStr;
@property (nonatomic, copy) NSString *currentDateStr;

-(NSArray *)nameOfYears;
-(NSArray *)nameOfMonths;
-(CGFloat)componentWidth;

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(NSIndexPath *)todayPath;
-(NSInteger)bigRowMonthCount;
-(NSInteger)bigRowYearCount;
-(NSString *)currentMonthName;
-(NSString *)currentYearName;

@end
