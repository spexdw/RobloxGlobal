local httpService = game:GetService('HttpService')
local ThemeManager = {} do
   ThemeManager.Folder = 'SpeXLibSettings'
   ThemeManager.Library = nil
   
   -- Extended built-in themes collection
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
       ['Matrix']         = { 29, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1714","AccentColor":"22c55e","BackgroundColor":"0b110f","OutlineColor":"1e2d26"}') }
   }

   function ThemeManager:ApplyTheme(theme)
       local customThemeData = self:GetCustomTheme(theme)
       local data = customThemeData or self.BuiltInThemes[theme]

       if not data then return end

       local scheme = type(data) == 'table' and data[2] or data

       for idx, col in next, scheme do
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

       self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
       self.Library:UpdateColorsUsingRegistry()
   end

   function ThemeManager:LoadDefault()        
       local theme = 'Default'
       local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

       if content then
           if self.BuiltInThemes[content] then
               self:ApplyTheme(content)
           elseif self:GetCustomTheme(content) then
               self:ApplyTheme(content)
           end
       else
           self:ApplyTheme(theme)
       end
   end

   function ThemeManager:SaveDefault2(theme)
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

   function ThemeManager:SaveDefault(theme)
       local themePath = self.Folder .. '/themes'
       local defaultFile = themePath .. '/default.txt'
       
       if not isfolder(themePath) then
           makefolder(themePath)
       end
       
       if isfile(defaultFile) then
           delfile(defaultFile)
       end
       writefile(defaultFile, theme)
   end

   function ThemeManager:CreateThemeManager(groupbox)
       groupbox:AddLabel('Main color'):AddColorPicker('MainColor', { Default = self.Library.MainColor })
       groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor })
       groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor })
       groupbox:AddLabel('Font color'):AddColorPicker('FontColor', { Default = self.Library.FontColor })

       local ThemesArray = {}
       for Name, Theme in next, self.BuiltInThemes do
           table.insert(ThemesArray, Name)
       end

       table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

       groupbox:AddDivider()
       groupbox:AddDropdown('ThemeManager_ThemeList', { 
           Text = 'Theme list', 
           Values = ThemesArray, 
           Default = 1,
           Callback = function(Value)
               if Value then
                   self:ApplyTheme(Value)
                   self.Library:Notify(string.format('Applied theme: %q', Value))
               end
           end
       })

       groupbox:AddButton('Set as default', function()
			self:SaveDefault2(Options.ThemeManager_ThemeList.Value)
			self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_ThemeList.Value))
		 end)

       groupbox:AddDivider()
       groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true })
       groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Theme name' })

       groupbox:AddButton('Load theme', function() 
           if Options.ThemeManager_CustomThemeList.Value then
               self:ApplyTheme(Options.ThemeManager_CustomThemeList.Value)
               self.Library:Notify(string.format('Loaded theme: %q', Options.ThemeManager_CustomThemeList.Value))
           end
       end)

       groupbox:AddButton('Create theme', function() 
           if Options.ThemeManager_CustomThemeName.Value:gsub(' ', '') ~= '' then
               self:CreateCustomTheme(Options.ThemeManager_CustomThemeName.Value)
               self.Library:Notify(string.format('Created theme: %q', Options.ThemeManager_CustomThemeName.Value))
           end
       end)

       groupbox:AddButton('Delete theme', function()
           if Options.ThemeManager_CustomThemeList.Value then
               self:DeleteCustomTheme(Options.ThemeManager_CustomThemeList.Value)
               self.Library:Notify(string.format('Deleted theme: %q', Options.ThemeManager_CustomThemeList.Value))
               
               Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
               Options.ThemeManager_CustomThemeList:SetValues()
               Options.ThemeManager_CustomThemeList:SetValue(nil)
           end
       end)

       groupbox:AddButton('Save theme', function() 
           if Options.ThemeManager_CustomThemeList.Value then
               self:SaveCustomTheme(Options.ThemeManager_CustomThemeList.Value)
               self.Library:Notify(string.format('Saved theme: %q', Options.ThemeManager_CustomThemeList.Value))
           end
       end)

       groupbox:AddButton('Set as default', function()
           if Options.ThemeManager_CustomThemeList.Value then
               self:SaveDefault(Options.ThemeManager_CustomThemeList.Value)
               self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_CustomThemeList.Value))
           end
       end)

       groupbox:AddButton('Refresh list', function()
           Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
           Options.ThemeManager_CustomThemeList:SetValues()
           Options.ThemeManager_CustomThemeList:SetValue(nil)
       end)
   
       local function UpdateTheme()
           self:ThemeUpdate()
       end

       Options.MainColor:OnChanged(UpdateTheme)
       Options.AccentColor:OnChanged(UpdateTheme)
       Options.OutlineColor:OnChanged(UpdateTheme)
       Options.FontColor:OnChanged(UpdateTheme)
   end

   function ThemeManager:GetCustomTheme(file)
       if not file then return end
       local path = self.Folder .. '/themes/' .. file
       if not isfile(path) then return end

       local data = readfile(path)
       local success, decoded = pcall(httpService.JSONDecode, httpService, data)
       
       if not success then return end
       return decoded
   end

   function ThemeManager:SaveCustomTheme(name)
       if name:gsub(' ', '') == '' then
           return self.Library:Notify('Invalid theme name (empty)', 3)
       end

       if not isfolder(self.Folder .. '/themes') then
           makefolder(self.Folder .. '/themes')
       end

       local theme = {}
       local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

       for _, field in next, fields do
           theme[field] = Options[field].Value:ToHex()
       end

       writefile(self.Folder .. '/themes/' .. name, httpService:JSONEncode(theme))
   end

   function ThemeManager:CreateCustomTheme(name)
       if name:gsub(' ', '') == '' then
           return self.Library:Notify('Invalid theme name (empty)', 3)
       end

       if not isfolder(self.Folder .. '/themes') then
           makefolder(self.Folder .. '/themes')
       end

       local theme = {}
       local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

       for _, field in next, fields do
           theme[field] = Options[field].Value:ToHex()
       end

       writefile(self.Folder .. '/themes/' .. name .. '.json', httpService:JSONEncode(theme))
       
       Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
       Options.ThemeManager_CustomThemeList:SetValues()
       Options.ThemeManager_CustomThemeList:SetValue(name .. '.json')
   end

   function ThemeManager:DeleteCustomTheme(name)
       if name:gsub(' ', '') == '' then
           return self.Library:Notify('Invalid theme name (empty)', 3)
       end

       local path = self.Folder .. '/themes/' .. name
       if isfile(path) then
           delfile(path)
           return true
       end
       
       return false
   end

   function ThemeManager:ReloadCustomThemes()
       if not isfolder(self.Folder .. '/themes') then
           makefolder(self.Folder .. '/themes')
           return {}
       end

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
       local paths = {
           self.Folder,
           self.Folder .. '/themes',
           self.Folder .. '/settings'
       }

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
