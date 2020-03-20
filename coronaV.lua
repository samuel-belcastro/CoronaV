local frame = CreateFrame("FRAME", "CoronaVFrame");

local me = UnitName("player");

-- Fired when saved variables are loaded
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("CHAT_MSG_ADDON");
frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE");

local infected = true;

local function eventHandler(self, event, ...)
    -- Check if the saved variables are set and set them if not
    if event == "ADDON_LOADED" then
        addonName = ...

        if (addonName == "CoronaV") then
            -- Our saved variables are ready at this point. If there are none, both variables will set to nil.
            if HasCorona == nil then
                infectionChance = math.random(0,100);
            
                -- 20% chance of getting covid when starting
                if (infectionChance > 80) then
                    SendChatMessage("I HAVE BEEN INFECTED BY THE CORONA!" , "YELL", nil);
                    HasCorona = true
                else
                    HasCorona = false;
                end
            end
        end
    end

    -- CHECK IF CORONA COUGH EVENT
    if event == "CHAT_MSG_ADDON" then
        prefix, message, distributionType = ...

        if (prefix == "coronaV" and message == "INFECTED" and distributionType == "SAY") then
            infectionChance = math.random(0,100);
            
            -- 50% chance of shoawing symptoms
            if (infectionChance > 50) then
                SendChatMessage("starts to feel a tightening in their chest." , "EMOTE");
            end

            -- 80% chance of getting covid
            if (infectionChance > 20) then
                -- Covid lasts 900 seconds (or 15 mina)
                alarm(3600, function() HasCorona = false; end);

                HasCorona = true
            end
        end
    end

    -- CHECK IF COUGHING
    if event == "CHAT_MSG_TEXT_EMOTE" then
        emoteMsg, name = ...
        -- Spread virus if infected
        if string.find(emoteMsg, "cough") then
            if name == me then
                if HasCorona then
                    -- All people within SAY distance have a chance of contracting the disease from someone infected
                    C_ChatInfo.SendAddonMessage("coronaV", "INFECTED", "SAY");
                end
            end
        end
    end
end

frame:SetScript("OnEvent", eventHandler);

SLASH_TEST1 = "/coronav"

SlashCmdList["TEST"] = function(msg)
    testChance = math.random(0,100);

    if (testChance > 30 and HasCorona) then
        SendChatMessage("I HAVE THE CORONA!" , "YELL", nil);
    elseif (testChance > 30 and not HasCorona) then
        print("You have successfully avoided the corona.");
    else
        print("Sorry there are no tests avaialable for you...");
    end
end 