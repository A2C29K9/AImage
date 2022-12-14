local api = 'http://261090.proxy.nscc-gz.cn:8888/img2img'
local raw = msg.fromMsg
local images = raw:sub(#'/i2i' + 1)

if not images:match("%[CQ:image") then return "笨蛋{nick},你的图呢？" end
-- 以图绘图核心 :s
if images:match('%[CQ:image(.*)http') then
    url = "https://" .. raw:match('https?://(.*)%]')
else
    url = 'https://gchat.qpic.cn/gchatpic_new/0/0-0-' .. images:match('{(.*)}'):gsub('-', '') .. '/0'
end

local json = require('json')
local seed = ranint(0, 1919810)
local tab = {}
local prompt = 'masterpiece, best quality, ' .. images:gsub('%[(.*)%]', ' ')
local whlstfromGroup = { 971050440, 10086 } --白名单群
local whlstfromQQ = { 2753364619, 1712724531 } --白名单用户
local enableTranslate = 1 -- 1为开启

tab['prompt'] = prompt
tab['width'] = 768
tab['height'] = 512
tab['cfg_scale'] = 7
tab['n_iter'] = 1
tab['steps'] = 20
tab['seed'] = seed
tab['batch_size'] = 1
tab['url'] = url
tab['sampler_index'] = 'Euler'
tab['negative_prompt'] =
'nsfw,{{{ugly}}}, {{{duplicate}}}, {{morbid}}, {{mutilated}}, {{{tranny}}}, mutated hands,{{{poorly drawn hands}}}, blurry, {{bad anatomy}},{{{bad proportions}}}, extra limbs, cloned face,{{{disfigured}}}, {{{more than 2 nipples}}}, {{{{missing arms}}}},{{{extra legs}}},mutated hands,{{{{{fused fingers}}}}}, {{{{{too many fingers}}}}}, {{{unclear eyes}}}, lowers, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality,jpeg artifacts, signature, watermark, username, blurry, bad feet, text font ui,malformed hands, long neck, missing limb,{mutated hand and finger: 1.5},{long body: 1.3},{mutation poorly drawn: 1.2}, disfigured, malformed mutated, multiple breasts, futa, yaoi, {{{{:3}}}}, {{{3d}}},sex,nipple,pussy'
local data = json.encode(tab)
for k = 1, #whlstfromGroup do
   if msg.gid == whlstfromGroup[k] and enableTranslate == 1 then
        sendMsg("i2i...(翻译已开启，可能会损失部分信息，高阶魔法师建议关闭。)", msg.fromGroup, msg.fromQQ)
        requestApi = "https://ovooa.com/API/qqfy/api.php?type=male&msg=" .. prompt
        status , translatedPrompt = http.get(requestApi)
        tab["prompt"] = translatedPrompt
        data = json.encode(tab)
        status, receive = http.post(api, data)
        image = "[CQ:image,file=" .. receive .. "]"
        return imagee
   else
        sendMsg("i2i...(翻译已关闭)", msg.fromGroup, msg.fromQQ)
        data = json.encode(tab)
        status, receive = http.post(api, data)
        image = "[CQ:image,file=" .. receive .. "]"
        return image
    end
end

for k = 1, #whlstfromQQ do
    if msg.uid == whlstfromQQ[k] and enableTranslate == 1 then
        sendMsg("i2i...(翻译已开启，可能会损失部分信息，高阶魔法师建议关闭。)", msg.fromGroup, msg.fromQQ)
        requestApi = "https://ovooa.com/API/qqfy/api.php?type=male&msg=" .. prompt
        status , translatedPrompt = http.get(requestApi)
        tab["prompt"] = translatedPrompt
        data = json.encode(tab)
        status, receive = http.post(api, data)
        image = "[CQ:image,file=" .. receive .. "]"
        return imagee
    else
        sendMsg("i2i...(翻译已关闭)", msg.fromGroup, msg.fromQQ)
        data = json.encode(tab)
        status, receive = http.post(api, data)
        image = "[CQ:image,file=" .. receive .. "]"
        return image
    end
end
return "你没有权限哦~"
