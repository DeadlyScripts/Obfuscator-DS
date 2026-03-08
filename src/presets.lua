-- This Script is Part of the Prometheus Obfuscator by Levno_710
--
-- pipeline.lua
--
-- This Script Provides some configuration presets

return {
    ["Minify"] = {
        -- The default LuaVersion is Lua51
        LuaVersion = "Lua51";
        -- For minifying no VarNamePrefix is applied
        VarNamePrefix = "";
        -- Name Generator for Variables
        NameGenerator = "MangledShuffled";
        -- No pretty printing
        PrettyPrint = false;
        -- Seed is generated based on current time
        Seed = 0;
        -- No obfuscation steps
        Steps = {

        }
    };
    ["Weak"] = {
        -- The default LuaVersion is Lua51
        LuaVersion = "Lua51";
        -- For minifying no VarNamePrefix is applied
        VarNamePrefix = "";
        -- Name Generator for Variables that look like this: IlI1lI1l
        NameGenerator = "MangledShuffled";
        -- No pretty printing
        PrettyPrint = false;
        -- Seed is generated based on current time
        Seed = 0;
        -- Obfuscation steps
        Steps = {
            {
                Name = "Vmify";
                Settings = {

                };
            },
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold    = 1;
                    StringsOnly = true;
                }
            },
            {
                Name = "WrapInFunction";
                Settings = {

                }
            },
        }
    };
    ["Vmify"] = {
        -- The default LuaVersion is Lua51
        LuaVersion = "Lua51";
        -- For minifying no VarNamePrefix is applied
        VarNamePrefix = "";
        -- Name Generator for Variables that look like this: IlI1lI1l
        NameGenerator = "MangledShuffled";
        -- No pretty printing
        PrettyPrint = false;
        -- Seed is generated based on current time
        Seed = 0;
        -- Obfuscation steps
        Steps = {
            {
                Name = "Vmify";
                Settings = {

                };
            },
        }
    };
    ["Medium"] = {
        -- The default LuaVersion is Lua51
        LuaVersion = "Lua51";
        -- For minifying no VarNamePrefix is applied
        VarNamePrefix = "";
        -- Name Generator for Variables
        NameGenerator = "MangledShuffled";
        -- No pretty printing
        PrettyPrint = false;
        -- Seed is generated based on current time
        Seed = 0;
        -- Obfuscation steps
        Steps = {
            {
                Name = "EncryptStrings";
                Settings = {

                };
            },
            {
                Name = "AntiTamper";
                Settings = {
                    UseDebug = false;
                };
            },
            {
                Name = "Vmify";
                Settings = {

                };
            },
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold    = 1;
                    StringsOnly = true;
                    Shuffle     = true;
                    Rotate      = true;
                    LocalWrapperTreshold = 0;
                }
            },
            {
                Name = "NumbersToExpressions";
                Settings = {

                }
            },
            {
                Name = "WrapInFunction";
                Settings = {

                }
            },
        }
    };
    ["Strong"] = {
        -- The default LuaVersion is Lua51
        LuaVersion = "Lua51";
        -- For minifying no VarNamePrefix is applied
        VarNamePrefix = "";
        -- Name Generator for Variables that look like this: IlI1lI1l
        NameGenerator = "MangledShuffled";
        -- No pretty printing
        PrettyPrint = false;
        -- Seed is generated based on current time
        Seed = 0;
        -- Obfuscation steps
        Steps = {
            {
                Name = "Vmify";
                Settings = {

                };
            },
            {
                Name = "EncryptStrings";
                Settings = {

                };
            },
            {
                Name = "AntiTamper";
                Settings = {

                };
            },
            {
                Name = "Vmify";
                Settings = {

                };
            },
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold    = 1;
                    StringsOnly = true;
                    Shuffle     = true;
                    Rotate      = true;
                    LocalWrapperTreshold = 0;
                }
            },
            {
                Name = "NumbersToExpressions";
                Settings = {

                }
            },
            {
                Name = "WrapInFunction";
                Settings = {

                }
            },
        }
    },
    -- =========================================================
    -- MAXIMUM preset — targets ~500 KB output
    -- Every technique, cranked to maximum settings, multi-pass
    -- =========================================================
    ["Maximum"] = {
        LuaVersion   = "Lua51";
        VarNamePrefix = "";
        -- "Il" uses only I/l/1 chars — impossible to read by eye
        NameGenerator = "Il";
        PrettyPrint  = false;
        Seed         = 0;
        Steps = {
            -- ── PRE-VM BLOAT PASS ─────────────────────────────────

            -- 1. Shred every string to single characters, reassembled
            --    by 8 custom shuffled-index local functions per scope
            {
                Name = "SplitStrings";
                Settings = {
                    Treshold                   = 1;
                    MinLength                  = 1;
                    MaxLength                  = 1;   -- one char per slot = max chunks
                    ConcatenationType          = "custom";
                    CustomFunctionType         = "local";
                    CustomLocalFunctionsCount  = 8;   -- 8 wrappers per scope
                };
            },

            -- 2. First string encryption pass
            {
                Name = "EncryptStrings";
                Settings = {};
            },

            -- 3. Heavy constant-array extraction — strings + numbers,
            --    10 local accessor wrappers with 8 args each
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold             = 1;
                    StringsOnly          = false;
                    Shuffle              = true;
                    Rotate               = true;
                    LocalWrapperTreshold = 1;
                    LocalWrapperCount    = 10;   -- ↑ from 5
                    LocalWrapperArgCount = 8;    -- ↑ from 6
                    MaxWrapperOffset     = 100;  -- ↑ from 50
                };
            },

            -- 4. Numbers → deeply recursive arithmetic expressions
            --    (InternalTreshold 0.05 = very deep recursion → huge AST)
            {
                Name = "NumbersToExpressions";
                Settings = {
                    Treshold         = 1;
                    InternalTreshold = 0.05;  -- lower = deeper trees = much more code
                };
            },

            -- 5. Wrap every local in a metatable proxy
            {
                Name = "ProxifyLocals";
                Settings = {
                    LiteralType = "any";
                };
            },

            -- ── FIRST VIRTUALIZATION ──────────────────────────────

            -- 6. Compile to custom bytecode + embed full interpreter
            {
                Name = "Vmify";
                Settings = {};
            },

            -- 7. Anti-tamper baked into VM output
            {
                Name = "AntiTamper";
                Settings = {
                    UseDebug = false;
                };
            },

            -- ── POST-VM BLOAT PASS ────────────────────────────────

            -- 8. Encrypt again — now the VM opcodes are encrypted
            {
                Name = "EncryptStrings";
                Settings = {};
            },

            -- 9. Second heavy constant-array pass over the VM blob
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold             = 1;
                    StringsOnly          = false;
                    Shuffle              = true;
                    Rotate               = true;
                    LocalWrapperTreshold = 1;
                    LocalWrapperCount    = 10;
                    LocalWrapperArgCount = 8;
                    MaxWrapperOffset     = 100;
                };
            },

            -- 10. Deep number-expression expansion on all new numeric
            --     constants produced by the VM/ConstantArray passes
            {
                Name = "NumbersToExpressions";
                Settings = {
                    Treshold         = 1;
                    InternalTreshold = 0.05;
                };
            },

            -- ── SECOND VIRTUALIZATION ─────────────────────────────

            -- 11. Double-VM: wrap the already-virtualized output in a
            --     second completely independent interpreter
            {
                Name = "Vmify";
                Settings = {};
            },

            -- 12. Third string encryption on the outer VM shell
            {
                Name = "EncryptStrings";
                Settings = {};
            },

            -- 13. Third constant-array pass on the outer VM
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold             = 1;
                    StringsOnly          = false;
                    Shuffle              = true;
                    Rotate               = true;
                    LocalWrapperTreshold = 1;
                    LocalWrapperCount    = 8;
                    LocalWrapperArgCount = 7;
                    MaxWrapperOffset     = 80;
                };
            },

            -- 14. Final number-expression pass
            {
                Name = "NumbersToExpressions";
                Settings = {
                    Treshold         = 1;
                    InternalTreshold = 0.05;
                };
            },

            -- 15. Wrap the whole thing in 5 nested anonymous IIFEs
            {
                Name = "WrapInFunction";
                Settings = {
                    Iterations = 5;
                };
            },
        };
    };
}
