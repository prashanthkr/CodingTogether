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

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
//@property (strong, nonatomic) PlayingCardDeck *deck;//view This allocation is now done on the fly in game initializer
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;//view
@property (strong, nonatomic) CardMatchingGame  *game;//The game model
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

//new comment test

@implementation CardGameViewController


/*
 This allocation is now done on the fly in game initializer

//lazy initialize deck by overriding the getter
-(Deck *)deck{
 //if(_deck == nil){
 //     _deck = [[PlayingCardDeck alloc] init];
 //     for(int i=0; i<53;i++){
 //         Card *card = [[Card alloc] init];
 //         [_deck addCard:card atTop:YES];
 //     }
     
 //}
    if(!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}
*/

//Lazy instantiation
-(CardMatchingGame *)game
{
    //We are getting the count of card buttons from the view
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                        usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

-(void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    /* THIS IS NOW DONE BY THE updateUI FOR CardMatchingGame
     for(UIButton *cardButton in cardButtons){
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
    }
     */
}

//Updates the UI for every flip
-(void)updateUI
{
    //Just cycle through the card buttons getting the associated card from the CardMatchingGame
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        //Set the title for selectedstate. if contents don't change, this will do nothing
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        
        //If the card is both selected and disabled, then set the title to teh card's contents
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        //Card is selected only if it is face up.
        cardButton.Selected = card.isFaceUp;//IS OBJECTIVE C Case sensitive????
        
        //Make the card untappable if it is unplayable
        cardButton.enabled = !card.isUnplayable;
        
        //Make a disabled button semi-transparent using opaqueness property
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0; //1 fully opaque, 0.0 fully transparent
        
        //Update the score
        self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d", self.game.score];
        
    }//end for
}


-(void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    //sender.selected = !sender.isSelected;
    //Flipping is now done by the CardMatchingGame
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    /*NSString *desc = [[self.deck drawRandomCard] description];
    //NSLog(@"cards size---%d",[[self.deck cards] length]);
    NSLog(@"cards---%@",[self.deck drawRandomCard]);
    NSLog(@"card desc---%@",desc);
    [sender setTitle: desc forState:UIControlStateSelected];
     */
    self.flipCount++;
    
    //Update the UI whenever the card gets flipped
    [self updateUI];
}



@end
