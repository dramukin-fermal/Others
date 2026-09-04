if getgenv().ExecutedFarm then return end
getgenv().ExecutedFarm = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end
--game:GetService("RunService"):Set3dRenderingEnabled(false)
local queueonteleport = queueonteleport or queue_on_teleport
if queueonteleport then
    queueonteleport([[
    loadstring(game:HttpGet('https://raw.githubusercontent.com/dramukin-fermal/Others/refs/heads/main/JumpForAnimal.lua'))()
    ]])
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local HttpService = game:GetService("HttpService")


local clientGuards = workspace.Map:FindFirstChild("ClientGuards")

local lp = LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
char:PivotTo(CFrame.new(0, 4000, -1500))
pcall(function()
	char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
end)

if clientGuards then
	clientGuards:Destroy()
end

local allowShop = false
spawn(function()
	local cdownshop = tick()
	repeat task.wait() until allowShop or tick() - cdownshop >= 15
	while wait() do
		local servers = {}
		local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
		local body = HttpService:JSONDecode(req)
		if body and body.data then
			for i, v in next, body.data do
				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
					table.insert(servers, 1, v.id)
				end
			end
		end
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
		else
			wait()
		end
	end
end)

local function idleFloat()
	local char = lp.Character or lp.CharacterAdded:Wait()
	if char then
		for i,v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
				v.Velocity = Vector3.new(0,0,0)
			end
		end
	end
end

local found = false
local eggwanted = {"PLESIOSAUR", "FIRE PHOENIX", "WYVERN", "PEGASUS"}
local Eggs = game:GetService("Workspace").Map.Stages["Celestial Heights"].SpawnedEggs
for i,v in pairs(Eggs:GetChildren()) do
	if table.find(eggwanted, v.Name) then
		char:PivotTo(v:GetPivot() * CFrame.new(0,-8,0))
		local p = v: FindFirstChildWhichIsA("ProximityPrompt", true)
		if p then
			found = true
			local start = tick()
			repeat task.wait()
				idleFloat() fireproximityprompt(p) char:PivotTo(v:GetPivot() * CFrame.new(0,-5,0))
			until not p or not p.Parent or not p.Enabled
			wait()
			repeat task.wait()
				char:PivotTo(CFrame.new(0,10000,0))
			until not v or not v.parent or tick() - start >= 5
		end
	end
end


httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if found then
	wait()
end
allowShop = true
