@@ -253,6 +253,40 @@ if redis:get(boss..'group:add'..msg.chat_id_) then
 msg.GroupActive = true
 else
 msg.GroupActive = false
 end

 if msg.GroupActive then 

 if (msg.content_.ID == "MessagePhoto" 
 or msg.content_.ID == "MessageSticker" 
 or msg.content_.ID == "MessageVoice" 
 or msg.content_.ID == "MessageAudio" 
 or msg.content_.ID == "MessageVideo" 
 or msg.content_.ID == "MessageAnimation" 
 or msg.content_.ID == "MessageUnsupported") 
 and redis:get(boss.."lock_cleaner"..msg.chat_id_) then
 print("Clener >>> ")
 redis:sadd(boss..":IdsMsgsCleaner:"..msg.chat_id_,msg.id_)
 redis:setex(boss..":SetTimerCleaner:"..msg.chat_id_..msg.id_,21600,true)  
 end



 print(boss..":IdsMsgsCleaner:"..msg.chat_id_)
 local Cleaner = redis:smembers(boss..":IdsMsgsCleaner:"..msg.chat_id_)
 for k,v in pairs(Cleaner) do
 if not redis:get(boss..":SetTimerCleaner:"..msg.chat_id_..v) then
 Del_msg(msg.chat_id_,v)
 redis:srem(boss..":IdsMsgsCleaner:"..msg.chat_id_,v)
 print("MSG DELET CLEANER : "..v)
 else
 print("MSG List CLEANER : "..v.." : Lodding ...")
 end
 end




 end

 if msg.content_.ID == "MessageChatDeleteMember" then 
