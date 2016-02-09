--[[ ====================================== ]]--

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	love.graphics.setNewFont("fnt/SomepxRegular.ttf", 64)

	screen = {}

	music = love.audio.newSource("audio/bgm/bmsr.wav", "stream")
	music:setLooping(true)
	music:setVolume(0.25)
	sfxBtn = love.audio.newSource("audio/sfx/btnp.wav", "static")
	sfxError = love.audio.newSource("audio/sfx/error.wav", "static")
	sfxStar = love.audio.newSource("audio/sfx/star.wav", "static")

	showMenu()
end

--[[ ================================ ]]--

function love.draw()
	screen.draw()
end

--[[ ================================ ]]--

function love.update()
	screen.update()
end

--[[ ================================ ]]--

function showMenu()
	love.graphics.setColor(255, 255, 255, 255)
	love.audio.play(music)

	screen.draw = drawMenu;
	screen.update = updateMenu;

	bgMenu = love.graphics.newImage("gfx/title.png")

	t = 0
	goal = 100
	exitDelta = 0

	left = {}
	left.isPressed = false
	left.wasPressed = false
	left.justPressed = false
	right = {}
	right.isPressed = false
	right.wasPressed = false
	right.justPressed = false
end

--[[ ================================ ]]--

function drawMenu()
	love.graphics.draw(bgMenu, 0, 0, 0, 2)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("goal", 222, 302, 200, "center")
	love.graphics.printf("< " .. goal .. " >", 222, 332, 200, "center")

	if t < 80 then
		love.graphics.printf("press z or m to start", 2, 392, 640, "center")
	end

	love.graphics.setColor(64, 64, 64, 255)
	love.graphics.printf("goal", 220, 300, 200, "center")
	love.graphics.printf("< " .. goal .. " >", 220, 330, 200, "center")

	if t < 80 then
		love.graphics.printf("press z or m to start", 0, 390, 640, "center")
	end

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.setColor(0, 0, 0, (255 / 100) * exitDelta)
	love.graphics.rectangle("fill", 0, 0, 640, 480)
	love.graphics.setColor(255, 255, 255, 255)
end

--[[ ================================ ]]--

function updateMenu()
	if love.keyboard.isDown("escape") then
		exitDelta = exitDelta + 1
		if exitDelta > 100 then
			love.event.push("quit")
		end
	else
		exitDelta = 0
	end

	t = t + 1
	if t > 100 then
		t = 0
	end

	left.wasPressed = left.isPressed
	left.isPressed = love.keyboard.isDown("a") or love.keyboard.isDown("left")
	left.justPressed = left.isPressed and not left.wasPressed
	right.wasPressed = right.isPressed
	right.isPressed = love.keyboard.isDown("d") or love.keyboard.isDown("right")
	right.justPressed = right.isPressed and not right.wasPressed

	if left.justPressed then
		if goal > 100 then
			sfxStar:stop()
			sfxStar:play()
			goal = goal - 50
		end
	elseif right.justPressed then
		if goal < 500 then
			sfxStar:stop()
			sfxStar:play()
			goal = goal + 50
		end
	end

	if love.keyboard.isDown("z") or love.keyboard.isDown("m") then
		showGame()
	end
end

--[[ ================================ ]]--

function showGame()
	love.graphics.setColor(255, 255, 255, 255)

	screen.draw = drawGame
	screen.update = updateGame

	background = love.graphics.newImage("gfx/back.png")

	stars = {}
	stars.t = 0
	stars.next = randomTime()
	starSprite = {}
	starSprite.t = 0
	starSprite[1] = love.graphics.newImage("gfx/star/star1.png")
	starSprite[2] = love.graphics.newImage("gfx/star/star2.png")
	starSprite[3] = love.graphics.newImage("gfx/star/star3.png")
	starSprite[4] = love.graphics.newImage("gfx/star/star4.png")
	starSprite[5] = love.graphics.newImage("gfx/star/star5.png")
	starSprite[6] = love.graphics.newImage("gfx/star/star6.png")

	playerSprite = {}
	playerSprite[1] = love.graphics.newImage("gfx/player/player1.png")
	playerSprite[2] = love.graphics.newImage("gfx/player/player2.png")
	playerSprite[3] = love.graphics.newImage("gfx/player/player3.png")

	player1 = {}
	player1.t = 0
	player1.counter = 0
	player1.isPressed = false
	player1.wasPressed = false
	player1.justPressed = false

	player2 = {}
	player2.t = 0
	player2.counter = 0
	player2.isPressed = false
	player2.wasPressed = false
	player2.justPressed = false

	podium = love.graphics.newImage("gfx/podium.png")

	globalCounter = 0
	winner = 0
end

--[[ ================================ ]]--

