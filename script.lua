-- Script Path: game:GetService("ReplicatedStorage").Client.Gameplay.Player.Movement
-- Took 0.09s to decompile.
-- Executor: Madium (2.0.0)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ActionMovement_m = require(game.ReplicatedStorage.Modules.Actions.ActionMovement)
local CharacterControllers_m = require(
    game.ReplicatedStorage.Modules.Characters.CharacterControllers
)
local LocalMovementGuard_m = require(game.ReplicatedStorage.Modules.Characters.LocalMovementGuard)
local DefaultPlayerScripts_m = require(script.Parent.DefaultPlayerScripts)
local Controls_m = require(game.ReplicatedStorage.Modules.Gameplay.Controls)
local Keybinds_m = require(game.ReplicatedStorage.Modules.Gameplay.Keybinds)
local LocalActionCleanup_m = require(game.ReplicatedStorage.Client.Gameplay.LocalActionCleanup)
local Ragdoll_m = require(game.ReplicatedStorage.Modules.Characters.Ragdoll)
local t = {}
local LocalPlayer = Players.LocalPlayer
local v1 = nil
local t_1 = {}
local t_2 = {}
local t_3 = {}
local t_4 = {}
local t_5 = {}
local v2 = nil
local v3 = nil
local v4 = nil
local t_6 = {}
local v5 = nil
local v6 = false
local v7 = false
local v8 = false
local v9 = nil
local t_7 = {}
local t_8 = {}
local t_9 = {}
local t_10 = {}
local t_11 = {}
local t_12 = {}
local v10 = false
local t_13 = { "Kick", "Pass", "Lob" }

local function refreshJumpKeyCodes() -- line: 50
    -- upvalues:
    --  [1] t_8 (ref)
    --  [2] t_9 (ref)
    --  [3] t_10 (ref)
    --  [4] t_11 (ref)
    --  [5] t_12 (ref)
    --  [6] Keybinds_m (copy)
    --  [7] t_13 (copy)

    t_8 = {}
    t_9 = {}
    t_10 = {}
    t_11 = {}
    t_12 = {}
    local v11 = Keybinds_m.Get("Jump")

    if v11.InputTypes then
        for _, val in v11.InputTypes do
            t_10[val] = true

            for _, val_1 in t_13 do
                if Keybinds_m.Matches(val_1, { UserInputType = val }) then
                    t_12[val] = true
                end
            end
        end
    end

    if v11.KeyCodes then
        for _, val_2 in v11.KeyCodes do
            for _, val_3 in Keybinds_m.GetLinkedKeyCodes(val_2) do
                t_8[val_3] = true

                if val_3 ~= Enum.KeyCode.Space and val_3 ~= Enum.KeyCode.ButtonA then
                    t_9[val_3] = true
                end

                for _, val_4 in t_13 do
                    if Keybinds_m.Matches(val_4, { KeyCode = val_3 }) then
                        t_11[val_3] = true
                    end
                end
            end
        end
    end
end

refreshJumpKeyCodes()
Keybinds_m.OnChanged(refreshJumpKeyCodes)

local _ = function(arg1, arg2) --[[ isClaimedJumpInput ]] -- line: 87
    -- upvalues:
    --  [1] Controls_m (copy)
    --  [2] v10 (ref)
    --  [3] t_11 (ref)
    --  [4] t_12 (ref)

    local v12 = Controls_m.IsCurveInput({ KeyCode = arg1, UserInputType = arg2 })

    if not v12 then
        v12 = v10 and (t_11[arg1] == true or t_12[arg2] == true)
    end

    return v12
end

local function disconnectConnections() -- line: 93
    -- upvalues:
    --  [1] t_6 (ref)

    for index = 1, #t_6 do
        local _ = #t_6
        t_6[index]:Disconnect()
    end

    t_6 = {}
end

local function getStandardValue(arg3, arg4) -- line: 100
    -- upvalues:
    --  [1] t_1 (copy)

    local v14 = nil

    for _, val_5 in t_1 do
        if val_5[arg3] ~= nil then
            if v14 then
                v14 = math.min(v14, val_5[arg3])
            else
                v14 = val_5[arg3]
            end
        end
    end

    return v14 or arg4
end

local function applyMinimumValues(arg5, arg6, arg7) -- line: 112
    -- upvalues:
    --  [1] t_3 (copy)

    for key_6, val_6 in t_3 do
        if key_6 ~= arg7 and val_6[arg5] ~= nil then
            arg6 = math.min(arg6, val_6[arg5])
        end
    end

    return arg6
end

local _ = function(arg8, arg9) --[[ applyMultiplierValues ]] -- line: 126
    -- upvalues:
    --  [1] t_2 (copy)

    for _, val_7 in t_2 do
        if val_7[arg8] ~= nil then
            arg9 *= val_7[arg8]
        end
    end

    return arg9
end

local _ = function() --[[ hasJumpStateBlock ]] -- line: 136
    -- upvalues:
    --  [1] t_5 (copy)

    for _, val_8 in t_5 do
        if val_8 then
            return true
        end
    end

    return false
end

local _ = function(arg10, arg11) --[[ getMovementValue ]] -- line: 146
    -- upvalues:
    --  [1] v7 (ref)
    --  [2] t_5 (copy)
    --  [3] ActionMovement_m (copy)
    --  [4] applyMinimumValues (copy)
    --  [5] getStandardValue (copy)
    --  [6] t_2 (copy)

    if arg10 == "JumpHeight" and not v7 then
        local v15

        for _, val_9 in t_5 do
            if val_9 then
                v15 = true
            end
        end

        v15 = false

        if v15 then
            return 0
        end
    else
        local v16 = if arg10 ~= "WalkSpeed" then ActionMovement_m.GetBaseJumpHeight() else ActionMovement_m.GetBaseWalkSpeed()
        local v17 = applyMinimumValues
        local v19 = getStandardValue(arg10, v16)

        for _, val_10 in t_2 do
            if val_10[arg10] ~= nil then
                v19 *= val_10[arg10]
            end
        end

        return (v17(arg10, v19, arg11))
    end
end

local function applyMovement() -- line: 165
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] ActionMovement_m (copy)
    --  [3] applyMinimumValues (copy)
    --  [4] getStandardValue (copy)
    --  [5] t_2 (copy)
    --  [6] v7 (ref)
    --  [7] t_5 (copy)

    if not v1 then
        return
    end

    local v20 = applyMinimumValues
    local v22 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

    for _, val_11 in t_2 do
        if val_11.WalkSpeed ~= nil then
            v22 *= val_11.WalkSpeed
        end
    end

    local v23 = v20("WalkSpeed", v22, nil)
    local v25, v26, v28

    if not v7 then
        local v24

        for _, val_12 in t_5 do
            if val_12 then
                v24 = true
            end
        end

        v24 = false

        if v24 then
            v25 = 0
        else
            v26 = applyMinimumValues
            v28 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_13 in t_2 do
                if val_13.JumpHeight ~= nil then
                    v28 *= val_13.JumpHeight
                end
            end

            v25 = v26("JumpHeight", v28, nil)
        end
    else
        v26 = applyMinimumValues
        v28 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

        for _, val_14 in t_2 do
            if val_14.JumpHeight ~= nil then
                v28 *= val_14.JumpHeight
            end
        end

        v25 = v26("JumpHeight", v28, nil)
    end

    if v1.UseJumpPower then
        v1.UseJumpPower = false
    end

    if v1.WalkSpeed ~= v23 then
        v1.WalkSpeed = v23
    end

    if v1.JumpHeight ~= v25 then
        v1.JumpHeight = v25
    end
end

