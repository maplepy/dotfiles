import { restoreText } from "./restore.js"
import { redactText } from "./engine.js"

function isPlainObject(value) {
  if (!value || typeof value !== "object") return false
  if (Array.isArray(value)) return false
  const proto = Object.getPrototypeOf(value)
  return proto === Object.prototype || proto === null
}

/**
 * 深度遍历工具参数对象，把所有字符串里的占位符还原为原值。
 * 返回还原后的副本，不修改入参：OpenCode V2 传给工具钩子的嵌套参数是只读的
 * （冻结对象），原地赋值会抛 "Attempted to assign to readonly property."。
 * - 只遍历 Array / PlainObject
 * @param {unknown} value
 * @param {{ prefix: string, lookup(ph: string): string | undefined }} session
 */
export function restoreDeep(value, session) {
  if (Array.isArray(value)) {
    return value.map((v) =>
      typeof v === "string" ? restoreText(v, session) : restoreDeep(v, session),
    )
  }

  if (isPlainObject(value)) {
    const restored = {}
    for (const key of Object.keys(value)) {
      const v = value[key]
      restored[key] = typeof v === "string" ? restoreText(v, session) : restoreDeep(v, session)
    }
    return restored
  }

  return value
}

/**
 * 深度遍历对象，把所有字符串中的敏感内容替换为占位符（原地修改）。
 * - 只遍历 Array / PlainObject
 * - 使用 WeakSet 避免循环引用导致爆栈
 * @param {unknown} value
 * @param {{ keywords: Array<{value:string,category:string}>, regex: Array<{pattern:string,flags:string,category:string}>, exclude: Set<string> }} patterns
 * @param {{ getOrCreatePlaceholder(original: string, category: string): string }} session
 */
export function redactDeep(value, patterns, session) {
  const seen = new WeakSet()

  const walk = (node) => {
    if (!node || typeof node !== "object") return
    if (seen.has(node)) return
    seen.add(node)

    if (Array.isArray(node)) {
      for (let i = 0; i < node.length; i++) {
        const v = node[i]
        if (typeof v === "string") node[i] = redactText(v, patterns, session).text
        if (v && typeof v === "object") walk(v)
      }
      return
    }

    if (!isPlainObject(node)) return

    for (const key of Object.keys(node)) {
      const v = node[key]
      if (typeof v === "string") node[key] = redactText(v, patterns, session).text
      if (v && typeof v === "object") walk(v)
    }
  }

  walk(value)
}
