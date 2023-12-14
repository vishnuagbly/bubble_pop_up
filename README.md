This package provides the functionality to create bubble pop ups around any widget, anywhere.

## Getting started
First install the package, then simply wrap your widget with the `BubblePopUp` Widget, then provide 
the pop up widget at `popUp` parameter.

## Usage
The following example shows how one can use this package to show a popup over a text which shows 
current balance of a user in short form like, "13K", where on hovering a pop up will appear showing 
the full value, like "13,429".

```dart
final widgetPopUpOnHover = BubblePopUp(
  popUpColor: scheme.background,
  popUp: Container(
    decoration: BoxDecoration(
      color: scheme.background,
      borderRadius: Globals.borderRadius,
    ),
    padding: const EdgeInsets.all(10),
    child: CurrencyText.fromString(
      balance.toMarkedString(),
    ),
  ),
  child: ExcludeSemantics(
    excluding: true,
    child: CurrencyText.fromString(
      balanceShortStr,
    ),
  ),
);
```