local _ = function() --[[ restoreJumpState ]] -- line: 185
    -- upvalues:
    --  [1] v2 (ref)
    --  [2] v3 (ref)
    --  [3] v4 (ref)
    --  [4] v1 (ref)
    --  [5] ActionMovement_m (copy)
    --  [6] applyMinimumValues (copy)
    --  [7] getStandardValue (copy)
    --  [8] t_2 (copy)
    --  [9] v7 (ref)
    --  [10] t_5 (copy)

    if not v2 then
        return
    end

    local v29 = v2
    local v30 = v3
    local v31 = v4
    v2 = nil
    v3 = nil
    v4 = nil

    if v29.Parent and v30 ~= nil then
        v29:SetStateEnabled(Enum.HumanoidStateType.Jumping, v30)

        if v31 ~= nil then
            v29.JumpPower = v31
        end
    end

    if not v1 then
        return
    end

    local v32 = applyMinimumValues
    local v34 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

    for _, val_15 in t_2 do
        if val_15.WalkSpeed ~= nil then
            v34 *= val_15.WalkSpeed
        end
    end

    local v35 = v32("WalkSpeed", v34, nil)
    local v37, v38, v40

    if not v7 then
        local v36

        for _, val_16 in t_5 do
            if val_16 then
                v36 = true
            end
        end

        v36 = false

        if v36 then
            v37 = 0
        else
            v38 = applyMinimumValues
            v40 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_17 in t_2 do
                if val_17.JumpHeight ~= nil then
                    v40 *= val_17.JumpHeight
                end
            end

            v37 = v38("JumpHeight", v40, nil)
        end
    else
        v38 = applyMinimumValues
        v40 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

        for _, val_18 in t_2 do
            if val_18.JumpHeight ~= nil then
                v40 *= val_18.JumpHeight
            end
        end

        v37 = v38("JumpHeight", v40, nil)
    end

    if v1.UseJumpPower then
        v1.UseJumpPower = false
    end

    if v1.WalkSpeed ~= v35 then
        v1.WalkSpeed = v35
    end

    if v1.JumpHeight ~= v37 then
        v1.JumpHeight = v37
    end
end

local _ = function() --[[ cancelNativeJump ]] -- line: 208
    -- upvalues:
    --  [1] v9 (ref)
    --  [2] v8 (ref)
    --  [3] v1 (ref)
    --  [4] LocalMovementGuard_m (copy)
    --  [5] CharacterControllers_m (copy)

    v9 = nil
    v8 = false

    if v1 then
        LocalMovementGuard_m.CancelPendingLaunch(v1.RootPart)
        CharacterControllers_m.SetJumpCommand(v1.Parent, false)
    end
end

local function applyJumpStateBlocks() -- line: 217
    -- upvalues:
    --  [1] v7 (ref)
    --  [2] t_5 (copy)
    --  [3] v9 (ref)
    --  [4] v8 (ref)
    --  [5] v1 (ref)
    --  [6] LocalMovementGuard_m (copy)
    --  [7] CharacterControllers_m (copy)
    --  [8] v2 (ref)
    --  [9] v3 (ref)
    --  [10] v4 (ref)
    --  [11] ActionMovement_m (copy)
    --  [12] applyMinimumValues (copy)
    --  [13] getStandardValue (copy)
    --  [14] t_2 (copy)

    local v41

    if v7 then
        for _, val_19 in t_5 do
            if val_19 then
                v41 = true
            end
        end

        v41 = false

        if v41 then
            v9 = nil
            v8 = false

            if v1 then
                LocalMovementGuard_m.CancelPendingLaunch(v1.RootPart)
                CharacterControllers_m.SetJumpCommand(v1.Parent, false)
            end
        end

        CharacterControllers_m.SetNativeJumpBlocked(v1.Parent, v41)

        return
    end

    for _, val_20 in t_5 do
        if val_20 then
            v41 = true
        end
    end

    v41 = false

    if not v41 then
        if not v2 then
            return
        end

        local v42 = v2
        local v43 = v3
        local v44 = v4
        v2 = nil
        v3 = nil
        v4 = nil

        if v42.Parent and v43 ~= nil then
            v42:SetStateEnabled(Enum.HumanoidStateType.Jumping, v43)

            if v44 ~= nil then
                v42.JumpPower = v44
            end
        end

        if not v1 then
            return
        end

        local v45 = applyMinimumValues
        local v47 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

        for _, val_21 in t_2 do
            if val_21.WalkSpeed ~= nil then
                v47 *= val_21.WalkSpeed
            end
        end

        local v48 = v45("WalkSpeed", v47, nil)
        local v50, v51, v53

        if not v7 then
            local v49

            for _, val_22 in t_5 do
                if val_22 then
                    v49 = true
                end
            end

            v49 = false

            if v49 then
                v50 = 0
            else
                v51 = applyMinimumValues
                v53 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_23 in t_2 do
                    if val_23.JumpHeight ~= nil then
                        v53 *= val_23.JumpHeight
                    end
                end

                v50 = v51("JumpHeight", v53, nil)
            end
        else
            v51 = applyMinimumValues
            v53 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_24 in t_2 do
                if val_24.JumpHeight ~= nil then
                    v53 *= val_24.JumpHeight
                end
            end

            v50 = v51("JumpHeight", v53, nil)
        end

        if v1.UseJumpPower then
            v1.UseJumpPower = false
        end

        if v1.WalkSpeed ~= v48 then
            v1.WalkSpeed = v48
        end

        if v1.JumpHeight ~= v50 then
            v1.JumpHeight = v50
        end

        return
    elseif not v1 then
        if not v2 then
            return
        end

        local v54 = v2
        local v55 = v3
        local v56 = v4
        v2 = nil
        v3 = nil
        v4 = nil

        if v54.Parent and v55 ~= nil then
            v54:SetStateEnabled(Enum.HumanoidStateType.Jumping, v55)

            if v56 ~= nil then
                v54.JumpPower = v56
            end
        end

        if not v1 then
            return
        end

        local v57 = applyMinimumValues
        local v59 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

        for _, val_25 in t_2 do
            if val_25.WalkSpeed ~= nil then
                v59 *= val_25.WalkSpeed
            end
        end

        local v60 = v57("WalkSpeed", v59, nil)
        local v62, v63, v65

        if not v7 then
            local v61

            for _, val_26 in t_5 do
                if val_26 then
                    v61 = true
                end
            end

            v61 = false

            if v61 then
                v62 = 0
            else
                v63 = applyMinimumValues
                v65 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_27 in t_2 do
                    if val_27.JumpHeight ~= nil then
                        v65 *= val_27.JumpHeight
                    end
                end

                v62 = v63("JumpHeight", v65, nil)
            end
        else
            v63 = applyMinimumValues
            v65 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_28 in t_2 do
                if val_28.JumpHeight ~= nil then
                    v65 *= val_28.JumpHeight
                end
            end

            v62 = v63("JumpHeight", v65, nil)
        end

        if v1.UseJumpPower then
            v1.UseJumpPower = false
        end

        if v1.WalkSpeed ~= v60 then
            v1.WalkSpeed = v60
        end

        if v1.JumpHeight ~= v62 then
            v1.JumpHeight = v62
        end

        return
    else
        if v2 and v2 ~= v1 and v2 then
            local v66 = v2
            local v67 = v3
            local v68 = v4
            v2 = nil
            v3 = nil
            v4 = nil

            if v66.Parent and v67 ~= nil then
                v66:SetStateEnabled(Enum.HumanoidStateType.Jumping, v67)

                if v68 ~= nil then
                    v66.JumpPower = v68
                end
            end

            if v1 then
                local v69 = applyMinimumValues
                local v71 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

                for _, val_29 in t_2 do
                    if val_29.WalkSpeed ~= nil then
                        v71 *= val_29.WalkSpeed
                    end
                end

                local v72 = v69("WalkSpeed", v71, nil)
                local v74, v75, v77

                if not v7 then
                    local v73

                    for _, val_30 in t_5 do
                        if val_30 then
                            v73 = true
                        end
                    end

                    v73 = false

                    if v73 then
                        v74 = 0
                    else
                        v75 = applyMinimumValues
                        v77 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                        for _, val_31 in t_2 do
                            if val_31.JumpHeight ~= nil then
                                v77 *= val_31.JumpHeight
                            end
                        end

                        v74 = v75("JumpHeight", v77, nil)
                    end
                else
                    v75 = applyMinimumValues
                    v77 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                    for _, val_32 in t_2 do
                        if val_32.JumpHeight ~= nil then
                            v77 *= val_32.JumpHeight
                        end
                    end

                    v74 = v75("JumpHeight", v77, nil)
                end

                if v1.UseJumpPower then
                    v1.UseJumpPower = false
                end

                if v1.WalkSpeed ~= v72 then
                    v1.WalkSpeed = v72
                end

                if v1.JumpHeight ~= v74 then
                    v1.JumpHeight = v74
                end
            end
        end

        if not v2 then
            v2 = v1
            v3 = v1:GetStateEnabled(Enum.HumanoidStateType.Jumping)
            v4 = v1.JumpPower
        end

        v1.Jump = false

        if v1.JumpHeight ~= 0 then
            v1.JumpHeight = 0
        end

        if v1.JumpPower ~= 0 then
            v1.JumpPower = 0
        end

        if v1:GetState() ~= Enum.HumanoidStateType.Jumping and v1:GetStateEnabled(
            Enum.HumanoidStateType.Jumping
        ) then
            v1:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        end

        return
    end
