

function love.load()
	--requires
	funct_lib = require('Client.libraries.func')
	extended_math = require('Client.libraries.extended_math')
	anim8 = require('libraries.anim8')
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	--networking
	local socket = require "socket"
	local address, port = "localhost", 12345
	udp = socket.udp()
	udp:setpeername(address, port)
	udp:settimeout(0)

	--player
	player = {}
	player.id = 0
	player.x = 50
	player.y = 50
	player.rot = 2
	player.beam = false
	player.speed = 0.5
	splinePoints = {}

	player.spriteSheet = love.graphics.newImage('sprites/YellowBikeSheet.png')
	player.grid = anim8.newGrid(55, 55, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

	player.animations = {}
	player.animations.up = anim8.newAnimation(player.grid('1-1', 1), 0.1)
	player.animations.right = anim8.newAnimation(player.grid('2-2', 1), 0.1)
	player.animations.down = anim8.newAnimation(player.grid('3-3', 1), 0.1)
	player.animations.left = anim8.newAnimation(player.grid('4-4', 1), 0.1)

	player.anim = player.animations.down

	--variables
	enable_gameplay = false
	gameplayState = {}
	--isUserInput = false
end

function love.update(dt)
ww = love.graphics.getWidth()
wh = love.graphics.getHeight()
isUserInput = false

	--gameplay run/stop
	if love.keyboard.isDown("r") and not oldR then
		enable_gameplay = not enable_gameplay
	end

	--handle player inputs and movement
	if enable_gameplay then
		if love.keyboard.isDown("w") and not oldW then
			player.rot = 0
			player.anim = player.animations.up
			isUserInput = true
		end
		if love.keyboard.isDown("s") and not oldS then
			player.rot = 2
			player.anim = player.animations.down
			isUserInput = true
		end
		if love.keyboard.isDown("d") and not oldD then
			player.rot = 1
			player.anim = player.animations.right
			isUserInput = true
		end
		if love.keyboard.isDown("a") and not oldA then
			player.rot = 3
			player.anim = player.animations.left
			isUserInput = true
		end
		if love.keyboard.isDown("space") and not oldSpace then
			player.beam = not player.beam
			if player.beam then
				table.insert(splinePoints, {player.x, player.y})
			else
				table.insert(splinePoints, {player.x, player.y, true})
			end
		end

		if player.rot == 0 then
			player.y = player.y - player.speed
		end
		if player.rot == 1 then
			player.x = player.x + player.speed
		end
		if player.rot == 2 then
			player.y = player.y + player.speed
		end
		if player.rot == 3 then
			player.x = player.x - player.speed
		end
	end

--animation updates
player.anim:update(dt)

--set olds to true
oldR = love.keyboard.isDown("r")
oldSpace = love.keyboard.isDown("space")
oldW = love.keyboard.isDown("w")
oldA = love.keyboard.isDown("a")
oldS = love.keyboard.isDown("s")
oldD = love.keyboard.isDown("d")
oldbeam = player.lightbeam
end

function love.draw()


	love.graphics.setColor(1, 1, 0)
	--if player.beam then
		if #splinePoints == 0 then
			table.insert(splinePoints, {player.x, player.y})
		end
		if isUserInput then
			table.insert(splinePoints, {player.x, player.y})
		end
		x, y = player.x, player.y
		for i, v in ipairs(splinePoints) do
			if #splinePoints == i then
				love.graphics.line(v[1], v[2], player.x, player.y)
			end
		end

		love.graphics.line(x, y, player.x, player.y)
	--end
	for i, v in ipairs(splinePoints) do
		if i ~= 1 and not v[3] then
			love.graphics.line(v[1], v[2], x, y)
		end
		x, y = v[1], v[2]
	end
	
	--draw player
	player.anim:draw(player.spriteSheet, player.x-41.25, player.y-41.25, nil, 1.5)

	--debug
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Players: "..#player
					.."\nenable gameplay: "..boolToString(enable_gameplay)
					.."\nlight beam: "..boolToString(player.beam)
					.."\nplayer rot: "..player.rot
					.."\nspline: "..#splinePoints
					.."\nisUserInput: "..boolToString(isUserInput))
end