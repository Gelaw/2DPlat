
level = {}

function love.load(arg)
  love.window.setFullscreen(true)
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  char = {}
  char.body = love.physics.newBody(world, 100, 100, "dynamic")
  char.shape = love.physics.newRectangleShape(0, 0, 100, 50)
  char.fixture = love.physics.newFixture(char.body, char.shape, 2.5) -- A higher density gives it more mass.
  char.draw = function (self)
    love.graphics.setColor(0, .8, .7)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
  char.fixture:setUserData("char")
  char.fixture:setRestitution(0.4)

  --ground
  ground = {}
  ground.body = love.physics.newBody(world, 500, 1000, "static")
  ground.shape = love.physics.newRectangleShape(0, 0, 5000, 50)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape, 5)
  ground.draw = function (self)
    love.graphics.setColor(.5, .8, 0)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
  ground.fixture:setUserData("ground")
  table.insert(level, ground)

  --ceil
  ground = {}
  ground.body = love.physics.newBody(world, 500, -1000, "static")
  ground.shape = love.physics.newRectangleShape(0, 0, 5000, 50)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape, 5)
  ground.draw = function (self)
    love.graphics.setColor(.5, .8, 0)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
  ground.fixture:setUserData("ground")
  table.insert(level, ground)

  --wallleft
    ground = {}
    ground.body = love.physics.newBody(world, -2000, 0, "static")
    ground.shape = love.physics.newRectangleShape(0, 0, 50, 2000)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 5)
    ground.draw = function (self)
      love.graphics.setColor(.5, .8, 0)
      love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
    ground.fixture:setUserData("ground")
    table.insert(level, ground)


      --wallleft
        ground = {}
        ground.body = love.physics.newBody(world, 2000, 0, "static")
        ground.shape = love.physics.newRectangleShape(0, 0, 50, 2000)
        ground.fixture = love.physics.newFixture(ground.body, ground.shape, 5)
        ground.draw = function (self)
          love.graphics.setColor(.5, .8, 0)
          love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
        end
        ground.fixture:setUserData("ground")
        table.insert(level, ground)


  ground = {}
  ground.body = love.physics.newBody(world, 200, 600, "static")
  ground.shape = love.physics.newRectangleShape(0, 0, 300, 50)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape, 5)
  ground.draw = function (self)
    love.graphics.setColor(.5, .8, 0)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
  ground.fixture:setUserData("ground")
  table.insert(level, ground)

  ball = {}
  ball.body = love.physics.newBody(world, 500, 950, "dynamic")
  ball.shape = love.physics.newCircleShape(25) --(0, 0, 90, 0, 45, 60)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape, 5)
  ball.draw = function (self)
    love.graphics.setColor(.5, .8, 0)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
    -- love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
  ball.fixture:setUserData("ball")
  table.insert(level, ball)
end

function love.draw()
  local x, y = char.body:getPosition()
  love.graphics.translate(.5*love.graphics.getWidth(),.5*love.graphics.getHeight())
  -- love.graphics.rotate(-char.body:getAngle())
  love.graphics.translate(-x, -y)
  for p, piece in pairs(level) do
    piece:draw()
  end
  char:draw()

end

function love.update(dt)
  world:update(dt) -- this puts the world into motion

  if love.keyboard.isDown("d") then --press the right arrow key to push the ball to the right
    char.body:applyForce(1200, 0)
  elseif love.keyboard.isDown("q") then --press the left arrow key to push the ball to the left
    char.body:applyForce(-1200, 0)
  end
  if love.keyboard.isDown("space") and char.grounded == true then
    char.grounded = false
    char.body:applyLinearImpulse(0, -2500)
    if char.balling then
      ball.body:applyLinearImpulse(0, -2000)
    end
  end
end

function love.keyreleased(key)
  if key == "space" then
    char.body:applyForce(0, -10)
  end
end

function beginContact(a, b, coll)
  if a:getUserData() == "char" or b:getUserData() == "char" then
    char.grounded = true
  end
  if (a:getUserData() == "char" and b:getUserData() == "ball") or (a:getUserData() == "ball" and b:getUserData() == "char") then
    char.balling = true
  end
end

function endContact(a, b, coll)
  if a:getUserData() == "char"  or b:getUserData() == "char" then
    char.grounded = false
  end
  if (a:getUserData() == "char" and b:getUserData() == "ball") or (a:getUserData() == "ball" and b:getUserData() == "char") then
    char.balling = false
  end
end
