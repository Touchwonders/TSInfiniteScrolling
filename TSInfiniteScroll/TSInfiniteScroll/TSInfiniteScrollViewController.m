//
//  TSInfiniteScrollViewController.m
//  TSInfiniteScroll
//
//  Created by Robin van Dijke on 02-05-12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "TSInfiniteScrollViewController.h"
#import "TSInfiniteScrollViewRow.h"
#import "TSInfiniteScrollItemViewController.h"
#import "TSInfiniteScrollViewItem.h"

// grid properties
#define TSNumberOfShownRows    10
#define TSNumberOfShownCols    5
#define TSNumberOfRowsPerPage  2

// some metrics
#define OFFSET_NO_ROWS CGSizeMake(30, 60)
#define MARGIN_LEFT_NO_ROWS 15
#define MARGIN_RIGHT_NO_ROWS 15
#define MARGIN_TOP_NO_ROWS 40
#define MARGIN_BOTTOM_NO_ROWS 40
#define ITEM_BOUNDS CGRectMake(0, 0 ,150, 220)
#define GRID_ROW_HEIGHT (ITEM_BOUNDS.size.height + MARGIN_TOP_NO_ROWS + MARGIN_BOTTOM_NO_ROWS)

@interface TSInfiniteScrollViewController (_RowFunctionality)

// adds a new row to the grid
- (void)addRow:(TSInfiniteScrollViewRow *)row;

// returns the given row at a relative row index
- (TSInfiniteScrollViewRow *)rowAtRowIndex:(NSUInteger)rowIndex;

// sets the correct contentSize for the scrollView using the rows variable
- (void)setCorrectContentSize;

// moves two top rows in the grid to the bottom
- (void)moveLastTwoRowsToTopAndAdjustContentOffset;

// reverse of the previous function
- (void)moveFirstTwoRowsToBottomAndAdjustContentOffset;

// returns the origin of a certain row
- (CGPoint)originOfRowAtRowIndex:(NSUInteger)rowIndex;

// moves a row to a new origin
- (void)moveRowAtRowIndex:(NSUInteger)rowIndex toOrigin:(CGPoint)newOrigin;

// resets the content for a row
- (void)resetItemsForRowAtIndex:(NSUInteger)rowIndex;

// sets items for a given row
- (void)setItems:(NSArray *)items forRowAtIndex:(NSUInteger)rowIndex;

// sets items starting at a given row. Keeps adding 'number of columns' amount of items
// to a row until there are no more items left
- (void)setItems:(NSArray *)items startingAtRowIndex:(NSUInteger)rowIndex;

// converts a relative row index to an absolute one
- (NSUInteger)absoluteRowIndexForRelativeRowIndex:(NSUInteger)rowIndex;

@end

@implementation TSInfiniteScrollViewController

- (id)init {
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
        rows = [[NSMutableArray alloc] init];
        totalNumberOfRows = -1; // not set yet
    }
    return self;
}

- (void)viewDidLoad {
    gridView = [[UIScrollView alloc] initWithFrame:CGRectMake(28, 40, 1024, 2 * (ITEM_BOUNDS.size.height + MARGIN_TOP_NO_ROWS + MARGIN_BOTTOM_NO_ROWS))];
    gridView.delegate = self;
    gridView.pagingEnabled = YES;
    gridView.alwaysBounceVertical = YES;
    [self.view addSubview:gridView];
    self.view.backgroundColor = [UIColor clearColor];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.clipsToBounds = NO;
    
    // create some dummy items (100 rows total, from which TSNumberOfShownRows are actually init'ed)
    totalNumberOfRows = 100;
    for (int i = 0; i < totalNumberOfRows; i++){
        for (int j = 0; j < 5; j++){
            TSInfiniteScrollViewItem *item = [[TSInfiniteScrollViewItem alloc] init];
            item.string = [NSString stringWithFormat:@"Item (%d, %d)", i, j];
            [items addObject:item];
        }
    }
    
    // add some items    
    for (int y = 0; y < TSNumberOfShownRows; y++) {
        TSInfiniteScrollViewRow *row = [[TSInfiniteScrollViewRow alloc] init];
        for (int i = 0; i < TSNumberOfShownCols; i++){
            TSInfiniteScrollItemViewController *itemViewController = [[TSInfiniteScrollItemViewController alloc] init];
            itemViewController.view.bounds = ITEM_BOUNDS;
            [row.itemViewControllers addObject:itemViewController];
        }
        
        [self addRow:row];
    }
}

