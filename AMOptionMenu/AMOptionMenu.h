//
//  AMOptionMenu.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMOptionMenuItem : NSObject
{
	NSString* _identifier;
	NSString* _title;
	NSString* _shortTitle;
}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* shortTitle;

+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title;

@end


@interface AMOptionMenuDataSource : NSObject
{	
	NSMutableDictionary* _sectionsDict;
	NSMutableDictionary* _optionsDict;
	NSMutableDictionary* _stateDict;
}

@property (nonatomic, readonly) NSString* summaryString;

- (NSArray*) sections;
- (void) setSections:(NSArray*)sections;

- (NSArray*) optionsForSectionWithIdentifier:(NSString*)identifier;
- (void) setOptions:(NSArray*)options forSectionWithIdentifier:(NSString*)identifier;


- (NSMenu*) newMenu;

@end

