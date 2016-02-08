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
	love.audio.play(music)

	showMenu()
end

function love.draw()
	screen.draw()
end

function love.update()
	screen.update()
end

function showMenu()
	love.graphics.setColor(255, 255, 255, 255)

	screen.draw = drawMenu;
	screen.update = updateMenu;

	bgMenu = love.graphics.newImage("gfx/title.png")
	sprPush = love.graphics.newImage("gfx/press.png")

	t = 0
	exitDelta = 0
end

function drawMenu()
	love.graphics.draw(bgMenu, 0, 0, 0, 2)

	if t < 80 then
		love.graphics.draw(sprPush, 116, 420, 0, 2)
	end

	love.graphics.setColor(0, 0, 0, (255 / 100) * exitDelta)
	love.graphics.rectangle("fill", 0, 0, 640, 480)
	love.graphics.setColor(255, 255, 255, 255)
end

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

	if love.keyboard.isDown("z") or love.keyboard.isDown("m") then
		showGame()
	end
end

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
end

function drawGame()
	love.graphics.draw(background, 0, 0, 0, 2)

	for i, st in ipairs(stars) do
		love.graphics.draw(starSprite[math.floor(starSprite.t / 4) + 1], st.x, st.y, 0, 2)
	end

	love.graphics.draw(podium, 4, 416, 0, 2)
	love.graphics.draw(podium, 508, 416, 0, 2)

	love.graphics.draw(playerSprite[math.floor(player1.t / 25) + 1], 32, 369, 0, 2)
	love.graphics.draw(playerSprite[math.floor(player2.t / 25) + 1], 608, 369, 0, -2, 2)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(globalCounter, 302, 34)
	love.graphics.print(player1.counter, 26, 266)
	love.graphics.print(player2.counter, 526, 266)
	love.graphics.setColor(64, 64, 64, 255)
	love.graphics.print(globalCounter, 300, 32)
	love.graphics.print(player1.counter, 24, 264)
	love.graphics.print(player2.counter, 524, 264)
	love.graphics.setColor(255, 255, 255, 255)
end

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
		st.y = st.y + 8
		if st.y > 480 then
			sfxStar:stop()
			sfxStar:play()
			table.remove(stars, i)
			globalCounter = globalCounter + 1
		end
	end

	player1.t = player1.t + 1
	if player1.t > 50 then
		player1.t = 0
	end

	player2.t = player2.t + 1
	if player2.t > 50 then
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
		player1.counter = player1.counter + globalCounter
		globalCounter = 0
		resetStars()
	end

	if player2.justPressed then
		playSound()
		player2.counter = player2.counter + globalCounter
		globalCounter = 0
		resetStars()
	end
end

function playSound()
	if globalCounter > 0 then
		sfxBtn:stop()
		sfxBtn:play()
	else
		sfxError:stop()
		sfxError:play()
	end
end

function genStar()
	star = {}
	star.y = -36
	star.x = math.random(136, 478)
	table.insert(stars, star)
end

function resetStars()
	stars = {}
	stars.t = 0
	stars.next = randomTime()
end

function randomTime()
	return math.random(5, 10)
end
