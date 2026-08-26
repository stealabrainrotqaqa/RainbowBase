repeat task.wait(0.5) until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local function getRainbowColor()
	return Color3.fromHSV((tick() % 3) / 3, 0.9, 1)
end

local function applyRainbowBase()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart", 20)
	
	-- Workspace ve Plots yüklenene kadar bekle
	local plotsFolder = Workspace:WaitForChild("Plots", 20)
	if not root or not plotsFolder then return end

	-- Spawn parçasına göre en yakın Plot'u bul
	local myPlot = nil
	local shortestDist = math.huge

	-- Plots tam yüklenene kadar sürekli tarama dener
	for attempt = 1, 10 do
		for _, plot in ipairs(plotsFolder:GetChildren()) do
			local spawnPart = plot:FindFirstChild("Spawn", true)
			if spawnPart and spawnPart:IsA("BasePart") then
				local dist = (root.Position - spawnPart.Position).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					myPlot = plot
				end
			end
		end
		
		if myPlot then break end
		task.wait(1)
	end

	if not myPlot then return end

	-- Eski Efekt Temizliği
	if myPlot:FindFirstChild("SolaraAutoExecHighlight") then myPlot.SolaraAutoExecHighlight:Destroy() end
	if myPlot:FindFirstChild("SolaraAutoExecGui") then myPlot.SolaraAutoExecGui:Destroy() end

	-- Highlight (Duvar Arkası Rainbow Parlama)
	local highlight = Instance.new("Highlight")
	highlight.Name = "SolaraAutoExecHighlight"
	highlight.Adornee = myPlot
	highlight.FillTransparency = 0.35
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = myPlot

	-- Base Üstü Tabela (BillboardGui)
	local spawnPart = myPlot:FindFirstChild("Spawn", true) or myPlot
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "SolaraAutoExecGui"
	billboard.Size = UDim2.new(0, 250, 0, 60)
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 12, 0)
	billboard.Adornee = spawnPart
	billboard.Parent = myPlot

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "★ MY BASE ★"
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 22
	label.TextStrokeTransparency = 0
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

	-- Kesintisiz Renk Döngüsü
	RunService.RenderStepped:Connect(function()
		if myPlot and highlight and highlight.Parent then
			local color = getRainbowColor()
			highlight.FillColor = color
			highlight.OutlineColor = color
			label.TextColor3 = color
		end
	end)
end

-- Otomatik Başlatıcılar (Autoexec)
task.spawn(function()
	task.wait(2)
	applyRainbowBase()
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1.5)
	applyRainbowBase()
end)
