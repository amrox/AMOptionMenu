//
//  AMOptionMenu.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* const kAMOptionPopUpButtonTitle;

@interface AMOptionMenuItem : NSObject
{
	NSString* _identifier;
	NSString* _title;
	NSString* _shortTitle;
}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* shortTitle;
@property (nonatomic, readonly) NSString* titleForSummary;

+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title;
+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle;
@end


extern NSString* const kAMOptionMenuContentWillChange;
extern NSString* const kAMOptionMenuContentDidChange;


@interface AMOptionMenuController : NSObject
{	
	NSMutableArray* _options;
	NSMutableDictionary* _valuesDict;
	NSMutableDictionary* _stateDict;
	
	BOOL _shouldSeparateSections;
}

@property (nonatomic, readonly) NSString* summaryString;
@property (nonatomic) BOOL shouldSeparateOptions;


// - (void) setOptionGroups:(NSArray*)groups andValues:(NSDictionary*)values;

- (void) insertOptionWithIdentifier:(NSString*)identifier title:(NSString*)title atIndex:(NSInteger)index;
- (void) setAlternatives:(NSArray*)alternatives forOptionWithIdentifier:(NSString*)optionIdentifier;
- (void) insertOption:(AMOptionMenuItem*)option atIndex:(NSInteger)insertIndex withAternatives:(NSArray*)alternatives;

- (BOOL) insertOptionsFromPropertyListWithURL:(NSURL*)url atIndex:(NSInteger)insertIndex;

- (void) insertItemsInMenu:(NSMenu*)menu atIndex:(NSInteger)insertIndex;

// TODO: make a property?
- (NSDictionary*) state;

@end

