pro tetris, ABHIMAT=abhimat
	;; Pieces
	piece1 = [[0,0,0,0,0],[0,0,0,0,0],[-1,-1,-1,0,0],[0,0,-1,0,0],[0,0,0,0,0]]	; Backwards L
	piece2 = [[0,0,0,0,0],[0,0,0,0,0],[0,0,-1,-1,-1],[0,0,-1,0,0],[0,0,0,0,0]]	; L
	piece3 = [[0,0,0,0,0],[0,0,0,0,0],[0,0,-1,-1,0],[0,0,-1,-1,0],[0,0,0,0,0]]	; Square
	piece4 = [[0,0,0,0,0],[0,0,0,0,0],[0,-1,-1,-1,-1],[0,0,0,0,0],[0,0,0,0,0]]	; Line
	piece5 = [[0,0,0,0,0],[0,0,0,0,0],[0,0,-1,-1,0],[0,-1,-1,0,0],[0,0,0,0,0]]	; Step Right
	piece6 = [[0,0,0,0,0],[0,0,0,0,0],[0,0,-1,-1,0],[0,0,-1,-1,0],[0,0,0,0,0]]	; Step Left
	piece7 = [[0,0,0,0,0],[0,0,0,0,0],[0,0,-1,0,0],[0,-1,-1,-1,0],[0,0,0,0,0]]	; Triangle
	if keyword_set(ABHIMAT) then begin	; Easter Egg!
		piece1 = [[0,0,-1,0,0],[0,-1,0,-1,0],[0,-1,-1,-1,0],[0,-1,0,-1,0],[0,-1,0,-1,0]]	; A
		piece2 = [[0,-1,-1,0,0],[0,-1,0,-1,0],[0,-1,-1,0,0],[0,-1,0,-1,0],[0,-1,-1,0,0]]	; B
		piece3 = [[0,-1,0,-1,0],[0,-1,0,-1,0],[0,-1,-1,-1,0],[0,-1,0,-1,0],[0,-1,0,-1,0]]	; H
		piece4 = [[0,-1,-1,-1,0],[0,0,-1,0,0],[0,0,-1,0,0],[0,0,-1,0,0],[0,-1,-1,-1,0]]		; I
		piece5 = [[-1,0,0,0,-1],[-1,-1,0,-1,-1],[-1,0,-1,0,-1],[-1,0,0,0,-1],[-1,0,0,0,-1]]	; M
		piece6 = [[0,0,-1,0,0],[0,-1,0,-1,0],[0,-1,-1,-1,0],[0,-1,0,-1,0],[0,-1,0,-1,0]]	; A
		piece7 = [[-1,-1,-1,-1,-1],[0,0,-1,0,0],[0,0,-1,0,0],[0,0,-1,0,0],[0,0,-1,0,0]]		; T
	end
	
	;; Delay (== Level)
	delay = 0.25
	
	;; Board
	xSize = 10
	ySize = 20
	
	board = indgen(xSize, ySize)*0+1; Default Board
	board = [[indgen(xSize + 2, 1)*0], $	; With boundaries
	[findgen(1,ySize)*0 + 0.25, board, indgen(1,ySize)*0], [indgen(xSize + 2, 1)*0 + 0.25]]
	
	; run = updateBoard(board)
	
	; altBoard = indgen(xSize, ySize)
	; 		
	; 	for i=0,9 do begin
	; 		run = updateBoard(board)
	; 		wait, 0.5
	; 		run = updateBoard(altBoard)
	; 		wait, 0.5
	; 	end
	
	;; Game Play
	
	; Assigning first piece
	nextPiece = piece1
	case fix(randomu(seed)*7)+1 of
		1:	nextPiece = piece1
		2:	nextPiece = piece2
		3:	nextPiece = piece3
		4:	nextPiece = piece4
		5:	nextPiece = piece5
		6:	nextPiece = piece6
		7:	nextPiece = piece7
	end
	
	score = 0
	
	while 1 eq 1 do begin
		;run = updateBoard(board, nextPiece)
		curPiece = nextPiece
		; Choose a random piece for the next piece
		case fix(randomu(seed)*7)+1 of
			1:	nextPiece = piece1
			2:	nextPiece = piece2
			3:	nextPiece = piece3
			4:	nextPiece = piece4
			5:	nextPiece = piece5
			6:	nextPiece = piece6
			7:	nextPiece = piece7
		end
		
		; Put piece into starting position.
		curPosX = xSize/2 - 1
		curPosY = -1
		
		if keyword_set(ABHIMAT) then curPosY = 1
		
		fit = checkMove(board, curPiece, curPosX, curPosY, nextPiece, score)
		if fit eq 0 then begin
			break
		end
	
		new = 0	; Variable updated once new piece is necessary.
		while new eq 0 do begin
			; User moving piece
			startTime = systime(1)
			while systime(1) lt startTime + delay do begin
				newPosX = curPosX
				newPosY = curPosY
				newPiece = curPiece
		
				keyPress = get_kbrd(0, /escape)	; Get keyboard input
				if keyPress eq "" then continue	; No input given
				
				; Slide piece
				keyPressByte = byte(keyPress)
				if keyPressByte[0] eq 27 and keyPressByte[1] eq 91 and keyPressByte[2] eq 68 then newPosX = curPosX - 1	; left
				if keyPressByte[0] eq 27 and keyPressByte[1] eq 91 and keyPressByte[2] eq 67 then newPosX = curPosX + 1	; right
				if keyPressByte[0] eq 27 and keyPressByte[1] eq 91 and keyPressByte[2] eq 66 then newPosY = curPosY + 1	; down
				
				; Rotate piece
				if keyPressByte[0] eq 27 and keyPressByte[1] eq 91 and keyPressByte[2] eq 65 then newPiece = rotate(curPiece, 1)
		
				; Check movement and finalize if possible
				fit = checkMove(board, newPiece, newPosX, newPosY, nextPiece, score)
				if fit then begin
					curPiece = newPiece
					curPosX = newPosX
					curPosY = newPosY
				end
                                
                   
			end
		
			; Piece moving down by computer
			fit = checkMove(board, curPiece, curPosX, curPosY+1, nextPiece, score)
			if fit eq 1 then begin
				curPosY = curPosY + 1
			end else begin
				board = addPiece(board, curPiece, curPosX, curPosY)
				new = 1
			end
		end
		
		s = checkCompletedLines(board)	; Check for completed lines
		board = s.board
		case s.linesCleared of
			0:	score = score
			1:	score+= 40 + 40
			2:	score+= 100 + 100
			3:	score+= 300 + 300
			4:	score+= 1200 + 1200
		end
	end
	over = gameOver(board, nextPiece, score)
