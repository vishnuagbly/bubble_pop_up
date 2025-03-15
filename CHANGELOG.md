## 2.0.1
- Updated example app.

## 2.0.0
- [Breaking Change]: Renamed `childBorderRadius` to `popUpBorderRadius`.
- Made `BubblePopUpState` as public, which exposes `addPopUp` and `addPopUpAndSelect` functions.
- Updated Example App and Readme

## 1.0.0
Added support for base border radius. This completes the package roadmap.

## 0.2.0
Fixed a bug in setting, bottom right child border radius value for downward arrow direction.

## 0.1.2
Updated dependencies

## 0.1.1
[Fix]: With this change with `onTap` set as true, no matter hover is enabled or not an 
InkWell widget will be wrapped around the `body`. This allows the user to tap on the widget to show 
the pop-up.

## 0.1.0+1
Please note that the num_pair package has been extracted from this project and is now maintained as 
a separate package. You can find the standalone num_pair package [here](https://pub.dev/packages/num_pair).

## 0.1.0
[Breaking Change]: This consists of lots of breaking changes. We have re-designed whole system.
Now we have a new config class, `BubblePopUpConfig` for various positioning related params for the
pop-up.

We have renamed few parameters:
 - `popUpPosition` -> `baseAnchor`
 - `triangleCornerRadius` -> `arrowCornerRadius`
 - `triangleSize` -> `arrowSize`

We have added new parameters, `popUpAnchor`, `arrowDirection`

## 0.0.3
Fixed all bugs with `onTap` and `onHover` features.

## 0.0.2+1
Fixed bug with `onTap` feature. Added auto close on dispose as well.

## 0.0.2
Now pop up will also be shown on tap. Also can set whether to show pop `onTap` and `onHover`.

## 0.0.1+1
Added GNU General Public License v3.0

## 0.0.1
This package provides a single widget called `BubblePopUp`.
