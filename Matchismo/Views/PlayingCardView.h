//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Caio Uvini on 7/28/13.
//  Copyright (c) 2013 Caio Uvini. All rights reserved.
//

#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (strong,nonatomic) NSString *suit;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