end

local _ = function(arg12, arg13) --[[ setJumpStateBlocked ]] -- line: 270
    -- upvalues:
    --  [1] t_5 (copy)
    --  [2] applyJumpStateBlocks (copy)

    local v78 = if arg13 then true else nil

    if t_5[arg12] == v78 then
        return
    end

    t_5[arg12] = v78
    applyJumpStateBlocks()
end

local function releaseHeldJumpBlock() -- line: 280
    -- upvalues:
    --  [1] v6 (ref)
    --  [2] t_5 (copy)
    --  [3] applyJumpStateBlocks (copy)

    if not v6 then
        return
    end

    v6 = false

    if t_5.HeldJump == nil then
        return
    end

    t_5.HeldJump = nil
    applyJumpStateBlocks()
end

Keybinds_m.OnChanged(releaseHeldJumpBlock)

local _ = function(arg14) --[[ blockHeldJumpUntilRelease ]] -- line: 291
    -- upvalues:
    --  [1] v6 (ref)
    --  [2] t_5 (copy)
    --  [3] applyJumpStateBlocks (copy)

    if v6 then
        return
    end

    v6 = true

    if arg14 then
        task.defer(function() -- line: 298
            -- upvalues:
            --  [1] v6 (ref)
            --  [2] t_5 (ref)
            --  [3] applyJumpStateBlocks (ref)

            if v6 then
                if t_5.HeldJump == true then
                    return
                end

                t_5.HeldJump = true
                applyJumpStateBlocks()
            end
        end)

        return
    end

    if t_5.HeldJump == true then
        return
    end

    t_5.HeldJump = true
    applyJumpStateBlocks()
end

local function isServerRagdollSuppressed(arg15) -- line: 308
    -- upvalues:
    --  [1] t_4 (copy)

    local v79 = workspace:GetServerTimeNow()

    for key_33, val_33 in t_4 do
        if v79 >= val_33.Until then
            t_4[key_33] = nil
        elseif not val_33.MaximumRagdolledUntil or arg15 <= val_33.MaximumRagdolledUntil then
            return true
        end
    end

    return false
end

local _ = function() --[[ getJumpLaunchSpeed ]] -- line: 321
    -- upvalues:
    --  [1] v7 (ref)
    --  [2] t_5 (copy)
    --  [3] ActionMovement_m (copy)
    --  [4] applyMinimumValues (copy)
    --  [5] getStandardValue (copy)
    --  [6] t_2 (copy)

    local v80 = 2 * workspace.Gravity
    local v82, v83, v85

    if not v7 then
        local v81

        for _, val_34 in t_5 do
            if val_34 then
                v81 = true
            end
        end

        v81 = false

        if v81 then
            v82 = 0
        else
            v83 = applyMinimumValues
            v85 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_35 in t_2 do
                if val_35.JumpHeight ~= nil then
                    v85 *= val_35.JumpHeight
                end
            end

            v82 = v83("JumpHeight", v85, nil)
        end
    else
        v83 = applyMinimumValues
        v85 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

        for _, val_36 in t_2 do
            if val_36.JumpHeight ~= nil then
                v85 *= val_36.JumpHeight
            end
        end

        v82 = v83("JumpHeight", v85, nil)
    end

    return (math.sqrt(v80 * v82))
end

local _ = function(arg16) --[[ registerJumpLaunch ]] -- line: 325
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] LocalMovementGuard_m (copy)
    --  [3] v7 (ref)
    --  [4] t_5 (copy)
    --  [5] ActionMovement_m (copy)
    --  [6] applyMinimumValues (copy)
    --  [7] getStandardValue (copy)
    --  [8] t_2 (copy)

    local RootPart = v1.RootPart

    if RootPart then
        if arg16 then
            LocalMovementGuard_m.RegisterPendingLaunch(RootPart, arg16)

            return
        end

        local RegisterLaunch = LocalMovementGuard_m.RegisterLaunch
        local v87 = 2 * workspace.Gravity
        local v89, v90, v92

        if not v7 then
            local v88

            for _, val_37 in t_5 do
                if val_37 then
                    v88 = true
                end
            end

            v88 = false

            if v88 then
                v89 = 0
            else
                v90 = applyMinimumValues
                v92 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_38 in t_2 do
                    if val_38.JumpHeight ~= nil then
                        v92 *= val_38.JumpHeight
                    end
                end

                v89 = v90("JumpHeight", v92, nil)
            end
        else
            v90 = applyMinimumValues
            v92 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_39 in t_2 do
                if val_39.JumpHeight ~= nil then
                    v92 *= val_39.JumpHeight
                end
            end

            v89 = v90("JumpHeight", v92, nil)
        end

        RegisterLaunch(RootPart, (math.sqrt(v87 * v89)))
    end
end

