//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Caio Uvini on 7/28/13.
//  Copyright (c) 2013 Caio Uvini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong,nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
