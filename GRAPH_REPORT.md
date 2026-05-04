# Graph Report - /Users/luowei/projects/libs/LWHUD  (2026-05-04)

## Corpus Check
- Corpus is ~19,719 words - fits in a single context window. You may not need a graph.

## Summary
- 255 nodes · 304 edges · 16 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]

## God Nodes (most connected - your core abstractions)
1. `LWHUD` - 95 edges
2. `LWHUD` - 11 edges
3. `UIViewController` - 8 edges
4. `showHUD()` - 8 edges
5. `LWRoundProgressView` - 8 edges
6. `LWBarProgressView` - 8 edges
7. `LWBackgroundView` - 8 edges
8. `LWAppDelegate` - 7 edges
9. `LWViewController` - 7 edges
10. `View` - 7 edges

## Surprising Connections (you probably didn't know these)
- `LWBackgroundView` --inherits--> `UIView`  [EXTRACTED]
  LWHUD_swift/Classes/LWBackgroundView.swift →   _Bridges community 8 → community 5_
- `LWHUD` --inherits--> `UIView`  [EXTRACTED]
  LWHUD/Classes/LWHUD.m →   _Bridges community 5 → community 0_
- `LWHUDRoundedButton` --inherits--> `UIButton`  [EXTRACTED]
  LWHUD/Classes/LWHUD.m →   _Bridges community 8 → community 3_

## Communities (21 total, 2 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.03
Nodes (66): LWHUD, -activityIndicatorColor, -allHUDsForView, -animateInwithTypecompletion, -applyPrioritytoConstraints, -cleanUp, -color, -cornerRadius (+58 more)

### Community 1 - "Community 1"
Cohesion: 0.11
Nodes (8): hideHUD(), LWHUD, showActivity(), showError(), showHUD(), showSuccess(), UIViewController, UIWindow

### Community 2 - "Community 2"
Cohesion: 0.11
Nodes (17): AnnularProgressView, BarProgressView, CircularProgressView, EnvironmentValues, HUDKey, LWHUDRepresentable, LWHUDView, LWHUDViewModifier (+9 more)

### Community 3 - "Community 3"
Cohesion: 0.09
Nodes (22): LWBackgroundView, -initWithFrame, -intrinsicContentSize, -setBlurEffectStyle, -setColor, -setStyle, -updateForBackgroundStyle, -updateViewsForColor (+14 more)

### Community 4 - "Community 4"
Cohesion: 0.11
Nodes (18): AnyObject, LWHUDAnimation, fade, zoom, zoomIn, zoomOut, LWHUDBackgroundStyle, blur (+10 more)

### Community 5 - "Community 5"
Cohesion: 0.14
Nodes (9): -commonInit, -registerForNotifications, -setupViews, -updateBezelMotionEffects, -updateIndicators, LWBarProgressView, LWRoundProgressView, LWProgressView (+1 more)

### Community 6 - "Community 6"
Cohesion: 0.18
Nodes (8): LWHUDExampleView, LWHUDExampleView_Previews, LWHUDExampleViewController, LWHUDSwiftUIExampleView, LWHUDView_Previews, PreviewProvider, UIViewController, View

### Community 7 - "Community 7"
Cohesion: 0.21
Nodes (7): -done, -handleGraceTimer, -handleMinShowTimer, -hide, -hideUsingAnimation, -show, -showUsingAnimation

### Community 8 - "Community 8"
Cohesion: 0.24
Nodes (3): LWBackgroundView, LWHUDRoundedButton, UIButton

### Community 9 - "Community 9"
Cohesion: 0.25
Nodes (7): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 10 - "Community 10"
Cohesion: 0.25
Nodes (7): LWViewController, -hideLoading, -showHUD, -showLoading, -showLoadingWithProgress, -showToastTextduration, -viewDidLoad

### Community 11 - "Community 11"
Cohesion: 0.25
Nodes (8): LWBarProgressView, -drawRect, -init, -initWithFrame, -intrinsicContentSize, -setProgress, -setProgressColor, -setProgressRemainingColor

### Community 12 - "Community 12"
Cohesion: 0.4
Nodes (4): Tests, -setUp, -tearDown, -testExample

### Community 14 - "Community 14"
Cohesion: 0.67
Nodes (3): -layoutSubviews, -updateConstraints, -updatePaddingConstraints

## Knowledge Gaps
- **123 isolated node(s):** `-setUp`, `-tearDown`, `-testExample`, `-applicationdidFinishLaunchingWithOptions`, `-applicationWillResignActive` (+118 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LWHUD` connect `Community 0` to `Community 3`, `Community 4`, `Community 5`, `Community 7`, `Community 13`, `Community 14`, `Community 15`?**
  _High betweenness centrality (0.381) - this node is a cross-community bridge._
- **Why does `LWHUDRoundedButton` connect `Community 3` to `Community 8`?**
  _High betweenness centrality (0.038) - this node is a cross-community bridge._
- **What connects `-setUp`, `-tearDown`, `-testExample` to the rest of the system?**
  _123 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.03 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.11 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.11 - nodes in this community are weakly interconnected._
- **Should `Community 3` be split into smaller, more focused modules?**
  _Cohesion score 0.09 - nodes in this community are weakly interconnected._