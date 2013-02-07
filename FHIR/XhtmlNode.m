//
//  XhtmlNode.m
//  FHIR
//
//  Created by Adam Sippel on 2013-01-29.
//  Copyright (c) 2013 Adam Sippel. All rights reserved.
//

#import "XhtmlNode.h"

@interface XhtmlNode()

#warning - not fully implemented, check line below
//public static final String NBSP = Character.toString((char)0xa0);

@property (nonatomic) NodeType *node; //decides node type
@property (nonatomic, retain) NSString *name; //name variable
@property (nonatomic, retain) NSMutableDictionary *Attributes;
//@property (nonatomic, retain) Map *attributes; //Map<String, String> Atributes = new HashMap<String, String>();
@property (nonatomic, retain) NSMutableArray *childNodes; //array of XhtmlNodes
@property (nonatomic, retain) NSString *content; //content of this XhtmlNode

@end

@implementation XhtmlNode

@synthesize childNodes = _childNodes;

- (NSString *)getNodeType
{
    return self.node.nodeType;
}

- (void)setNodeType:(NSString *)nodeType
{
    self.node.nodeType = nodeType;
}

- (NSString *)getName
{
    return self.name;
}

- (void)setName:(NSString *)name
{
    self.name = name;
}

- (NSMutableDictionary *)getAttributes
{
    return self.Attributes;
}

- (NSArray *)getChildNodes
{
    return self.childNodes;
}

- (NSString *)getContent
{
    return self.content;
}

- (void)setContent:(NSString *)content
{
    if (!(self.node.nodeType != @"Test" || self.node.nodeType != @"Comment"))
    {
        [NSException raise:@"Wrong Node Type" format:@"Wrong Node Type"];
    }
    self.content = content;
}

- (XhtmlNode *)addTag:(NSString *)name
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Wrong Node Type" format:@"Node Type is %@", self.node.nodeType];
    }
    XhtmlNode *node = [[XhtmlNode alloc] init];
    [node setNodeType:@"Element"];
    [node setName:name];
    [_childNodes addObject:node];
    return node;
}

- (XhtmlNode *)addTag:(NSInteger *)index:(NSString *)name
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Wrong Node Type" format:@"Node Type is %@", self.node.nodeType];
    }
    XhtmlNode *node = [[XhtmlNode alloc] init];
    [node setNodeType:@"Element"];
    [node setName:name];
    [_childNodes addObject:node];
    return node;
}

- (XhtmlNode *)addComment:(NSString *)content
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Node" format:@"Wrong Node Type"];
    }
    XhtmlNode *node = [[XhtmlNode alloc] init];
    [node setNodeType:@"Comment"];
    [node setContent:content];
    [_childNodes addObject:node];
    return node;
}

- (XhtmlNode *)addDocType:(NSString *)content
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Node" format:@"Wrong Node Type"];
    }
    XhtmlNode *node = [[XhtmlNode alloc] init];
    [node setNodeType:@"DocType"]; //document instead of DocType?
    [node setContent:content];
    [_childNodes addObject:node];
    return node;
}

- (XhtmlNode *)addInstruction:(NSString *)content
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Node" format:@"Wrong Node Type"];
    }
    XhtmlNode *node = [[XhtmlNode alloc] init];
    [node setNodeType:@"Instruction"]; //Instruction is a type?
    [node setContent:content];
    [_childNodes addObject:node];
    return node;
}

- (XhtmlNode *)addText:(NSString *)content
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Node" format:@"Wrong Node Type"];
    }
    XhtmlNode *node = [[XhtmlNode alloc] init];
    [node setNodeType:@"Text"];
    [node setContent:content];
    [_childNodes addObject:node];
    return node;
}

- (XhtmlNode *)addText:(NSInteger *)index :(NSString *)content
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Node" format:@"Wrong Node Type"];
    }
    if (content == NULL)
    {
        [NSException raise:@"Content" format:@"Content cannot be null."];
    }
    XhtmlNode *node = [[XhtmlNode alloc] init];
    [node setNodeType:@"Text"];
    [node setContent:content];
    [_childNodes addObject:node]; //atIndex:index];
    return node;
}

#warning - below function purpose unknown
/*
- (BOOL *)allChildrenAreText
{
    BOOL res = TRUE;
    for (XhtmlNode* n in _childNodes)
    {
        res = res && n.getNodeType == NodeType.Text;
    }
    return res;
}
 */

- (XhtmlNode *)getElement:(NSString *)name
{
    for (XhtmlNode* n in _childNodes)
    {
        if (n.getNodeType == @"Element" && [self.name caseInsensitiveCompare:(n.getName)])
        {
            return n;
        }
    }
    return NULL;
}
                                                  
- (NSString *)allText
{
    NSMutableString *tempString = [[NSMutableString alloc]init];
    for (XhtmlNode* n in _childNodes)
    {
        if (n.getNodeType == @"Text")
        {
            [tempString appendString:n.getContent];
        }
        else if (n.getNodeType == @"Element")
        {
            [tempString appendString:n.allText];
        }
        
    }
    return tempString;
}
                                                  
- (void)attribute:(NSString *)name :(NSString *)value
{
    if (!(self.node.nodeType == @"Element" || self.node.nodeType == @"Document"))
    {
        [NSException raise:@"Node" format:@"Wrong Node Type."];
    }
    if (name == NULL)
    {
        [NSException raise:@"Name" format:@"Name is Null"];
    }
    if (value == NULL)
    {
        [NSException raise:@"Value" format:@"Value is Null"];
    }
    [self.Attributes setObject:value forKey:name];
}
                                                  
- (NSString *)getAttribute:(NSString *)name
{
    return [self.Attributes objectForKey:name];
}
                                                  
- (void)setAttribute:(NSString *)name :(NSString *)value
{
    [self.Attributes setObject:value forKey:name];
}

@end