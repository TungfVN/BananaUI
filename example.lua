--[[
=====================================================================
   BANANA UI LIBRARY - EXAMPLE CODE CHI TIẾT (đã chỉnh theo lib thật)
=====================================================================
   - Mỗi UI element chỉ xuất hiện ĐÚNG 1 LẦN
   - Comment tiếng Việt giải thích từng tham số
   - KHÔNG có phần Save/Load Config (lib này KHÔNG support)
   - KHÔNG có SetKeybind (lib này chỉ có nút Hide floating góc màn hình)
   - Theme (màu) phải set qua getgenv().UIColor TRƯỚC CreateWindow
---------------------------------------------------------------------
   Cách dùng: copy file này vào executor (Synapse, KRNL, Fluxus...)
   rồi Execute trong game Roblox bất kỳ để xem demo UI.
=====================================================================
]]

----------------------------------------------------------------------
-- 0) TẢI BANANA UI LIBRARY TỪ PASTEFY
----------------------------------------------------------------------
-- loadstring() chạy script từ URL và trả về table Library
-- Bắt buộc phải load trước khi gọi bất kỳ hàm nào khác
local Library = loadstring(game:HttpGet("https://pastefy.app/kyYdSx0A/raw"))()

----------------------------------------------------------------------
-- 1) TUỲ CHỈNH MÀU GIAO DIỆN (THEME) - PHẢI SET TRƯỚC CreateWindow
----------------------------------------------------------------------
-- Banana UI không có ThemeManager runtime
-- Màu sắc cấu hình qua table getgenv().UIColor BEFORE tạo window
-- Bạn có thể chỉnh từng key để đổi màu, ví dụ đổi "Title Text Color"
getgenv().UIColor = getgenv().UIColor or {}  -- giữ default nếu đã có
getgenv().UIColor["Title Text Color"]      = Color3.fromRGB(255, 206, 27)
getgenv().UIColor["Background Main Color"] = Color3.fromRGB(18, 18, 22)
getgenv().UIColor["Page Selected Color"]   = Color3.fromRGB(255, 206, 27)
getgenv().UIColor["Button Color"]          = Color3.fromRGB(255, 206, 27)

----------------------------------------------------------------------
-- 2) TẠO CỬA SỔ CHÍNH (WINDOW)
----------------------------------------------------------------------
-- Library:CreateWindow(config) -> trả về đối tượng Window
--
-- CONFIG (table):
--   Title    : string -> Tiêu đề lớn trên đầu UI
--   Subtitle : string -> Dòng phụ phía dưới Title (hoặc dùng key "Desc")
--   Image    : string -> rbxassetid:// icon hiển thị bên trái
--   (KHÔNG có tham số Keybind - lib này không hỗ trợ set phím toggle)
local Window = Library:CreateWindow({
    ["Title"]    = "Banana Hub";
    ["Subtitle"] = "- Example UI by Z.ai";
    ["Image"]    = "rbxassetid://5009915795";
})

----------------------------------------------------------------------
-- 3) NOTIFICATION (thông báo góc màn hình)
----------------------------------------------------------------------
-- Library:Notify(config)
--
-- CONFIG:
--   Title       : string -> Tiêu đề thông báo
--   Description : string -> Nội dung (hoặc key "Desc" / "Content")
--   Duration    : number -> thời gian hiển thị (giây) (hoặc "Timeshow"/"Delay")
wait(1)
Library:Notify({
    ["Title"]       = "Banana UI Example";
    ["Description"] = "UI đã load xong! Mỗi element xuất hiện đúng 1 lần.";
    ["Duration"]    = 5;
})

----------------------------------------------------------------------
-- 4) TẠO TAB (AddTab)
----------------------------------------------------------------------
-- Window:AddTab(name) -> trả về Tab object (pagefunc)
-- Mỗi tab là 1 trang riêng, có thể có nhiều Groupbox (Section)
local MainTab = Window:AddTab("Main")        -- tab demo các element

----------------------------------------------------------------------
-- 5) TẠO GROUPBOX (AddLeftGroupbox / AddRightGroupbox)
----------------------------------------------------------------------
-- Trong code library thật, AddLeftGroupbox / AddRightGroupbox đều gọi
-- tới AddSection(name) bên trong, nên 2 hàm này thực chất giống nhau
-- (lib này không phân chia cột trái/phải thật sự).
local LeftGroup  = MainTab:AddLeftGroupbox("Elements - Group 1")
local RightGroup = MainTab:AddRightGroupbox("Elements - Group 2")