- (void)displayItem:(TSInfiniteScrollItemViewController *)item {
    doNotReOrder = YES;
    
    // calculate some variables
    NSUInteger indexOfProduct = [items indexOfObject:item];
    NSUInteger indexOfRow = floor(indexOfProduct / TSNumberOfShownCols);
    
    NSUInteger indexForContentOffset = 0, indexForAbsolute = 0, indexForRelative = 0;
    
    indexForRelative = indexOfRow;
    
    BOOL indexOfRowIsEven = indexOfRow % 2 == 0;
    
    if (indexOfRow > TSNumberOfShownRows / 2){
        // upper case
        indexForAbsolute = indexOfRow;
        
        if (indexOfRowIsEven)
            indexForContentOffset = indexForAbsolute;
        else
            indexForContentOffset = indexForAbsolute - 1;
        
    }else {
        if (indexOfRow > totalNumberOfRows - (TSNumberOfShownRows / 2)) {
            // middle case
            indexForContentOffset = (TSNumberOfShownRows / 2) - 1;
            
            if (indexOfRowIsEven)
                indexForAbsolute = (TSNumberOfShownRows / 2) - 1;
            else
                indexForAbsolute = TSNumberOfShownRows / 2;
            
        }else{
            // bottom case
            indexForAbsolute = indexOfRow % TSNumberOfShownRows;
            
            if (indexOfRowIsEven)
                indexForContentOffset = indexForAbsolute;
            else
                indexForContentOffset = indexForAbsolute - 1;
        }
    }
    
    // rebuild rows
    
    // first get a copy of the rows array (to retain each productGridRow)
    NSMutableArray *copyOfRows = [rows copy];
    
    // remove all itemViewControllers from its superview
    for (TSInfiniteScrollViewRow *row in rows)
        for (TSInfiniteScrollItemViewController *itemViewController in row.itemViewControllers)
            [itemViewController.view removeFromSuperview];
    
    // empty rows
    [rows removeAllObjects];
    
    // set correct instance variables
    currentSelectedRowIndex = indexForRelative;
    absoluteSelectedRowIndex = indexForAbsolute;
    
    // loop through each productGridRow, add it again and set correct indices
    for (int i = 0; i < TSNumberOfShownRows; i++){
        TSInfiniteScrollViewRow *row = [copyOfRows objectAtIndex:i];
        [self addRow:row];
        row.indexOfRow = indexForRelative - indexForAbsolute + i;
        
        [self resetItemsForRowAtIndex:row.indexOfRow];
    }
    
    // get contentOffset
    CGPoint originForNewContentOffset = [self originOfRowAtRowIndex:indexForContentOffset];
    
    [gridView setContentOffsetForPaging:CGPointMake(gridView.contentOffset.x, originForNewContentOffset.y - MARGIN_TOP_NO_ROWS - OFFSET_NO_ROWS.height) 
                               animated:NO];
    doNotReOrder = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    scrollingDown = scrollView.contentOffset.y - previousContentOffsetForInfiniteScrolling.y > 0;
    previousContentOffsetForInfiniteScrolling = scrollView.contentOffset;
    
    NSUInteger newAbsoluteSelectedRowIndex = (NSUInteger)(gridView.contentOffset.y / GRID_ROW_HEIGHT + 0.5);
    if (newAbsoluteSelectedRowIndex == absoluteSelectedRowIndex + 1)
        currentSelectedRowIndex++;
    if (newAbsoluteSelectedRowIndex == absoluteSelectedRowIndex - 1)
        currentSelectedRowIndex--;
    
    absoluteSelectedRowIndex = newAbsoluteSelectedRowIndex;
    
    if (doNotReOrder) return;
    
    if (scrollingDown && absoluteSelectedRowIndex == TSNumberOfShownRows - TSNumberOfRowsPerPage &&
        currentSelectedRowIndex < totalNumberOfRows){
        
        [self moveFirstTwoRowsToBottomAndAdjustContentOffset];
    }
    else if (!scrollingDown && absoluteSelectedRowIndex == TSNumberOfRowsPerPage && 
             currentSelectedRowIndex > TSNumberOfRowsPerPage){
        
        [self moveLastTwoRowsToTopAndAdjustContentOffset];
    }
}

@end

