//
//  SetCard.h
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/14.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;
+ (NSUInteger)maxNumber;

@end
