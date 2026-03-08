# Presets

The following table provides an overview over the presets

| name    | size        | speed    |
| ------- | ----------- | -------- |
| Minify  | tiny        | fastest  |
| Weak    | small       | fast     |
| Medium  | medium      | medium   |
| Strong  | huge        | slowest  |
| Maximum | very huge   | extreme  |

## Maximum preset

The `Maximum` preset applies **every available obfuscation technique** in the most aggressive configuration, stacked in multiple passes:

1. **SplitStrings** — every string shredded to 1–2 char chunks, reassembled by a custom shuffled-index function
2. **EncryptStrings** (×2) — rolling-key cipher applied twice (before and after the first VM layer)
3. **ConstantArray** (×2) — all constants (strings + numbers) extracted into a shuffled, rotated array with deep local accessor wrappers, applied twice
4. **NumbersToExpressions** (×2) — all numeric literals replaced with multi-operation expressions, applied twice
5. **ProxifyLocals** — every local variable wrapped in a metatable proxy object
6. **Vmify** (×2) — double virtualization; the script is compiled to custom bytecode and embedded inside a full interpreter — *twice*
7. **AntiTamper** — any modification of the output file will break execution
8. **WrapInFunction** (3 iterations) — entire output wrapped in 3 nested anonymous IIFEs

### Usage

```batch
lua ./cli.lua --preset Maximum ./your_file.lua
```

Or with the standalone config file:

```batch
lua ./cli.lua --config maximum-config.lua ./your_file.lua
```