----------------------------------------------------------------------
-- 6) BUTTON (AddButton) - nút bấm
----------------------------------------------------------------------
-- Groupbox:AddButton(config)
--
-- CONFIG (lib thật chỉ đọc các key sau):
--   Title    : string   -> Tên nút (hoặc dùng "Text")
--   Callback : function -> hàm chạy khi bấm (hoặc dùng "Func")
--   (KHÔNG hỗ trợ Description cho button)
LeftGroup:AddButton({
    ["Title"] = "Button Example";
    ["Callback"] = function()
        print("[Button] đã được bấm!")
        Library:Notify({
            ["Title"]       = "Button Clicked";
            ["Description"] = "Callback đã chạy thành công.";
            ["Duration"]    = 3;
        })
    end
})

----------------------------------------------------------------------
-- 7) TOGGLE (AddToggle) - công tắc Bật/Tắt
----------------------------------------------------------------------
-- Groupbox:AddToggle(idx, config)   -> cần idx (string unique)
--
-- CONFIG (lib thật chỉ đọc các key sau):
--   Title       : string    -> Tên toggle (hoặc "Text")
--   Description : string    -> mô tả nhỏ (hoặc "Desc")
--   Default     : boolean   -> trạng thái ban đầu
--   Callback    : function  -> chạy khi đổi state, nhận Value (boolean)
--   (KHÔNG hỗ trợ Tooltip)
local MyToggle = LeftGroup:AddToggle("MyToggle", {
    ["Title"]       = "Toggle Example";
    ["Description"] = "Bật/tắt để in ra console";
    ["Default"]     = false;
    ["Callback"] = function(Value)
        print("[Toggle] state =", Value)
    end
})
-- Lưu object MyToggle để dùng sau (đọc state qua MyToggle.Value...)

----------------------------------------------------------------------
-- 8) SLIDER (AddSlider) - thanh trượt chọn số
----------------------------------------------------------------------
-- Groupbox:AddSlider(config)
--
-- CONFIG (lib thật chỉ đọc các key sau):
--   Title    : string    -> Tên slider (hoặc "Text")
--   Min      : number    -> giá trị nhỏ nhất
--   Max      : number    -> giá trị lớn nhất
--   Default  : number    -> giá trị ban đầu
--   Precise  : boolean   -> true = số thập phân, false/nil = số nguyên
--   Callback : function  -> chạy khi kéo, nhận Value (number)
--   (KHÔNG có "Rounding" - dùng Precise để bật/tắt số thập phân)
--   (KHÔNG hỗ trợ Description cho slider)
LeftGroup:AddSlider({
    ["Title"]    = "Slider Example (0 - 100)";
    ["Min"]      = 0;
    ["Max"]      = 100;
    ["Default"]  = 50;
    ["Precise"]  = false;          -- false = số nguyên, true = có thập phân
    ["Callback"] = function(Value)
        print("[Slider] value =", Value)
    end
})

----------------------------------------------------------------------
-- 9) DROPDOWN (AddDropdown) - chọn 1 giá trị (Single)
----------------------------------------------------------------------
-- Groupbox:AddDropdown(idx, config)   -> cần idx (string unique)
--
-- CONFIG (lib thật chỉ đọc các key sau):
--   Title    : string        -> Tên dropdown (hoặc "Text")
--   Values   : table         -> danh sách option { "A", "B", "C" }
--   Default  : string|number -> option mặc định (string = giá trị,
--                               number = index trong Values, nil = chưa chọn)
--   Search   : boolean       -> true = hiện ô tìm kiếm trong dropdown
--   Multi    : boolean       -> false = chọn 1, true = chọn nhiều
--                               (hoặc dùng key "Selected")
--   Callback : function      -> nhận Value (string khi Multi=false)
LeftGroup:AddDropdown("MyDropdown", {
    ["Title"]    = "Dropdown Example";
    ["Values"]   = { "Option 1", "Option 2", "Option 3" };
    ["Default"]  = "Option 1";
    ["Multi"]    = false;
    ["Search"]   = false;
    ["Callback"] = function(Value)
        print("[Dropdown Single] đã chọn:", Value)
    end
})

