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

//Stores the number of points earned or lost during the last flip ,+ve for match, -ve for no match. 0 if only one card flipped.
/*@property (nonatomic, readonly) int lastMatchedFlipPoints;
@property (nonatomic, readonly) int lastUnmatchedFlipPoints;*/
@property (nonatomic, readonly) int lastFlipPoints;//we only need the total points gained/lost from the last flip

//Store the cards that were flipped...it is 3 for 3 card game, and 2 for 2 card game
@property (strong, nonatomic, readonly) NSMutableArray *matchingFlippedCards;
@property (strong, nonatomic, readonly) NSMutableArray *unMatchingFlippedCards;

/*
@property (nonatomic, readonly) int lastFlipPoints;
@property (strong, nonatomic, readonly) NSMutableArray *flippedCards;

*/

@end