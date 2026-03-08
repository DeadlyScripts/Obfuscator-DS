-- ================================================================
-- Prometheus Maximum Obfuscation Config  (~500 KB target)
-- Usage: lua ./cli.lua --config maximum-config.lua your_script.lua
-- ================================================================
-- Stacks every available technique at their most aggressive settings
-- across 15 passes.  Output will be dramatically larger and slower.
-- ================================================================

return {
    LuaVersion   = "Lua51";
    VarNamePrefix = "";
    NameGenerator = "Il";
    PrettyPrint  = false;
    Seed         = 0;

    Steps = {
        -- 1. Shred every string to single characters (MaxLength=1 = max chunks)
        --    reassembled by 8 custom shuffled-index local functions per scope
        {
            Name = "SplitStrings";
            Settings = {
                Treshold                  = 1;
                MinLength                 = 1;
                MaxLength                 = 1;
                ConcatenationType         = "custom";
                CustomFunctionType        = "local";
                CustomLocalFunctionsCount = 8;
            };
        },

        -- 2. First rolling-key cipher pass on all string constants
        {
            Name = "EncryptStrings";
            Settings = {};
        },

        -- 3. Extract ALL constants into a shuffled/rotated array
        --    with 10 local accessor wrappers (8 args each = huge call overhead)
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

        -- 4. Deep recursive arithmetic expression trees
        --    InternalTreshold=0.05: 95% chance to recurse deeper per node = massive expansion
        {
            Name = "NumbersToExpressions";
            Settings = {
                Treshold         = 1;
                InternalTreshold = 0.05;
            };
        },

        -- 5. Wrap every local variable in a metatable proxy object
        {
            Name = "ProxifyLocals";
            Settings = {
                LiteralType = "any";
            };
        },

        -- 6. FIRST VM LAYER: compile to custom bytecode + embed interpreter
        {
            Name = "Vmify";
            Settings = {};
        },

        -- 7. Anti-tamper guard baked in — any file modification breaks execution
        {
            Name = "AntiTamper";
            Settings = {
                UseDebug = false;
            };
        },

        -- 8. Encrypt again — now VM opcodes and interpreter internals are encrypted
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

        -- 10. Deep number expansion on new constants from VM/ConstantArray passes
        {
            Name = "NumbersToExpressions";
            Settings = {
                Treshold         = 1;
                InternalTreshold = 0.05;
            };
        },

        -- 11. SECOND VM LAYER: double virtualization
        --     Reverse engineering now requires defeating two independent VMs
        {
            Name = "Vmify";
            Settings = {};
        },

        -- 12. Third encryption pass on the outer VM shell
        {
            Name = "EncryptStrings";
            Settings = {};
        },

        -- 13. Third constant-array extraction over the outer VM
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

        -- 14. Final deep number-expression pass on outer VM constants
        {
            Name = "NumbersToExpressions";
            Settings = {
                Treshold         = 1;
                InternalTreshold = 0.05;
            };
        },

        -- 15. Wrap everything in 5 layers of nested anonymous IIFEs
        {
            Name = "WrapInFunction";
            Settings = {
                Iterations = 5;
            };
        },
    };
}
