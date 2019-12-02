-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar(display.HiddenStatusBar);

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)

local _W = display.contentWidth / 2
local _H = display.contentHeight / 2

--Musica
	local bgMusic = audio.loadStream("Menu.mp3")

local carro
local NumScore
local horizontal
local vertical
local velocidadeX = 0
local velocidadeY = -2
local pontos = 0
local faseatual
local botao
local grupotelainicial
local evento = ""
local background1
local NumZonas = 0
local Score = 0

local textBoxGroup
local textBox
local conditionDisplay
local messageText

local rnd = {}
for x = 1, 10 do
		table.insert(rnd, x)
	end
local comparar = {}
for x = 1, 10 do
		table.insert(comparar, 0)
	end

local predio1
local predio2
local predio3
local predio4
local predio5
local predio6
local predio7
local predio8
local predio9
--Main
function main()
	mostrartelainicial()
end

--Tela Inicial
function mostrartelainicial()
	audio.play(bgMusic, {loops =- 1});
		audio.setVolume(0.2)
	grupotelainicial = display.newGroup()

	--Imagem de fundo da telainicial
	local telainicial
	telainicial = display.newImage("gorila2.png", _W, _H)
	telainicial.x = _W
	telainicial.y = _H

	--Botão para Iniciar
	botao = display.newImage("jogar.png")
	botao.x = _W
	botao.y = _H + 150
	botao.name = "jogar"

	grupotelainicial:insert(telainicial)
	grupotelainicial:insert(botao)

	botao:addEventListener("tap", Iniciar)
end

--remover função do Botão
function Iniciar(event)
	if event.target.name == "jogar" then
		transition.to(grupotelainicial,{time = 400, alpha=0, onComplete = Preparar})
		botao:removeEventListener("tap", Iniciar);
	end
end


--O Jogo
function Preparar()
	--O Jogador
	carro = display.newImageRect("car6.png",_W/8,_H/6)
	carro.x = _W/1.6
	carro.y = _H*0.8
	carro.name = "taxi"

	--Os Clientes
	ZonasCliente(NumZonas)

	--Pontuação do Jogo
	TextoScore = display.newText("Score", _W, (_H*0)-25, "Arial Black", 14)
	TextoScore:setTextColor(255, 255, 255, 255)
	NumeroScore = display.newText("0", TextoScore.x, TextoScore.y+15, "Arial Black", 14)
	NumeroScore:setTextColor(255, 255, 255, 255)	

	--mudança de Fase
	MudarFaseHum()
end

function MudarFaseHum( ... )
	--Imagem de fundo
	background1 = display.newImageRect ("ruazinha.png", _W*2, _H*2.3)
	background1.x = _W
	background1.y = _H
	background1:toBack()

	--Os Predios
	predio1 = display.newImageRect("cliente.png",_H/6,_W/4)
	predio1.x = _W*0.11
	predio1.y = (_H*0)-15
	predio1.alpha = 0
	predio1.name = "predio1"

	predio2 = display.newImageRect("cliente.png",_H/3.5,_W/4)
	predio2.x = _W
	predio2.y = (_H*0)-15
	predio2.alpha = 0
	predio2.name = "predio2"

	predio3 = display.newImageRect("cliente.png",_H/6,_W/4)
	predio3.x = _W*1.88
	predio3.y = (_H*0)-15
	predio3.alpha = 0
	predio3.name = "predio3"

	predio4 = display.newImageRect("cliente.png",_H/3.3,_W*1.6)
	predio4.x = _W*0
	predio4.y = _H
	predio4.alpha = 0
	predio4.name = "predio4"

	predio5 = display.newImageRect("cliente.png",_H/3.3,_W*1.6)
	predio5.x = _W
	predio5.y = _H
	predio5.alpha = 0
	predio5.name = "predio5"

	predio6 = display.newImageRect("cliente.png",_H/3.3,_W*1.6)
	predio6.x = _W*2
	predio6.y = _H
	predio6.alpha = 0
	predio6.name = "predio6"

	predio7 = display.newImageRect("cliente.png",_H/6,_W/4)
	predio7.x = _W*0.11
	predio7.y = _H*2.08
	predio7.alpha = 0
	predio7.name = "predio7"

	predio8 = display.newImageRect("cliente.png",_H/3.5,_W/4)
	predio8.x = _W
	predio8.y = _H*2.08
	predio8.alpha = 0
	predio8.name = "predio8"

	predio9 = display.newImageRect("cliente.png",_H/6,_W/4)
	predio9.x = _W*1.88
	predio9.y = _H*2.08
	predio9.alpha = 0
	predio9.name = "predio9"

	background1:addEventListener("tap", Comecar)
