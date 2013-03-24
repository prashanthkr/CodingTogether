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
             usingDeck:(Deck *)deck
               andMatchMode: (NSUInteger)mode;

//Method to flip a card
-(void)flipCardAtIndex:(NSUInteger)index;

//Method to get a card (to display somewhere in UI or other purposes)
-(Card *)cardAtIndex:(NSUInteger)index;

//Public read only, but is privately read-write, defined within interface in the implementation file
@property (nonatomic,readonly) int score;



//Stores the number of points earned or lost during the last flip ,+ve for match, -ve for no match. 0 if only one card flipped.
@property (nonatomic, readonly) int lastFlipPoints;//we only need the total points gained/lost from the last flip

//We only want to match the current flipped card with the previous card that was flipped. Need not match all the cards that are face up. So we need to store the previousFlippedCard too.
@property(strong, nonatomic) Card* previousFlippedCard; //MOVED TO CardGameViewController.m
@property(strong, nonatomic, readonly) Card* currentFlippedCard;

//Stores all the flipped cards
@property (strong, nonatomic, readonly) NSMutableArray *allFlippedCards;

@property (nonatomic, readonly) NSString* resultString;


@end