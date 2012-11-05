-- tpBatch
tpBatch = class()

-- customization: default sprite pack for TexturePacker atlases
local _defaultSpritePack = "Documents"

--
-- TODO: 
--    1. Directly set mesh verts instead of using addRect()/setRect()
--    2. Add methods similar to Codea's sprite drawing, style,
--       and matrix functions, and have them affect sprite drawing:
--        * scale(), rotate(), translate()
--        * push/pop/apply/resetMatrix()
--        * spriteMode()
--        * push/pop/resetStyle() (only spriteMode will be supported)
--

function tpBatch:init(atlasData, spritePack)
    spritePack = spritePack or _defaultSpritePack
    
    self.mesh = mesh()
    self.mesh.texture = spritePack..":"..atlasData.texture.name
    self.frames = atlasData.frames
    
    self.indices = {}
    self.nextSprite = 1
    self.spritesLastFrame = 0
    
end

local function _debugDraw(self, x, y, w, h, sx, sy, r)
    local stack = self.modeStack
    pushStyle()
    fill(255, 255, 255, 128)
    rectMode(CENTER)
    pushMatrix()
    translate(x, y)
    rotate(math.deg(r))
    rect(0, 0, w*sx, h*sy)
    popMatrix()
    popStyle()    
end

local function _getargs(...)
    local narg = arg["n"]
    
    if narg == 2 then
        return arg[1], arg[2], 0, 1, 1
    elseif narg == 3 then
        return arg[1], arg[2], math.rad(arg[3]), 1, 1
    elseif narg == 4 then
        local _scale = arg[4]
        return arg[1], arg[2], math.rad(arg[3]), _scale, _scale
    elseif narg == 5 then
        return arg[1], arg[2], math.rad(arg[3]), arg[4], arg[5]
    end
    
    return 0, 0, 0, 1, 1
end

-- sprite(x, y, r, scaleX, scaleY)
function tpBatch:sprite(spriteName, ...)
    local frame = self.frames[spriteName]
    local size, uvRect = frame.frameSize, frame.uvRect
    local x, y, r, sx, sy = _getargs(...)
    local w, h = size.w, size.h
    
    if frame.rotated then r = r + 1.5708 end

    local indices, mesh = self.indices, self.mesh    
    if self.nextSprite > #indices then
        local idx = mesh:addRect(x, y, w*sx, h*sy, r)
        mesh:setRectTex(idx, uvRect.s, uvRect.t, uvRect.tw, uvRect.th)
        table.insert(indices, idx)
    else
        local idx = indices[self.nextSprite]
        mesh:setRect(idx, x, y, w*sx, h*sy, r)
        mesh:setRectTex(idx, uvRect.s, uvRect.t, uvRect.tw, uvRect.th)        
    end
    
    self.nextSprite = self.nextSprite + 1    
    
    --_debugDraw(self, x, y, w, h, sx, sy, r)
end

function tpBatch:spriteSize(spriteName)
    local frame = self.frames[spriteName]
    local size = frame.sourceSize
    return size.w, size.h
end

function tpBatch:frameSize(spriteName)
    local frame = self.frames[spriteName]
    local size = frame.frameSize
    
    if frame.rotated then
        return size.h, size.w
    end
    
    return size.w, size.h
end

function tpBatch:draw()
    local indices = self.indices
    
    -- zero out unused sprites
    for i = self.nextSprite, self.spritesLastFrame do
        self.mesh:setRect(indices[i], 0, 0, 0, 0, 0)
    end
    
    self.mesh:draw()
    
    -- reset for next frame
    self.spritesLastFrame = self.nextSprite - 1
    self.nextSprite = 1
end