local function setHumanoid(arg17) -- line: 336
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] disconnectConnections (copy)
    --  [3] v7 (ref)
    --  [4] v9 (ref)
    --  [5] v8 (ref)
    --  [6] LocalMovementGuard_m (copy)
    --  [7] CharacterControllers_m (copy)
    --  [8] t_7 (ref)
    --  [9] v6 (ref)
    --  [10] t_5 (copy)
    --  [11] v2 (ref)
    --  [12] v3 (ref)
    --  [13] v4 (ref)
    --  [14] ActionMovement_m (copy)
    --  [15] applyMinimumValues (copy)
    --  [16] getStandardValue (copy)
    --  [17] t_2 (copy)
    --  [18] t_6 (ref)
    --  [19] applyMovement (copy)
    --  [20] applyJumpStateBlocks (copy)
    --  [21] v5 (ref)

    if v1 == arg17 then
        return
    end

    disconnectConnections()

    if v1 and v7 then
        v9 = nil
        v8 = false

        if v1 then
            LocalMovementGuard_m.CancelPendingLaunch(v1.RootPart)
            CharacterControllers_m.SetJumpCommand(v1.Parent, false)
        end

        CharacterControllers_m.SetNativeJumpBlocked(v1.Parent, false)
    end

    for key_40, val_40 in t_7 do
        key_40.Enabled = val_40
    end

    t_7 = {}
    v7 = false
    v8 = false
    v6 = false
    t_5.HeldJump = nil

    if v2 then
        local v93 = v2
        local v94 = v3
        local v95 = v4
        v2 = nil
        v3 = nil
        v4 = nil

        if v93.Parent and v94 ~= nil then
            v93:SetStateEnabled(Enum.HumanoidStateType.Jumping, v94)

            if v95 ~= nil then
                v93.JumpPower = v95
            end
        end

        if v1 then
            local v96 = applyMinimumValues
            local v98 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

            for _, val_41 in t_2 do
                if val_41.WalkSpeed ~= nil then
                    v98 *= val_41.WalkSpeed
                end
            end

            local v99 = v96("WalkSpeed", v98, nil)
            local v101, v102, v104

            if not v7 then
                local v100

                for _, val_42 in t_5 do
                    if val_42 then
                        v100 = true
                    end
                end

                v100 = false

                if v100 then
                    v101 = 0
                else
                    v102 = applyMinimumValues
                    v104 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                    for _, val_43 in t_2 do
                        if val_43.JumpHeight ~= nil then
                            v104 *= val_43.JumpHeight
                        end
                    end

                    v101 = v102("JumpHeight", v104, nil)
                end
            else
                v102 = applyMinimumValues
                v104 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_44 in t_2 do
                    if val_44.JumpHeight ~= nil then
                        v104 *= val_44.JumpHeight
                    end
                end

                v101 = v102("JumpHeight", v104, nil)
            end

            if v1.UseJumpPower then
                v1.UseJumpPower = false
            end

            if v1.WalkSpeed ~= v99 then
                v1.WalkSpeed = v99
            end

            if v1.JumpHeight ~= v101 then
                v1.JumpHeight = v101
            end
        end
    end

    v1 = arg17

    if not v1 then
        return
    end

    table.insert(t_6, v1:GetPropertyChangedSignal("WalkSpeed"):Connect(applyMovement))
    table.insert(t_6, v1:GetPropertyChangedSignal("JumpHeight"):Connect(applyMovement))
    table.insert(t_6, v1:GetPropertyChangedSignal("UseJumpPower"):Connect(applyMovement))
    table.insert(t_6, v1:GetPropertyChangedSignal("JumpPower"):Connect(applyJumpStateBlocks))
    table.insert(t_6, v1.StateChanged:Connect(function(_, arg19) -- line: 364
        -- upvalues:
        --  [1] v7 (ref)
        --  [2] v8 (ref)
        --  [3] v9 (ref)
        --  [4] v1 (ref)
        --  [5] LocalMovementGuard_m (ref)
        --  [6] CharacterControllers_m (ref)
        --  [7] v5 (ref)
        --  [8] v6 (ref)
        --  [9] t_5 (ref)
        --  [10] applyJumpStateBlocks (ref)
        --  [11] ActionMovement_m (ref)
        --  [12] applyMinimumValues (ref)
        --  [13] getStandardValue (ref)
        --  [14] t_2 (ref)

        if v7 and v8 and arg19 == Enum.HumanoidStateType.Freefall then
            v9 = nil
            v8 = false

            if v1 then
                LocalMovementGuard_m.CancelPendingLaunch(v1.RootPart)
                CharacterControllers_m.SetJumpCommand(v1.Parent, false)
            end
        end

        if arg19 ~= Enum.HumanoidStateType.Jumping then
            return
        end

        if v7 then
            v8 = false

            if v9 and not v9.ReadsImpulse then
                v9 = nil
            end

            CharacterControllers_m.SetJumpCommand(v1.Parent, false)

            return
        end

        if v5 and not v5() then
            v1.Jump = false

            if v6 then
                return
            end

            v6 = true

            if t_5.HeldJump == true then
                return
            end

            t_5.HeldJump = true
            applyJumpStateBlocks()

            return
        end

        local RootPart_1 = v1.RootPart

        if RootPart_1 then
            local RegisterLaunch_1 = LocalMovementGuard_m.RegisterLaunch
            local v110 = 2 * workspace.Gravity
            local v112, v113, v115

            if not v7 then
                local v111

                for _, val_45 in t_5 do
                    if val_45 then
                        v111 = true
                    end
                end

                v111 = false

                if v111 then
                    v112 = 0
                else
                    v113 = applyMinimumValues
                    v115 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                    for _, val_46 in t_2 do
                        if val_46.JumpHeight ~= nil then
                            v115 *= val_46.JumpHeight
                        end
                    end

                    v112 = v113("JumpHeight", v115, nil)
                end
            else
                v113 = applyMinimumValues
                v115 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_47 in t_2 do
                    if val_47.JumpHeight ~= nil then
                        v115 *= val_47.JumpHeight
                    end
                end

                v112 = v113("JumpHeight", v115, nil)
            end

            RegisterLaunch_1(RootPart_1, (math.sqrt(v110 * v112)))
        end

        if v6 then
            return
        end

        v6 = true
        task.defer(function() -- line: 298
            -- upvalues:
            --  [1] v6 (ref)
            --  [2] t_5 (ref)
            --  [3] applyJumpStateBlocks (ref)

            if v6 then
                if t_5.HeldJump == true then
                    return
                end

                t_5.HeldJump = true
                applyJumpStateBlocks()
            end
        end)
    end))

    if v1 then
        local v117 = applyMinimumValues
        local v119 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

        for _, val_48 in t_2 do
            if val_48.WalkSpeed ~= nil then
                v119 *= val_48.WalkSpeed
            end
        end

        local v120 = v117("WalkSpeed", v119, nil)
        local v122, v123, v125

        if not v7 then
            local v121

            for _, val_49 in t_5 do
                if val_49 then
                    v121 = true
                end
            end

            v121 = false

            if v121 then
                v122 = 0
            else
                v123 = applyMinimumValues
                v125 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_50 in t_2 do
                    if val_50.JumpHeight ~= nil then
                        v125 *= val_50.JumpHeight
                    end
                end

                v122 = v123("JumpHeight", v125, nil)
            end
        else
            v123 = applyMinimumValues
            v125 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_51 in t_2 do
                if val_51.JumpHeight ~= nil then
                    v125 *= val_51.JumpHeight
                end
            end

            v122 = v123("JumpHeight", v125, nil)
        end

        if v1.UseJumpPower then
            v1.UseJumpPower = false
        end

        if v1.WalkSpeed ~= v120 then
            v1.WalkSpeed = v120
        end

        if v1.JumpHeight ~= v122 then
            v1.JumpHeight = v122
        end
    end

    applyJumpStateBlocks()
end

