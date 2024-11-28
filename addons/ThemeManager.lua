local httpService = game:GetService('HttpService')
local ThemeManager = {} do
   ThemeManager.Folder = 'LinoriaLibSettings'

   ThemeManager.Library = nil
   ThemeManager.BuiltInThemes = {
       ['Default']         = { 1, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}') },
       ['BBot']           = { 2, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}') },
       ['Fatality']       = { 3, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}') },
       ['Jester']         = { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
       ['Mint']           = { 5, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
       ['Tokyo Night']    = { 6, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}') },
       ['Ubuntu']         = { 7, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}') },
       ['Quartz']         = { 8, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}') },
       ['Nordic']         = { 9, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242933","AccentColor":"81a1c1","BackgroundColor":"2e3440","OutlineColor":"3b4252"}') },
       ['Crimson']        = { 10, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a0f0f","AccentColor":"dc2626","BackgroundColor":"160c0c","OutlineColor":"2d1f1f"}') },
       ['Ocean']          = { 11, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1a2634","AccentColor":"38bdf8","BackgroundColor":"0f172a","OutlineColor":"1e3a5f"}') },
       ['Emerald']        = { 12, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"132e1f","AccentColor":"34d399","BackgroundColor":"0f291c","OutlineColor":"204c36"}') },
       ['Lavender']       = { 13, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2d2438","AccentColor":"a78bfa","BackgroundColor":"1f1926","OutlineColor":"443c57"}') },
       ['Sunset']         = { 14, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2b1d1d","AccentColor":"f97316","BackgroundColor":"231717","OutlineColor":"412e2e"}') },
       ['Carbon']         = { 15, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"6b7280","BackgroundColor":"171717","OutlineColor":"2d2d2d"}') },
       ['Cyber']          = { 16, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1221","AccentColor":"00ff9f","BackgroundColor":"0c0f1d","OutlineColor":"1e2233"}') },
       ['Sakura']         = { 17, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2d2329","AccentColor":"fb7185","BackgroundColor":"241c20","OutlineColor":"433339"}') },
       ['Glacier']        = { 18, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1f2937","AccentColor":"60a5fa","BackgroundColor":"111827","OutlineColor":"374151"}') },
       ['Volcanic']       = { 19, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"251512","AccentColor":"f43f5e","BackgroundColor":"1c0f0c","OutlineColor":"3d2723"}') },
       ['Forest']         = { 20, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1b2921","AccentColor":"4ade80","BackgroundColor":"141e1a","OutlineColor":"2d3d35"}') },
       ['Amethyst']       = { 21, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"231c2d","AccentColor":"a855f7","BackgroundColor":"1a1523","OutlineColor":"382e44"}') },
       ['Dawn']           = { 22, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"202535","AccentColor":"f59e0b","BackgroundColor":"181c29","OutlineColor":"323a4f"}') },
       ['Matrix']         = { 23, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1714","AccentColor":"22c55e","BackgroundColor":"0b110f","OutlineColor":"1e2d26"}') }
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
       groupbox:AddLabel('Main color'):AddColorPicker('MainColor', { Default = self.Library.MainColor });
       groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
       groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
       groupbox:AddLabel('Font color'):AddColorPicker('FontColor', { Default = self.Library.FontColor });

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

   function ThemeManager:CreateCustomTheme(name)
       if name:gsub(' ', '') == '' then
           return self.Library:Notify('Invalid theme name (empty)', 3)
       end

       local theme = {}
       local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

       for _, field in next, fields do
           theme[field] = Options[field].Value:ToHex()
       end

       writefile(self.Folder .. '/themes/' .. name .. '.json', httpService:JSONEncode(theme))

       Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
       Options.ThemeManager_CustomThemeList:SetValues()
       Options.ThemeManager_CustomThemeList:SetValue(name)
   end

   function ThemeManager:SaveCustomTheme(name)
       if name:gsub(' ', '') == '' then
           return self.Library:Notify('Invalid theme name (empty)', 3)
       end

       local theme = {}
       local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

       for _, field in next, fields do
           theme[field] = Options[field].Value:ToHex()
       end

       writefile(self.Folder .. '/themes/' .. name .. '.json', httpService:JSONEncode(theme))
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
