open Item

module Make = (Item: Item) => {
  type item = Item.t
  type items = array<item>

  type action =
    | StartDragging(int, int)
    | StopDragging
    | SetTouchY(int)
    | Movement(int)
    | ReorderItems(items, int)

  type state = {
    items,
    dragged: option<item>,
    placeholder: option<int>,
    y: int,
    touchY: int,
  }

  let reducer = (state, action) => switch action {
    | StartDragging(index, y) => {
        ...state,
        dragged: Some(state.items[index]),
        placeholder: Some(index),
        y,
      }
    | StopDragging => {
        ...state,
        placeholder: None,
        dragged: None,
      }
    | SetTouchY(touchY) => {
        ...state,
        touchY,
      }
    | Movement(direction) => {
        ...state,
        y: state.y + direction,
      }
    | ReorderItems(items, placeholder) => {
        ...state,
        items,
        placeholder: Some(placeholder),
      }
  }

  let initialState = items => {
    items,
    dragged: None,
    placeholder: None,
    y: 0,
    touchY: 0,
  }
}