local function bindCharacterHumanoid(arg20) -- line: 396
    -- upvalues:
    --  [1] LocalPlayer (copy)
    --  [2] setHumanoid (copy)
    --  [3] v1 (ref)
    --  [4] v7 (ref)
    --  [5] DefaultPlayerScripts_m (copy)
    --  [6] t_7 (ref)
    --  [7] v6 (ref)
    --  [8] t_5 (copy)
    --  [9] applyJumpStateBlocks (copy)
    --  [10] v2 (ref)
    --  [11] v3 (ref)
    --  [12] v4 (ref)
    --  [13] ActionMovement_m (copy)
    --  [14] applyMinimumValues (copy)
    --  [15] getStandardValue (copy)
    --  [16] t_2 (copy)
    --  [17] CharacterControllers_m (copy)
    --  [18] t_6 (ref)

    local Humanoid = arg20:WaitForChild("Humanoid")

    if LocalPlayer.Character == arg20 then
        setHumanoid(Humanoid)

        local function updateNativeJumpInput() -- line: 400
            -- upvalues:
            --  [1] LocalPlayer (ref)
            --  [2] arg20 (copy)
            --  [3] v1 (ref)
            --  [4] Humanoid (copy)
            --  [5] v7 (ref)
            --  [6] DefaultPlayerScripts_m (ref)
            --  [7] t_7 (ref)
            --  [8] v6 (ref)
            --  [9] t_5 (ref)
            --  [10] applyJumpStateBlocks (ref)
            --  [11] v2 (ref)
            --  [12] v3 (ref)
            --  [13] v4 (ref)
            --  [14] ActionMovement_m (ref)
            --  [15] applyMinimumValues (ref)
            --  [16] getStandardValue (ref)
            --  [17] t_2 (ref)
            --  [18] CharacterControllers_m (ref)

            if LocalPlayer.Character ~= arg20 or v1 ~= Humanoid or v7 then
                return
            end

            local v126 = DefaultPlayerScripts_m.GetNativeJumpInputActions(arg20)

            if v126 and LocalPlayer.Character == arg20 and v1 == Humanoid and not Humanoid.EvaluateStateMachine and not v7 then
                for _, val_52 in v126 do
                    t_7[val_52] = val_52.Enabled
                    val_52.Enabled = false
                end

                if v6 then
                    v6 = false

                    if t_5.HeldJump ~= nil then
                        t_5.HeldJump = nil
                        applyJumpStateBlocks()
                    end
                end

                local v135

                if v2 then
                    local v127 = v2
                    local v128 = v3
                    local v129 = v4
                    v2 = nil
                    v3 = nil
                    v4 = nil

                    if v127.Parent and v128 ~= nil then
                        v127:SetStateEnabled(Enum.HumanoidStateType.Jumping, v128)

                        if v129 ~= nil then
                            v127.JumpPower = v129
                        end
                    end

                    if v1 then
                        local v130 = applyMinimumValues
                        local v132 = getStandardValue(
                            "WalkSpeed",
                            (ActionMovement_m.GetBaseWalkSpeed())
                        )

                        for _, val_53 in t_2 do
                            if val_53.WalkSpeed ~= nil then
                                v132 *= val_53.WalkSpeed
                            end
                        end

                        local v133 = v130("WalkSpeed", v132, nil)
                        local v136, v138

                        if not v7 then
                            local v134

                            for _, val_54 in t_5 do
                                if val_54 then
                                    v134 = true
                                end
                            end

                            v134 = false

                            if v134 then
                                v135 = 0
                            else
                                v136 = applyMinimumValues
                                v138 = getStandardValue(
                                    "JumpHeight",
                                    (ActionMovement_m.GetBaseJumpHeight())
                                )

                                for _, val_55 in t_2 do
                                    if val_55.JumpHeight ~= nil then
                                        v138 *= val_55.JumpHeight
                                    end
                                end

                                v135 = v136("JumpHeight", v138, nil)
                            end
                        else
                            v136 = applyMinimumValues
                            v138 = getStandardValue(
                                "JumpHeight",
                                (ActionMovement_m.GetBaseJumpHeight())
                            )

                            for _, val_56 in t_2 do
                                if val_56.JumpHeight ~= nil then
                                    v138 *= val_56.JumpHeight
                                end
                            end

                            v135 = v136("JumpHeight", v138, nil)
                        end

                        if v1.UseJumpPower then
                            v1.UseJumpPower = false
                        end

                        if v1.WalkSpeed ~= v133 then
                            v1.WalkSpeed = v133
                        end

                        if v1.JumpHeight ~= v135 then
                            v1.JumpHeight = v135
                        end
                    end
                end

                v7 = true
                CharacterControllers_m.SetLocalControlStateResolver(
                    DefaultPlayerScripts_m.GetControlStateResolver()
                )
                CharacterControllers_m.SetJumpCommand(arg20, false)

                if not v1 then
                    return
                end

                local v139 = applyMinimumValues
                v135 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

                for _, val_57 in t_2 do
                    if val_57.WalkSpeed ~= nil then
                        v135 *= val_57.WalkSpeed
                    end
                end

                local v141 = v139("WalkSpeed", v135, nil)
                local v143, v144, v146

                if not v7 then
                    local v142

                    for _, val_58 in t_5 do
                        if val_58 then
                            v142 = true
                        end
                    end

                    v142 = false

                    if v142 then
                        v143 = 0
                    else
                        v144 = applyMinimumValues
                        v146 = getStandardValue(
                            "JumpHeight",
                            (ActionMovement_m.GetBaseJumpHeight())
                        )

                        for _, val_59 in t_2 do
                            if val_59.JumpHeight ~= nil then
                                v146 *= val_59.JumpHeight
                            end
                        end

                        v143 = v144("JumpHeight", v146, nil)
                    end
                else
                    v144 = applyMinimumValues
                    v146 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                    for _, val_60 in t_2 do
                        if val_60.JumpHeight ~= nil then
                            v146 *= val_60.JumpHeight
                        end
                    end

                    v143 = v144("JumpHeight", v146, nil)
                end

                if v1.UseJumpPower then
                    v1.UseJumpPower = false
                end

                if v1.WalkSpeed ~= v141 then
                    v1.WalkSpeed = v141
                end

                if v1.JumpHeight ~= v143 then
                    v1.JumpHeight = v143
                end
            end
        end

        table.insert(
            t_6,
            Humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(updateNativeJumpInput)
        )
        updateNativeJumpInput()
    end
end

local t_17 = { WalkSpeed = 0, JumpHeight = 0 }
local v148 = false

local function setServerRagdollOverride() -- line: 437
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] LocalPlayer (copy)
    --  [3] isServerRagdollSuppressed (copy)
    --  [4] v148 (ref)
    --  [5] t (copy)
    --  [6] t_17 (copy)
    --  [7] t_5 (copy)
    --  [8] applyJumpStateBlocks (copy)

    local v149 = Ragdoll_m.GetRagdolledUntil(LocalPlayer)
    local v150 = if v149 ~= nil then if v149 > workspace:GetServerTimeNow() then not isServerRagdollSuppressed(
        v149
    ) else false else false

    if v150 == v148 then
        return
    end

    v148 = v150

    if v150 then
        t.SetMinimum("ServerRagdoll", t_17)

        if t_5.ServerRagdoll == true then
            return
        end

        t_5.ServerRagdoll = true
        applyJumpStateBlocks()

        return
    else
        t.ClearMinimum("ServerRagdoll")

        if t_5.ServerRagdoll == nil then
            return
        end

        t_5.ServerRagdoll = nil
        applyJumpStateBlocks()

        return
    end
end

local v151 = false

