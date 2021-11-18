@get external offsetTop: {..} => int = "offsetTop"
type boudingClientRect = {
  top: float,
  left: float,
  width: float,
  height: float,
}
@send external getBoundingClientRect: {..} => boudingClientRect = "getBoundingClientRect"

type touch = {
  pageY: float,
}
@get external getTouches: {..} => array<touch> = "touches"

let getPageY = touches => touches[0].pageY->Belt.Float.toInt

let move = (arr: array<'a>, item: 'a, cmp: 'a => bool, ~pos: int) => {
  let arr = arr->Js.Array.copy
  let from = arr|>Js.Array.findIndex(cmp)
  arr->Js.Array2.spliceInPlace(~pos=from, ~remove=1, ~add=[])->ignore
  arr->Js.Array2.spliceInPlace(~pos, ~remove=0, ~add=[item])->ignore
  arr
}
