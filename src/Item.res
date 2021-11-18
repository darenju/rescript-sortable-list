module type Item = {
  type t
  let render: t => React.element
  let find: t => t => bool
}
