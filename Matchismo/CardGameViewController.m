//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import "CardGameViewController.h"
#import "HistoryViewController.h"
#import "Card.h"

@interface CardGameViewController ()
@property (nonatomic) BOOL animating;
@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (CardView *card in self.cardViews) {
        UITapGestureRecognizer *recognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapPlayingCardView:)];
        [card addGestureRecognizer:recognizer];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *)segue.destinationViewController;
            NSMutableString *htext = [[NSMutableString alloc] init];
            for (NSString *con in self.game.considerationHistory) {
                [htext appendFormat:@"%@\n", con];
            }
            hvc.historyText = htext;
        }
    }
}

// abstract method. must override this.
- (Deck *)createDeck
{
    return nil;
}

- (void)tapPlayingCardView:(UITapGestureRecognizer *)sender {
    int chosenButtonIndex = [self.cardViews indexOfObject:sender.view];
    NSLog(@"%d tapped", chosenButtonIndex);
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [UIView transitionWithView:sender.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:nil
                    completion:^(BOOL finished){
                        if (finished) {
                            int howManyFaceUped = 0;
                            for (CardView *cardView in self.cardViews) {
                                int cardViewIndex = [self.cardViews indexOfObject:cardView];
                                Card *card = (Card *)[self.game cardAtIndex:cardViewIndex];
                                if (cardView.faceUp && !card.isMatched) howManyFaceUped++;
                            }
                            if (( self.game.isThreeCardsMode && howManyFaceUped == 3) ||
                                (!self.game.isThreeCardsMode && howManyFaceUped == 2) ) {
                                
                                for (CardView *cardView in self.cardViews) {
                                    int cardViewIndex = [self.cardViews indexOfObject:cardView];
                                    Card *card = (Card *)[self.game cardAtIndex:cardViewIndex];
                                    if (cardView.faceUp && !card.isMatched) {
                                        [UIView animateWithDuration:0.1
                                                              delay:0.5
                                                            options:UIViewAnimationOptionBeginFromCurrentState
                                                         animations:^{cardView.alpha = 1.001;}
                                                         completion:^(BOOL finished){
                                                             if (finished) {
                                                                cardView.faceUp = NO;
                                                                card.chosen = NO;
                                        [UIView transitionWithView:cardView
                                                          duration:0.4
                                                           options:UIViewAnimationOptionTransitionFlipFromLeft
                                                        animations:^{cardView.alpha = 1.00;}
                                                        completion:^(BOOL finished){ } ];
                                                             }
                                                         }];
                                        
                                        
                                    }
                                }
                                
                            }
                        }
                    }];
    [self updateUI];
}

- (IBAction)redealBarButton:(UIBarButtonItem *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                              usingDeck:[self createDeck]];
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

// if you override this method you must call this.
- (void)updateUI
{
    
    for (CardView *cardView in self.cardViews) {
        int cardViewIndex = [self.cardViews indexOfObject:cardView];
        Card *card = (Card *)[self.game cardAtIndex:cardViewIndex];
        cardView.faceUp = card.isChosen;
        if (card.isMatched) {
            // spin 180 degrees
            [UIView animateWithDuration:0.2f
                                  delay:1.0f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                cardView.transform = CGAffineTransformRotate(cardView.transform, M_PI);
                             }
                             completion:^(BOOL finished) {
                                if (finished) {
                                    [UIView animateWithDuration:0.5
                                                          delay:0.5
                                                        options:UIViewAnimationOptionBeginFromCurrentState
                                                     animations:^{ cardView.alpha = 0.0; }
                                                     completion:^(BOOL finished){
                                                         if (finished) {
                                                             [cardView removeFromSuperview];
                                                         }
                                                     }];
                                }
                             }];
            
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