if msg.GroupActive and redis:get(boss..'mute_tgservice'..msg.chat_id_) then
Del_msg(msg.chat_id_,msg.id_)
end
return false 
end
if msg.sender_user_id_ == SUDO_ID then 
msg.TheRankCmd = 'المطور الاساسي' 
msg.TheRank = 'مطور اساسي 👨🏻‍✈️' 
msg.Rank = 1
elseif redis:sismember(boss..':SUDO_BOT:',msg.sender_user_id_) then 
msg.TheRankCmd = 'المطور'
msg.TheRank = 'مطور البوت 👨🏽‍💻'
msg.Rank = 2
elseif msg.GroupActive and redis:sismember(boss..':MONSHA_Group:'..msg.chat_id_,msg.sender_user_id_) then 
msg.TheRankCmd = 'منشئ اساسي'
msg.TheRank = 'منشئ اساسي 👲🏼'
msg.Rank = 11
elseif msg.GroupActive and redis:sismember(boss..':MONSHA_BOT:'..msg.chat_id_,msg.sender_user_id_) then 
msg.TheRankCmd = 'المنشىء'
msg.TheRank = 'المنشىء 👷🏽'
msg.Rank = 3
elseif msg.GroupActive and redis:sismember(boss..'owners:'..msg.chat_id_,msg.sender_user_id_) then 
msg.TheRankCmd = 'المدير' 
msg.TheRank = 'مدير البوت 👨🏼‍⚕️' 
msg.Rank = 4
elseif msg.GroupActive and redis:sismember(boss..'admins:'..msg.chat_id_,msg.sender_user_id_) then 
msg.TheRankCmd = 'الادمن'
msg.TheRank = 'ادمن في البوت 👨🏼‍🎓'
msg.Rank = 5
elseif msg.GroupActive and redis:sismember(boss..'whitelist:'..msg.chat_id_,msg.sender_user_id_) then 
msg.TheRank = 'عضو مميز'
msg.Rank = 6
elseif msg.sender_user_id_ == our_id then
msg.Rank = 7
else
msg.TheRank = 'فقط عضو 🙍🏼‍♂️'
msg.Rank = 10 
end
if msg.Rank == 1 then
msg.SudoBase = true
end
if msg.Rank == 1 or msg.Rank == 2 or msg.Rank == 11 then
msg.SuperCreator = true
msg.Creator = true
msg.Admin = true
msg.Director = true
end
if msg.Rank == 1 or msg.Rank == 2 then
msg.SudoUser = true
end
if msg.Rank == 1 or msg.Rank == 2 or msg.Rank == 3 then
msg.Creator = true
end
if msg.Rank == 1 or msg.Rank == 2 or msg.Rank == 3 or msg.Rank == 4 then
msg.Director = true
end
if msg.Rank == 1 or msg.Rank == 2 or msg.Rank == 3 or msg.Rank == 4 or msg.Rank == 5 then
msg.Admin = true
end
if msg.Rank == 6 then
msg.Special = true
end
if msg.Rank == 7 then
msg.OurBot = true
end
ISONEBOT = false
if msg.content_.ID == "MessageChatAddMembers" then
local lock_bots = redis:get(boss..'lock_bots'..msg.chat_id_)
ZISBOT = false
for i=0,#msg.content_.members_ do
if msg.content_.members_[i].type_.ID == "UserTypeBot" then
ISONEBOT = true
if msg.GroupActive and not msg.Admin and lock_bots then 
ZISBOT = true
kick_user(msg.content_.members_[i].id_, msg.chat_id_)
end
end
end
if msg.GroupActive and ZISBOT and redis:get(boss..'lock_bots_by_kick'..msg.chat_id_) then
kick_user(msg.sender_user_id_, msg.chat_id_)
end
if msg.content_.members_[0].id_ == our_id and redis:get(boss..':WELCOME_BOT') then
SUDO_USER = redis:hgetall(boss..'username:'..SUDO_ID).username
sendPhoto(msg.chat_id_,msg.id_,redis:get(boss..':WELCOME_BOT'),[[💯¦ مـرحبآ آنآ بوت آسـمـي ]]..redis:get(boss..':NameBot:')..[[ 🎖
💰¦ آختصـآصـي حمـآيهہ‏‏ آلمـجمـوعآت
📛¦ مـن آلسـبآم وآلتوجيهہ‏‏ وآلتگرآر وآلخ...
⚖️¦ مـعرف آلمـطـور  : ]]..SUDO_USER:gsub([[\_]],'_')..[[ 🌿
👨🏽‍🔧]])
return false
end
if not ISONEBOT then
msg.adduser = msg.content_.members_[0].id_
msg.addusername = msg.content_.members_[0].username_
msg.addname = msg.content_.members_[0].first_name_
msg.adduserType = msg.content_.members_[0].type_.ID
end
end
if msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == "MessageChatJoinByLink" then 
if msg.GroupActive then
if msg.content_.ID == "MessageChatAddMembers" then
Senderid = msg.content_.members_[0].id_
else
Senderid = msg.sender_user_id_
end
if not msg.Special and not msg.Admin and redis:get(boss.."lock_Add"..msg.chat_id_) then
kick_user(Senderid, msg.chat_id_,function(arg,data)
StatusLeft(msg.chat_id_,Senderid)
end)
end
if redis:get(boss..'mute_tgservice'..msg.chat_id_) then
Del_msg(msg.chat_id_,msg.id_)
return false 
else
if redis:get(boss.."lock_check"..msg.chat_id_) and not redis:get(boss..":TqeedUser:"..msg.chat_id_..Senderid) then
local text = "⚜️┇ اهلاً بك في المجموعة\n🛠┇ للتأكد بأنك لست { ربوت }\n⚠️┇ تم تقييدك اضغط الزر بالاسفل\n💡┇ للتأكد انك { عضو حقيقي }🌻👇🏾"
local inline = {{{text="• أضـغط ۿـنا للتـأكد أنك لست ربوت ♻️",callback_data="CheckRobotJoin:"..Senderid}}}
Restrict(msg.chat_id_,Senderid,1)
return send_inline(msg.chat_id_,text,inline,msg.id_)
end
end
end
if ISONEBOT then return false end
end
-- [[ المحظورين عام ]]
if GeneralBanned((msg.adduser or msg.sender_user_id_)) then
print('\27[1;31m is_G_BAN_USER\27[0m')
Del_msg(msg.chat_id_,msg.id_)
kick_user((msg.adduser or msg.sender_user_id_),msg.chat_id_)
return false 
end
--[[ المكتومين ]]
if msg.GroupActive and MuteUser(msg.chat_id_,msg.sender_user_id_) then 
if msg.Special or msg.Admin then redis:srem(boss..'is_silent_users:'..msg.chat_id_,msg.sender_user_id_) return false end
print("\27[1;31m User is Silent\27[0m")
Del_msg(msg.chat_id_,msg.id_)
return false 
end
--[[ المحظورين ]]
if msg.GroupActive and Check_Banned(msg.chat_id_,(msg.adduser or msg.sender_user_id_)) then
if msg.Special then redis:srem(boss..'banned:'..msg.chat_id_,msg.sender_user_id_) return end
print('\27[1;31m is_BANED_USER\27[0m')
Del_msg(msg.chat_id_, msg.id_)
kick_user((msg.adduser or msg.sender_user_id_), msg.chat_id_)
return false 
end
if msg.GroupActive and not msg.Special and not msg.Admin then
if redis:get(boss..'mute_text'..msg.chat_id_) then --قفل الدردشه
print("\27[1;31m Chat is Mute \27[0m")
Del_msg(msg.chat_id_,msg.id_)
return false 
end
if msg.content_.ID == "MessageText" then
Type_id = msg.content_.text_
elseif msg.content_.ID == 'MessagePhoto' then
if msg.content_.photo_.sizes_[3] then Type_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_ else Type_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_ end
elseif msg.content_.ID == "MessageSticker" then
Type_id = msg.content_.sticker_.sticker_.persistent_id_
elseif msg.content_.ID == "MessageVoice" then
Type_id = msg.content_.voice_.voice_.persistent_id_
elseif msg.content_.ID == "MessageAnimation" then
Type_id = msg.content_.animation_.animation_.persistent_id_
elseif msg.content_.ID == "MessageVideo" then
Type_id = msg.content_.video_.video_.persistent_id_
elseif msg.content_.ID == "MessageAudio" then
Type_id = msg.content_.audio_.audio_.persistent_id_
else
Type_id = 0
end
if FilterX(msg,Type_id) then --[[ الكلمات الممنوعه ]]
return false
end 
end 
if ScriptFile and ScriptFile.Boss then 
if msg.text and ScriptFile.iBoss then
XBoss = ScriptFile.Boss
local list = redis:hgetall(boss..":AwamerBotArray:"..msg.chat_id_)
for Boss2,k in pairs(list) do
Text = msg.text
Text2 = k
if Text:match(Boss2) then 
local amrr = {Text:match(Boss2)}
local AmrOld = redis:hgetall(boss..":AwamerBotArray2:"..msg.chat_id_)
amrnew = "" amrold = ""
for Amor,ik in pairs(AmrOld) do
if Text2:match(ik) then	
if amrr[1] == Amor then
amrnew = Amor ; amrold = ik   
end end end
Text = Text:gsub(amrnew,amrold)
AF = CheckBotA(msg) if AF then return sendMsg(msg.chat_id_,msg.id_,AF) end 
GetMsg = ScriptFile.iBoss(msg,{Text:match(Text2)})
if GetMsg then
print("\27[1;35m¦This_Msg : "..Text2.."  | Plugin is: \27[1;32mScript.lua\27[0m")
sendMsg(msg.chat_id_,msg.id_,GetMsg)
return false
end 
end
end
for k, Boss in pairs(XBoss) do
Text = msg.text
Text = Text:gsub("ی","ي")
Text = Text:gsub("ک","ك")
Text = Text:gsub("ه‍","ه")
if Text:match(Boss) then -- Check Commands To admin
AF = CheckBotA(msg) if AF then return sendMsg(msg.chat_id_,msg.id_,AF) end 
GetMsg = ScriptFile.iBoss(msg,{Text:match(Boss)})
if GetMsg then
print("\27[1;35m¦This_Msg : ",Boss.." | Plugin is: \27[1;32mScript.lua\27[0m")
sendMsg(msg.chat_id_,msg.id_,GetMsg)
return false
end 
end
end
end  --- End iBoss
if ScriptFile.dBoss then
if ScriptFile.dBoss(msg) == false then
return false
end
print("\27[1;35m¦Msg_IN_Process : Proc _ Script.lua\27[0m")
end
for name,Plug in pairs(File) do
if Plug.Boss then 
if msg.text and Plug.iBoss then
for k, Boss in pairs(Plug.Boss) do
if msg.text:match(Boss) then
local GetMsg = Plug.iBoss(msg,{msg.text:match(Boss)})
if GetMsg then
print("\27[1;35m¦This_Msg : ",Boss.." | Plugin is: \27[1;32m"..name.."\27[0m")
sendMsg(msg.chat_id_,msg.id_,GetMsg)
end 
return false
end
end
end
if Plug.dBoss then
Plug.dBoss(msg)
print("\27[1;35m¦Msg_IN_Process : \27[1;32"..name.."\27[0m")
end
else
print("The File "..name.." Not Runing in The Source Boss")
end 
end
else
print("The File Script.lua Not Runing in The Source Boss")
end
end
function tdcli_update_callback(data)
local msg = data.message_
if data.ID == "UpdateMessageSendFailed" then 
if msg and msg.sender_user_id_ then
redis:srem(boss..'users',msg.sender_user_id_)
end
elseif data.ID == "UpdateNewCallbackQuery" then
local datab = data.payload_.data_ 
local UserID = data.sender_user_id_
local ChatID = data.chat_id_
local dataid = data.message_id_
local Text,UserJoin = datab:match("^(CheckRobotJoin:)(%d+)$")
local UserJoin = tonumber(UserJoin)
if Text == "CheckRobotJoin:" then
local Adminn = false
if UserID == SUDO_ID then 
Adminn = true
elseif redis:sismember(boss..':SUDO_BOT:',UserID) then 
Adminn = true
elseif redis:sismember(boss..':MONSHA_BOT:'..ChatID,UserID) then 
Adminn = true
elseif redis:sismember(boss..':MONSHA_Group:'..ChatID,UserID) then 
Adminn = true
elseif redis:sismember(boss..'owners:'..ChatID,UserID) then 
Adminn = true
elseif redis:sismember(boss..'admins:'..ChatID,UserID) then 
Adminn = true
elseif UserID == UserJoin then 
Adminn = true
end	
if Adminn then
Restrict(ChatID,UserJoin,2)
answerCallbackQuery(data.id_,"👍🏻|تم فك التقييد بنجاح والتأكد بانك لست روبوت ❤️",true)
EditMsg(ChatID,dataid,"👍🏻|تم فك التقييد بنجاح والتأكد بانك لست روبوت ❤️")
else
answerCallbackQuery(data.id_,"عذرا انت لست الشخص المقيد او لا يوجد لديك صلاحيه الادارة , نعتذر منك",true)	
end
else
--	answerCallbackQuery(data.id_,"امر غير معرف",true)
end
elseif data.ID == "UpdateMessageSendSucceeded" then
local msg = data.message_
if msg.content_.text_ then
if redis:get(boss..":propin"..msg.chat_id_) == msg.content_.text_ then
redis:del(boss..":propin"..msg.chat_id_)
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,d) end,nil)   
end
end
if Refresh_Start then
Refresh_Start = false
Start_Bot()
return false
end
if UpdateSourceStart then
UpdateSourceStart = false
UpdateSource(msg,true)
end
elseif data.ID == "UpdateNewMessage" then
if msg.content_.ID == "MessageText" then
if msg.content_.entities_ and msg.content_.entities_[0] and msg.content_.entities_[0].ID then
if msg.content_.entities_[0].ID == "MessageEntityTextUrl" then
msg.textEntityTypeTextUrl = true
print("MessageEntityTextUrl")
elseif msg.content_.entities_[0].ID == "MessageEntityBold" then 
msg.textEntityTypeBold = true
elseif msg.content_.entities_[0].ID == "MessageEntityItalic" then
msg.textEntityTypeItalic = true
print("MessageEntityItalic")
elseif msg.content_.entities_[0].ID == "MessageEntityCode" then
msg.textEntityTypeCode = true
print("MessageEntityCode")
end
end
msg.text = msg.content_.text_
if (msg.text=="تحديث" or msg.text=="we" or msg.text=="تحديث ♻️") and msg.sender_user_id_ == SUDO_ID then
return sendMsg(msg.chat_id_,msg.id_," 🗂¦ تہ‏‏م تحديث آلمـلفآت \n✓",function(arg,data)
Refresh_Start = true
end)
end 
if msg.text == 'Update Source' and msg.sender_user_id_ == SUDO_ID then
UpdateSource(msg)
sendMsg(msg.chat_id_,msg.id_,'👷🏽| {* تــم تحديث وتثبيت السورس  *} 📡.\n\n👨🏼‍💼| { Bot is Update » }👍🏿',function(arg,data)
dofile("./inc/Run.lua")
print("Reload ~ ./inc/Run.lua")
end) 
end
if (msg.text == 'reload' or msg.text == "أعادة التشغيل 🔌") and msg.sender_user_id_ == SUDO_ID then
sendMsg(msg.chat_id_,msg.id_,'👷🏽| {* تــم أعـاده تشغيل البوت  *} 📡.\n\n👨🏼‍💼| { Bot is Reloaded » }👍🏿',function(arg,data)
dofile("./inc/Run.lua")
print("Reload ~ ./inc/Run.lua")
end)
return false
end
end 
input_inFo(msg)
elseif data.ID == "UpdateNewChat" then  
if redis:get(boss..'group:add'..data.chat_.id_) then
redis:set(boss..'group:name'..data.chat_.id_,data.chat_.title_)
end
elseif data.ID == "UpdateChannel" then  
if data.channel_.status_.ID == "ChatMemberStatusKicked" then 
if redis:get(boss..'group:add-100'..data.channel_.id_) then
local linkGroup = (redis:get(boss..'linkGroup-100'..data.channel_.id_) or "")
local NameGroup = (redis:get(boss..'group:name-100'..data.channel_.id_) or "")
send_msg(SUDO_ID,"📛| قام شخص بطرد البوت من المجموعه الاتيه : \n🏷| ألايدي : `-100"..data.channel_.id_.."`\n🗯| الـمجموعه : "..Flter_Markdown(NameGroup).."\n\n📮| تـم مسح كل بيانات المجموعه بنـجاح ")
rem_data_group('-100'..data.channel_.id_)
end
end
elseif data.ID == "UpdateFile" then 
if Uploaded_Groups_Ok then
Uploaded_Groups_Ok = false
local GetInfo = io.open(data.file_.path_, "r"):read('*a')
local All_Groups = JSON.decode(GetInfo)
for k,IDS in pairs(All_Groups.Groups) do
redis:mset(
boss..'group:name'..k,IDS.Title,
boss..'num_msg_max'..k,5,
boss..'group:add'..k,true,
boss..'lock_link'..k,true,
boss..'lock_spam'..k,true,
boss..'lock_webpage'..k,true,
boss..'lock_markdown'..k,true,
boss..'lock_flood'..k,true,
boss..'lock_bots'..k,true,
boss..'mute_forward'..k,true,
boss..'mute_contact'..k,true,
boss..'mute_document'..k,true,
boss..'mute_inline'..k,true,
boss..'lock_username'..k,true,
boss..'replay'..k,true
)
redis:sadd(boss..'group:ids',k) 
if IDS.Admins then
for user,ID in pairs(IDS.Admins) do
redis:hset(boss..'username:'..ID,'username',user)
redis:sadd(boss..'admins:'..k,ID)
end
end
if IDS.Creator then
for user,ID in pairs(IDS.Creator) do
redis:hset(boss..'username:'..ID,'username',user)
redis:sadd(boss..':MONSHA_BOT:'..k,ID)
end
end
if IDS.Owner then
for user,ID in pairs(IDS.Owner) do
redis:hset(boss..'username:'..ID,'username',user)
redis:sadd(boss..'owners:'..k,ID)
end
end
end
io.popen("rm -fr ../.telegram-cli/data/document/*")
sendMsg(Uploaded_Groups_CH,Uploaded_Groups_MS,'📦*¦* تم رفع آلنسـخهہ‏‏ آلآحتيآطـيهہ\n⚖️*¦* حآليآ عدد مـجمـوعآتگ هہ‏‏يهہ‏‏ *'..redis:scard(boss..'group:ids')..'* 🌿\n✓')
end
elseif data.ID == "UpdateUser" then  
if data.user_.type_.ID == "UserTypeDeleted" then
print("¦ userTypeDeleted")
redis:srem(boss..'users',data.user_.id_)
elseif data.user_.type_.ID == "UserTypeGeneral" then
local CheckUser = redis:hgetall(boss..'username:'..data.user_.id_).username
if data.user_.username_  then 
USERNAME = '@'..data.user_.username_
else
USERNAME = data.user_.first_name_..' '..(data.user_.last_name_ or "" )
end	
if CheckUser and CheckUser ~= USERNAME  then
print("¦ Enter Update User ")
redis:hset(boss..'username:'..data.user_.id_,'username',USERNAME)
end 
end
elseif data.ID == "UpdateMessageEdited" then
GetMsgInfo(data.chat_id_,data.message_id_,function(arg,data)
msg = data
msg.edited = true
msg.text = data.content_.text_
input_inFo(msg)  
end,nil)
elseif data.ID == "UpdateOption" and data.value_.value_ == "Ready" then
UpdateSource() dofile("./inc/Run.lua")
tdcli_function({ID='GetChat',chat_id_ = SUDO_ID},function(arg,data)end,nil)
end
end