function drawGame()
	love.graphics.draw(background, 0, 0, 0, 2)

	-- stars
	for i, st in ipairs(stars) do
		love.graphics.draw(starSprite[math.floor(starSprite.t / 4) + 1], st.x, st.y, 0, 2)
	end

	-- players
	love.graphics.draw(podium, 4, 416, 0, 2)
	love.graphics.draw(podium, 508, 416, 0, 2)

	if player1.t < 0 then
		love.graphics.draw(playerSprite[3], 32, 369, 0, 2)
	else
		love.graphics.draw(playerSprite[math.floor(player1.t / 25) + 1], 32, 369, 0, 2)
	end

	if player2.t < 0 then
		love.graphics.draw(playerSprite[3], 608, 369, 0, -2, 2)
	else
		love.graphics.draw(playerSprite[math.floor(player2.t / 25) + 1], 608, 369, 0, -2, 2)
	end

	-- scores
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf(globalCounter, 222, 34, 200, "center")
	love.graphics.printf(player1.counter .. "/" .. goal, -5, 266, 150, "center")
	love.graphics.printf(player2.counter .. "/" .. goal, 499, 266, 150, "center")
	love.graphics.setColor(64, 64, 64, 255)
	love.graphics.printf(globalCounter, 220, 32, 200, "center")
	love.graphics.printf(player1.counter .. "/" .. goal, -7, 264, 150, "center")
	love.graphics.printf(player2.counter .. "/" .. goal, 497, 264, 150, "center")
	love.graphics.setColor(255, 255, 255, 255)
end

--[[ ================================ ]]--

function updateGame()
	if love.keyboard.isDown("escape") then
		showMenu()
	end

	stars.t = stars.t + 1
	if stars.t > stars.next then
		stars.t = 0
		stars.next = randomTime()
		genStar()
	end

	starSprite.t = starSprite.t + 1
	if starSprite.t >= 24 then
		starSprite.t = 0
	end

	for i, st in ipairs(stars) do
		st.y = st.y + 10
		if st.y > 480 then
			sfxStar:stop()
			sfxStar:play()
			table.remove(stars, i)
			globalCounter = globalCounter + 1
		end
	end

	player1.t = player1.t + 1
	if player1.t >= 50 then
		player1.t = 0
	end

	player2.t = player2.t + 1
	if player2.t >= 50 then
		player2.t = 0
	end

	player1.wasPressed = player1.isPressed
	player1.isPressed = love.keyboard.isDown("z")
	player1.justPressed = player1.isPressed and not player1.wasPressed
	player2.wasPressed = player2.isPressed
	player2.isPressed = love.keyboard.isDown("m")
	player2.justPressed = player2.isPressed and not player2.wasPressed

	if player1.justPressed then
		playSound()
		player1.t = -25
		player1.counter = player1.counter + globalCounter
		globalCounter = 0
		resetStars()

		if player1.counter >= goal then
			winner = 1
			showGameOver()
		end
	end

	if player2.justPressed then
		playSound()
		player2.t = -25
		player2.counter = player2.counter + globalCounter
		globalCounter = 0
		resetStars()

		if player2.counter >= goal then
			winner = 2
			showGameOver()
		end
	end
end

--[[ ================================ ]]--

function showGameOver()
	love.graphics.setColor(255, 255, 255, 255)

	screen.update = updateGameOver
	screen.draw = drawGameOver

	background = love.graphics.newImage("gfx/back.png")
	love.audio.stop(music)

	t = 0
end

--[[ ================================ ]]--

function updateGameOver()
	t = t + 1
	if t > 300 then
		t = 0
		showMenu()
	end
end

--[[ ================================ ]]--

function drawGameOver()
	love.graphics.draw(background, 0, 0, 0, 2)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("winner", 222, 202, 200, "center")

	if winner == 1 then
		love.graphics.printf("< player 1", 222, 242, 200, "center")
	elseif winner == 2 then
		love.graphics.printf("player 2 >", 222, 242, 200, "center")
	end

	love.graphics.setColor(64, 64, 64, 255)
	love.graphics.printf("winner", 220, 200, 200, "center")

	if winner == 1 then
		love.graphics.printf("< player 1", 220, 240, 200, "center")
	elseif winner == 2 then
		love.graphics.printf("player 2 >", 220, 240, 200, "center")
	end

	love.graphics.setColor(255, 255, 255, 255)

	if winner == 1 then
		love.graphics.draw(podium, 4, 416, 0, 2)
		love.graphics.draw(playerSprite[3], 32, 369, 0, 2)

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(player1.counter .. "/" .. goal, -5, 266, 150, "center")
		love.graphics.setColor(64, 64, 64, 255)
		love.graphics.printf(player1.counter .. "/" .. goal, -7, 264, 150, "center")
		love.graphics.setColor(255, 255, 255, 255)
	elseif winner == 2 then
		love.graphics.draw(podium, 508, 416, 0, 2)
		love.graphics.draw(playerSprite[3], 608, 369, 0, -2, 2)

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(player2.counter .. "/" .. goal, 499, 266, 150, "center")
		love.graphics.setColor(64, 64, 64, 255)
		love.graphics.printf(player2.counter .. "/" .. goal, 497, 264, 150, "center")
		love.graphics.setColor(255, 255, 255, 255)
	end
end

--[[ ================================ ]]--

function playSound()
	if globalCounter > 0 then
		sfxBtn:stop()
		sfxBtn:play()
	else
		sfxError:stop()
		sfxError:play()
	end
end

--[[ ================================ ]]--

function genStar()
	star = {}
	star.y = -36
	star.x = math.random(136, 478)
	table.insert(stars, star)
end

--[[ ================================ ]]--

function resetStars()
	stars = {}
	stars.t = 0
	stars.next = randomTime()
end

--[[ ================================ ]]--

function randomTime()
	return math.random(2, 8)
end

--[[ ================================ ]]--

--[[ ====================================== ]]--
--[[ | Made by Neko250 with a bunch of <3 | ]]--
--[[ ====================================== ]]--
