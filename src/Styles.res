let containerStyle = ReactDOM.Style.make(
  ~position="relative",
  (),
)->ReactDOM.Style.unsafeAddProp("touchAction", "none")

let itemStyle = ReactDOM.Style.make(
  ~transition="top 0.3s ease",
  (),
)->ReactDOM.Style.unsafeAddProp("touchAction", "manipulation")

let draggedStyle = ReactDOM.Style.make(
  ~opacity="0.5",
  ~position="absolute",
  ~pointerEvents="none",
  ~left="0px",
  ~right="0px",
  (),
)

let placeholderStyle = ReactDOM.Style.make(
  ~visibility="hidden",
  (),
)

let draggedWithY = y =>
  ReactDOM.Style.combine(
    draggedStyle,
    ReactDOM.Style.make(
      ~top=y->Belt.Int.toString ++ "px",
      (),
    )
  )