----------------------------------------------------------------------
-- 10) DROPDOWN (Multi) - chọn nhiều giá trị
----------------------------------------------------------------------
-- Khi Multi = true:
--   Default  : table -> { "Item A", "Item B" } (default cho multi)
--   Callback : nhận Value là TABLE (các giá trị đang được chọn)
LeftGroup:AddDropdown("MyMultiDropdown", {
    ["Title"]    = "Multi Dropdown Example";
    ["Values"]   = { "Item A", "Item B", "Item C", "Item D" };
    ["Multi"]    = true;
    ["Search"]   = true;            -- có ô search
    ["Callback"] = function(Value)
        -- Value là table, duyệt bằng pairs
        print("[Dropdown Multi] đã chọn:")
        for _, v in pairs(Value) do
            print("  -", v)
        end
    end
})

----------------------------------------------------------------------
-- 11) INPUT (AddInput) - ô nhập text
----------------------------------------------------------------------
-- Groupbox:AddInput(idx, config)   -> cần idx (string unique)
--
-- CONFIG (lib thật chỉ đọc các key sau):
--   Title       : string    -> Tên ô input (hoặc "Text")
--   Placeholder : string    -> chữ mờ gợi ý khi chưa nhập
--   Default     : string    -> (optional) giá trị mặc định
--   Numeric     : boolean   -> true = chỉ cho nhập số
--   Callback    : function  -> chạy khi đổi, nhận Value (string)
LeftGroup:AddInput("MyInput", {
    ["Title"]       = "Input Example";
    ["Placeholder"] = "Nhập text ở đây...";
    ["Numeric"]     = false;
    ["Callback"] = function(Value)
        print("[Input] value =", Value)
    end
})

----------------------------------------------------------------------
-- 12) LABEL (AddLabel) - dòng text hiển thị
----------------------------------------------------------------------
-- Groupbox:AddLabel(text) -> trả về Label object
-- Muốn đổi text sau này phải gọi :SetText(newText)
local MyLabel = LeftGroup:AddLabel("Label Example: Hello World!")

-- Demo cập nhật label mỗi giây (giống đồng hồ / status check trong game)
task.spawn(function()
    while task.wait(1) do
        MyLabel:SetText("Time now: " .. os.date("%H:%M:%S"))
    end
end)

----------------------------------------------------------------------
-- 13) [GROUP 2] Toggle với Default = true
----------------------------------------------------------------------
RightGroup:AddToggle("RightToggle", {
    ["Title"]       = "Toggle (mặc định ON)";
    ["Description"] = "Demo Default = true ở group 2";
    ["Default"]     = true;
    ["Callback"] = function(Value)
        print("[RightToggle] state =", Value)
    end
})

----------------------------------------------------------------------
-- 14) [GROUP 2] Float Slider (số thập phân)
----------------------------------------------------------------------
-- Precise = true -> cho phép giá trị thập phân
RightGroup:AddSlider({
    ["Title"]    = "Float Slider (0.1 - 2.0)";
    ["Min"]      = 0.1;
    ["Max"]      = 2.0;
    ["Default"]  = 0.5;
    ["Precise"]  = true;            -- BẬT số thập phân
    ["Callback"] = function(Value)
        print("[FloatSlider] value =", Value)
    end
})

----------------------------------------------------------------------
-- 15) [GROUP 2] Dropdown lấy Values động (players list)
----------------------------------------------------------------------
local Players = game:GetService("Players")
local PlayerList = {}
for _, p in ipairs(Players:GetPlayers()) do
    table.insert(PlayerList, p.Name)
end

RightGroup:AddDropdown("PlayerDropdown", {
    ["Title"]    = "Select Player (động)";
    ["Values"]   = PlayerList;     -- table tạo lúc runtime
    ["Multi"]    = false;
    ["Search"]   = true;           -- có ô search để tìm nhanh
    ["Callback"] = function(Value)
        print("[PlayerDropdown] đã chọn:", Value)
    end
})

----------------------------------------------------------------------
-- 16) [GROUP 2] LABEL demo SetText (cập nhật state kiểu ✅/❌)
----------------------------------------------------------------------
local StateLabel = RightGroup:AddLabel("Status: đang kiểm tra...")
task.spawn(function()
    while task.wait(2) do
        local ok = math.random(1, 100) > 50
        StateLabel:SetText("Status: " .. (ok and "ON" or "OFF"))
    end
end)