function t.Start() -- line: 456
    -- upvalues:
    --  [1] v151 (ref)
    --  [2] CharacterControllers_m (copy)
    --  [3] applyMovement (copy)
    --  [4] LocalPlayer (copy)
    --  [5] bindCharacterHumanoid (copy)
    --  [6] setHumanoid (copy)
    --  [7] LocalActionCleanup_m (copy)
    --  [8] v7 (ref)
    --  [9] v9 (ref)
    --  [10] v8 (ref)
    --  [11] v1 (ref)
    --  [12] LocalMovementGuard_m (copy)
    --  [13] t_5 (copy)
    --  [14] UserInputService (copy)
    --  [15] v6 (ref)
    --  [16] applyJumpStateBlocks (copy)
    --  [17] t_8 (ref)
    --  [18] Controls_m (copy)
    --  [19] v10 (ref)
    --  [20] t_11 (ref)
    --  [21] t_12 (ref)
    --  [22] Keybinds_m (copy)
    --  [23] t_10 (ref)
    --  [24] t_9 (ref)
    --  [25] t (copy)
    --  [26] setServerRagdollOverride (copy)
    --  [27] RunService (copy)
    --  [28] ActionMovement_m (copy)
    --  [29] applyMinimumValues (copy)
    --  [30] getStandardValue (copy)
    --  [31] t_2 (copy)

    if v151 then
        return
    end

    v151 = true
    CharacterControllers_m.SetLocalMovementReconciler(applyMovement)
    LocalPlayer.CharacterAdded:Connect(function(character) -- line: 463
        -- upvalues:
        --  [1] bindCharacterHumanoid (ref)

        task.spawn(bindCharacterHumanoid, character)
    end)
    LocalPlayer.CharacterRemoving:Connect(function() -- line: 466
        -- upvalues:
        --  [1] setHumanoid (ref)

        setHumanoid(nil)
    end)
    LocalActionCleanup_m.Requested.Event:Connect(function() -- line: 469
        -- upvalues:
        --  [1] v7 (ref)
        --  [2] v9 (ref)
        --  [3] v8 (ref)
        --  [4] v1 (ref)
        --  [5] LocalMovementGuard_m (ref)
        --  [6] CharacterControllers_m (ref)
        --  [7] t_5 (ref)

        if v7 then
            v9 = nil
            v8 = false

            if v1 then
                LocalMovementGuard_m.CancelPendingLaunch(v1.RootPart)
                CharacterControllers_m.SetJumpCommand(v1.Parent, false)
            end

            CharacterControllers_m.SetNativeJumpBlocked(v1.Parent, true)
            local SetNativeJumpBlocked = CharacterControllers_m.SetNativeJumpBlocked
            local Parent = v1.Parent
            local v152

            for _, val_61 in t_5 do
                if val_61 then
                    v152 = true
                end
            end

            v152 = false
            SetNativeJumpBlocked(Parent, v152)

            return
        end

        if v1 then
            v1.Jump = false
        end
    end)
    UserInputService.JumpRequest:Connect(function() -- line: 480
        -- upvalues:
        --  [1] v7 (ref)
        --  [2] v1 (ref)
        --  [3] t_5 (ref)
        --  [4] v6 (ref)
        --  [5] applyJumpStateBlocks (ref)
        --  [6] t_8 (ref)
        --  [7] Controls_m (ref)
        --  [8] v10 (ref)
        --  [9] t_11 (ref)
        --  [10] t_12 (ref)
        --  [11] UserInputService (ref)
        --  [12] Keybinds_m (ref)
        --  [13] t_10 (ref)

        if v7 then
            return
        end

        if v1 then
            local v153

            for _, val_62 in t_5 do
                if val_62 then
                    v153 = true
                end
            end

            v153 = false

            if v153 then
                v1.Jump = false

                if not v6 then
                    v6 = true

                    if t_5.HeldJump ~= true then
                        t_5.HeldJump = true
                        applyJumpStateBlocks()
                    end
                end

                applyJumpStateBlocks()

                return
            end
        end

        if v1 then
            local _ = function(arg22) --[[ isRefusedEngineKeyCode ]] -- line: 495
                -- upvalues:
                --  [1] t_8 (ref)
                --  [2] Controls_m (ref)
                --  [3] v10 (ref)
                --  [4] t_11 (ref)
                --  [5] t_12 (ref)

                local v154 = not t_8[arg22]

                if not v154 then
                    v154 = Controls_m.IsCurveInput({ KeyCode = arg22, UserInputType = nil })

                    if not v154 then
                        v154 = v10 and (t_11[arg22] == true or t_12[nil] == true)
                    end
                end

                return v154
            end

            local KeyCode_Space = Enum.KeyCode.Space
            local v156 = not t_8[KeyCode_Space] or (Controls_m.IsCurveInput(
                { KeyCode = KeyCode_Space, UserInputType = nil }
            ) or v10 and (t_11[KeyCode_Space] == true or t_12[nil] == true))
            local KeyCode_ButtonA
            local v157

            if v156 then
                v157 = UserInputService:IsKeyDown(Enum.KeyCode.Space)

                if not v157 then
                    KeyCode_ButtonA = Enum.KeyCode.ButtonA
                    v157 = not t_8[KeyCode_ButtonA] or (Controls_m.IsCurveInput(
                        { KeyCode = KeyCode_ButtonA, UserInputType = nil }
                    ) or v10 and (if t_11[KeyCode_ButtonA] ~= true then if t_12[nil] ~= true then false else true else true))

                    if v157 then
                        v157 = UserInputService:IsGamepadButtonDown(
                            Enum.UserInputType.Gamepad1,
                            Enum.KeyCode.ButtonA
                        )
                    end
                end
            else
                KeyCode_ButtonA = Enum.KeyCode.ButtonA
                v157 = not t_8[KeyCode_ButtonA] or (Controls_m.IsCurveInput(
                    { KeyCode = KeyCode_ButtonA, UserInputType = nil }
                ) or v10 and (if t_11[KeyCode_ButtonA] ~= true then if t_12[nil] ~= true then false else true else true))

                if v157 then
                    v157 = UserInputService:IsGamepadButtonDown(
                        Enum.UserInputType.Gamepad1,
                        Enum.KeyCode.ButtonA
                    )
                end
            end

            if not v157 then
                return
            end

            local v158

            for key_63 in t_8 do
                v158 = Controls_m.IsCurveInput({ KeyCode = key_63, UserInputType = nil })

                if not v158 then
                    v158 = v10 and (t_11[key_63] == true or t_12[nil] == true)
                end

                if not v158 then
                    if if Keybinds_m.IsGamepadKeyCode(key_63) then UserInputService:IsGamepadButtonDown(
                        Enum.UserInputType.Gamepad1,
                        key_63
                    ) else UserInputService:IsKeyDown(key_63) then
                        return
                    end
                end
            end

            for key_64 in t_10 do
                v158 = Controls_m.IsCurveInput({ KeyCode = nil, UserInputType = key_64 })

                if not v158 then
                    v158 = v10 and (t_11[nil] == true or t_12[key_64] == true)
                end

                if not v158 and UserInputService:IsMouseButtonPressed(key_64) then
                    return
                end
            end

            v1.Jump = false
        end
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) -- line: 525
        -- upvalues:
        --  [1] Controls_m (ref)
        --  [2] v10 (ref)
        --  [3] t_11 (ref)
        --  [4] t_12 (ref)
        --  [5] v7 (ref)
        --  [6] t_8 (ref)
        --  [7] t_9 (ref)
        --  [8] t_10 (ref)
        --  [9] t (ref)

        if not gameProcessedEvent then
            local KeyCode = input.KeyCode
            local UserInputType = input.UserInputType

            if Controls_m.IsCurveInput({ KeyCode = KeyCode, UserInputType = UserInputType }) or v10 and (t_11[KeyCode] == true or t_12[UserInputType] == true) then
                return
            end

            if if not v7 then t_9[input.KeyCode] or t_10[input.UserInputType] else t_8[input.KeyCode] or (t_9[input.KeyCode] or t_10[input.UserInputType]) then
                t.Jump()
            end

            return
        else
            return
        end
    end)
    UserInputService.InputEnded:Connect(function(input_1) -- line: 538
        -- upvalues:
        --  [1] t_8 (ref)
        --  [2] t_10 (ref)
        --  [3] v6 (ref)
        --  [4] t_5 (ref)
        --  [5] applyJumpStateBlocks (ref)

        if t_8[input_1.KeyCode] or input_1.UserInputType == Enum.UserInputType.Touch or t_10[input_1.UserInputType] then
            if not v6 then
                return
            end

            v6 = false

            if t_5.HeldJump == nil then
                return
            end

            t_5.HeldJump = nil
            applyJumpStateBlocks()
        end
    end)

    if LocalPlayer.Character then
        task.spawn(bindCharacterHumanoid, LocalPlayer.Character)
    end

    setServerRagdollOverride()
    RunService.Heartbeat:Connect(function() -- line: 555
        -- upvalues:
        --  [1] setServerRagdollOverride (ref)
        --  [2] v1 (ref)
        --  [3] ActionMovement_m (ref)
        --  [4] applyMinimumValues (ref)
        --  [5] getStandardValue (ref)
        --  [6] t_2 (ref)
        --  [7] v7 (ref)
        --  [8] t_5 (ref)
        --  [9] applyJumpStateBlocks (ref)
        --  [10] v9 (ref)
        --  [11] v8 (ref)
        --  [12] CharacterControllers_m (ref)
        --  [13] LocalMovementGuard_m (ref)

        setServerRagdollOverride()

        if v1 then
            local v160 = applyMinimumValues
            local v162 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

            for _, val_63 in t_2 do
                if val_63.WalkSpeed ~= nil then
                    v162 *= val_63.WalkSpeed
                end
            end

            local v163 = v160("WalkSpeed", v162, nil)
            local v165, v166, v168

            if not v7 then
                local v164

                for _, val_64 in t_5 do
                    if val_64 then
                        v164 = true
                    end
                end

                v164 = false

                if v164 then
                    v165 = 0
                else
                    v166 = applyMinimumValues
                    v168 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                    for _, val_65 in t_2 do
                        if val_65.JumpHeight ~= nil then
                            v168 *= val_65.JumpHeight
                        end
                    end

                    v165 = v166("JumpHeight", v168, nil)
                end
            else
                v166 = applyMinimumValues
                v168 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_66 in t_2 do
                    if val_66.JumpHeight ~= nil then
                        v168 *= val_66.JumpHeight
                    end
                end

                v165 = v166("JumpHeight", v168, nil)
            end

            if v1.UseJumpPower then
                v1.UseJumpPower = false
            end

            if v1.WalkSpeed ~= v163 then
                v1.WalkSpeed = v163
            end

            if v1.JumpHeight ~= v165 then
                v1.JumpHeight = v165
            end
        end

        applyJumpStateBlocks()

        if v9 and v9.ReadLaunchSpeed then
            v9.ReadLaunchSpeed()

            return
        end

        if v8 and not CharacterControllers_m.CanQueueJump(v1.Parent, v1) then
            v9 = nil
            v8 = false

            if v1 then
                LocalMovementGuard_m.CancelPendingLaunch(v1.RootPart)
                CharacterControllers_m.SetJumpCommand(v1.Parent, false)
            end
        end
    end)
end

function t.GetBaseWalkSpeed() -- line: 569
    -- upvalues:
    --  [1] ActionMovement_m (copy)

    return ActionMovement_m.GetBaseWalkSpeed()
end

