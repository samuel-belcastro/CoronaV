local frame = CreateFrame("FRAME", "CoronaVFrame");

local me = UnitName("player");
local numTests = 5;

-- Fired when saved variables are loaded
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("CHAT_MSG_ADDON");
frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE");

local infected = true;

local function clearCorona()
    HasCorona = false;
    SendChatMessage("starts to feel much better!" , "EMOTE");
end

local function replenishTest()
    if (numTests < 5) then
        print("You hear through the grapevine more tests are available.")
        numTests = numTests + 1
    end
end

local function eventHandler(self, event, ...)
    -- Check if the saved variables are set and set them if not
    if event == "ADDON_LOADED" then
        addonName = ...

        if (addonName == "CoronaV") then
            infectionChance = math.random(0,100);

            -- 10% chance of getting covid when starting
            if (infectionChance > 90) then
                message("You woke up feeling a little ill.. better see a doctor.");
                -- Covid lasts 3600 seconds (or 60 mina)
                C_Timer.After(3600, clearCorona)

                HasCorona = true
            else
                HasCorona = false;
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
                SendChatMessage("suddenly feels a tightening in their chest." , "EMOTE");
            end

            -- 10% chance of getting covid
            if (infectionChance > 1 and not HasCorona) then
                -- Covid lasts 3600 seconds (or 60 mins)
                C_Timer.After(3600, clearCorona)

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
    if (numTests <= 0) then
        numTests = 0
        print("You have no tests available! Try again later after more tests are available to administer.")
    else
        numTests = numTests - 1;

        -- Replenish a test after one minute
        C_Timer.After(60, replenishTest)

        testChance = math.random(0,100);
        
        if (testChance > 70 and HasCorona) then
            SendChatMessage("I HAVE THE CORONA!" , "YELL", nil);
        elseif (testChance > 70 and not HasCorona) then
            print("You have successfully avoided the corona.");
        else
            print("This test came back inconclusive.");
        end
    end
end 