----------------------------------------------------------------------
-- 17) KEYBIND (AddKeyBind) - gán phím tắt
----------------------------------------------------------------------
-- Groupbox:AddKeyBind(config)  -> KHÔNG cần idx
--
-- CONFIG (lib thật chỉ đọc các key sau):
--   Title    : string   -> Tên keybind (hoặc "Text")
--   Default  : KeyCode  -> phím mặc định (Enum.KeyCode.F hoặc string "F")
--   Mode     : string   -> "Toggle" (bật/tắt) hoặc "Hold" (giữ mới chạy)
--   Callback : function -> chạy khi trigger, nhận Value (boolean state)
RightGroup:AddKeyBind({
    ["Title"]    = "KeyBind Example";
    ["Default"]  = Enum.KeyCode.F;
    ["Mode"]     = "Toggle";        -- "Toggle" hoặc "Hold"
    ["Callback"] = function(Value)
        print("[KeyBind] triggered, state =", Value)
        Library:Notify({
            ["Title"]       = "KeyBind Triggered";
            ["Description"] = "Mode = Toggle, state = " .. tostring(Value);
            ["Duration"]    = 2;
        })
    end
})

----------------------------------------------------------------------
-- 18) ẨN / HIỆN UI
----------------------------------------------------------------------
-- Banana UI KHÔNG có Library:SetKeybind()
-- UI được ẩn/hiện bằng nút tròn floating ở góc màn hình (btnHide)
-- Nếu muốn toggle bằng code, gọi Library.ToggleUI() trực tiếp:
--   Library.ToggleUI()  -> ẩn UI nếu đang hiện, hiện UI nếu đang ẩn
-- Library.DestroyUI()  ->  phá hủy UI hoàn toàn

----------------------------------------------------------------------
-- 19) DEMO LOOP - đọc state toggle để bật auto-farm
----------------------------------------------------------------------
-- Ví dụ: khi MyToggle ON, in ra console mỗi giây
task.spawn(function()
    while task.wait(1) do
        if MyToggle and MyToggle.Value then
            print("[AutoLoop] đang chạy vì Toggle đang ON...")
            -- Viết logic auto-farm/teleport ở đây
        end
    end
end)

--[[
=====================================================================
   TÓM TẮT CÁC ELEMENT ĐÃ DÙNG (mỗi loại 1 lần):
---------------------------------------------------------------------
   1. getgenv().UIColor = {...}         -> set màu TRƯỚC CreateWindow
   2. Library:CreateWindow({...})       -> tạo cửa sổ chính
   3. Library:Notify({...})             -> thông báo
   4. Window:AddTab(name)               -> tạo tab
   5. Tab:AddLeftGroupbox(name)         -> groupbox (gọi AddSection)
   6. Tab:AddRightGroupbox(name)        -> groupbox (gọi AddSection)
   7. Groupbox:AddButton({...})         -> nút bấm
   8. Groupbox:AddToggle(idx, {...})    -> công tắc
   9. Groupbox:AddSlider({...})         -> thanh trượt số nguyên
  10. Groupbox:AddDropdown(idx, Multi=false) -> dropdown 1 chọn
  11. Groupbox:AddDropdown(idx, Multi=true)  -> dropdown nhiều chọn
  12. Groupbox:AddInput(idx, {...})     -> ô nhập text
  13. Groupbox:AddLabel(text)           -> label + :SetText()
  14. Groupbox:AddKeyBind({...})        -> gán phím tắt
  15. Library.ToggleUI() / DestroyUI()  -> ẩn/hiện / phá hủy UI

   GHI CHÚ QUAN TRỌNG VỀ LIBRARY NÀY:
   - KHÔNG hỗ trợ SaveManager / LoadConfig / SaveConfig
     -> Không thể lưu/nạp cấu hình ra file
   - KHÔNG hỗ trợ ThemeManager runtime
     -> Phải set màu qua getgenv().UIColor TRƯỚC CreateWindow
   - KHÔNG có Library:SetKeybind(KeyCode)
     -> UI toggle qua nút floating góc màn hình hoặc Library.ToggleUI()
   - AddSlider dùng Precise (boolean), KHÔNG dùng Rounding
   - AddButton/AddSlider KHÔNG hỗ trợ Description
   - AddToggle KHÔNG hỗ trợ Tooltip
   - AddDropdown có Search (ô tìm kiếm) và Multi (chọn nhiều)
   - AddKeyBind có Mode: "Toggle" hoặc "Hold"
   - AddLabel không có Callback, muốn đổi text phải gọi :SetText()
=====================================================================
]]
