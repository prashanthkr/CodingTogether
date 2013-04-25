//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"
//#import "Utility.h"
#import "GameViewController.h"

//Test branch 2

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
//@property(strong, nonatomic) Card* previousFlippedCard;
@property(strong, nonatomic) Card* currentFlippedCard;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;//view
@property (strong, nonatomic) CardMatchingGame  *game;//The game model
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
- (IBAction)startNewGame:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *gameModeButton;
@property (nonatomic)NSUInteger gameMatchMode;//default value is 2.
@end

@implementation CardGameViewController

//Lazy initialize gameMatchMode
-(NSUInteger)gameMatchMode{
    if(!_gameMatchMode)_gameMatchMode = 2;//default value is 2 if button not clicked
    return _gameMatchMode;
}

-(UISegmentedControl*)gameModeButton{
    if(!_gameModeButton)_gameModeButton = [[UISegmentedControl alloc] init];
    [_gameModeButton setEnabled:YES forSegmentAtIndex:0];
    return _gameModeButton;

}
//Lazy instantiation
-(CardMatchingGame *)game
{
    
    //We are getting the count of card buttons from the view
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                         usingDeck:[[PlayingCardDeck alloc] init]
                                                     andMatchMode: self.gameMatchMode ];
    return _game;
}

-(void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for(UIButton * cardButton in _cardButtons){
        [cardButton setBackgroundImage:[UIImage imageNamed:@"card-back.png"] forState:UIControlStateNormal];
    }
}



@end
