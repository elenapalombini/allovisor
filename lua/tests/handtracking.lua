local nodeNames = {
    "palm",
    "wrist",
    "thumb_metacarpal",
    "thumb_proximal",
    "thumb_distal",
    "thumb_tip",
    "index_metacarpal",
    "index_proximal",
    "index_intermediate",
    "index_distal",
    "index_tip",
    "middle_metacarpal",
    "middle_proximal",
    "middle_intermediate",
    "middle_distal",
    "middle_tip",
    "ring_metacarpal",
    "ring_proximal",
    "ring_intermediate",
    "ring_distal",
    "ring_tip",
    "little_metacarpal",
    "little_proximal",
    "little_intermediate",
    "little_distal",
    "little_tip",
}

function lovr.load()
    models = {
        ["hand/left"] = lovr.graphics.newModel("assets/models/avatars/female/left-hand.glb"),
    }
    pbr = lovr.graphics.newShader(
        'standard',
        {
            flags = {
                normalMap = true,
                indirectLighting = true,
                occlusion = true,
                emissive = true,
                skipTonemap = false,
                animated = true,
            },
            stereo = lovr.headset == nil or (lovr.headset.getName() ~= "Pico") -- turn off stereo on pico: it's not supported
        }
    )
    pbr:send('lovrLightDirection', { -1, -1, -1 })
    pbr:send('lovrLightColor', { .9, .9, .8, 1.0 })
    pbr:send('lovrExposure', 2)
    lovr.graphics.setBackgroundColor(0.95, 0.98, 0.98)
    lovr.graphics.setColor(0,0,0)
end

function drawHand(hand)
    models[hand] = models[hand] or lovr.headset.newModel(hand)
    
    lovr.graphics.setShader()
    local x, y, z, a, ax, ay, az = lovr.headset.getPose(hand)
    lovr.graphics.cube("line", x, y, z, 0.1, a, ax, ay, az)
    for i, joint in ipairs(lovr.headset.getSkeleton(hand) or {}) do
        local px, py, pz, pa, pax, pay, paz = unpack(joint)
        lovr.graphics.push()
        lovr.graphics.transform(px, py, pz, 1, 1, 1, pa, pax, pay, paz)
        lovr.graphics.setColor(0.6, 0.2, 0.2, 0.5)
        lovr.graphics.sphere(0, 0, 0, 0.01)
        lovr.graphics.setColor(0.6,0,0)
        lovr.graphics.transform(0, 0.03, 0.0, 1, 1, 1, -3.14/2, 1, 0, 0)
        lovr.graphics.print(tostring(i-1), 0, 0.005, 0, 0.007)
        if models[hand] and i <= models[hand]:getNodeCount() then
            lovr.graphics.print(tostring(models[hand]:getNodeName(i)), 0, 0.00, 0, 0.007)
        end
        lovr.graphics.setColor(0,0.6,0)
        lovr.graphics.print(nodeNames[i], 0, -0.005, 0, 0.007)
        lovr.graphics.pop()
        --leftHand:pose(i, px, py, pz, pa, pax, pay, paz)
    end
    lovr.graphics.setColor(1, 1, 1)
    if models[hand] then
        lovr.headset.animate(hand, models[hand])
        lovr.graphics.setShader(pbr)
        models[hand]:draw(x, y, z, 1.0, a, ax, ay, az)
    end
end
function lovr.draw()
    lovr.graphics.clear()
    lovr.graphics.cube('line', 0, 1.2, -3, .5, lovr.timer.getTime())

    for _, hand in ipairs({ 'hand/left', 'hand/right' }) do
        drawHand(hand)
    end
end
  