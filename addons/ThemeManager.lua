local httpService = game:GetService('HttpService')
local ThemeManager = {} do
	ThemeManager.Folder = 'SpeXLibSettings'
	if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

	ThemeManager.Library = nil
	ThemeManager.BuiltInThemes = {
	       ['Default']        = { 1, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}') },
	       ['BBot']           = { 2, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}') },
	       ['Fatality']       = { 3, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}') },
	       ['Tokyo Night']    = { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}') },
	       ['Ocean']          = { 5, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a2634","AccentColor":"38bdf8","BackgroundColor":"0f172a","OutlineColor":"1e3a5f"}') },
	       ['Midnight']       = { 6, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0a0a0f","AccentColor":"3b82f6","BackgroundColor":"060609","OutlineColor":"1f1f2e"}') },
	       ['Nebula']         = { 7, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a1a2e","AccentColor":"ff6b6b","BackgroundColor":"141428","OutlineColor":"2d2d44"}') },
	       ['Autumn']         = { 8, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2d1f1f","AccentColor":"d97706","BackgroundColor":"1f1616","OutlineColor":"483333"}') },
	       ['Poison']         = { 9, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a2416","AccentColor":"84cc16","BackgroundColor":"141a10","OutlineColor":"2d3d24"}') },
	       ['Winter']         = { 10, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a242d","AccentColor":"60a5fa","BackgroundColor":"141c24","OutlineColor":"2d3d4d"}') },
	       ['Royal']          = { 11, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1f1a2d","AccentColor":"c084fc","BackgroundColor":"171422","OutlineColor":"342d4d"}') },
	       ['Dragon']         = { 12, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2d1f1a","AccentColor":"f97316","BackgroundColor":"241814","OutlineColor":"4d362d"}') },
	       ['Strawberry']     = { 13, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2d1a24","AccentColor":"f472b6","BackgroundColor":"24141c","OutlineColor":"4d2d3d"}') },
	       ['Quartz']         = { 14, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}') },
	       ['Nordic']         = { 15, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242933","AccentColor":"81a1c1","BackgroundColor":"2e3440","OutlineColor":"3b4252"}') },
	       ['Crimson']        = { 16, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a0f0f","AccentColor":"dc2626","BackgroundColor":"160c0c","OutlineColor":"2d1f1f"}') },
	       ['Ocean']          = { 17, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a2634","AccentColor":"38bdf8","BackgroundColor":"0f172a","OutlineColor":"1e3a5f"}') },
	       ['Emerald']        = { 18, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"132e1f","AccentColor":"34d399","BackgroundColor":"0f291c","OutlineColor":"204c36"}') },
	       ['Lavender']       = { 19, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2d2438","AccentColor":"a78bfa","BackgroundColor":"1f1926","OutlineColor":"443c57"}') },
	       ['Sunset']         = { 20, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2b1d1d","AccentColor":"f97316","BackgroundColor":"231717","OutlineColor":"412e2e"}') },
	       ['Carbon']         = { 21, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"6b7280","BackgroundColor":"171717","OutlineColor":"2d2d2d"}') },
	       ['Cyber']          = { 22, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1221","AccentColor":"00ff9f","BackgroundColor":"0c0f1d","OutlineColor":"1e2233"}') },
	       ['Sakura']         = { 23, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2d2329","AccentColor":"fb7185","BackgroundColor":"241c20","OutlineColor":"433339"}') },
	       ['Glacier']        = { 24, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1f2937","AccentColor":"60a5fa","BackgroundColor":"111827","OutlineColor":"374151"}') },
	       ['Volcanic']       = { 25, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"251512","AccentColor":"f43f5e","BackgroundColor":"1c0f0c","OutlineColor":"3d2723"}') },
	       ['Forest']         = { 26, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1b2921","AccentColor":"4ade80","BackgroundColor":"141e1a","OutlineColor":"2d3d35"}') },
	       ['Amethyst']       = { 27, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"231c2d","AccentColor":"a855f7","BackgroundColor":"1a1523","OutlineColor":"382e44"}') },
	       ['Dawn']           = { 28, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"202535","AccentColor":"f59e0b","BackgroundColor":"181c29","OutlineColor":"323a4f"}') },
	       ['Matrix']         = { 29, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1714","AccentColor":"22c55e","BackgroundColor":"0b110f","OutlineColor":"1e2d26"}') },
	       ['Neon Nights']    = { 30, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f0f1a","AccentColor":"00ffff","BackgroundColor":"0a0a14","OutlineColor":"1e1e33"}') },
	       ['Blood Moon']     = { 31, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a0f0f","AccentColor":"ff3333","BackgroundColor":"140a0a","OutlineColor":"331e1e"}') },
	       ['Synthwave']      = { 32, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a0f26","AccentColor":"ff00ff","BackgroundColor":"140a1e","OutlineColor":"331e4d"}') },
	       ['Deep Sea']       = { 33, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1a1a","AccentColor":"00ffcc","BackgroundColor":"0a1414","OutlineColor":"1e3333"}') },
	       ['Golden Hour']    = { 34, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a1a0f","AccentColor":"ffd700","BackgroundColor":"14140a","OutlineColor":"33331e"}') },
	       ['Quantum']        = { 35, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a0f1a","AccentColor":"9933ff","BackgroundColor":"140a14","OutlineColor":"331e33"}') },
	       ['Arctic Aurora']  = { 36, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1a26","AccentColor":"33ffcc","BackgroundColor":"0a141e","OutlineColor":"1e334d"}') },
	       ['Hellfire']       = { 37, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"260f0f","AccentColor":"ff3300","BackgroundColor":"1e0a0a","OutlineColor":"4d1e1e"}') },
	       ['Ethereal']       = { 38, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a1a26","AccentColor":"cc99ff","BackgroundColor":"14141e","OutlineColor":"33334d"}') },
	       ['Toxic']          = { 39, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a260f","AccentColor":"33ff00","BackgroundColor":"141e0a","OutlineColor":"334d1e"}') },
	       ['Void']           = { 40, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f0f0f","AccentColor":"6600ff","BackgroundColor":"0a0a0a","OutlineColor":"1e1e1e"}') }
	}

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then return end


		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			self.Library[idx] = Color3.fromHex(col)
			
			if Options[idx] then
				Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
		for i, field in next, options do
			if Options and Options[field] then
				self.Library[field] = Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()		
		local theme = 'Default'
		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

		local isDefault = true
		if content then
			if self.BuiltInThemes[content] then
				theme = content
			elseif self:GetCustomTheme(content) then
				theme = content
				isDefault = false;
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
		 	theme = self.DefaultTheme
		end

		if isDefault then
			Options.ThemeManager_ThemeList:SetValue(theme)
		else
			self:ApplyTheme(theme)
		end
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('Main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('Font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })

		groupbox:AddButton('Set as default', function()
			self:SaveDefault(Options.ThemeManager_ThemeList.Value)
			self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_ThemeList.Value))
		end)

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)

		groupbox:AddDivider()

		ThemeManager:LoadDefault()

		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. '/themes/' .. file
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(httpService.JSONDecode, httpService, data)
		
		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			return self.Library:Notify('Invalid file name for theme (empty)', 3)
		end

		local theme = {}
		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

		for _, field in next, fields do
			theme[field] = Options[field].Value:ToHex()
		end

		writefile(self.Folder .. '/themes/' .. file .. '.json', httpService:JSONEncode(theme))
	end

	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/themes')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then

				local pos = file:find('.json', 1, true)
				local char = file:sub(pos, pos)

				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1))
				end
			end
		end

		return out
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}


		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		table.insert(paths, self.Folder .. '/themes')
		table.insert(paths, self.Folder .. '/settings')

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end
return ThemeManager