end

function gameOver, board, nextPiece, score
	boardSize = size(board)
	
	boardInfo = [[nextPiece + 1], [indgen(5, 1)*0], [indgen(5, boardSize[2] - 6)*0 + 1]]
	
	board = [board, boardInfo]
	boardAlt = board*(-1)
	boardSize = size(board)
	
	for i = 1,3 do begin
		display, rotate(boardAlt, 7), xticks = boardSize[1], xticklen = 1, xrange = [0,boardSize[1]],$
		yticks = boardSize[2], yticklen = 1, yrange = [0,boardSize[2]], xtickname = replicate(' ', boardSize[1] + 1),$
		ytickname = [("Score: " + String(score)), replicate(' ', boardSize[2])]
		wait, 0.25
		
		display, rotate(board, 7), xticks = boardSize[1], xticklen = 1, xrange = [0,boardSize[1]],$
		yticks = boardSize[2], yticklen = 1, yrange = [0,boardSize[2]], xtickname = replicate(' ', boardSize[1] + 1),$
		ytickname = [("Score: " + String(score)), replicate(' ', boardSize[2])]
		wait, 0.25
	end
	
	print, ""
	print, ""
	print, ""
	print, "Game Over!"
	print, "Your score: ", score
	return, 1
end

function updateBoard, board, nextPiece, score
	
	boardSize = size(board)
	
	boardInfo = [[nextPiece + 1], [indgen(5, 1)*0], [indgen(5, boardSize[2] - 6)*0 + 1]]
	
	board = [board, boardInfo]
	boardSize = size(board)
	
	display, rotate(board, 7), xticks = boardSize[1], xticklen = 1, xrange = [0,boardSize[1]],$
	yticks = boardSize[2], yticklen = 1, yrange = [0,boardSize[2]], xtickname = replicate(' ', boardSize[1] + 1),$
	ytickname = [("Score: " + String(score)), replicate(' ', boardSize[2])]
	
	return, 1	; Successful
end

function checkMove, board, piece, posX, posY, nextPiece, score
	boardSize = size(board)
	boardCopy = board
	; Attempt at adding piece to board
	for i=0,4 do begin
		for j=0,4 do begin
			; Continue if outside of board
			if (i + posX lt 0) or (j + posY lt 0) or (i + posX gt boardSize[1] - 1) or (j + posY gt boardSize[2] - 1) then CONTINUE
			
			boardCopy[i + posX, j + posY] = boardCopy[i + posX, j + posY] + piece[i, j]
		end
	end
	
	; Check for negative numbers
	negatives = where(boardCopy lt 0)
	if total(negatives) eq -1 then begin	; Legal Move
		run = updateBoard(boardCopy, nextPiece, score)
		return, 1
	end
	return, 0
end

function addPiece, board, piece, posX, posY
	boardSize = size(board)
	boardCopy = board
	; Adds piece to board
	for i=0,4 do begin
		for j=0,4 do begin
			; Continue if outside of board
			if (i + posX lt 0) or (j + posY lt 0) or (i + posX gt boardSize[1] - 1) or (j + posY gt boardSize[2] - 1) then CONTINUE
			
			boardCopy[i + posX, j + posY] = boardCopy[i + posX, j + posY] + piece[i, j]
		end
	end
	
	return, boardCopy
end

function checkCompletedLines, board
	boardSize = size(board)
	boardX = boardSize[1] - 2
	boardY = boardSize[2] - 2
	
	linesCleared = 0; 	Keeps track of how many lines have been cleared
	
	for j = 0,boardY-1 do begin
		subBoard = board(1:boardX, boardY - j)
		while total(subBoard) eq 0 do begin
			linesCleared++	; Add one more to how many lines cleared
			board(1:boardX,1:boardY - j) = [[indgen(boardX,1)*0+1],[board(1:boardX,1:boardY-j-1)]]
			subBoard = board(1:boardX, boardY - j)
		end
	end
	 
	; gameEnd = 0
	; topBoard = board(1:boardX, 0)
	; if where(topBoard lt 0) ne -1 then gameEnd = 1
	
	return, {board: board, linesCleared: linesCleared}
end
