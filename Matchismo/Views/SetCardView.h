//
//  SetCardView.h
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/14.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

@property (nonatomic) BOOL faceUp;

@end
