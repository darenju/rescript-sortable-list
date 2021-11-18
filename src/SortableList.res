open Item

module Make = (Item: Item) => {
  module Reducer = Reducer.Make(Item)

  open Utils
  open Styles
  open Reducer

  @react.component
  let make = (~items, ~onSort: option<items => unit> = ?) => {
    let (state, dispatch) = reducer->React.useReducer(items->initialState)

    let reorderItems = (~item, ~pos) => {
      let find = Item.find(item)
      let newItems = state.items->Utils.move(
        item,
        find,
        ~pos,
      )
      ReorderItems(
        newItems,
        pos,
      )->dispatch

      // Call the callback, if any.
      switch onSort {
        | Some(cb) => cb(newItems)
        | None => ()
      }
    }

    let onMouseDownOnItem = (e, index) => {
      open ReactEvent.Mouse
      e->preventDefault
      StartDragging(index, e->target->offsetTop)->dispatch
    }

    let onTouchStartOnItem = (e, index) => {
      open ReactEvent.Touch
      SetTouchY(e->nativeEvent->getTouches->getPageY)->dispatch
      StartDragging(index, e->target->offsetTop)->dispatch
    }

    let onMoveOnItem = (pos, offsetTop) => switch state.dragged {
      | Some(item) => {
          let diff = state.y - offsetTop
          let placeholder = state.placeholder->Belt.Option.getExn

          if (diff < 0 && pos <= placeholder) || (diff > 0 && pos >= placeholder) {
            reorderItems(~item, ~pos)
          }
        }
      | None => ()
    }

    let onMouseMoveOnItem = (e, hoveredIndex) => {
      open ReactEvent.Mouse
      e->preventDefault
      onMoveOnItem(hoveredIndex, e->target->offsetTop)
    }

    let moveItem = movementY => switch state.dragged {
      | Some(_) => {
          if movementY != 0 {
            Movement(movementY)->dispatch
          }
        }
      | None => ()
    }

    // Container events
    let onMouseLeaveOnContainer = _ =>
      StopDragging->dispatch

    let onTouchEndOnContainer = _ =>
      StopDragging->dispatch

    let onMouseMoveOnContainer = (e: ReactEvent.Mouse.t) =>
      moveItem(e->ReactEvent.Mouse.movementY)

    let onTouchMoveOnContainer = e => {
      switch state.dragged {
      | Some(item) => {
          open ReactEvent.Touch
          let rect = e->target->getBoundingClientRect
          let height = rect.height->Belt.Float.toInt
          let newTouchY = (e->nativeEvent->getTouches)[0].pageY->Belt.Float.toInt
          SetTouchY(newTouchY)->dispatch

          let movement = newTouchY - state.touchY
          moveItem(movement)

          let nextY = state.y + movement
          let mod = mod(nextY, height)

          if mod < 5 {
            let pos = max(min(nextY / height, items->Array.length - 1), 0)
            let placeholder = state.placeholder->Belt.Option.getExn

            if placeholder != pos {
              reorderItems(~item, ~pos)
            }
          }
        }
      | None => ()
    }}

    // Rendering
    let draggingItem = switch state.dragged {
      | Some(item) =>
          <div style=(draggedWithY(state.y))>
            (Item.render(item))
          </div>
      | None => React.null
    }

    let renderItem = (index, item) => {
      let isPlaceholder = switch state.placeholder {
        | Some(placeholder) => placeholder == index
        | None => false
      }

      let rendered = Item.render(item)

      <React.Fragment key=(index->Belt.Int.toString)>
        (isPlaceholder ? (
          <div style=(placeholderStyle)>
            (rendered)
          </div>
        ) : (
          <div
            onMouseDown=(e => onMouseDownOnItem(e, index))
            onTouchStart=(e => onTouchStartOnItem(e, index))
            onMouseMove=(e => onMouseMoveOnItem(e, index))
            style=(itemStyle)
          >
            (rendered)
          </div>
        ))
      </React.Fragment>
    }

    <div
      onMouseLeave=(onMouseLeaveOnContainer)
      onMouseUp=(onMouseLeaveOnContainer)
      onMouseMove=(onMouseMoveOnContainer)
      onTouchEnd=(onTouchEndOnContainer)
      onTouchMove=(onTouchMoveOnContainer)
      style=(containerStyle)
    >
      (draggingItem)
      (state.items->Belt.Array.mapWithIndex(renderItem)->React.array)
    </div>
  }
}