@implementation TSInfiniteScrollViewController (_RowFunctionality)

- (void)addRow:(TSInfiniteScrollViewRow *)row {
    NSAssert([row.itemViewControllers count] <= TSNumberOfShownCols, 
             @"Maximum number of viewControllers allowed per grid row");
    
    NSUInteger rowIndex = [rows count];
    
    // set correct frames
    CGPoint originForRow = [self originOfRowAtRowIndex:rowIndex];
    CGFloat yValueForThisRow = originForRow.y;
    CGFloat currentXValue = originForRow.x;
    
    for (TSInfiniteScrollItemViewController *itemViewController in row.itemViewControllers){
        currentXValue += MARGIN_LEFT_NO_ROWS;
        itemViewController.view.frame = CGRectMake(currentXValue, yValueForThisRow, itemViewController.view.frame.size.width, itemViewController.view.frame.size.height);
        currentXValue += itemViewController.view.frame.size.width;
        currentXValue += MARGIN_RIGHT_NO_ROWS;
        
        [gridView addSubview:itemViewController.view];
    } 
    
    row.indexOfRow = [rows count];
    [rows addObject:row];
    [self setCorrectContentSize];
    [self resetItemsForRowAtIndex:row.indexOfRow];
}

- (void)setCorrectContentSize {   
    NSUInteger _numberOfRows = totalNumberOfRows < TSNumberOfShownRows ? totalNumberOfRows : TSNumberOfShownRows;
    
    [gridView setContentSizeForPaging:CGSizeMake(gridView.frame.size.width, _numberOfRows * GRID_ROW_HEIGHT)];
}

- (TSInfiniteScrollViewRow *)rowAtRowIndex:(NSUInteger)rowIndex {
    if (rowIndex >= [rows count]) return nil;
    
    return [rows objectAtIndex:rowIndex];
}

- (CGPoint)originOfRowAtRowIndex:(NSUInteger)rowIndex {
    CGFloat yValueForThisRow = OFFSET_NO_ROWS.height + (rowIndex * GRID_ROW_HEIGHT) + MARGIN_TOP_NO_ROWS;
    return CGPointMake(OFFSET_NO_ROWS.width, yValueForThisRow);
}

- (void)moveRowAtRowIndex:(NSUInteger)rowIndex toOrigin:(CGPoint)newOrigin {
    if (rowIndex > [rows count] - 1) return;
    TSInfiniteScrollViewRow *row = [rows objectAtIndex:rowIndex];
    
    for (TSInfiniteScrollItemViewController *itemViewController in row.itemViewControllers){
        CGRect frame = itemViewController.view.frame;
        frame.origin.y = newOrigin.y;
        itemViewController.view.frame = frame;
    }
}

- (void)moveLastTwoRowsToTopAndAdjustContentOffset {
    void (^moveOneRow)(void) = ^{
        // get the last row
        TSInfiniteScrollViewRow *lastRow = [rows lastObject];
        
        // remember origin or first row
        CGPoint originOfFirstRow = [self originOfRowAtRowIndex:0];
        
        // move each row downwards
        for (TSInfiniteScrollViewRow *row in rows){
            if (row == lastRow) continue;
            
            NSUInteger rowIndex = [rows indexOfObject:row];
            
            CGPoint originOfNextRow = [self originOfRowAtRowIndex:rowIndex + 1];
            [self moveRowAtRowIndex:rowIndex toOrigin:originOfNextRow];
        }
        
        // move last to first
        [self moveRowAtRowIndex:[rows indexOfObject:lastRow] toOrigin:originOfFirstRow];
        [rows removeLastObject];
        [rows insertObject:lastRow atIndex:0];
        lastRow.indexOfRow -= TSNumberOfShownRows;
        [self resetItemsForRowAtIndex:lastRow.indexOfRow];
    };
    
    moveOneRow();
    moveOneRow();
    
    // alter contentOffset
    gridView.contentOffset = CGPointMake(gridView.contentOffset.x, gridView.contentOffset.y + gridView.frame.size.height);
}

