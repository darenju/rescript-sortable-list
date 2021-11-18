# rescript-sortable-list

Very simple sortable vertical list with for [`@rescript/react`](https://reasonml.github.io/reason-react/).
Yes, it’s [`rescript-dnd`](https://github.com/shakacode/rescript-dnd), but my own version, produced to train myself with ReScript! :

## Features

- Vertical list sorting
- Very simple markup
- Works on desktop and mobile

## Installation

1. Install the package in your `node_modules` with either `yarn add rescript-sortable-list` or `npm install --save rescript-sortable-list`.
2. Reference the dependency in your `bsconfig.json` :

```json
"bs-dependencies": [
  "rescript-sortable-list"
]
```

## Usage

Using the package is very simple, because not much is configurable (as of now).

You need to create a type for your list items:

```rescript
type item = {
  id: int,
  title: string,
}
```

Then, you need to implement the `Item` module:

```rescript
module Item = {
  type t = item

  // This function will be called when displaying items.
  let render = item =>
    <div className="item-list__item">(item.title->React.string)</div>

  // This is necessary to reorder items.
  let find =
    (toFind: t) =>
      (item: t) =>
        item.id == toFind.id
}
```

Once you got that ready, you’ll need to tell the `SortableList` generator to use your `Item` module:

```rescript
module MySortableList = SortableList.Make(Item)
```

This allows you to use the `MySortableList` component. See next section for example.

## Example

```rescript
let myItems = [
  {
    id: 1,
    title: "First item",
  },
  {
    id: 2,
    title: "Second item",
  },
  {
    id: 3,
    title: "Third item",
  },
  {
    id: 4,
    title: "Fourth item",
  },
]

<MySortableList
  items=(myItems)
  onSort=(newItems => Js.log(newItems))
/>
```
