//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *lastConsiderationLabel;
@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}
                 
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    self.matchModeSegmentedControl.enabled = NO;
    [self updateUI];
}

- (IBAction)redealButton:(UIButton *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck:[self createDeck]];
    self.game.threeCardsMode = [self.matchModeSegmentedControl selectedSegmentIndex] == 1 ? YES : NO;
    self.matchModeSegmentedControl.enabled = YES;
    [self updateUI];
}

- (IBAction)changeMatchModeSegmentedControl:(UISegmentedControl *)sender {
    self.game.threeCardsMode = [self.matchModeSegmentedControl selectedSegmentIndex] == 1 ? YES : NO;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    self.lastConsiderationLabel.text = self.game.lastConsideration;
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
