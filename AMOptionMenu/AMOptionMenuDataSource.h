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


@interface AMOptionMenuDataSource : NSObject
{	
	NSArray* _groups;
	NSDictionary* _valuesDict;
	NSMutableDictionary* _stateDict;
}

@property (nonatomic, readonly) NSString* summaryString;

//- (NSArray*) optionGroups;
//- (void) setSections:(NSArray*)sections;

//- (void) setOptions:(NSArray*)options forSectionWithIdentifier:(NSString*)identifier;

- (void) setOptionGroups:(NSArray*)groups andValues:(NSDictionary*)values;

- (NSMenu*) createMenuWithTitle:(NSString*)title;

@end
