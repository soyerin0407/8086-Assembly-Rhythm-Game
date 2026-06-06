org 100h

jmp start

score db 0
combo db 0

noteY db 0
noteLane db 1   
randSeed db 1

prevY db 0    

prevLane db 1       



judgeLine db '---------------------------------$'  

helpMsg db ' ESC=EXIT$'  

beatCounter db 0

start:

    mov ax,0003h
    int 10h

    ; 제목
    mov ah,02h
    mov bh,0
    mov dh,5
    mov dl,20
    int 10h

    mov ah,09h
    mov dx,offset titleMsg
    int 21h

    ; 설명
    mov ah,02h
    mov dh,8
    mov dl,15
    int 10h

    mov ah,09h
    mov dx,offset controlMsg1
    int 21h

    mov ah,02h
    mov dh,10
    mov dl,15
    int 10h

    mov ah,09h
    mov dx,offset controlMsg2
    int 21h

    mov ah,02h
    mov dh,12
    mov dl,15
    int 10h

    mov ah,09h
    mov dx,offset controlMsg3
    int 21h

    ; 시작 안내
    mov ah,02h
    mov dh,16
    mov dl,18
    int 10h

    mov ah,09h
    mov dx,offset startMsg
    int 21h

    ; 아무 키 대기
    mov ah,00h
    int 16h

    ; 화면 초기화 후 게임 시작
    mov ax,0003h
    int 10h

mainLoop:

    

    ; SCORE 출력
    mov ah,02h
    mov bh,0
    mov dh,0
    mov dl,0
    int 10h

    mov ah,09h
    mov dx,offset scoreMsg
    int 21h   
    
    mov ah,09h
    mov dx,offset scoreText
    int 21h      
    
    
    mov ah,09h
    mov dx,offset comboMsg
    int 21h

    mov ah,09h
    mov dx,offset comboText
    int 21h   
    
    mov ah,09h
    mov dx,offset helpMsg
    int 21h
    
    
    ; 이전 노트 지우기

    mov ah,02h
    mov bh,0

    mov dh,[prevY]
    add dh,3

    mov dl,10

    cmp byte ptr [prevLane],1
    je erasePos

    mov dl,20

    cmp byte ptr [prevLane],2
    je erasePos

    mov dl,30

    erasePos:

    int 10h

    mov ah,02h
    mov dl,' '
    int 21h    
    
    
    mov al,[noteY]
    mov [prevY],al   
    
    
    mov al,[noteLane]
    mov [prevLane],al
                   
    
    ; 레인

    mov ah,02h
    mov bh,0
    mov dh,2
    mov dl,10
    int 10h

    mov ah,02h
    mov dl,'|'
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,2
    mov dl,20
    int 10h

    mov ah,02h
    mov dl,'|'
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,2
    mov dl,30
    int 10h

    mov ah,02h
    mov dl,'|'
    int 21h
                   
    ; 판정선

    mov ah,02h
    mov bh,0
    mov dh,5
    mov dl,5
    int 10h

    mov ah,09h
    mov dx,offset judgeLine
    int 21h


    ; 노트 출력
    mov ah,02h
    mov bh,0

    mov dh,noteY
    add dh,3

    mov dl,10

    cmp noteLane,1
    je drawNote

    mov dl,20

    cmp noteLane,2
    je drawNote

    mov dl,30  
    
   
drawNote:

    int 10h

    mov ah,02h
    mov dl,'O'
    int 21h
    
    ; 키 확인
    mov ah,01h
    int 16h
    jz skipInput

    mov ah,00h
    int 16h  
    
    cmp al,27
je exitGame

cmp byte ptr [noteY],2
jl skipInput

cmp byte ptr [noteY],4
jg skipInput

; 왼쪽
cmp ah,4Bh
jne checkCenter

cmp byte ptr [noteLane],1
jne skipInput 




inc byte ptr [score] 



mov al,[score]
mov ah,0

mov bl,10
div bl

add al,'0'
mov [scoreText],al

mov al,ah
add al,'0'
mov [scoreText+1],al      


inc byte ptr [combo]

mov al,[combo]
mov ah,0

mov bl,10
div bl

add al,'0'
mov [comboText],al

mov al,ah
add al,'0'
mov [comboText+1],al  



mov byte ptr [noteY],0
mov byte ptr [prevY],0
mov byte ptr [prevLane],1

call RandomLane
jmp mainLoop



checkCenter:

; 스페이스
cmp al,' '
jne checkRight

cmp byte ptr [noteLane],2
jne skipInput       




inc byte ptr [score]   


mov al,[score]
mov ah,0

mov bl,10
div bl

add al,'0'
mov [scoreText],al

mov al,ah
add al,'0'
mov [scoreText+1],al  


inc byte ptr [combo]

mov al,[combo]
mov ah,0

mov bl,10
div bl

add al,'0'
mov [comboText],al

mov al,ah
add al,'0'
mov [comboText+1],al


mov byte ptr [noteY],0
mov byte ptr [prevY],0
mov byte ptr [prevLane],1

call RandomLane
jmp mainLoop

checkRight:

; 오른쪽
cmp ah,4Dh
jne skipInput

cmp byte ptr [noteLane],3
jne skipInput   
 

 
 
inc byte ptr [score] 


mov al,[score]
mov ah,0

mov bl,10
div bl

add al,'0'
mov [scoreText],al

mov al,ah
add al,'0'
mov [scoreText+1],al

inc byte ptr [combo]

mov al,[combo]
mov ah,0

mov bl,10
div bl

add al,'0'
mov [comboText],al

mov al,ah
add al,'0'
mov [comboText+1],al

mov byte ptr [noteY],0
mov byte ptr [prevY],0
mov byte ptr [prevLane],1

call RandomLane
jmp mainLoop



skipInput:

    ; 딜레이
    mov cx,1

delayLoop:
    loop delayLoop

    ; 노트 이동
    inc noteY
    inc noteY

    cmp noteY,6
    jle mainLoop

    
    mov noteY,0

inc byte ptr [beatCounter]

mov al,[beatCounter]
and al,1

jne noBeat

mov ah,02h
mov dl,7
int 21h

noBeat:

call RandomLane
    
    
    
    mov byte ptr [combo],0
    mov byte ptr [comboText],'0'
    
    cmp noteLane,3
    jle mainLoop

    mov noteLane,1
    jmp mainLoop







exitGame:

    mov ax,4C00h
    int 21h

scoreMsg db 'SCORE: $' 
scoreText db '00$'     


comboMsg db ' COMBO: $'
comboText db '00$'    


titleMsg db 'ASCII RHYTHM GAME$'

controlMsg1 db 'LEFT  : <-$'
controlMsg2 db 'CENTER: SPACE$'
controlMsg3 db 'RIGHT : ->$'

startMsg db 'PRESS ANY KEY TO START$'

 

RandomLane:

    mov ah,00h
    int 1Ah

    mov al,dl
    and al,00000011b

    cmp al,0
    jne laneOK

    mov al,1

laneOK:

    cmp al,3
    jle saveLane2

    mov al,3

saveLane2:

    mov [noteLane],al
    ret        
    
    
    
