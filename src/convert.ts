import type {
  MatraAST,
  MatraASTChild,
  MatraJSON,
  MatraJSONChild,
  MatraValue,
} from "./types.js"

export function isMatraAST(value: unknown): value is MatraAST {
  return (
    Array.isArray(value) &&
    value.length === 3 &&
    typeof value[0] === "string" &&
    isRecord(value[1]) &&
    Array.isArray(value[2])
  )
}

export function isMatraJSON(value: unknown): value is MatraJSON {
  return (
    isRecord(value) &&
    typeof value.tag === "string" &&
    isRecord(value.props) &&
    Array.isArray(value.children)
  )
}

/** Convert the compact internal AST to the object-shaped interchange form. */
export function astToMatraJSON(ast: MatraAST): MatraJSON {
  const [tag, props, children] = ast
  return {
    tag,
    props: cloneValue(props),
    children: children.map(childToJSON),
  }
}

/** Convert the object-shaped interchange form to the compact internal AST. */
export function matraJSONToAST(node: MatraJSON): MatraAST {
  return [
    node.tag,
    cloneValue(node.props),
    node.children.map(childToAST),
  ]
}

function childToJSON(child: MatraASTChild): MatraJSONChild {
  return isMatraAST(child) ? astToMatraJSON(child) : cloneValue(child)
}

function childToAST(child: MatraJSONChild): MatraASTChild {
  return isMatraJSON(child) ? matraJSONToAST(child) : cloneValue(child)
}

function isRecord(value: unknown): value is Record<string, any> {
  return value !== null && typeof value === "object" && !Array.isArray(value)
}

function cloneValue<T extends MatraValue>(value: T): T {
  if (Array.isArray(value)) return value.map(item => cloneValue(item)) as T
  if (isRecord(value)) {
    return Object.fromEntries(
      Object.entries(value).map(([key, item]) => [key, cloneValue(item)]),
    ) as T
  }
  return value
}