function t.GetWalkSpeedWithoutMinimum(arg26) -- line: 573
    -- upvalues:
    --  [1] ActionMovement_m (copy)
    --  [2] applyMinimumValues (copy)
    --  [3] getStandardValue (copy)
    --  [4] t_2 (copy)

    local v169 = applyMinimumValues
    local v171 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

    for _, val_67 in t_2 do
        if val_67.WalkSpeed ~= nil then
            v171 *= val_67.WalkSpeed
        end
    end

    return (v169("WalkSpeed", v171, arg26))
end

function t.GetZeroWalkSpeedSources() -- line: 579
    -- upvalues:
    --  [1] t_3 (copy)
    --  [2] t_1 (copy)
    --  [3] t_2 (copy)

    local t_24 = {}

    for key_70, val_68 in t_3 do
        if val_68.WalkSpeed == 0 then
            table.insert(t_24, key_70)
        end
    end

    for key_71, val_69 in t_1 do
        if val_69.WalkSpeed == 0 then
            table.insert(t_24, "standard:" .. key_71)
        end
    end

    for key_72, val_70 in t_2 do
        if val_70.WalkSpeed == 0 then
            table.insert(t_24, "multiplier:" .. key_72)
        end
    end

    return t_24
end

local function setValueGroup(arg27, arg28, arg29) -- line: 602
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] ActionMovement_m (copy)
    --  [3] applyMinimumValues (copy)
    --  [4] getStandardValue (copy)
    --  [5] t_2 (copy)
    --  [6] v7 (ref)
    --  [7] t_5 (copy)

    local v172 = arg27[arg28]

    if arg29 then
        if v172 and (v172.WalkSpeed == arg29.WalkSpeed and v172.JumpHeight == arg29.JumpHeight) then
            return
        end

        arg27[arg28] = { WalkSpeed = arg29.WalkSpeed, JumpHeight = arg29.JumpHeight }
    elseif v172 then
        arg27[arg28] = nil
    else
        return
    end

    if not v1 then
        return
    end

    local v173 = applyMinimumValues
    local v175 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

    for _, val_71 in t_2 do
        if val_71.WalkSpeed ~= nil then
            v175 *= val_71.WalkSpeed
        end
    end

    local v176 = v173("WalkSpeed", v175, nil)
    local v178, v179, v181

    if not v7 then
        local v177

        for _, val_72 in t_5 do
            if val_72 then
                v177 = true
            end
        end

        v177 = false

        if v177 then
            v178 = 0
        else
            v179 = applyMinimumValues
            v181 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_73 in t_2 do
                if val_73.JumpHeight ~= nil then
                    v181 *= val_73.JumpHeight
                end
            end

            v178 = v179("JumpHeight", v181, nil)
        end
    else
        v179 = applyMinimumValues
        v181 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

        for _, val_74 in t_2 do
            if val_74.JumpHeight ~= nil then
                v181 *= val_74.JumpHeight
            end
        end

        v178 = v179("JumpHeight", v181, nil)
    end

    if v1.UseJumpPower then
        v1.UseJumpPower = false
    end

    if v1.WalkSpeed ~= v176 then
        v1.WalkSpeed = v176
    end

    if v1.JumpHeight ~= v178 then
        v1.JumpHeight = v178
    end
end

function t.SetStandard(arg30, arg31) -- line: 620
    -- upvalues:
    --  [1] setValueGroup (copy)
    --  [2] t_1 (copy)

    setValueGroup(t_1, arg30, arg31)
end

function t.SetMultiplier(arg32, arg33) -- line: 624
    -- upvalues:
    --  [1] setValueGroup (copy)
    --  [2] t_2 (copy)

    setValueGroup(t_2, arg32, arg33)
end

function t.ClearMultiplier(arg34) -- line: 628
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] v1 (ref)
    --  [3] ActionMovement_m (copy)
    --  [4] applyMinimumValues (copy)
    --  [5] getStandardValue (copy)
    --  [6] v7 (ref)
    --  [7] t_5 (copy)

    local v182 = t_2

    if v182[arg34] then
        v182[arg34] = nil

        return
    end
end

function t.SetMinimum(arg35, arg36) -- line: 632
    -- upvalues:
    --  [1] setValueGroup (copy)
    --  [2] t_3 (copy)

    setValueGroup(t_3, arg35, arg36)
end

function t.ClearMinimum(arg37) -- line: 636
    -- upvalues:
    --  [1] t_3 (copy)
    --  [2] v1 (ref)
    --  [3] ActionMovement_m (copy)
    --  [4] applyMinimumValues (copy)
    --  [5] getStandardValue (copy)
    --  [6] t_2 (copy)
    --  [7] v7 (ref)
    --  [8] t_5 (copy)

    local v192 = t_3

    if v192[arg37] then
        v192[arg37] = nil

        return
    end
end

function t.SetJumpStateBlocked(arg38, arg39) -- line: 640
    -- upvalues:
    --  [1] t_5 (copy)
    --  [2] applyJumpStateBlocks (copy)

    local v202 = if arg39 then true else nil

    if t_5[arg38] == v202 then
        return
    end

    t_5[arg38] = v202
    applyJumpStateBlocks()
end

function t.LockMovement(arg40) -- line: 647
    -- upvalues:
    --  [1] setValueGroup (copy)
    --  [2] t_2 (copy)
    --  [3] t_17 (copy)
    --  [4] t_5 (copy)
    --  [5] applyJumpStateBlocks (copy)

    setValueGroup(t_2, arg40, t_17)

    if t_5[arg40] == true then
        return
    end

    t_5[arg40] = true
    applyJumpStateBlocks()
end

function t.UnlockMovement(arg41) -- line: 652
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] v1 (ref)
    --  [3] ActionMovement_m (copy)
    --  [4] applyMinimumValues (copy)
    --  [5] getStandardValue (copy)
    --  [6] v7 (ref)
    --  [7] t_5 (copy)
    --  [8] applyJumpStateBlocks (copy)

    local v203 = t_2

    if v203[arg41] then
        v203[arg41] = nil

        if v1 then
            local v204 = applyMinimumValues
            local v206 = getStandardValue("WalkSpeed", (ActionMovement_m.GetBaseWalkSpeed()))

            for _, val_83 in t_2 do
                if val_83.WalkSpeed ~= nil then
                    v206 *= val_83.WalkSpeed
                end
            end

            local v207 = v204("WalkSpeed", v206, nil)
            local v209, v210, v212

            if not v7 then
                local v208

                for _, val_84 in t_5 do
                    if val_84 then
                        v208 = true
                    end
                end

                v208 = false

                if v208 then
                    v209 = 0
                else
                    v210 = applyMinimumValues
                    v212 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                    for _, val_85 in t_2 do
                        if val_85.JumpHeight ~= nil then
                            v212 *= val_85.JumpHeight
                        end
                    end

                    v209 = v210("JumpHeight", v212, nil)
                end
            else
                v210 = applyMinimumValues
                v212 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_86 in t_2 do
                    if val_86.JumpHeight ~= nil then
                        v212 *= val_86.JumpHeight
                    end
                end

                v209 = v210("JumpHeight", v212, nil)
            end

            if v1.UseJumpPower then
                v1.UseJumpPower = false
            end

            if v1.WalkSpeed ~= v207 then
                v1.WalkSpeed = v207
            end

            if v1.JumpHeight ~= v209 then
                v1.JumpHeight = v209
            end
        end
    end

    if t_5[arg41] == nil then
        return
    end

    t_5[arg41] = nil
    applyJumpStateBlocks()
end

function t.SetJumpStartedHandler(arg42) -- line: 657
    -- upvalues:
    --  [1] v5 (ref)

    v5 = arg42
end