end

function Comecar()
	physics.addBody(carro, "dynamic", {density = 1, friction = 0, bounce = 0})
	carro.isFixedRotation = true
	physics.addBody(predio1, "static")
	physics.addBody(predio2, "static")
	physics.addBody(predio3, "static")
	physics.addBody(predio4, "static")
	physics.addBody(predio5, "static")
	physics.addBody(predio6, "static")
	physics.addBody(predio7, "static")
	physics.addBody(predio8, "static")
	physics.addBody(predio9, "static")
	background1:removeEventListener("tap", Comecar)
	if NumZonas < 3 then
		ZonasCliente(NumZonas)
	end

	--if carro.y 
	--transition.to(removercliente,{time = 400, alpha=0, onComplete = return}) 
	--end
	gameListeners("add")
end

function updateCarro( ... )
	--movimento
	carro.y = carro.y + velocidadeY
	carro.x = carro.x + velocidadeX

	--mudar posição ao tocar no limite da tela
	if carro.x > _W*2 then
		carro.x = 0 
	elseif carro.x < 0  then
		carro.x = _W * 1.86
	end

	if carro.y > _H*2.1 then
		carro.y = (_H*0)-30
	elseif carro.y < (_H*0)-30  then
		carro.y = (_H*2)+20
	end
end

function gameListeners(evento)
	if evento == "add" then
		Runtime:addEventListener("enterFrame", updateCarro)
		Runtime:addEventListener("enterFrame", ZonasCliente)
		background1:addEventListener("tap", moverCarro)
		carro:addEventListener("collision", removercliente)
	
	elseif evento == "remove" then
		Runtime:removeEventListener("enterFrame", updateCarro)
		Runtime:removeEventListener("enterFrame", ZonasCliente)
		background1:removeEventListener("tap", moverCarro)
		carro:removeEventListener("collision", removercliente)
	end
end

function moverCarro(evento)
	if  velocidadeY < 0 then
		velocidadeX = 2
		velocidadeY = 0
		carro:rotate(90)
	elseif velocidadeY > 0 then
		velocidadeX = -2
		velocidadeY = 0 
		carro:rotate(90)
	elseif velocidadeX > 0 then
		velocidadeX = 0
		velocidadeY = 2
		carro:rotate(90)
	else 
		velocidadeX = 0
		velocidadeY = -2
		carro:rotate(90)
	end
end

