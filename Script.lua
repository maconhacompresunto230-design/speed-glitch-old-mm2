local Players = game:GetService("Players")
local player = Players.LocalPlayer
local itensBalao = {
WaterBalloon2024 = true,
SnowballToy2020 = true,
IceCream = true
}

local function aplicarSistema(character)
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

if character:FindFirstChild("GlitchPart") then
character.GlitchPart:Destroy()
end

local glitchPart = Instance.new("Part")
glitchPart.Name = "GlitchPart"
glitchPart.Size = Vector3.new(2, 2, 2)
glitchPart.Transparency = 1
glitchPart.CanCollide = false
glitchPart.CanTouch = false
glitchPart.CanQuery = false
glitchPart.Parent = character

local weld = Instance.new("Weld")
weld.Part0 = rootPart
weld.Part1 = glitchPart
weld.Parent = glitchPart

local function setOffset(z)
weld.C0 = CFrame.new(0, 0, z)
end

local emoteAtual = nil
local efeitoAtivo = false
local offsetAtual = 0
local toolAtual = nil
local modoEscalada = false
local aguardandoMudancaTool = false
local terminouComTool = false
local offsetTravado = false

local emotes = {
["http://www.roblox.com/asset/?id=15609995579"] = "normal",
["rbxassetid://15609995579"] = "normal",
["rbxassetid://107481557610007"] = "forte"
}

local function ativar(offset)
efeitoAtivo = true
offsetAtual = offset
glitchPart.Transparency = 1
setOffset(offset)
end

local function desativar()
efeitoAtivo = false
modoEscalada = false
offsetAtual = 0
aguardandoMudancaTool = false
terminouComTool = false
glitchPart.Transparency = 1
setOffset(0)
end

humanoid.AnimationPlayed:Connect(function(track)
if track.Animation then
local tipo = emotes[track.Animation.AnimationId]

if tipo then
emoteAtual = tipo
offsetAtual = 0
offsetTravado = false
aguardandoMudancaTool = false
terminouComTool = false

track.Stopped:Connect(function()
emoteAtual = nil
aguardandoMudancaTool = true
terminouComTool = toolAtual ~= nil
end)
end
end
end)

character.ChildRemoved:Connect(function(obj)

if itensBalao[obj.Name] then

if emoteAtual == "normal" then
offsetAtual = 10
offsetTravado = true

elseif emoteAtual == "forte" then
offsetAtual = 12
offsetTravado = true
end

if efeitoAtivo then
setOffset(offsetAtual)
end
end

if obj:IsA("Tool") then

if obj == toolAtual then
toolAtual = nil

if aguardandoMudancaTool and terminouComTool then
aguardandoMudancaTool = false
terminouComTool = false
desativar()

elseif not emoteAtual and not itensBalao[obj.Name] then
desativar()
end
end
end
end)

character.ChildAdded:Connect(function(obj)

if obj:IsA("Tool") then

toolAtual = obj

if aguardandoMudancaTool and not terminouComTool then
aguardandoMudancaTool = false
desativar()
return
end

local escalando =
humanoid:GetState() == Enum.HumanoidStateType.Climbing

if escalando then

modoEscalada = true
efeitoAtivo = true
setOffset(3.7)

elseif emoteAtual == "normal" then

if offsetAtual > 0 then
ativar(offsetAtual)
else
ativar(7.9)
end

elseif emoteAtual == "forte" then

if offsetAtual > 0 then
ativar(offsetAtual)
else
ativar(11)
end

end
end
end)

task.spawn(function()

while character.Parent do

task.wait(0.05)

if efeitoAtivo then

if modoEscalada then
setOffset(3.7)
else
setOffset(offsetAtual)
end

end
end
end)

end

if player.Character then
aplicarSistema(player.Character)
end

player.CharacterAdded:Connect(aplicarSistema)