function t.Jump() -- line: 661
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] t_5 (copy)
    --  [3] v7 (ref)
    --  [4] v6 (ref)
    --  [5] v8 (ref)
    --  [6] CharacterControllers_m (copy)
    --  [7] ActionMovement_m (copy)
    --  [8] applyMinimumValues (copy)
    --  [9] getStandardValue (copy)
    --  [10] t_2 (copy)
    --  [11] v5 (ref)
    --  [12] v9 (ref)
    --  [13] LocalMovementGuard_m (copy)

    if not v1 then
        return false
    end

    local v213

    for _, val_87 in t_5 do
        if val_87 then
            v213 = true
        end
    end

    v213 = false

    if v213 then
        return false
    end

    if v7 then
        if v6 then
            return false
        end

        if v8 then
            return false
        end

        if not CharacterControllers_m.CanQueueJump(v1.Parent, v1) then
            return false
        end

        local v215, v216, v218

        if not v7 then
            local v214

            for _, val_88 in t_5 do
                if val_88 then
                    v214 = true
                end
            end

            v214 = false

            if v214 then
                v215 = 0
            else
                v216 = applyMinimumValues
                v218 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                for _, val_89 in t_2 do
                    if val_89.JumpHeight ~= nil then
                        v218 *= val_89.JumpHeight
                    end
                end

                v215 = v216("JumpHeight", v218, nil)
            end
        else
            v216 = applyMinimumValues
            v218 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

            for _, val_90 in t_2 do
                if val_90.JumpHeight ~= nil then
                    v218 *= val_90.JumpHeight
                end
            end

            v215 = v216("JumpHeight", v218, nil)
        end

        if v215 <= 0 then
            return false
        end

        v6 = true

        if v5 and not v5() then
            return false
        end

        v8 = true
        local Parent_1 = v1.Parent
        local v219 = CharacterControllers_m.CreateNativeJumpImpulseReader(Parent_1)
        local t_26 = { ReadsImpulse = if v219 == nil then false else true, Result = false }
        v9 = t_26

        if v219 then
            function t_26.ReadLaunchSpeed() -- line: 691
                -- upvalues:
                --  [1] t_26 (copy)
                --  [2] v9 (ref)
                --  [3] v219 (copy)
                --  [4] v7 (ref)
                --  [5] t_5 (ref)
                --  [6] ActionMovement_m (ref)
                --  [7] applyMinimumValues (ref)
                --  [8] getStandardValue (ref)
                --  [9] t_2 (ref)
                --  [10] v8 (ref)
                --  [11] CharacterControllers_m (ref)
                --  [12] Parent_1 (copy)

                if t_26.Result ~= false then
                    return t_26.Result
                end

                if v9 ~= t_26 then
                    t_26.Result = nil

                    return nil
                end

                local v220 = v219()

                if v220 == false then
                    return false
                end

                if v220 then
                    local v221 = t_26
                    local v222 = 2 * workspace.Gravity
                    local v224, v225, v227

                    if not v7 then
                        local v223

                        for _, val_91 in t_5 do
                            if val_91 then
                                v223 = true
                            end
                        end

                        v223 = false

                        if v223 then
                            v224 = 0
                        else
                            v225 = applyMinimumValues
                            v227 = getStandardValue(
                                "JumpHeight",
                                (ActionMovement_m.GetBaseJumpHeight())
                            )

                            for _, val_92 in t_2 do
                                if val_92.JumpHeight ~= nil then
                                    v227 *= val_92.JumpHeight
                                end
                            end

                            v224 = v225("JumpHeight", v227, nil)
                        end
                    else
                        v225 = applyMinimumValues
                        v227 = getStandardValue(
                            "JumpHeight",
                            (ActionMovement_m.GetBaseJumpHeight())
                        )

                        for _, val_93 in t_2 do
                            if val_93.JumpHeight ~= nil then
                                v227 *= val_93.JumpHeight
                            end
                        end

                        v224 = v225("JumpHeight", v227, nil)
                    end

                    v221.Result = math.sqrt(v222 * v224)
                else
                    t_26.Result = nil
                end

                v9 = nil
                v8 = false
                CharacterControllers_m.SetJumpCommand(Parent_1, false)

                return t_26.Result
            end

            local ReadLaunchSpeed = t_26.ReadLaunchSpeed
            v218 = v1.RootPart

            if v218 then
                if ReadLaunchSpeed then
                    LocalMovementGuard_m.RegisterPendingLaunch(v218, ReadLaunchSpeed)
                else
                    local RegisterLaunch_2 = LocalMovementGuard_m.RegisterLaunch
                    local v229 = 2 * workspace.Gravity
                    local v231, v232, v234

                    if not v7 then
                        local v230

                        for _, val_94 in t_5 do
                            if val_94 then
                                v230 = true
                            end
                        end

                        v230 = false

                        if v230 then
                            v231 = 0
                        else
                            v232 = applyMinimumValues
                            v234 = getStandardValue(
                                "JumpHeight",
                                (ActionMovement_m.GetBaseJumpHeight())
                            )

                            for _, val_95 in t_2 do
                                if val_95.JumpHeight ~= nil then
                                    v234 *= val_95.JumpHeight
                                end
                            end

                            v231 = v232("JumpHeight", v234, nil)
                        end
                    else
                        v232 = applyMinimumValues
                        v234 = getStandardValue(
                            "JumpHeight",
                            (ActionMovement_m.GetBaseJumpHeight())
                        )

                        for _, val_96 in t_2 do
                            if val_96.JumpHeight ~= nil then
                                v234 *= val_96.JumpHeight
                            end
                        end

                        v231 = v232("JumpHeight", v234, nil)
                    end

                    RegisterLaunch_2(v218, (math.sqrt(v229 * v231)))
                end
            end
        else
            local RootPart_2 = v1.RootPart

            if RootPart_2 then
                local RegisterLaunch_3 = LocalMovementGuard_m.RegisterLaunch
                local v236 = 2 * workspace.Gravity
                local v238, v239, v241

                if not v7 then
                    local v237

                    for _, val_97 in t_5 do
                        if val_97 then
                            v237 = true
                        end
                    end

                    v237 = false

                    if v237 then
                        v238 = 0
                    else
                        v239 = applyMinimumValues
                        v241 = getStandardValue(
                            "JumpHeight",
                            (ActionMovement_m.GetBaseJumpHeight())
                        )

                        for _, val_98 in t_2 do
                            if val_98.JumpHeight ~= nil then
                                v241 *= val_98.JumpHeight
                            end
                        end

                        v238 = v239("JumpHeight", v241, nil)
                    end
                else
                    v239 = applyMinimumValues
                    v241 = getStandardValue("JumpHeight", (ActionMovement_m.GetBaseJumpHeight()))

                    for _, val_99 in t_2 do
                        if val_99.JumpHeight ~= nil then
                            v241 *= val_99.JumpHeight
                        end
                    end

                    v238 = v239("JumpHeight", v241, nil)
                end

                RegisterLaunch_3(RootPart_2, (math.sqrt(v236 * v238)))
            end
        end

        CharacterControllers_m.SetJumpCommand(v1.Parent, true)

        return true
    else
        v1.Jump = true

        return true
    end
end

function t.ReleaseJump() -- line: 722
    -- upvalues:
    --  [1] v6 (ref)
    --  [2] t_5 (copy)
    --  [3] applyJumpStateBlocks (copy)

    if not v6 then
        return
    end

    v6 = false

    if t_5.HeldJump == nil then
        return
    end

    t_5.HeldJump = nil
    applyJumpStateBlocks()
end

function t.SetBallActionSharedKeyClaim(arg43) -- line: 729
    -- upvalues:
    --  [1] v10 (ref)

    v10 = arg43 == true
end

function t.SuppressServerRagdoll(arg44, arg45, arg46) -- line: 733
    -- upvalues:
    --  [1] t_4 (copy)
    --  [2] setServerRagdollOverride (copy)

    t_4[arg44] = { Until = workspace:GetServerTimeNow() + arg45, MaximumRagdolledUntil = arg46 }
    setServerRagdollOverride()
    task.delay(arg45, function() -- line: 740
        -- upvalues:
        --  [1] t_4 (ref)
        --  [2] arg44 (copy)
        --  [3] setServerRagdollOverride (ref)

        if t_4[arg44] then
            if workspace:GetServerTimeNow() >= t_4[arg44].Until then
                t_4[arg44] = nil
                setServerRagdollOverride()
            end
        end
    end)
end

function t.ClearServerRagdollSuppression(arg47) -- line: 753
    -- upvalues:
    --  [1] t_4 (copy)
    --  [2] setServerRagdollOverride (copy)

    if not t_4[arg47] then
        return
    end

    t_4[arg47] = nil
    setServerRagdollOverride()
end

return t