function ZonasCliente( ... )
	for x = 1, 10 do
		if contains(comparar,0) == true  then

			while NumZonas < 3 do

				local function gerarNumero( ... )
					local index = math.random(1,10)
					local num = rnd[index]
					table.insert(rnd, index,0)
					table.remove(rnd,index+1)
					table.insert(comparar,index,1)
					table.remove(comparar,index+1)
					return num
				end

				local x = gerarNumero()
				
				if x==1 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/7)
				cliente.x = _W/3.5
				cliente.y = _H/1.5
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==2 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/7)
				cliente.x = _W/3.5
				cliente.y = _H
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==3 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/7)
				cliente.x = _W/3.5
				cliente.y = _H*1.3
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==4 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/4)
				cliente.x = _W
				cliente.y = _H/2.7
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==5 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/4)
				cliente.x = _W
				cliente.y = _H*1.7
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==6 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/7)
				cliente.x = _W*1.7
				cliente.y = _H/1.5
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==7 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/7)
				cliente.x = _W*1.7
				cliente.y = _H
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==8 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/7)
				cliente.x = _W*1.7
				cliente.y = _H*1.3
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==9 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/4)
				cliente.x = _W
				cliente.y = _H*0
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1
				physics.addBody(cliente, "static")

				elseif x==10 then
				cliente=display.newImageRect("cliente.png",_W/3,_H/4)
				cliente.x = _W
				cliente.y = _H*2
				cliente.alpha = 0.4
				cliente.name = "cliente"
				NumZonas = NumZonas + 1 
				physics.addBody(cliente, "static")
					end
				end
			else
				for x = 1,10 do
					comparar[x] = 0
					rnd[x] = x
				end
			end
		end
	end
	function contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

	function textBoxScreen(title, message)
	gameListeners("remove")
	
	-- Display text box with win or lose message
	textBox = display.newImage("textBox.png")
	textBox.x = _W
	textBox.y = _H
	
	-- Win or Lose Text
	conditionDisplay = display.newText(title, 0, 0, "Arial", 38)
	conditionDisplay:setTextColor(255,255,255,255)
	conditionDisplay.xScale = 0.5
	conditionDisplay.yScale = 0.5
	conditionDisplay.x = display.contentCenterX
	conditionDisplay.y = display.contentCenterY - 15
	
	--Try Again or Congrats Text
	messageText = display.newText(message, 0, 0, "Arial", 24)
	messageText:setTextColor(255,255,255,255)
	messageText.xScale = 0.5
	messageText.yScale = 0.5
	messageText.x = display.contentCenterX
	messageText.y = display.contentCenterY + 15

	-- Add all elements into a new group
	textBoxGroup = display.newGroup()
	textBoxGroup:insert(textBox)
	textBoxGroup:insert(conditionDisplay)
	textBoxGroup:insert(messageText)

	-- Make text box interactive
	textBox:addEventListener("tap", restart)
end

function restart( ... )

	if gameEvent == "win" then	
		textBoxScreen("  Quer tentar ganhar mais pontos?","  sim" .. "   não")
		gameEvent = "completed"
	elseif gameEvent == "lose" then	
		textBoxScreen("  Quer tentar denovo?","  sim" .. "   não")
		gameEvent = "completed"
	end
	-- If the game has been completed, remove the listener of the text box to free up memory
	if gameEvent == "completed" then
		textBox:removeEventListener("tap", restart)
		cleanup()
	end
end

function cleanup()
	predio1:removeSelf()
	predio2:removeSelf()
	predio3:removeSelf()
	predio4:removeSelf()
	predio5:removeSelf()
	predio6:removeSelf()
	predio7:removeSelf()
	predio8:removeSelf()
	predio9:removeSelf()

	background1:removeSelf()
	--bgMusic:removeSelf()

	carro:rotate(0)
	carro:removeSelf()

	TextoScore:removeSelf()
	NumeroScore:removeSelf()
	Score = 0

	textBox:removeEventListener("tap", cleanup)
	textBoxGroup:removeSelf()
	textBoxGroup = nil
	main()
end

function removercliente(evento)
	--local Vy = velocidadeY
	--local Vx = velocidadeX

	--velocidadeY = 0
	--velocidadeX = 0
	if evento.other.name == "cliente" then
	evento.other:removeSelf()
	evento = nil
	
	NumZonas = NumZonas - 1		
	Score = Score + 10
	NumeroScore.text = Score
	if Score == 200 then
		textBoxScreen("PARABENS","A CIDADE ESTÁ MAIS FRIA");
		gameEvent = "win";
	end

	elseif evento.other.name == "predio1" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio2" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio3" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio4" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio5" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio6" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio7" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio8" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	elseif evento.other.name == "predio9" then
	Score = Score - 10
	NumeroScore.text = Score
		if Score < 0 then

			textBoxScreen("Ah Não!", " Não esfriamos o suficiente")
			gameEvent = "lose"
		end
	end
end

main()