//
//  Content.m
//  FHIR
//
//  Created by Adam Sippel on 2013-06-05.
//  Copyright (c) 2013 Mohawk College. All rights reserved.
//

#import "FHIRContent.h"

@implementation FHIRContent

@synthesize contentDictionary = _contentDictionary; //a dictionary containing all resources in this content object
@synthesize item = _item; //The product that is in the package.
@synthesize amount = _amount; //The amount of the product that is in the package.

- (id)init
{
    self = [super init];
    if (self) {
        _contentDictionary = [[FHIRResourceDictionary alloc] init];
        _item = [[FHIRResourceReference alloc] init];
        _amount = [[FHIRQuantity alloc] init];
    }
    return self;
}

- (NSDictionary *)generateAndReturnDictionary
{
    _contentDictionary.dataForResource = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [_item generateAndReturnDictionary], @"item",
                                           [_amount generateAndReturnDictionary], @"amount",
                                           nil];
    _contentDictionary.resourceName = @"Content";
    [_contentDictionary cleanUpDictionaryValues];
    return _contentDictionary.dataForResource;
}

- (void)contentParser:(NSDictionary *)dictionary
{
    [_item resourceReferenceParser:[dictionary objectForKey:@"item"]];
    [_amount quantityParser:[dictionary objectForKey:@"amount"]];
}

@end
