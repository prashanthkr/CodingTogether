//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 2/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

//Initializer to initialize the game with card count and a deck. This comment is the only way for someone to understand that this is the designated initializer. No language support to specify it.
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck;
//Method to flip a card
-(void)flipCardAtIndex:(NSUInteger)index;

//Method to get a card (to display somewhere in UI or other purposes)
-(Card *)cardAtIndex:(NSUInteger)index;

//Public read only, but is privately read-write, defined within interface in the implementation file
@property (nonatomic,readonly) int score;

@end
