//
//  JSONToDict.m
//  FHIR
//
//  Created by Adam Sippel on 2013-02-19.
//  Copyright (c) 2013 Mohawk College. All rights reserved.
//

#import "JSONToDict.h"

@implementation JSONToDict

- (NSObject *)convertJsonToDictionary:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];

    if (jsonString)
    {
        NSLog(@"Exists");
        NSData *fileContent = [[NSData alloc] initWithContentsOfURL:url];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:fileContent options:kNilOptions error:&error];
        //_incomingResourceType = resourceType;
        //NSLog(@"JSON Dict before localized: %@", jsonDictionary);
        NSObject *resourceAsObject = [self createLocalizedObject:jsonDictionary];
        return resourceAsObject;
    }
    else
    {
        NSLog(@"File does not exist at: %@", url);
        return nil;
    }
    
}

- (NSObject *)createLocalizedObject:(NSDictionary *)jsonDict
{
    if ([jsonDict objectForKey:@"Patient"])
    {
        Patient *patient = [[Patient alloc] init];
        [patient patientParser:jsonDict];
        return patient;
    }
    else if ([jsonDict objectForKey:@"Organization"])
    {
        Organization *organization = [[Organization alloc] init];
        [organization organizationParser:jsonDict];
        return organization;
        NSLog(@"organizationXML ************** %@", organization);
    }
    else
    {
        return nil;
    }
}

@end
