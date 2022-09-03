import * as pt from "pareto-core-types"
import * as pi from "pareto-core-internals"

export function filterArray<T, NT>(
    $: pt.Array<T>,
    callback: ($: T) => undefined | NT,
) {
    const temp: NT[] = []
    $.forEach(($) => {
        const res = callback($)
        if (res !== undefined) {
            temp.push(res)
        }
    })
    return pi.wrapRawArray(temp)
}