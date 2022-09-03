import * as pm from "pareto-core-state"

export function createUnsafeDictionaryBuilder<T>(): pm.DictionaryBuilder<T> {
    return pm.createDictionaryBuilder(
        ["ignore", {}],
        (key) => {
            throw new Error(`CORE: duplicate key: ${key}`)
        }
    )
}