- (void)moveFirstTwoRowsToBottomAndAdjustContentOffset {    
    // don't do this if one the last row its index is equal to totalNumberOfRows - 1
    TSInfiniteScrollViewRow *lastRow = [rows lastObject];
    if (lastRow.indexOfRow == totalNumberOfRows - 1 || lastRow.indexOfRow == totalNumberOfRows - 2) {
        return;
    }
    
    void (^moveOneRow)(void) = ^{
        // get the first row
        TSInfiniteScrollViewRow *firstRow = [rows objectAtIndex:0];
        
        // remember origin or last row
        CGPoint originOfLastRow = [self originOfRowAtRowIndex:[rows count] - 1];
        
        // current origin (start at first row)
        CGPoint originOfCurrentRow = [self originOfRowAtRowIndex:0];
        
        // move each row upwards
        for (TSInfiniteScrollViewRow *row in rows){
            if (row == firstRow) continue;
            
            NSUInteger rowIndex = [rows indexOfObject:row];
            
            CGPoint originOfPreviousRow = [self originOfRowAtRowIndex:rowIndex];
            
            [self moveRowAtRowIndex:rowIndex toOrigin:originOfCurrentRow];
            originOfCurrentRow = originOfPreviousRow;
        }
        
        // move first to last
        [self moveRowAtRowIndex:0 toOrigin:originOfLastRow];
        [rows removeObjectAtIndex:0];
        [rows insertObject:firstRow atIndex:[rows count]];
        firstRow.indexOfRow += TSNumberOfShownRows;
        [self resetItemsForRowAtIndex:firstRow.indexOfRow];
    };
    
    moveOneRow();
    moveOneRow();
    
    // alter contentOffset
    gridView.contentOffset = CGPointMake(gridView.contentOffset.x, gridView.contentOffset.y - gridView.frame.size.height);
}

- (void)resetItemsForRowAtIndex:(NSUInteger)rowIndex {
    NSUInteger originalRowIndex = rowIndex;
    
    // convert rowIndex
    rowIndex = [self absoluteRowIndexForRelativeRowIndex:rowIndex];
    
    if (rowIndex > [rows count]) return;
    
    [self setItems:[items subarrayWithRange:NSMakeRange(originalRowIndex * TSNumberOfShownCols, TSNumberOfShownCols)]
     forRowAtIndex:originalRowIndex];
}

- (void)setItems:(NSArray *)_items forRowAtIndex:(NSUInteger)rowIndex {    
    if (rowIndex >= totalNumberOfRows) return;
    
    // convert rowIndex
    rowIndex = [self absoluteRowIndexForRelativeRowIndex:rowIndex];
    
    if (rowIndex >= [rows count]) return;
    
    TSInfiniteScrollViewRow *row = [rows objectAtIndex:rowIndex];
    for (TSInfiniteScrollItemViewController *itemViewController in row.itemViewControllers){
        
        NSUInteger indexOfItemViewController = [row.itemViewControllers indexOfObject:itemViewController];
        if (indexOfItemViewController < [_items count]){
            TSInfiniteScrollViewItem *item = [_items objectAtIndex:indexOfItemViewController];
            
            [itemViewController setItem:item];
            
            if (itemViewController.hidden)
                [itemViewController setHidden:NO];
        }else{
            // no item for this itemViewController, hide it
            if (!itemViewController.hidden)
                [itemViewController setHidden:YES];
        }
    }
}

- (void)setItems:(NSArray *)_items startingAtRowIndex:(NSUInteger)startingRowIndex {
    NSUInteger numberOfGivenRows = [_items count] / TSNumberOfShownCols;
    if (numberOfGivenRows == 0) numberOfGivenRows = 1;
    NSMutableArray *mutableItems = [[NSMutableArray alloc] initWithArray:_items];
    
    NSUInteger lastRowIndex = startingRowIndex;
    
    for (int i = 0; i < numberOfGivenRows; i++){
        NSUInteger rangeLength = [mutableItems count] >= TSNumberOfShownCols ? TSNumberOfShownCols : [mutableItems count];
        NSArray *subItems = [_items subarrayWithRange:NSMakeRange(i * TSNumberOfShownCols, rangeLength)];
        [self setItems:subItems forRowAtIndex:i + startingRowIndex];
        [mutableItems removeObjectsInArray:subItems];
        lastRowIndex++;
    }
}

- (NSUInteger)absoluteRowIndexForRelativeRowIndex:(NSUInteger)rowIndex {
    for (int i = 0; i < [rows count]; i++){
        TSInfiniteScrollViewRow *row = [rows objectAtIndex:i];
        if (row.indexOfRow == rowIndex) {
            return i;
        }
    }
    
    return -1;
}

@end
