          ;  _______ _           __      __                   ___  
          ; |__   __| |          \ \    / (_)                |__ \ 
          ;    | |  | |__   ___   \ \  / / _ _ __ _   _ ___     ) |
          ;    | |  | '_ \ / _ \   \ \/ / | | '__| | | / __|   / / 
          ;    | |  | | | |  __/    \  /  | | |  | |_| \__ \  / /_ 
          ;    |_|  |_| |_|\___|     \/   |_|_|   \__,_|___/ |____|
        
          
          ;Programmed and designed by Jamie Haazen
          ;Main Code Space (4536 Bytes): Interupt Handeler: (107 Bytes): Variable Space (63 Bytes): Graphic Tiles (2048 Bytes): Game Screens And Map (9309 Bytes): Music (1923 Bytes): Car Sprite (64 Bytes): Loading Screen (1000 Bytes)
          ;Total Size (19000 Bytes)(19Kb)
          ;Coded on C64 Studio
          ;Music Made On Goat Tracker
          ;Unlabled Common Addresses $C5 = Keyboard Matrix, $FFD2 = Print Charactor, $FFF0 = Set Curser(Coords), $BDCD = Print Number
          ;Mem map is included in Mem_Map.txt
          ;Designed for Pal Systems at 50Hz But Will Run On NTSC Systems Just At A Faster Than The Intended Speed.

Title_Song = 0
Ending_Song = 1
Main_Song = 2                                                                  
Zombie_Frame_0 = 0
Player_Frame_0 = 1
Gun = 2
Bullet = 3
Car = 4
Lock = 5
Door = 6
Key = 7
Left_Dag = 8
Up_Dag = 10
Right_Dag = 9
Down_Dag = 11
Right_Gun = 12
Down_Gun = 13
Left_Gun = 14
Up_Gun = 15
Vertical_Bullet = 16
Material_Box = 17
Player_Frame_1 = 18
Zombie_Frame_1 = 19
Player_X_Pos = $CF00
Player_Y_Pos = $CF01
Zombie1_X_Pos = $CF02
Zombie1_Y_Pos = $CF03
Dagger_Dir = $CF04
Last_Press = $CF05
Dag_X_Pos = $CF06
Dag_Y_Pos = $CF07
Dag_On = $CF08
Counter = $CF09
Dag_X_Buff = $CF0A
Dag_Y_Buff = $CF0B
Zombie1_State = $CF0C
Zombie2_X_Pos = $CF0D
Zombie2_Y_Pos = $CF0E
Zombie2_State = $CF0F
Player_X_Buff = $CF10
Player_Y_Buff = $CF11
Gun_X_Pos = $CF12
Gun_Y_Pos = $CF13
Gun_State = $CF14
Bullet_X_Pos = $CF15
Bullet_Y_Pos = $CF16
Bullet_State = $CF17
Bullet_Dir = $CF18
Bullet_Sprite = $CF19
Zombie1_X_Buff = $CF1A
Zombie1_Y_Buff = $CF1B
Zombie2_X_Buff = $CF1C
Zombie2_Y_Buff = $CF1D
Zombie_Timer = $CF1E
Zombies_Killed = $CF1F
Materials = $CF20
Mats_X_Pos = $CF21
Mats_Y_Pos = $CF22
Mats_State = $CF23
Game_Mode = $CF24
Mats_High = $CF25
Zombies_Killed_High = $CF26
Key_X_Pos = $CF27
Key_Y_Pos = $CF28
Key_State = $CF29
Song = $CF2A
Room = $CF2B
Door_X_Pos = $CF2C
Door_Y_Pos = $CF2D
Lock_X_Pos = $CF2E
Lock_Y_Pos = $CF2F
Player_Tile = $CF30
Animation_Frame = $CF31
Zombie_Tile = $CF32
Mats_Counter = $CF33
Swapable = $CF34
Key_Press = $CF35
Curser_X_Pos = $CF36
Curser_Y_Pos = $CF37
Current_Tile = $CF38
Player_Death_Count = $CF39
Bad_Allowed = $CF3A
Timer = $CF3B
Seconds = $CF3C
Minuites = $CF3D
Beat_Game = $CF3E 
Left = $0A
Right = $12
Up = $09
Down = $0D
Space = $3C
ScreenRam = $0400
Sprite_MultiColour1 = $D025
Sprite_MultiColour2 = $D026
Car_Colour = $D027
Car_On = $D015
Car_X_Pos = $D000 
Car_Y_Pos = $D001



* = $0801
          !BYTE  $1B, $08, $EA, $07, $9E, $32, $34, $35, $37, $36, $00, $00, $00

* = $6000
          lda  #$00
          sta  Player_Death_Count
          sta  Bad_Allowed
          sta  Timer
          sta  Seconds
          Sta  Minuites
          sta Beat_Game
                         
:Setup
:Music_Initionalisation
:Set_Song
          lda  #Title_Song
          sta  Song
:Setup_Vic_ii_Chip          

          sei
          lda  #01   ;Enable Interupts from Vic ii chip
          sta  $D01A
          lda  #$64 ;Set Target Scanline for Raster Interupts
          sta  $D012
          lda  $D011;Set Video Mode Hi Res Text Mode
          and  #$7F
          sta  $D011
:Set_Interupt_Location   
          lda  #$7F ;Disable Cia 1 interupts
          sta  $DC0D
          lda  $DC0D
          lda  #$00   ;Set Interuptrs to custom interupt routine
          sta  $0314          
          lda  #$C0
          sta  $0315
:Sprite_Initionalisation
          lda  #00
          lda  #01                   
          sta  $D01C ;Set Sprite to Multicolour mode
          lda  #02
          sta  Sprite_MultiColour1
          lda #11
          sta  Sprite_MultiColour2
          lda  #03
          sta Car_Colour
          sta Car_Colour          ;Set Main And Aux Colours
:Ending_Song_Setup          
          jsr  $1500 ;Initionalise Ending Song

:Title_Song_Setup
          jsr  $1900 ;Initionalise Title Song
:Main_Song_Setup
          jsr  $1000 ;Initionalise Main Song
          cli
:Set_Variables
          lda  #$93 
          jsr  $FFD2 ;Clear Screen
          lda  #00
          sta  Zombies_Killed_High ;Set All variables initional values
          sta Mats_High
          sta Materials
          sta  Zombie1_State
          sta Zombie2_State
          sta  Dag_On
          sta  Zombies_Killed
          sta  Counter
          sta  Zombie_Timer
          sta  Key_State
          sta  Animation_Frame
          sta Swapable
          lda  #35
          sta  Gun_X_Pos
          lda  #5
          sta  Gun_Y_Pos
          lda  #00
          sta  Gun_State
          lda  #00
          sta Bullet_State
          lda  #Left
          sta  Last_Press
          lda  #15
          sta  Key_Y_Pos
          lda  #29
          sta  Key_X_Pos         
          lda  #12
          sta  Player_X_Pos
          sta  Player_Y_Pos
          sta  Player_X_Buff       
          sta  Player_Y_Buff        

          lda #1
          sta  Zombie1_Y_Pos
          lda  #29
          sta  Zombie1_X_Pos
          lda  #1
          sta  Zombie2_X_Pos
          lda  #18
          Sta  Zombie2_Y_Pos
          lda  #19
          sta  Door_Y_Pos
          lda  #14
          sta  Door_X_Pos
          lda  #00
          sta  Room
          lda  #17
          sta  Gun_X_Pos
          lda  #12
          sta  Gun_Y_Pos
          lda  #14
          sta  Lock_X_Pos
          lda  #18
          sta  Lock_Y_Pos
          
          
          


:Set_Timers
          lda  #00
          sta Mats_State ;Set Mats to uncollected
          lda  Mats_Counter
          and  #%00000111 
          adc #04 
          sta  Mats_Y_Pos ;Use a pseudo random number to initionalise the Mats Y position
          lda  Mats_Counter
          adc  Zombie_Timer
          And  #%00001111
          adc  #03
          sta  Mats_X_Pos ;Use a similar algorithm for the X
  
:Graphics_Setup                  
          lda  $D018 ;Load Current Graphics State
          AND  #%11110000;Preserve location of ScreenRam
          ORA  #%00001100;Read Graphics From Bank 6 ($3000)
          Sta  $D018 ;Tell the Vic ii to read from the Custom Charactor set
          ldx  #00

:Load_Title_Screen
 
         
:Load_Title_Screen_Loop
          lda  #00
          sta  $D021
          lda  #$0B
          sta $D020
          lda Title_Screen_Data, x        
          sta ScreenRam, x  
          lda Title_Screen_Data + $100, x  
          sta ScreenRam + $100, x
          lda Title_Screen_Data + $200, x  
          sta ScreenRam + $200, x
          lda Title_Screen_Data + $300, x  
          sta ScreenRam + $300, x

          lda Title_Screen_Colour, x        
          sta $D800, x      
          lda Title_Screen_Colour + $100, x  
          sta  $D800 + $100, x   
          lda Title_Screen_Colour + $200, x  
          sta $D800 + $200, x      
          lda Title_Screen_Colour + $300, x  
          sta $D800 + $300, x      

          inx               
          bne  Load_Title_Screen_Loop
:Check_Bad_Title_Screen
          lda  Game_Mode
          cmp  #01
          bne  Title_Screen
          lda  Beat_Game
          cmp  #01
          beq Display_Bonus_Text                  
          lda  Player_Death_Count
          cmp  #10
          bcs  Display_Infected_Text
          jmp  Title_Screen
:Display_Infected_Text
          ldy  #06
          ldx  #17
          clc
          jsr  $FFF0
          ldx  #00
:Display_Infected_Text_Loop
          lda  Infected_Text, x
          cmp  #00
          beq Title_Screen
          jsr  $FFD2
          inx
          jmp Display_Infected_Text_Loop

:Display_Disabled_Text
          ldy  #06
          ldx  #18
          clc
          jsr  $FFF0
          ldx  #00
:Display_Disabled_Text_Loop
          lda  Disabled_Text, x
          cmp  #00
          beq Title_Screen
          jsr  $FFD2
          inx
          jmp  Display_Disabled_Text_Loop
          
:Display_Bonus_Text
          lda  #$9A
          jsr  $FFD2
          ldy  #03
          ldx  #17
          clc
          jsr  $FFF0
          ldx  #00
:Display_Bonus_Text_Loop
          lda  Bonus_Text, x
          cmp  #00
          beq Title_Screen
          jsr  $FFD2
          inx
          jmp  Display_Bonus_Text_Loop
          
:Title_Screen
          lda  $C5
          cmp  #$40
          beq  Title_Screen
          cmp  #$38
          beq  Set_Easy
          cmp  #$3B 
          beq  Set_Hard
          cmp  #$08
          beq  Set_Endless
          cmp  #$27
          beq  Disable_Bad_Ending
          cmp  #$1C
          beq Goto_Bonus
          jmp Title_Screen
:Disable_Bad_Ending
          lda  #01
          sta  Bad_Allowed
          lda  #01
          sta Player_Death_Count
          jmp  Display_Disabled_Text
          
:Set_Easy
          lda  #00
          sta  Game_Mode
          jmp Initionalise_Colour
:Set_Hard
          lda  #01
          sta  Game_Mode
          jmp  Initionalise_Colour

:Set_Endless
          lda  #02
          sta  Game_Mode
          jmp  Initionalise_Colour

:Goto_Bonus
          jmp  Bonus

:Initionalise_Colour
          lda  #$0B
          sta $D020
          ldx  #$00      
          lda  #$0E

    

Colour_Set_loop:
          sta  $D800, x  
          sta  $D800 + $100, x    
          sta  $D800 + $200, x     
          sta  $D800 + $300, x    
          inx              
          bne  Colour_Set_loop         
          
                        
:Load_Map
          ldx  #00
:Load_Map_Loop
          lda  Map, x
          sta  ScreenRam, x
          lda  Map + $100, x
          sta  ScreenRam + $100, x
          lda  Map + $200, x
          sta  ScreenRam + $200, x
          lda  Map + $300, x
          sta  ScreenRam + $300, x
          inx
          bne  Load_Map_Loop
          jmp Set_Main_Song
          
          
          


:Draw_Door
          lda  Door_X_Pos
          sta  Curser_X_Pos
          lda  Door_Y_Pos
          sta  Curser_Y_Pos
          lda  #Door
          sta  Current_Tile
          jsr  Draw_Tile
          rts
          
          
:Set_Main_Song 
          lda  Player_Death_Count      
          lda  #Main_Song
          sta  Song
          jmp Game_Run_Loop

         
:Game_Run_Loop
          
          Jsr Set_Animation_Frame
          jsr  Stop_Zom1_Spawn
          jsr  Clear_Zombie1
          jsr  Clear_Zombie2
          jsr  Save_Zombie_Buff
          jsr  Clear_Dag
          jsr  Clear_Bullet
          jsr  Clear_Player
          jsr Buffer_Shift        
          jsr  Player_Logic
          jsr Lock_Logic
          jsr Draw_Player
          jsr  Player_Edge_Col
          jsr Key_Logic
          jsr  Attack
          jsr  Gun_Shoot
          jsr  Check_Bullet_Pos
          jsr  Zombie1_Logic
          jsr  Zombie2_Logic
          Jsr  Mats_Logic
          jsr  Check_Bullet_Pos  
          jsr  Update_Bullet_Pos
          Jsr  Car_Logic
          jsr Draw_Door
          jsr Door_Col
          jsr  Check_Map_Col_Bullet
          jsr  Zom_Col_1
          jsr  Zom_Col_2
          jsr  Gun_Col
          jsr  Print_Score
          jsr  Print_Mats
          jsr  Print_Weapon_Text     
          jsr  Draw_Dagger
          jsr  Draw_Gun
          jsr  Draw_Bullet
          jsr  Draw_Mats
          jsr  Check_Counter_Dag
          inc  Counter
          inc  Zombie_Timer
          jsr  Respawn_Zombies
          jsr  Delay
          jmp Game_Run_Loop
          
                   
        
:Clear_Player
                      
          lda  Player_X_Pos
          sta  Curser_X_Pos
          lda  Player_Y_Pos
          sta  Curser_Y_Pos
          jsr  Clear_Tile          
          rts
          
:Clear_Zombie1
          lda  Zombie1_State
          cmp  #01
          beq  No_Clear_Zombie1
          lda  Zombie1_X_Pos
          sta  Curser_X_Pos
          lda  Zombie1_Y_Pos
          sta  Curser_Y_Pos
          jsr  Clear_Tile
          rts
:No_Clear_Zombie1
          rts
          
:Clear_Zombie2
          lda  Zombie2_State
          cmp  #01
          Beq  No_Clear_Zombie2
          lda  Zombie2_X_Pos
          sta  Curser_X_Pos
          lda  Zombie2_Y_Pos
          sta  Curser_Y_Pos
          jsr  Clear_Tile
          rts

:No_Clear_Zombie2
          rts          

:Clear_Dag    
          lda  Dag_On
          cmp  #00
          beq  No_Clear_Dag
          lda  Player_X_Pos
          Cmp  Player_X_Buff
          bne  Execute_Clear
          lda  Player_Y_Pos
          cmp  Player_Y_Buff
          beq No_Clear_Dag
:Execute_Clear 
          lda  Dag_X_Pos
          sta  Curser_X_Pos
          lda  Dag_Y_Pos
          sta  Curser_Y_Pos
          jsr  Clear_Tile
          lda  Dag_X_Buff
          sta  Curser_X_Pos
          lda  Dag_Y_Buff
          sta  Curser_Y_Pos
          jsr  Clear_Tile
          rts

:No_Clear_Dag
          rts

:Draw_Tile
          ldx  Curser_Y_Pos
          ldy  Curser_X_Pos
          clc
          jsr  $FFF0
          ldx  Current_Tile
          lda  Colour,x
          jsr  $FFD2
          lda  Tile, x
          jsr  $FFD2
          rts
          
:Clear_Tile
          ldx  Curser_Y_Pos
          ldy  Curser_X_Pos
          clc
          jsr  $FFF0
          lda  #$20
          jsr  $FFD2
          rts
                
:Delay
          ldy  #$1C
:Outer
          ldx  #$00     
:Inner
          dex
          bne  Inner
          dey
          bne  Outer
          rts

:Player_Logic
          lda  $C5
          cmp  #$40
          beq  Exit_Scan

       
:Move_Player          
          lda  $C5
          cmp  #$29
          beq  Pause_Bridge
          jsr  Swap_Weapon
          lda $C5
          cmp  #Left
          beq  Move_Player_Left
          cmp  #Right
          beq  Move_Player_Right
          cmp  #Up
          beq  Move_Player_Up
          cmp  #Down
          beq  Move_Player_Down
          cmp  #Space
          beq  Dagger_Set          
          rts
:Pause_Bridge
          jmp  Pause


:Dagger_Set
          lda  #1
          sta  Dag_On
          lda  #00
          sta  Counter
          rts
         
:Exit_Scan
          lda  #00
          sta  Key_Press
          rts

:Buffer_Shift
          lda  Player_X_Pos
          sta  Player_X_Buff
          lda  Player_Y_Pos
          sta  Player_Y_Buff
          rts
               
:Move_Player_Left
          lda  $C5
          sta  Last_Press
          dec  Player_X_Pos
          jsr  Check_Map_Col
          lda  Player_X_Pos
          cmp  #255
          beq  Colided_Bridge
          jsr Execute_Clear
          rts

:Move_Player_Right
          lda  $C5
          sta  Last_Press
          inc  Player_X_Pos
          jsr  Check_Map_Col
          lda  Player_X_Pos
          cmp  #40
          beq  Colided_Bridge
          jsr Execute_Clear       
          rts

:Move_Player_Up
          lda  $C5
          sta  Last_Press
          dec  Player_Y_Pos
          jsr  Check_Map_Col
          lda  Player_Y_Pos
          cmp  #255
          beq  Colided_Bridge
          Jsr Execute_Clear     
          rts

:Move_Player_Down
          lda  $C5
          sta  Last_Press
          inc  Player_Y_Pos
          jsr  Check_Map_Col
          lda  Player_Y_Pos
          cmp  #25
          beq  Colided_Bridge
          jsr Execute_Clear
          rts


:Colided_Bridge
          jsr  Colided
          rts

:Check_Map_Col
 
          Ldx  #00
:Map_Y_Loop          
          lda  Map_Y_Array, x
          cmp  Player_Y_Pos
          beq  Check_Map_Col_X
          Cmp  #$FF
          beq  End_Check_Col
          inx
          jmp  Map_Y_Loop
:Check_Map_Col_X
:Map_X_Loop          
          lda  Map_X_Array, x
          cmp  Player_X_Pos
          beq  Colided
          inx
          jmp  Map_Y_Loop

:Colided
          lda  Player_X_Buff
          sta  Player_X_Pos
          Lda  Player_Y_Buff
          sta  Player_Y_Pos
          rts
:End_Check_Col
          rts
       
:Draw_Player

          lda  Player_X_Pos
          sta  Curser_X_Pos
          lda  Player_Y_Pos
          sta  Curser_Y_Pos
          lda  Player_Tile
          sta  Current_Tile
          jsr  Draw_Tile
          rts

          
:Zombie1_Logic
          lda  Room
          cmp  #01
          beq  No_Spawn1
          lda  Zombie1_State
          cmp  #01
          beq  No_Spawn1
          jsr  Calculate_Zombie1
          jsr  Draw_Zombie1
          jsr Check_Zombie1_Col
:No_Spawn1
          rts
           
:Draw_Zombie1
          lda  Room
          cmp  #01
          beq  No_Spawn1
          lda  Zombie1_X_Pos
          sta  Curser_X_Pos
          lda  Zombie1_Y_Pos
          sta  Curser_Y_Pos
          lda  Zombie_Tile
          sta Current_Tile
          jsr  Draw_Tile
          rts
          
         
:Calculate_Zombie1    
             
:Calculate_Y_Zombie1
          
          lda  Player_X_Pos
          cmp  Zombie1_X_Pos
          bne  Calculate_X_Zombie1
          lda  Player_Y_Pos
          cmp  Zombie1_Y_Pos
          beq No_Move
          bcc  Move_Zombie1_Up          
          bcs  Move_Zombie1_Down

:Calculate_X_Zombie1
          clc
          lda  Player_X_Pos
          cmp  Zombie1_X_Pos
          beq No_Move
          bcc  Move_Zombie1_Left          
          bcs  Move_Zombie1_Right
          rts          
:Move_Zombie1_Left
          dec  Zombie1_X_Pos
          rts
:Move_Zombie1_Right
          inc  Zombie1_X_Pos
          rts
:Move_Zombie1_Up
          dec  Zombie1_Y_Pos
          rts

:Move_Zombie1_Down
          inc  Zombie1_Y_Pos
          rts
:No_Move
          rts
:Check_Zombie1_Col
          Lda  Player_X_Pos
          cmp  Zombie1_X_Pos
          Bne  End_Check1
          lda  Player_Y_Pos
          cmp  Zombie1_Y_Pos
          beq  Player_Death1
          rts
:End_Check1
          rts
:Player_Death1
          jmp Game_Over

:Zom_Col_1
          lda  Dag_On
          cmp  #01
          bne End_Check1
          lda  Dag_X_Pos
          cmp  Zombie1_X_Pos
          bne  End_Check1
          lda  Dag_Y_Pos
          cmp  Zombie1_Y_Pos
          beq  Kill_Zom1
          rts
:Kill_Zom1
          lda  Zombie1_State
          Cmp  #1
          beq  End_Check1
          jsr Clear_Zombie1
          lda  Zombies_Killed
          adc  #01
          sta Zombies_Killed
          bcs Set_Zombie_High_Byte
          lda  #1
          sta  Zombie1_State
          rts
:Set_Zombie_High_Byte
          inc  Zombies_Killed_High
          lda  #1
          sta  Zombie1_State
          rts
               
:Zombie2_Logic
          lda  Room
          cmp  #01
          beq  No_Spawn2
          lda  Zombie2_State
          cmp  #01
          beq  No_Spawn2
          jsr  Calculate_Zombie2
          jsr  Draw_Zombie2
          jsr Check_Zombie2_Col
:No_Spawn2
          rts  
:Draw_Zombie2
          lda  Room
          cmp  #01
          beq  No_Spawn2
          lda  Zombie2_X_Pos
          sta  Curser_X_Pos
          lda  Zombie2_Y_Pos
          sta  Curser_Y_Pos
          lda  Zombie_Tile
          sta Current_Tile
          jsr  Draw_Tile
          rts
          
:No_Move_Bridge
          jmp  No_Move
         
:Calculate_Zombie2   
             
:Calculate_Y_Zombie2
          
          lda  Player_X_Pos
          cmp  Zombie2_X_Pos
          bne  Calculate_X_Zombie2
          lda  Player_Y_Pos
          cmp  Zombie2_Y_Pos
          beq No_Move_Bridge
          bcc  Move_Zombie2_Up          
          bcs  Move_Zombie2_Down

:Calculate_X_Zombie2
          clc
          lda  Player_X_Pos
          cmp  Zombie2_X_Pos
          beq No_Spawn2
          bcc  Move_Zombie2_Left          
          bcs  Move_Zombie2_Right
          rts          
:Move_Zombie2_Left
          dec  Zombie2_X_Pos
          rts
:Move_Zombie2_Right
          inc  Zombie2_X_Pos
          rts
:Move_Zombie2_Up
          dec  Zombie2_Y_Pos
          rts

:Move_Zombie2_Down
          inc  Zombie2_Y_Pos
          rts

:Check_Zombie2_Col
          Lda  Player_X_Pos
          cmp  Zombie2_X_Pos
          Bne  End_Check2
          lda  Player_Y_Pos
          cmp  Zombie2_Y_Pos
          beq  Player_Death
          rts
:End_Check2
          rts
:Player_Death
          jmp  Game_Over
          

:Zom_Col_2
          lda  Dag_On
          cmp  #01
          bne  End_Check2
          lda  Dag_X_Pos
          cmp  Zombie2_X_Pos
          bne  End_Check2
          lda  Dag_Y_Pos
          cmp  Zombie2_Y_Pos
          beq  Kill_Zom2
          rts
:Kill_Zom2
          lda  Zombie2_State
          cmp  #01
          beq  End_Check2
          jsr Clear_Zombie2
          lda  Zombies_Killed
          adc  #01
          sta Zombies_Killed
          bcs Set_Zombie_High_Byte_Bridge
          lda  #1
          sta  Zombie2_State
          rts

:Set_Zombie_High_Byte_Bridge
          jmp  Set_Zombie_High_Byte
                 
:Draw_Dagger
          jsr  Check_Counter_Dag
          lda  Dag_On
          cmp  #0
          beq  No_Dag_On
          lda  Dag_X_Pos
          sta  Curser_X_Pos
          lda  Dag_Y_Pos
          sta  Curser_Y_Pos
          lda  Dagger_Dir
          sta  Current_Tile
          jsr Draw_Tile
          rts
:No_Dag
          
          jsr  Execute_Clear
          rts
:No_Dag_On
          rts
          
:Attack   
          
          lda  Gun_State
          cmp  #01
          beq  Gun_Attack
          lda  Dag_X_Pos
          sta  Dag_X_Buff
          lda  Dag_Y_Pos
          sta  Dag_Y_Buff
          lda  Last_Press
          cmp  #Up
          beq  Dag_Mov_Up
          cmp  #Down
          beq Dag_Mov_Down
          cmp  #Left
          beq  Dag_Mov_Left
          Cmp  #Right
          beq  Dag_Mov_Right
          rts
          
:Dag_Mov_Left
          ldx  #Left_Dag
          Stx  Dagger_Dir
          lda  Player_Y_Pos
          Sta  Dag_Y_Pos
          lda  Player_X_Pos
          sta  Dag_X_Pos
          Dec  Dag_X_Pos
          rts
          
:Dag_Mov_Up
          ldx  #Up_Dag
          stx  Dagger_Dir
          lda  Player_X_Pos
          Sta Dag_X_Pos
          lda  Player_Y_Pos
          sta  Dag_Y_Pos
          Dec  Dag_Y_Pos
          rts
          
:Dag_Mov_Down
          ldx  #Down_Dag
          stx  Dagger_Dir
          lda  Player_X_Pos
          sta  Dag_X_Pos
          lda  Player_Y_Pos
          sta  Dag_Y_Pos
          inc  Dag_Y_Pos
          rts          
          
:Dag_Mov_Right
          ldx  #Right_Dag
          Stx  Dagger_Dir
          lda  Player_Y_Pos
          Sta Dag_Y_Pos
          lda  Player_X_Pos
          sta  Dag_X_Pos
          inc  Dag_X_Pos
          rts
:Gun_Attack

          lda  Swapable
          cmp  #00
          beq  No_Gun
          lda  Dag_X_Pos
          sta  Dag_X_Buff
          lda  Dag_Y_Pos
          sta  Dag_Y_Buff
          lda  Last_Press
          cmp  #Up
          beq  Gun_Mov_Up
          cmp  #Down
          beq Gun_Mov_Down
          cmp  #Left
          beq  Gun_Mov_Left
          Cmp  #Right
          beq  Gun_Mov_Right
          rts
:No_Gun
          
          jsr  No_Dag
          rts

          
:Gun_Mov_Left
          ldx  #Left_Gun
          Stx  Dagger_Dir
          lda  Player_Y_Pos
          Sta  Dag_Y_Pos
          lda  Player_X_Pos
          sta  Dag_X_Pos
          Dec  Dag_X_Pos
          rts
          
:Gun_Mov_Up
          ldx  #Up_Gun
          stx  Dagger_Dir
          lda  Player_X_Pos
          Sta Dag_X_Pos
          lda  Player_Y_Pos
          sta  Dag_Y_Pos
          Dec  Dag_Y_Pos
          rts
          
:Gun_Mov_Down
          ldx  #Down_Gun
          stx  Dagger_Dir
          lda  Player_X_Pos
          sta  Dag_X_Pos
          lda  Player_Y_Pos
          sta  Dag_Y_Pos
          inc  Dag_Y_Pos
          rts          
          
:Gun_Mov_Right
          ldx  #Right_Gun
          Stx  Dagger_Dir
          lda  Player_Y_Pos
          Sta Dag_Y_Pos
          lda  Player_X_Pos
          sta  Dag_X_Pos
          inc  Dag_X_Pos
          rts       
:Check_Counter_Dag
          lda  Counter
          cmp  #$03
          beq  Reset_Dag
          rts
:Reset_Dag
          lda  #$00
          sta  Dag_On
          jsr Execute_Clear
          rts
          


:Draw_Gun
          lda  Swapable
          cmp  #1
          beq  Gun_Collected
          lda  Room
          cmp  #00
          beq Gun_Collected
          lda  Gun_X_Pos
          sta  Curser_X_Pos
          lda  Gun_Y_Pos
          sta  Curser_Y_Pos
          lda  #Right_Gun
          sta  Current_Tile
          jsr  Draw_Tile
          rts
:Gun_Collected
          rts
          
          
:Gun_Col
          lda  Room
          cmp  #00
          beq  End_Gun_Check
          lda  Gun_X_Pos
          cmp  Player_X_Pos
          bne  End_Gun_Check
          lda  Gun_Y_Pos
          cmp  Player_Y_Pos
          bne  End_Gun_Check
          lda  #1
          sta  Gun_State
          lda  #01
          sta Swapable
          rts
:End_Gun_Check
          rts
          
:Gun_Shoot
          lda  Gun_State
          cmp  #00
          beq  No_Shoot
          lda  Dag_On
          cmp  #00
          beq  No_Shoot
          lda  Bullet_State
          cmp  #01
          beq  No_Shoot
          lda Bullet_State
          cmp  #01
          beq End_Gun_Check
          lda  Last_Press
          sta  Bullet_Dir
          lda  #01
          sta  Bullet_State
          rts
          
          
:Update_Bullet_Pos
          lda  Bullet_State
          cmp  #01
          beq  Move_Bullet
          lda  Player_X_Pos
          sta  Bullet_X_Pos
          lda  Player_Y_Pos
          sta  Bullet_Y_Pos
          lda  Dag_On
          cmp  #00
          beq  No_Shoot
          lda  Gun_State
          cmp  #00
          beq  No_Shoot

:Move_Bullet          
          lda  Bullet_Dir
          cmp  #Right
          beq  Move_Bullet_Right
          cmp  #Left
          beq  Move_Bullet_Left
          cmp  #Up
          beq  Move_Bullet_Up
          cmp  #Down
          beq  Move_Bullet_Down
          rts
:Move_Bullet_Right
          inc  Bullet_X_Pos
          lda  #Bullet
          sta Bullet_Sprite
          rts
:Move_Bullet_Left
          dec  Bullet_X_Pos
          lda  #Bullet
          sta Bullet_Sprite
          rts
:Move_Bullet_Up
          dec  Bullet_Y_Pos
          lda  #Vertical_Bullet
          sta Bullet_Sprite
          rts
:Move_Bullet_Down
          inc  Bullet_Y_Pos
          lda  #Vertical_Bullet
          sta Bullet_Sprite
          rts
          
:No_Shoot
          rts
:Check_Bullet_Pos
          lda  Bullet_State
          cmp  #00
          beq  No_Shoot
          jsr  Check_Zom1_Shot_X
          jsr  Check_Zom2_Shot_X
          jsr  Check_Bullet_Edge
          rts
:Check_Zom1_Shot_X
          lda  Zombie1_State
          cmp  #01
          beq  No_Shoot
          lda  Zombie1_X_Pos
          cmp  Bullet_X_Pos
          beq  Check_Zom1_Shot_Y         
          rts
:Check_Zom1_Shot_Y
          lda  Zombie1_Y_Pos
          cmp  Bullet_Y_Pos
          beq Shoot_Zombie1        
          rts
:Shoot_Zombie1
          jsr  Bullet_Off
          jmp  Kill_Zom1
:Check_Zom2_Shot_X
          lda  Zombie2_State
          cmp  #01
          beq  No_Shoot
          lda  Zombie2_X_Pos
          cmp  Bullet_X_Pos
          beq  Check_Zom2_Shot_Y      
          rts
:Check_Zom2_Shot_Y
          lda  Zombie2_Y_Pos
          cmp  Bullet_Y_Pos
          beq  Shoot_Zombie2     
          rts
:Shoot_Zombie2
          jsr  Bullet_Off
          jmp  Kill_Zom2
         
:Check_Bullet_Edge
          lda  Bullet_X_Pos
          cmp  #39
          beq  Bullet_Off
          cmp  #00
          beq  Bullet_Off
          lda  Bullet_Y_Pos
          cmp  #24
          beq  Bullet_Off
          cmp  #0
          beq  Bullet_Off
          rts
:Bullet_Off
          lda  #00
          sta  Bullet_State
          lda  Player_X_Pos
          sta  Bullet_X_Pos
          lda  Player_Y_Pos
          sta  Bullet_Y_Pos
          rts
:Draw_Bullet
          lda  Bullet_State
          cmp  #00
          beq  Bullet_Off
          lda  Bullet_X_Pos
          sta  Curser_X_Pos
          lda  Bullet_Y_Pos
          sta  Curser_Y_Pos
          lda  Bullet_Sprite
          sta  Current_Tile
          jsr Draw_Tile
          rts

:Clear_Bullet
        
          lda  Bullet_X_Pos
          sta  Curser_X_Pos
          lda  Bullet_Y_Pos
          sta  Curser_Y_Pos
          jsr  Clear_Tile
          rts
          
          
         
:Check_Map_Col_Bullet
          Ldx  #00
:Map_Y_Loop_Bullet          
          lda  Map_Y_Array, x
          cmp  Bullet_Y_Pos
          beq  Check_Map_Col_X_Bullet 
          Cmp  #$FF
          beq  End_Check_Col_Bullet
          inx
          jmp  Map_Y_Loop_Bullet


:Check_Map_Col_X_Bullet
:Map_X_Loop_Bullet        
          lda  Map_X_Array, x
          cmp  Bullet_X_Pos
          beq  Bullet_Off
          inx
          jmp  Map_Y_Loop_Bullet
:End_Check_Col_Bullet
          rts
:Save_Zombie_Buff
          lda  Zombie1_X_Pos
          sta  Zombie1_X_Buff
          lda  Zombie1_Y_Pos
          sta  Zombie1_Y_Buff
          lda  Zombie2_X_Pos         
          sta  Zombie2_X_Buff
          lda  Zombie2_Y_Pos
          sta  Zombie2_Y_Buff
          rts
 
          
:Respawn_Zombies
          lda  Zombie_Timer
          cmp  #100
          beq  Check_If_Zombie_Dead
          lda  Materials
          cmp  #90
          bcs Check_If_Zombie_Dead
          cmp  #$FF
          bne  No_Respawn

:Check_If_Zombie_Dead          
          lda  Zombie1_State
          Cmp  #00
          beq  No_Respawn
          lda  Zombie2_State
          cmp #00
          beq No_Respawn
:Respawn          
          lda  #1
          sta  Zombie1_Y_Pos
          lda  #29
          sta  Zombie1_X_Pos
          lda  #1
          sta  Zombie2_X_Pos
          lda  #18
          Sta Zombie2_Y_Pos
          lda  #00
          sta  Zombie1_State
          sta  Zombie2_State
          lda  #00
          sta Zombie_Timer
:No_Respawn
          rts
          
:Print_Score
          lda  #05
          jsr  $FFD2
          ldx  #01
          ldy  #00
          clc
          jsr $FFF0
          ldx  #00
:Score_Loop          
          lda  Score, x
          cmp  #00
          beq  Print_Score2
          jsr  $FFD2
          inx
          jmp  Score_Loop
:Print_Score2
          ldx  #1
          ldy  #18
          clc
          jsr  $FFF0
          ldx  Zombies_Killed
          lda  Zombies_Killed_High
          sec
          jsr  $BDCD
          rts
          
          
:Print_Mats
          ldx  #02
          ldy  #00
          clc
          jsr  $FFF0
          ldx  #00
:Mats_Loop          
          lda  Mats_Text, x
          cmp  #00
          beq  Print_Mats2
          jsr  $FFD2
          inx
          jmp  Mats_Loop
:Print_Mats2
          ldx  #2
          ldy  #22
          clc
          jsr  $FFF0
          ldx  Materials
          lda  Mats_High
          sec
          jsr  $BDCD
          rts                   

:Mats_Logic
          jsr  Calculate_Mats_Pos
          jsr  Mats_Col_Check
          
:Calculate_Mats_Pos
          lda  Mats_State
          cmp  #01
          bne  No_Mats
          lda  #00
          sta Mats_State
          lda  Zombie_Timer
          and  #%00000111
          adc #04
          sta  Mats_Y_Pos
          lda  Zombie_Timer
          adc  Mats_Counter
          and  #%00001111
          adc  #08
          sta  Mats_X_Pos
          rts
:No_Mats
          rts

:Draw_Mats
          lda  Room
          cmp  #01
          beq  No_Mats
          lda  Mats_X_Pos
          sta  Curser_X_Pos
          lda  Mats_Y_Pos
          sta  Curser_Y_Pos
          lda  #Material_Box
          sta  Current_Tile
          jsr Draw_Tile
          rts
          
          
:Mats_Col_Check
          lda  Room
          cmp  #01
          beq  No_Collect
          lda  Player_X_Pos
          cmp  Mats_X_Pos
          bne  No_Collect
          lda  Player_Y_Pos
          cmp  Mats_Y_Pos
          beq  Collect
          rts
:Collect

          lda  #01
          sta  Mats_State
          clc
          lda  Materials
          adc  #01
          sta Materials
          bcs Set_Mats_High
          rts
:No_Collect
          rts
   
:Set_Mats_High
          inc  Mats_High
          rts
  
:Stop_Zom1_Spawn
          lda  #00
          cmp  Game_Mode
          bne  Spawn
          lda  #01
          sta  Zombie1_State
          rts
:Spawn 
          rts


:Silence_Sid
          ldx  #$18
          lda  #00
:Silence_Loop
          sta  $D400, x
          dex
          bpl  Silence_Loop
          ldy  #15
          ldx  #11
          clc
          jsr  $FFF0
          rts
:Pause
          lda  #$FF
          sta  Song
          jsr Silence_Sid          
          ldx #00
:Pause_Loop  
          lda  #$05
          jsr  $FFD2
          lda  Pause_Text, x
          cmp  #00
          beq  Pause_Input
          jsr  $FFD2
          inx
          jmp  Pause_Loop
:Pause_Input                                
          lda  $C5
          cmp  #00
          beq  Reset
          cmp  #$29
          beq  Pause
          cmp  #$40
          beq Pause
          jmp  Unpause
:Unpause
          lda  #$93
          jsr  $FFD2
          jsr Initionalise_Colour
          lda  Main_Song
          sta  Song
          jmp  Game_Run_Loop

:Reset
          jmp  Setup
          
 
          
:Load_Game_Over_Screen
          lda  #00
          sta  Car_On
          lda  #01
          sta  $0286
          lda  #02
          sta  $D020
          sta $D021
          lda  #$93
          jsr  $FFD2
          ldx  #00
   
:Load_Game_Over_Screen_Loop

          lda Game_Over_Screen, x        
          sta ScreenRam, x  
          lda Game_Over_Screen + $100, x  
          sta ScreenRam + $100, x
          lda Game_Over_Screen + $200, x  
          sta ScreenRam + $200, x
          lda Game_Over_Screen + $300, x  
          sta  ScreenRam + $300, x
          inx
          beq  End_Over_Load
          jmp  Load_Game_Over_Screen_Loop
          
:Game_Over
          lda  #$FF
          sta  Song
          inc  Player_Death_Count
          jsr  Load_Game_Over_Screen
          jsr  Print_Score
          jsr  Print_Mats
          lda  $C5
          sta  Last_Press
          jsr Check_Bad_Allowed
          
:Game_Over_Loop
          lda  $C5
          cmp  Last_Press
          beq Game_Over_Loop
          lda  $C5
          cmp  #$3C
          bne  Game_Over_Loop
          jmp Setup   

:Check_Bad_Allowed
          lda  Bad_Allowed
          cmp  #01
          bne  Game_Over_Loop
          lda  #01
          sta  Player_Death_Count
          jmp  Game_Over_Loop

          
:End_Over_Load
          rts



:Player_Edge_Col
          lda  Player_X_Pos
          cmp  #255
          beq  Reset_Player_Pos
          cmp  #40
          beq  Reset_Player_Pos
          lda  Player_Y_Pos
          cmp  #0
          beq  Reset_Player_Pos
          cmp  #25
          beq  Reset_Player_Pos
          rts

:Reset_Player_Pos
          lda  Player_X_Buff
          sta  Player_X_Pos
          lda  Player_Y_Buff
          sta  Player_Y_Pos
          rts

:Key_Logic
          lda  Room
          cmp  #01
          beq  No_Key
          beq  No_Key
          lda  Key_State
          cmp  #01
          beq  No_Key
          lda  Materials
          cmp  #35
          bcc  No_Key
          jsr  Check_Key_Col
          jsr  Draw_Key
          rts
          
:Check_Key_Col
          lda  Player_X_Pos
          cmp  Key_X_Pos
          bne  No_Key
          lda  Player_Y_Pos
          cmp  Key_Y_Pos
          beq  Collect_Key
          rts
          

          
:No_Key
          rts
          
          
:Collect_Key
          lda  #01
          sta  Key_State
          rts
          
:Draw_Key
          lda  Key_X_Pos
          sta  Curser_X_Pos
          lda  Key_Y_Pos
          sta  Curser_Y_Pos
          lda  #Key
          sta Current_Tile
          jsr  Draw_Tile
          rts
          
:Car_Logic
          jsr  Car_Spawn_Check
          jsr  Car_Coll          
          
:Car_Spawn_Check
          lda  Materials
          cmp  #100
          bcs  Spawn_Car
          rts
          
:Spawn_Car
          lda  Room
          cmp  #01
          beq  No_Key
          lda  #$80                        
          sta  $07F8  ;Set the sprite pointer to the car sprites location in RAM ( $80 * $40(64) = $2000 )
          lda  Game_Mode
          cmp  #02
          beq No_Key      
          lda  #100
          sta  Car_X_Pos
          lda  #100
          sta  Car_Y_Pos
          lda  #01
          sta  Car_On
          rts
          
:Car_Coll
          lda  Materials
          Cmp  #100
          bcc  No_Key
          lda  Room
          cmp  #01
          beq  No_Key
          lda  Game_Mode
          cmp  #02
          beq No_Key
          lda  Player_X_Pos
          cmp  #09
          beq  Check_Car_Y
          cmp  #10
          Beq  Check_Car_Y
          cmp  #11
          beq  Check_Car_Y
          cmp  #12
          Beq  Check_Car_Y
          rts
          
:Check_Car_Y
          lda  Player_Y_Pos
          cmp  #06
          beq Ending
          cmp  #07
          beq  Ending
          cmp  #08
          beq  Ending
          cmp  #09
          beq  Ending
          rts
          
          
:Ending


:Ending_Music

          lda  #Ending_Song
          sta  Song
          cli

                    
:End_Screen_Load
          lda  #$93
          jsr  $FFD2
          lda  #00  ;Set Screen Colour
          sta  $D021
          lda  #$0B  ; Set Screen Border Colour
          sta  $D020
:Check_For_Best_Ending
          lda  Player_Death_Count
          bne  End_Screen_Load_Loop
          lda  Game_Mode
          cmp  #01
          bne  End_Screen_Load_Loop
          ldx  #00
          jmp  Load_Best_Ending_Loop
          
:End_Screen_Load_Loop
          lda Ending_Screen, x        
          sta ScreenRam, x  
          lda Ending_Screen + $100, x  
          sta ScreenRam + $100, x
          lda Ending_Screen + $200, x  
          sta ScreenRam + $200, x
          lda Ending_Screen + $300, x  
          sta ScreenRam + $300, x
          inx
          bne  End_Screen_Load_Loop
          

          ldx  #$00      
          lda  #02
          jmp Ending_Colour_Set_Loop

:Load_Best_Ending_Loop

          lda Best_Ending_Screen, x        
          sta ScreenRam, x  
          lda Best_Ending_Screen + $100, x  
          sta ScreenRam + $100, x
          lda Best_Ending_Screen + $200, x  
          sta ScreenRam + $200, x
          lda Best_Ending_Screen + $300, x  
          sta ScreenRam + $300, x
          inx
          bne Load_Best_Ending_Loop
          

          ldx  #$00      
          lda  #02
          jmp Ending_Colour_Set_Loop
   

:Ending_Colour_Set_Loop
          sta  $D800, x  
          sta  $D800 + $100, x    
          sta  $D800 + $200, x     
          sta  $D800 + $300, x    
          inx              
          bne  Ending_Colour_Set_Loop   
          lda  #00
          sta  Car_On
          lda  #02
          sta  $D020
          lda  #02
:Ending_Check
          lda  Game_Mode
          cmp  #01
          beq  Set_Beat_Game
          
:Ending_Input_Handle     
     
          lda  $C5
          sta  Last_Press
          lda  Game_Mode
          cmp  #00
          beq Ending_Input_Handle_Loop
          lda  Player_Death_Count
          cmp  #10
          bcs Print_Bad_Ending

:Ending_Input_Handle_Loop
          lda  $C5
          cmp  Last_Press
          beq  Ending_Input_Handle_Loop
          lda  $C5
          cmp  #$3C
          beq  Load_Credits
          jmp  Ending_Input_Handle          
:Set_Beat_Game
          lda  #01
          sta  Beat_Game
          jmp  Ending_Input_Handle

:Print_Bad_Ending
          ldy  #02
          ldx  #12
          clc
          jsr  $FFF0
          lda  #$1C
          jsr $FFD2
          ldx  #00
:Print_Bad_Ending_Loop
          lda  Bad_Ending_Text, x
          cmp  #00
          beq  Ending_Input_Handle_Loop
          jsr $FFD2
          inx
          jmp  Print_Bad_Ending_Loop
          
          
:Load_Credits
          lda  #$93
          jsr  $FFD2
          lda  #02
          ldx #00
:Credits_Colour_Set_loop
          sta  $D800, x  
          sta  $D800 + $100, x    
          sta  $D800 + $200, x     
          sta  $D800 + $300, x    
          inx              
          bne  Credits_Colour_Set_loop  

:Credits_Load_Loop
          lda Credits, x        
          sta ScreenRam, x  
          lda Credits + $100, x  
          sta ScreenRam + $100, x
          lda Credits + $200 , x  
          sta ScreenRam + $200, x
          lda Credits + $300, x  
          sta ScreenRam + $300, x
          inx
          bne  Credits_Load_Loop
          
 
:Credits_Input
          lda  $c5
          sta  Last_Press
:Credits_Loop
          lda  $C5
          cmp  Last_Press
          beq  Credits_Loop
          lda  $C5
          cmp  #$3C
          beq  Restart
          jmp  Credits_Input
          
:Restart
          lda  #00
          sta  Player_Death_Count
          jmp  Setup
          
          
:Door_Col
          lda  Player_Y_Pos
          cmp  Door_Y_Pos
          bne  Not_Col
          lda  Player_X_Pos
          cmp  Door_X_Pos
          beq  Set_Room
          rts
 :Not_Col
          rts
         
:Set_Room
          lda  Room
          cmp  #01
          beq  Exit_Door
:Enter_Door
          lda  #01
          sta  Room
          lda  #$93
          jsr  $FFD2
          lda  #17
          sta  Player_X_Pos
          lda  #03
          sta Player_Y_Pos
          lda  #17
          sta  Door_X_Pos
          lda  #1
          sta  Door_Y_Pos
          lda  #09
          sta  $D020
          lda  #00
          sta Car_On
          jmp  Draw_Door
          rts
:Exit_Door
          lda  #00
          sta  Room
          lda  #19
          sta  Door_Y_Pos
          lda  #14
          sta  Door_X_Pos
          lda  #14
          sta  Player_X_Pos
          lda  #17
          sta Player_Y_Pos
          lda  #$93
          jsr  $FFD2
          jmp Initionalise_Colour
          rts
          
:Lock_Logic
          lda  Key_State
          cmp  #01
          beq  Clear_Lock
          jsr  Lock_Check
          jsr  Draw_Lock
          rts
:Lock_Check

          lda  Player_X_Pos
          cmp  Lock_X_Pos
          bne  No_Lock
          lda  Player_Y_Pos
          cmp  Lock_Y_Pos
          beq  Stop_Player
          rts
          
:Stop_Player
          jsr  Colided
          rts
           
:No_Lock
          rts
:Draw_Lock
          lda  Lock_X_Pos
          sta  Curser_X_Pos
          lda  Lock_Y_Pos
          sta  Curser_Y_Pos
          lda  #Lock
          sta  Current_Tile
          jsr Draw_Tile
          rts
:Clear_Lock
          lda  Lock_X_Pos
          sta  Curser_X_Pos
          lda  Lock_Y_Pos
          sta  Curser_Y_Pos
          jsr Clear_Tile
          rts    


:Set_Animation_Frame
          lda  Game_Mode
          cmp  #01
          bne  Ignore_Check_If_Easy
          lda  Player_Death_Count
          cmp  #10
          bcs  Set_Bad_Tiles
:Ignore_Check_If_Easy
          lda  Animation_Frame
          clc
          adc  #01
          and  #%00000001
          sta  Animation_Frame
          cmp  #01
          beq  Set_Frame_1
          jmp Set_Frame_0
:Set_Frame_0
          lda  #Player_Frame_0
          sta  Player_Tile
          lda  #Zombie_Frame_0
          sta  Zombie_Tile
          rts
:Set_Frame_1
          lda  #Player_Frame_1
          sta  Player_Tile
          lda  #Zombie_Frame_1
          sta  Zombie_Tile
          jsr Check_Player_Move
          rts          
          
:Check_Player_Move
          lda  Player_X_Pos
          cmp  Player_X_Buff
          bne  Moved
          lda  Player_Y_Pos
          cmp  Player_Y_Buff
          beq  Set_Frame_0_Player
          rts
          
:Moved
          rts
:Set_Frame_0_Player
          lda  #Player_Frame_0
          sta  Player_Tile
          rts
:Set_Bad_Tiles

          lda  #Zombie_Frame_0
          sta  Player_Tile
          lda  #Zombie_Frame_0
          sta  Zombie_Tile
          rts
          
:Swap_Weapon
          lda  Swapable
          cmp  #01
          bne  Moved
          lda  $C5
          cmp  #$2A
          bne  Moved
          lda  Key_Press
          cmp  #00
          bne Moved
          lda  #01
          sta Key_Press
          jsr Bullet_Off
          lda  Gun_State
          clc
          adc #01
          And  #%00000001
          sta Gun_State
          rts

:Print_Weapon_Text
          ldx  #01
          ldy  #30
          clc
          jsr  $FFF0
          lda  #05
          jsr $FFD2
          ldx #00
          
:Weapon_Text_Loop
          lda  Weapon_Text, x
          cmp  #00
          beq  Print_Weapon
          jsr  $FFD2
          inx
          jmp  Weapon_Text_Loop
:Print_Weapon
          lda  Gun_State
          cmp  #01
          beq  Print_Gun
          jmp  Print_Dag
:Print_Dag
          ldx  #Up_Dag
          clc
          lda Colour,x
          jsr  $FFD2
          lda  Tile, x
          jsr $FFD2
          rts
:Print_Gun
          ldx  #Right_Gun
          clc
          lda Colour,x
          jsr  $FFD2
          lda  Tile, x
          jsr  $FFD2
          rts
          
               
:Debug
          lda  $C5
          cmp  #$25
          bne  Debug_End
          lda  Materials
          clc
          adc  #10
          bcs Debug_High
          sta  Materials
          rts
                    
:Debug_High
          inc  Mats_High
          sta Materials
          rts

:Debug_End
          rts
          
          
:Bonus
          lda  Beat_Game
          cmp  #01
          bne  Not_Unlocked
          lda  #Ending_Song
          sta  Song
          jsr  $1900
          jsr  Silence_Sid
          jmp Load_Bonus_Screen

:Not_Unlocked
          jmp  Title_Screen

:Load_Bonus_Screen
          lda  #$93
          jsr  $FFD2
          lda  #00                   
          sta  $D021
          lda  #$0B
          sta $D020
          ldx  #00
          
  
         
:Load_Bonus_Screen_Loop

          lda Bonus_Screen, x        
          sta ScreenRam, x  
          lda Bonus_Screen + $100, x  
          sta ScreenRam + $100, x
          lda Bonus_Screen + $200, x  
          sta ScreenRam + $200, x
          lda Bonus_Screen + $300, x  
          sta ScreenRam + $300, x

          lda Bonus_Colour, x        
          sta $D800, x      
          lda Bonus_Colour + $100, x  
          sta  $D800 + $100, x   
          lda Bonus_Colour + $200, x  
          sta $D800 + $200, x      
          lda Bonus_Colour + $300, x  
          sta  $D800 + $300, x
          inx
          bne  Load_Bonus_Screen_Loop
          

:Bonus_Menu

          lda  $C5
          cmp  #$08
          beq  Pre_Alpha
          cmp  #$3B
          beq  Goto_Time
          cmp  #$38
          beq  Goto_Jukebox
          cmp  #$3C
          beq Return_Title
          jmp  Bonus_Menu

:Return_Title
          jmp  Setup

:Goto_Time
          jmp  Time_Played

:Goto_Jukebox
          jmp  Jukebox

:Pre_Alpha
          lda  #$93
          jsr  $FFD2
          lda  #$FF
          sta  Song
          jsr Silence_Sid
          lda  #$93
          jsr  $FFD2
          lda  #12
          sta  Player_X_Pos
          sta  Player_Y_Pos
          sta  Zombie1_Y_Pos
          lda  #5
          sta Zombie1_X_Pos
       
          lda  $D018
          AND  #$F0
          ORA  #$0C
          Sta  $D018
:Game_Run_Loop_Alpha

          jsr  Clear_Player_Alpha
          jsr Clear_Zombie1_Alpha
          jsr  KeyScan_Alpha
          jsr  Zombie_Slot_1_Alpha
          jsr  Draw_Player_Alpha
          jsr  Delay_Alpha
          jsr Check_Break_Alpha
          jmp  Game_Run_Loop_Alpha
          
:Clear_Player_Alpha
          ldx  Player_Y_Pos
          ldy  Player_X_Pos
          clc
          Jsr  $FFF0
          lda  #$20
          jsr $FFD2
          rts
          
          
:Clear_Zombie1_Alpha
          ldx  Zombie1_Y_Pos
          ldy  Zombie1_X_Pos
          clc
          Jsr  $FFF0
          lda  #$20
          jsr $FFD2
          rts 
:Delay_Alpha
          ldy  #$40     ; Outer loop delay factor
:Outer_Alpha
          ldx  #$00     ; Inner loop
:Inner_Alpha
          dex
          bne  Inner_Alpha
          dey
          bne  Outer_Alpha
          rts
:KeyScan_Alpha
          lda  $C5
          cmp  #$40
Beq Exit_Scan_Alpha
          lda  $C5
          cmp  #$0A
          beq  Move_Player_Left_Alpha
          cmp  #$12
          beq  Move_Player_Right_Alpha
          cmp  #$09
          beq  Move_Player_Up_Alpha
          cmp  #$0D
          beq Move_Player_Down_Alpha
          rts
:Exit_Scan_Alpha
          rts
          
 :Move_Player_Left_Alpha
          dec  Player_X_Pos
          rts
 :Move_Player_Right_Alpha
          inc  Player_X_Pos
          rts
:Move_Player_Up_Alpha
          dec  Player_Y_Pos
          rts

:Move_Player_Down_Alpha
          inc  Player_Y_Pos
          rts



:Draw_Player_Alpha


          ldx  Player_Y_Pos
          ldy  Player_X_Pos
          clc
          jsr  $FFF0
          ldx  #Player_Frame_0
          lda  Colour, x
          jsr  $FFD2
          lda  Tile, x
          jsr  $FFD2
          rts
          
:Zombie_Slot_1_Alpha 
          jsr  Calculate_Zombie1_Alpha
          jsr  Draw_Zombie1_Alpha
   
:Draw_Zombie1_Alpha
          ldx  Zombie1_Y_Pos
          ldy  Zombie1_X_Pos
          clc
          jsr  $FFF0
          ldx  #Zombie_Frame_0
          lda  Colour, x
          jsr  $FFD2
          lda  Tile, x
          jsr  $FFD2
          rts

:Calculate_Zombie1_Alpha   
             
:Calculate_Y_Zombie1_Alpha
          
          lda  Player_X_Pos
          cmp  Zombie1_X_Pos
          bne  Calculate_X_Zombie1_Alpha
          lda  Player_Y_Pos
          cmp  Zombie1_Y_Pos
          beq No_Move_Alpha
          bcc  Move_Zombie1_Up_Alpha          
          bcs  Move_Zombie1_Down_Alpha

:Calculate_X_Zombie1_Alpha
          clc
          lda  Player_X_Pos
          cmp  Zombie1_X_Pos
          beq No_Move_Alpha
          bcc  Move_Zombie1_Left_Alpha          
          bcs  Move_Zombie1_Right_Alpha
          rts          
:Move_Zombie1_Left_Alpha
          dec  Zombie1_X_Pos
          rts
:Move_Zombie1_Right_Alpha
          inc  Zombie1_X_Pos
          rts
:Move_Zombie1_Up_Alpha
          dec  Zombie1_Y_Pos
          rts

:Move_Zombie1_Down_Alpha
          inc  Zombie1_Y_Pos
          rts
:No_Move_Alpha
          rts
        
          
:Check_Break_Alpha
          lda  $C5
          cmp  #$3C
          beq  Break_Alpha
          rts
:Break_Alpha
          jmp  Bonus
      
          
:Time_Played
          lda  #$05
          jsr  $FFD2

          lda  #$93
          jsr  $FFD2
          ldx  Minuites
          lda  #00
          jsr  $BDCD
          lda  #$3A
          jsr  $FFD2
          ldx  Seconds
          lda #00
          jsr  $BDCD
          lda  $C5
          cmp  #$3C
          beq Return_Time_Played
          jmp  Time_Played
   
          
:Return_Time_Played
          jmp  Bonus
          
:Jukebox
          lda  #$93
          jsr  $FFD2
          lda  #$05
          jsr $FFD2
          ldx #00
:JukeBox1_Loop          
          lda  Jukebox1_Text, x
          cmp  #00
          beq  Print_Jukebox2
          jsr  $FFD2
          inx
          jmp  JukeBox1_Loop
                  
:Print_Jukebox2
          ldy  #00
          ldx  #02
          clc
          jsr  $FFF0
          ldx #00
          
:Jukebox2_Loop
          lda  Jukebox2_Text, x
          cmp  #00
          beq  Print_Jukebox3
          jsr  $FFD2
          inx
          jmp  Jukebox2_Loop
:Print_Jukebox3
          ldy  #00
          ldx  #04
          clc
          jsr  $FFF0
          ldx  #00
:Jukebox3_Loop
          lda  Jukebox3_Text, x
          cmp  #00
          beq  Jukebox_Menu
          jsr  $FFD2
          inx
          jmp  Jukebox3_Loop                   
          
:Jukebox_Menu
          lda  $C5
          cmp  #$38
          beq  Set_Jukebox_Main
          cmp  #$3B
          beq  Set_Jukebox_Title
          cmp  #$08
          beq  Set_Jukebox_Ending
          cmp  #$3C
          beq Return_Jukebox
          jmp Jukebox_Menu

:Set_Jukebox_Main
          lda  #Main_Song
          sta  Song
          jsr  $1000           
          jsr  Silence_Sid       
          jmp  Jukebox_Menu
          
:Set_Jukebox_Title

          lda  #Title_Song
          sta  Song
          jsr  $1500                    
          jsr  Silence_Sid                  
          jmp  Jukebox_Menu
          
:Set_Jukebox_Ending
          lda  #Ending_Song
          sta  Song
          jsr  $1900             
          jsr  Silence_Sid               
          jmp  Jukebox_Menu

:Return_Jukebox
          jmp  Bonus
                                                                                      
Tile
          !byte  $60, $60, $61, $62, $63, $64, $66, $65, $67, $68, $69, $6A,$61,$6C,$6D,$6B,$6E,$6F,$71,$71
Colour
          !byte  $1E, $81, $97, $9E, $1c, $9E, $95, $97, $97, $97, $97, $97,$97,$97,$97,$97,$9E,$1C,$81,$1E

:Score       
          !text  "ZOMBIES KILLED = "
          !Byte  $00

:Mats_Text
          !text  "MATERIALS COLLECTED = "
          !Byte  $00

:Pause_Text
          !Text  "PAUSE"
          !Byte  $00

:Weapon_Text
          !Text  "WEAPON = "
          !Byte  $00
          
:Infected_Text          
          !Text  "YOU ARE INFECTED!            "
          !Byte  $00
          
:Bad_Ending_Text
          !Text  "YOUR FAMILY MADE IT BUT YOU NEVER                                                            RECOVERED"
          !Byte $00
          
:Disabled_Text
          !Text  "ALTERNATE ENDINGS DISABLED"
          !Byte  $00
:Jukebox1_Text
          !Text  "1. MAIN THEME"
          !byte  $00
:Jukebox2_Text
          !Text  "2. TITLE THEME"
          !Byte  $00
:Jukebox3_Text
          !Text  "3. ENDING THEME"
          !Byte  $00
:Bonus_Text
          !Text  "BONUS FEATURES UNLOCKED (PRESS B)   "
          !Byte  $00
  

* = $C000

          inc  $D019 ;Acknoweledge interrupt
          
:Save_X_And_Y_Registers;Via Stack
          pha
          txa
          pha
          tya
          pha

:Interupt_Run_Order
          jsr  Count_Seconds
          Jsr  Increment_Mats_Random_Timer
          Jmp  Music_Routines

:Increment_Mats_Random_Timer                         
          inc  Mats_Counter
          rts
:Count_Seconds
          Inc  Timer
          lda  Timer
          cmp  #50
          beq  Set_Seconds
          rts
:Set_Seconds
          lda  #00
          sta  Timer
          inc  Seconds
          lda Seconds
          cmp  #60
          beq  Set_Minuites
          rts
:Set_Minuites
          lda  #00
          sta  Seconds
          inc  Minuites
          lda Minuites
          rts
          


:Music_Routines       
          lda  Song
          cmp  #Ending_Song
          beq  Play_Ending
          cmp  #Main_Song
          beq  Play_Main
          cmp #Title_Song
          beq  Play_Title
          jmp Play_Nothing

:Play_Main
          jsr  $1003
          jmp Return

:Play_Ending
          jsr  $1503
          jmp  Return
          
:Play_Title
          jsr  $1903
          jmp  Return
          
:Play_Nothing
          jmp  Return
          
:Return
          pla
          tay
          pla
          tax
          pla
          jmp  $EA31
          
          

          
                 
* = $3000

CHARS
!byte $3c,$66,$6e,$6e,$60,$62,$3c,$00
!byte $18,$3c,$66,$7e,$66,$66,$66,$00
!byte $7c,$66,$66,$7c,$66,$66,$7c,$00
!byte $3c,$66,$60,$60,$60,$66,$3c,$00
!byte $78,$6c,$66,$66,$66,$6c,$78,$00
!byte $7e,$60,$60,$78,$60,$60,$7e,$00
!byte $7e,$60,$60,$78,$60,$60,$60,$00
!byte $3c,$66,$60,$6e,$66,$66,$3c,$00
!byte $66,$66,$66,$7e,$66,$66,$66,$00
!byte $3c,$18,$18,$18,$18,$18,$3c,$00
!byte $1e,$0c,$0c,$0c,$0c,$6c,$38,$00
!byte $66,$6c,$78,$70,$78,$6c,$66,$00
!byte $60,$60,$60,$60,$60,$60,$7e,$00
!byte $63,$77,$7f,$6b,$63,$63,$63,$00
!byte $66,$76,$7e,$7e,$6e,$66,$66,$00
!byte $3c,$66,$66,$66,$66,$66,$3c,$00
!byte $7c,$66,$66,$7c,$60,$60,$60,$00
!byte $3c,$66,$66,$66,$66,$3c,$0e,$00
!byte $7c,$66,$66,$7c,$78,$6c,$66,$00
!byte $3c,$66,$60,$3c,$06,$66,$3c,$00
!byte $7e,$18,$18,$18,$18,$18,$18,$00
!byte $66,$66,$66,$66,$66,$66,$3c,$00
!byte $66,$66,$66,$66,$66,$3c,$18,$00
!byte $63,$63,$63,$6b,$7f,$77,$63,$00
!byte $66,$66,$3c,$18,$3c,$66,$66,$00
!byte $66,$66,$66,$3c,$18,$18,$18,$00
!byte $7e,$06,$0c,$18,$30,$60,$7e,$00
!byte $3c,$30,$30,$30,$30,$30,$3c,$00
!byte $0c,$12,$30,$7c,$30,$62,$fc,$00
!byte $3c,$0c,$0c,$0c,$0c,$0c,$3c,$00
!byte $00,$18,$3c,$7e,$18,$18,$18,$18
!byte $00,$10,$30,$7f,$7f,$30,$10,$00
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $18,$18,$18,$18,$00,$00,$18,$00
!byte $66,$66,$66,$00,$00,$00,$00,$00
!byte $66,$66,$ff,$66,$ff,$66,$66,$00
!byte $18,$3e,$60,$3c,$06,$7c,$18,$00
!byte $62,$66,$0c,$18,$30,$66,$46,$00
!byte $3c,$66,$3c,$38,$67,$66,$3f,$00
!byte $06,$0c,$18,$00,$00,$00,$00,$00
!byte $0c,$18,$30,$30,$30,$18,$0c,$00
!byte $30,$18,$0c,$0c,$0c,$18,$30,$00
!byte $00,$66,$3c,$ff,$3c,$66,$00,$00
!byte $00,$18,$18,$7e,$18,$18,$00,$00
!byte $00,$00,$00,$00,$00,$18,$18,$30
!byte $00,$00,$00,$7e,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$18,$18,$00
!byte $00,$03,$06,$0c,$18,$30,$60,$00
!byte $3c,$66,$6e,$76,$66,$66,$3c,$00
!byte $18,$18,$38,$18,$18,$18,$7e,$00
!byte $3c,$66,$06,$0c,$30,$60,$7e,$00
!byte $3c,$66,$06,$1c,$06,$66,$3c,$00
!byte $06,$0e,$1e,$66,$7f,$06,$06,$00
!byte $7e,$60,$7c,$06,$06,$66,$3c,$00
!byte $3c,$66,$60,$7c,$66,$66,$3c,$00
!byte $7e,$66,$0c,$18,$18,$18,$18,$00
!byte $3c,$66,$66,$3c,$66,$66,$3c,$00
!byte $3c,$66,$66,$3e,$06,$66,$3c,$00
!byte $00,$00,$18,$00,$00,$18,$00,$00
!byte $00,$00,$18,$00,$00,$18,$18,$30
!byte $0e,$18,$30,$60,$30,$18,$0e,$00
!byte $00,$00,$7e,$00,$7e,$00,$00,$00
!byte $70,$18,$0c,$06,$0c,$18,$70,$00
!byte $3c,$66,$06,$0c,$18,$00,$18,$00
!byte $38,$44,$44,$7c,$10,$7c,$10,$28
!byte $00,$00,$00,$3f,$7e,$70,$60,$60
!byte $00,$00,$00,$00,$b3,$00,$00,$00
!byte $00,$00,$18,$24,$42,$ff,$ff,$42
!byte $00,$18,$24,$24,$3c,$3c,$3c,$3c
!byte $00,$1c,$14,$1c,$08,$18,$08,$18
!byte $7c,$44,$44,$7c,$74,$7c,$7c,$7c
!byte $00,$00,$00,$04,$ff,$04,$00,$00
!byte $00,$00,$00,$40,$ff,$40,$00,$00
!byte $10,$10,$10,$10,$10,$10,$38,$10
!byte $10,$38,$10,$10,$10,$10,$10,$10
!byte $20,$30,$30,$30,$30,$3f,$1f,$00
!byte $00,$78,$7c,$0c,$0c,$0c,$0c,$04
!byte $00,$00,$00,$fc,$7e,$06,$06,$06
!byte $10,$10,$00,$00,$10,$00,$10,$10
!byte $ee,$ee,$ee,$00,$ee,$ee,$ee,$00
!byte $7e,$81,$b9,$a1,$a1,$b9,$81,$7e
!byte $38,$44,$44,$7c,$10,$7c,$10,$10
!byte $00,$00,$00,$00,$00,$ff,$ff,$00
!byte $36,$7f,$7f,$7f,$3e,$1c,$08,$00
!byte $60,$60,$60,$60,$60,$60,$60,$60
!byte $00,$00,$00,$07,$0f,$1c,$18,$18
!byte $c3,$e7,$7e,$3c,$3c,$7e,$e7,$c3
!byte $00,$3c,$7e,$66,$66,$7e,$3c,$00
!byte $18,$18,$66,$66,$18,$18,$3c,$00
!byte $06,$06,$06,$06,$06,$06,$06,$06
!byte $08,$1c,$3e,$7f,$3e,$1c,$08,$00
!byte $18,$18,$18,$ff,$ff,$18,$18,$18
!byte $c0,$c0,$30,$30,$c0,$c0,$30,$30
!byte $18,$18,$18,$18,$18,$18,$18,$18
!byte $00,$00,$03,$3e,$76,$36,$36,$00
!byte $ff,$7f,$3f,$1f,$0f,$07,$03,$01
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
!byte $00,$00,$00,$00,$ff,$ff,$ff,$ff
!byte $ff,$00,$00,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$00,$00,$ff
!byte $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0
!byte $cc,$cc,$33,$33,$cc,$cc,$33,$33
!byte $03,$03,$03,$03,$03,$03,$03,$03
!byte $00,$00,$00,$00,$cc,$cc,$33,$33
!byte $ff,$fe,$fc,$f8,$f0,$e0,$c0,$80
!byte $03,$03,$03,$03,$03,$03,$03,$03
!byte $18,$18,$18,$1f,$1f,$18,$18,$18
!byte $00,$00,$00,$00,$0f,$0f,$0f,$0f
!byte $18,$18,$18,$1f,$1f,$00,$00,$00
!byte $00,$00,$00,$f8,$f8,$18,$18,$18
!byte $00,$00,$00,$00,$00,$00,$ff,$ff
!byte $00,$00,$00,$1f,$1f,$18,$18,$18
!byte $18,$18,$18,$ff,$ff,$00,$00,$00
!byte $00,$00,$00,$ff,$ff,$18,$18,$18
!byte $18,$18,$18,$f8,$f8,$18,$18,$18
!byte $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0
!byte $e0,$e0,$e0,$e0,$e0,$e0,$e0,$e0
!byte $07,$07,$07,$07,$07,$07,$07,$07
!byte $ff,$ff,$00,$00,$00,$00,$00,$00
!byte $ff,$ff,$ff,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$ff,$ff,$ff
!byte $03,$03,$03,$03,$03,$03,$ff,$ff
!byte $00,$00,$00,$00,$f0,$f0,$f0,$f0
!byte $0f,$0f,$0f,$0f,$00,$00,$00,$00
!byte $18,$18,$18,$f8,$f8,$00,$00,$00
!byte $f0,$f0,$f0,$f0,$00,$00,$00,$00
!byte $f0,$f0,$f0,$f0,$0f,$0f,$0f,$0f
!byte $c3,$99,$91,$91,$9f,$99,$c3,$ff
!byte $e7,$c3,$99,$81,$99,$99,$99,$ff
!byte $83,$99,$99,$83,$99,$99,$83,$ff
!byte $c3,$99,$9f,$9f,$9f,$99,$c3,$ff
!byte $87,$93,$99,$99,$99,$93,$87,$ff
!byte $81,$9f,$9f,$87,$9f,$9f,$81,$ff
!byte $81,$9f,$9f,$87,$9f,$9f,$9f,$ff
!byte $c3,$99,$9f,$91,$99,$99,$c3,$ff
!byte $99,$99,$99,$81,$99,$99,$99,$ff
!byte $c3,$e7,$e7,$e7,$e7,$e7,$c3,$ff
!byte $e1,$f3,$f3,$f3,$f3,$93,$c7,$ff
!byte $99,$93,$87,$8f,$87,$93,$99,$ff
!byte $9f,$9f,$9f,$9f,$9f,$9f,$81,$ff
!byte $9c,$88,$80,$94,$9c,$9c,$9c,$ff
!byte $99,$89,$81,$81,$91,$99,$99,$ff
!byte $c3,$99,$99,$99,$99,$99,$c3,$ff
!byte $83,$99,$99,$83,$9f,$9f,$9f,$ff
!byte $c3,$99,$99,$99,$99,$c3,$f1,$ff
!byte $83,$99,$99,$83,$87,$93,$99,$ff
!byte $c3,$99,$9f,$c3,$f9,$99,$c3,$ff
!byte $81,$e7,$e7,$e7,$e7,$e7,$e7,$ff
!byte $99,$99,$99,$99,$99,$99,$c3,$ff
!byte $99,$99,$99,$99,$99,$c3,$e7,$ff
!byte $9c,$9c,$9c,$94,$80,$88,$9c,$ff
!byte $99,$99,$c3,$e7,$c3,$99,$99,$ff
!byte $99,$99,$99,$c3,$e7,$e7,$e7,$ff
!byte $81,$f9,$f3,$e7,$cf,$9f,$81,$ff
!byte $c3,$cf,$cf,$cf,$cf,$cf,$c3,$ff
!byte $f3,$ed,$cf,$83,$cf,$9d,$03,$ff
!byte $c3,$f3,$f3,$f3,$f3,$f3,$c3,$ff
!byte $ff,$e7,$c3,$81,$e7,$e7,$e7,$e7
!byte $ff,$ef,$cf,$80,$80,$cf,$ef,$ff
!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
!byte $e7,$e7,$e7,$e7,$ff,$ff,$e7,$ff
!byte $99,$99,$99,$ff,$ff,$ff,$ff,$ff
!byte $99,$99,$00,$99,$00,$99,$99,$ff
!byte $e7,$c1,$9f,$c3,$f9,$83,$e7,$ff
!byte $9d,$99,$f3,$e7,$cf,$99,$b9,$ff
!byte $c3,$99,$c3,$c7,$98,$99,$c0,$ff
!byte $f9,$f3,$e7,$ff,$ff,$ff,$ff,$ff
!byte $f3,$e7,$cf,$cf,$cf,$e7,$f3,$ff
!byte $cf,$e7,$f3,$f3,$f3,$e7,$cf,$ff
!byte $ff,$99,$c3,$00,$c3,$99,$ff,$ff
!byte $ff,$e7,$e7,$81,$e7,$e7,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$e7,$e7,$cf
!byte $ff,$ff,$ff,$81,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$e7,$e7,$ff
!byte $ff,$fc,$f9,$f3,$e7,$cf,$9f,$ff
!byte $c3,$99,$91,$89,$99,$99,$c3,$ff
!byte $e7,$e7,$c7,$e7,$e7,$e7,$81,$ff
!byte $c3,$99,$f9,$f3,$cf,$9f,$81,$ff
!byte $c3,$99,$f9,$e3,$f9,$99,$c3,$ff
!byte $f9,$f1,$e1,$99,$80,$f9,$f9,$ff
!byte $81,$9f,$83,$f9,$f9,$99,$c3,$ff
!byte $c3,$99,$9f,$83,$99,$99,$c3,$ff
!byte $81,$99,$f3,$e7,$e7,$e7,$e7,$ff
!byte $c3,$99,$99,$c3,$99,$99,$c3,$ff
!byte $c3,$99,$99,$c1,$f9,$99,$c3,$ff
!byte $ff,$ff,$e7,$ff,$ff,$e7,$ff,$ff
!byte $ff,$ff,$e7,$ff,$ff,$e7,$e7,$cf
!byte $f1,$e7,$cf,$9f,$cf,$e7,$f1,$ff
!byte $ff,$ff,$81,$ff,$81,$ff,$ff,$ff
!byte $8f,$e7,$f3,$f9,$f3,$e7,$8f,$ff
!byte $c3,$99,$f9,$f3,$e7,$ff,$e7,$ff
!byte $ff,$ff,$ff,$00,$00,$ff,$ff,$ff
!byte $f7,$e3,$c1,$80,$80,$e3,$c1,$ff
!byte $e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7
!byte $ff,$ff,$ff,$00,$00,$ff,$ff,$ff
!byte $ff,$ff,$00,$00,$ff,$ff,$ff,$ff
!byte $ff,$00,$00,$ff,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$00,$00,$ff,$ff
!byte $cf,$cf,$cf,$cf,$cf,$cf,$cf,$cf
!byte $f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3
!byte $ff,$ff,$ff,$1f,$0f,$c7,$e7,$e7
!byte $e7,$e7,$e3,$f0,$f8,$ff,$ff,$ff
!byte $e7,$e7,$c7,$0f,$1f,$ff,$ff,$ff
!byte $3f,$3f,$3f,$3f,$3f,$3f,$00,$00
!byte $3f,$1f,$8f,$c7,$e3,$f1,$f8,$fc
!byte $fc,$f8,$f1,$e3,$c7,$8f,$1f,$3f
!byte $00,$00,$3f,$3f,$3f,$3f,$3f,$3f
!byte $00,$00,$fc,$fc,$fc,$fc,$fc,$fc
!byte $ff,$c3,$81,$81,$81,$81,$c3,$ff
!byte $ff,$ff,$ff,$ff,$ff,$00,$00,$ff
!byte $c9,$80,$80,$80,$c1,$e3,$f7,$ff
!byte $9f,$9f,$9f,$9f,$9f,$9f,$9f,$9f
!byte $ff,$ff,$ff,$f8,$f0,$e3,$e7,$e7
!byte $3c,$18,$81,$c3,$c3,$81,$18,$3c
!byte $ff,$c3,$81,$99,$99,$81,$c3,$ff
!byte $e7,$e7,$99,$99,$e7,$e7,$c3,$ff
!byte $f9,$f9,$f9,$f9,$f9,$f9,$f9,$f9
!byte $f7,$e3,$c1,$80,$c1,$e3,$f7,$ff
!byte $e7,$e7,$e7,$00,$00,$e7,$e7,$e7
!byte $3f,$3f,$cf,$cf,$3f,$3f,$cf,$cf
!byte $e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7
!byte $ff,$ff,$fc,$c1,$89,$c9,$c9,$ff
!byte $00,$80,$c0,$e0,$f0,$f8,$fc,$fe
!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
!byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
!byte $ff,$ff,$ff,$ff,$00,$00,$00,$00
!byte $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$00
!byte $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
!byte $33,$33,$cc,$cc,$33,$33,$cc,$cc
!byte $fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc
!byte $ff,$ff,$ff,$ff,$33,$33,$cc,$cc
!byte $00,$01,$03,$07,$0f,$1f,$3f,$7f
!byte $fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc
!byte $e7,$e7,$e7,$e0,$e0,$e7,$e7,$e7
!byte $ff,$ff,$ff,$ff,$f0,$f0,$f0,$f0
!byte $e7,$e7,$e7,$e0,$e0,$ff,$ff,$ff
!byte $ff,$ff,$ff,$07,$07,$e7,$e7,$e7
!byte $ff,$ff,$ff,$ff,$ff,$ff,$00,$00
!byte $ff,$ff,$ff,$e0,$e0,$e7,$e7,$e7
!byte $e7,$e7,$e7,$00,$00,$ff,$ff,$ff
!byte $ff,$ff,$ff,$00,$00,$e7,$e7,$e7
!byte $e7,$e7,$e7,$07,$07,$e7,$e7,$e7
!byte $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
!byte $1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f
!byte $f8,$f8,$f8,$f8,$f8,$f8,$f8,$f8
!byte $00,$00,$ff,$ff,$ff,$ff,$ff,$ff
!byte $00,$00,$00,$ff,$ff,$ff,$ff,$ff
!byte $ff,$ff,$ff,$ff,$ff,$00,$00,$00
!byte $fc,$fc,$fc,$fc,$fc,$fc,$00,$00
!byte $ff,$ff,$ff,$ff,$0f,$0f,$0f,$0f
!byte $f0,$f0,$f0,$f0,$ff,$ff,$ff,$ff
!byte $e7,$e7,$e7,$07,$07,$ff,$ff,$ff
!byte $0f,$0f,$0f,$0f,$ff,$ff,$ff,$ff
!byte $0f,$0f,$0f,$0f,$f0,$f0,$f0,$f0

    
          
:Map

!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $a0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

:Map_Col_Data
:Map_X_Array
    !byte $00,$01,$00,$01,$00,$01,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d
    !byte $0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$05,$06,$07,$08,$09,$0a
    !byte $0b,$0c,$0d,$0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$05,$06
    !byte $07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16
    !byte $17,$18,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12
    !byte $13,$14,$15,$16,$17,$18,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e
    !byte $0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$05,$06,$07,$08,$09,$0a
    !byte $0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$05,$06
    !byte $07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16
    !byte $17,$18
:Map_Y_Array
    !byte $02,$02,$03,$03,$04,$04,$12,$12,$12,$12,$12,$12,$12,$12,$12
    !byte $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$13,$13,$13,$13,$13,$13
    !byte $13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$14,$14
    !byte $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14
    !byte $14,$14,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15
    !byte $15,$15,$15,$15,$15,$15,$16,$16,$16,$16,$16,$16,$16,$16,$16,$16
    !byte $16,$16,$16,$16,$16,$16,$16,$16,$16,$16,$17,$17,$17,$17,$17,$17
    !byte $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$18,$18
    !byte $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18
    !byte $18,$18,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19
    !byte $19,$19,$19 ,$19,$19,$19,$FF

;size 40,25
:Title_Screen_Data
!byte $20,$20,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $60,$14,$08,$05,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$a0,$60,$60,$a0,$a0,$a0,$60,$60,$a0,$60,$a0,$20,$20,$60,$a0,$a0,$a0,$20,$20,$20,$a0,$a0,$a0,$20,$20,$20,$20,$20,$20,$20
!byte $60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$a0,$60,$60,$a0,$60,$a0,$20,$20,$a0,$20,$a0,$20,$20,$20,$a0,$20,$20,$20,$20,$20,$20,$20,$a0,$20,$20,$20,$20,$20,$20,$20
!byte $60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$a0,$60,$60,$a0,$a0,$a0,$60,$60,$a0,$60,$a0,$20,$20,$20,$a0,$a0,$a0,$20,$20,$20,$a0,$a0,$a0,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$a0,$60,$60,$a0,$60,$60,$a0,$a0,$60,$60,$60,$a0,$20,$a0,$20,$20,$20,$20,$20,$a0,$20,$20,$20,$a0,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$60,$a0,$60,$60,$60,$a0,$60,$60,$a0,$20,$a0,$20,$20,$a0,$a0,$a0,$20,$20,$20,$a0,$a0,$a0,$20,$20,$20,$a0,$a0,$a0,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$10,$12,$05,$13,$13,$20,$31,$20,$06,$0f,$12,$20,$05,$01,$13,$19,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$10,$12,$05,$13,$13,$20,$32,$20,$06,$0f,$12,$20,$08,$01,$12,$04,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$10,$12,$05,$13,$13,$20,$33,$20,$06,$0f,$12,$20,$01,$12,$03,$01,$04,$05,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$60,$20,$50,$20,$32,$30,$32,$36,$20,$0a,$01,$0d,$09,$05,$20,$08,$01,$01,$1a,$05,$0e,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$48,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,$41,$20
!byte $20,$20,$40,$20,$20,$40,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$20,$20,$20,$40,$20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$a0,$a0,$a0
!byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0
!byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0
!byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0

:Title_Screen_Colour
!byte $01,$01,$05,$05,$05,$05,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$01,$05,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$05,$05,$05,$05,$05,$01,$01,$01,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$01,$05,$01,$05,$01,$05,$05,$05,$05,$01,$01,$01,$01,$01,$01,$05,$01,$01,$01,$01,$01,$01,$01
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$05,$05,$05,$05,$05,$01,$01,$01,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$05,$01,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$05,$01,$05,$01,$05,$01,$05,$01,$01,$01,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$05,$01,$01,$05,$05,$05,$01,$01,$01,$05,$05,$05,$01,$01,$01,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$05,$05,$05,$05,$05,$01,$05,$01,$05,$05,$05,$01,$05,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$0e,$0e,$03,$0e,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$0e,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$0a,$0b,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$05,$01,$01,$0b,$01
!byte $01,$01,$05,$01,$01,$05,$01,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$01,$01,$05,$01,$01,$01,$01,$01,$01,$05,$01,$01,$01,$01,$05,$05,$05,$05,$05,$05,$05
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05

:Game_Over_Screen
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$a0,$20,$a0,$20,$a0,$a0,$a0,$20,$a0,$20,$a0,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$60,$a0,$a0,$a0,$60,$a0,$a0,$a0,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$a0,$20,$a0,$20,$a0,$20,$a0,$20,$a0,$20,$a0,$20,$20,$20,$20,$a0,$20,$60,$20,$20,$a0,$20,$a0,$60,$20,$a0,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$20,$a0,$20,$a0,$20,$a0,$20,$a0,$20,$20,$20,$20,$a0,$60,$a0,$a0,$20,$a0,$20,$a0,$60,$20,$a0,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$20,$a0,$20,$a0,$20,$a0,$20,$a0,$20,$20,$20,$20,$a0,$60,$60,$a0,$60,$a0,$20,$a0,$60,$60,$a0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$20,$a0,$a0,$a0,$20,$a0,$a0,$a0,$20,$20,$20,$20,$a0,$a0,$a0,$a0,$20,$a0,$a0,$a0,$60,$20,$a0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$a0,$20,$20,$a0,$20,$a0,$a0,$20,$a0,$a0,$a0,$20,$a0,$a0,$a0,$60,$a0,$a0,$a0,$20,$a0,$a0,$a0,$20,$a0,$a0,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$a0,$a0,$20,$a0,$20,$a0,$20,$20,$a0,$20,$20,$20,$a0,$20,$20,$60,$60,$a0,$20,$20,$a0,$20,$20,$20,$a0,$20,$a0,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$a0,$20,$a0,$a0,$20,$a0,$a0,$20,$a0,$a0,$a0,$20,$a0,$20,$20,$60,$60,$a0,$20,$20,$a0,$a0,$a0,$20,$a0,$20,$a0,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$a0,$20,$20,$a0,$20,$a0,$20,$20,$a0,$20,$20,$20,$a0,$20,$20,$60,$60,$a0,$20,$20,$a0,$20,$20,$20,$a0,$20,$a0,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$a0,$20,$a0,$20,$20,$a0,$20,$a0,$20,$20,$a0,$a0,$a0,$20,$a0,$a0,$a0,$20,$60,$a0,$20,$20,$a0,$a0,$a0,$20,$a0,$a0,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$10,$12,$05,$13,$13,$20,$13,$10,$01,$03,$05,$20,$14,$0f,$20,$12,$05,$14,$15,$12,$0e,$20,$14,$0f,$20,$14,$09,$14,$0c,$05,$20,$13,$03,$12,$05,$05,$0e,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

:Ending_Screen

!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$19,$0f,$15,$20,$08,$01,$16,$05,$20,$03,$0f,$0c,$0c,$05,$03,$14,$05,$04,$20,$05,$0e,$0f,$15,$07,$08,$20,$0d,$01,$14,$05,$12,$09,$01,$0c,$13,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$14,$0f,$20,$13,$15,$03,$03,$05,$13,$13,$06,$15,$0c,$0c,$19,$20,$13,$15,$12,$16,$09,$16,$05,$20,$01,$0e,$04,$20,$19,$0f,$15,$20,$08,$01,$16,$05,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$05,$13,$03,$01,$10,$05,$04,$20,$14,$08,$05,$20,$09,$0e,$06,$05,$03,$14,$05,$04,$20,$01,$12,$05,$01,$2e,$20,$14,$08,$01,$0e,$0b,$13,$20,$14,$0f,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$19,$0f,$15,$12,$20,$05,$06,$06,$0f,$12,$14,$13,$20,$08,$15,$0d,$01,$0e,$09,$14,$19,$20,$17,$09,$0c,$0c,$20,$13,$15,$12,$16,$09,$16,$05,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$14,$08,$01,$0e,$0b,$20,$19,$0f,$15,$20,$06,$0f,$12,$20,$10,$0c,$01,$19,$09,$0e,$07,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

:Credits

!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$03,$12,$05,$04,$09,$14,$13,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20
!byte $60,$60,$60,$60,$10,$12,$0f,$07,$12,$01,$0d,$0d,$09,$0e,$07,$20,$02,$19,$20,$0a,$01,$0d,$09,$05,$20,$08,$01,$01,$1a,$05,$0e,$60,$60,$60,$60,$60,$60,$60,$20,$20
!byte $20,$20,$20,$20,$20,$60,$60,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$60,$60,$60,$07,$01,$0d,$05,$20,$04,$05,$13,$09,$07,$0e,$05,$04,$20,$02,$19,$20,$0a,$01,$0d,$09,$05,$20,$08,$01,$01,$1a,$05,$0e,$20,$20,$20,$20,$20,$20,$20
!byte $20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$60,$60,$15,$13,$09,$0e,$07,$20,$0b,$05,$12,$0e,$01,$0c,$20,$12,$0f,$15,$14,$09,$0e,$05,$13,$20,$0f,$12,$09,$07,$09,$0e,$01,$0c,$0c,$19,$60,$60,$20,$20
!byte $20,$20,$20,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$17,$12,$09,$14,$14,$05,$0e,$20,$02,$19,$20,$03,$0f,$0d,$0d,$0f,$04,$0f,$12,$05,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$03,$0f,$0d,$10,$09,$0c,$05,$12,$20,$15,$13,$05,$04,$20,$40,$20,$03,$36,$34,$20,$13,$14,$15,$04,$09,$0f,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$14,$12,$01,$03,$0b,$05,$12,$20,$15,$13,$05,$04,$20,$40,$60,$07,$0f,$01,$14,$20,$14,$12,$01,$03,$0b,$05,$12,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$60,$20,$09,$0d,$01,$07,$05,$13,$20,$0f,$0e,$20,$02,$0f,$18,$20,$01,$12,$14,$20,$06,$12,$0f,$0d,$20,$10,$0e,$07,$20,$14,$12,$05,$05,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$02,$0f,$18,$20,$01,$12,$14,$20,$01,$0e,$04,$20,$0d,$01,$0e,$15,$05,$0c,$20,$03,$12,$05,$01,$14,$05,$04,$20,$0f,$0e,$20,$03,$01,$0e,$16,$01,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$13,$10,$05,$03,$09,$01,$0c,$20,$14,$08,$01,$0e,$0b,$13,$20,$14,$0f,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$19,$0f,$15,$20,$14,$08,$05,$20,$10,$0c,$01,$19,$05,$12,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

:Best_Ending_Screen
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$19,$0f,$15,$20,$08,$01,$16,$05,$20,$03,$0f,$0c,$0c,$05,$03,$14,$05,$04,$20,$05,$0e,$0f,$15,$07,$08,$20,$0d,$01,$14,$05,$12,$09,$01,$0c,$13,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$01,$0e,$04,$20,$08,$01,$16,$05,$20,$13,$15,$03,$03,$05,$13,$13,$06,$15,$0c,$0c,$19,$20,$05,$13,$03,$01,$10,$05,$04,$20,$14,$08,$05,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$09,$0e,$06,$05,$03,$14,$05,$04,$20,$01,$12,$05,$01,$2e,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$04,$15,$05,$20,$14,$0f,$20,$19,$0f,$15,$12,$20,$05,$18,$14,$12,$01,$0f,$12,$04,$09,$0e,$01,$12,$19,$20,$05,$06,$06,$0f,$12,$14,$13,$20,$01,$0e,$04,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$13,$0b,$09,$0c,$0c,$13,$20,$04,$05,$0d,$0f,$0e,$13,$14,$12,$01,$14,$05,$04,$20,$02,$19,$20,$0e,$0f,$14,$20,$07,$05,$14,$14,$09,$0e,$07,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$02,$09,$14,$14,$05,$0e,$20,$05,$16,$05,$0e,$20,$0f,$0e,$03,$05,$20,$19,$0f,$15,$12,$20,$03,$05,$0c,$0c,$13,$20,$17,$05,$12,$05,$20,$15,$13,$05,$04,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$14,$0f,$20,$06,$09,$0e,$04,$20,$01,$20,$03,$15,$12,$05,$20,$06,$0f,$12,$20,$14,$08,$05,$20,$16,$09,$12,$15,$13,$20,$03,$01,$15,$13,$09,$0e,$07,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$01,$0c,$0c,$20,$14,$08,$05,$20,$1a,$0f,$0d,$02,$09,$05,$13,$20,$14,$08,$01,$14,$20,$08,$01,$04,$20,$0e,$0f,$14,$20,$04,$09,$05,$04,$20,$19,$05,$14,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$13,$15,$12,$16,$09,$16,$05,$2e,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$05,$18,$14,$12,$01,$20,$13,$10,$05,$03,$09,$01,$0c,$20,$14,$08,$01,$0e,$0b,$13,$20,$06,$0f,$12,$20,$10,$0c,$01,$19,$09,$0e,$07,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
          !byte  $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20

:Bonus_Screen
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$02,$0f,$0e,$15,$13,$20,$06,$05,$01,$14,$15,$12,$05,$13,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$31,$2e,$20,$0a,$15,$0b,$05,$02,$0f,$18,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$32,$2e,$20,$14,$09,$0d,$05,$20,$10,$0c,$01,$19,$05,$04,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$33,$2e,$20,$16,$09,$12,$15,$13,$20,$32,$20,$10,$12,$05,$20,$01,$0c,$10,$08,$01,$20,$14,$05,$13,$14,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$41,$20,$20,$20,$20,$20,$a0,$a0,$20,$20,$40,$48,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
!byte $20,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$20,$20,$20
!byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$20,$20,$a0,$a0,$a0,$a0
!byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0

:Bonus_Colour
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$0b,$01,$01,$01,$01,$01,$05,$05,$01,$01,$0a,$0b,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
!byte $01,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$05,$01,$01,$01,$01,$01,$01,$05,$01,$01,$01,$01,$01,$01,$01,$01
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$01,$01,$05,$05,$05,$05
!byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05

* = $1000
          !Bin "Music\Virus 2(Main Music).bin"
          
          
* = $1500 
          !Bin "Music\Virus 2(Ending Music).bin"

* = $1900
          
          !Binary "Music\Virus 2(Title Music).bin"
  
* = $2000
:Car_Sprite
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $00,$00,$00,$00,$00,$00,$00,$00
!byte $00,$00,$15,$00,$00,$6a,$40,$01
!byte $aa,$90,$05,$55,$50,$15,$55,$54
!byte $15,$55,$55,$15,$55,$55,$0f,$00
          !byte  $f0, $0f, $00, $f0, $0f, $00, $f0, $83

* = $0400
:Loading_Screen
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20
!byte $60,$60,$14,$08,$05,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$60,$60,$a0,$a0,$a0,$60,$60,$60,$a0,$60,$a0,$60,$60,$a0,$a0,$a0,$60,$60,$60,$a0,$a0,$a0,$a0,$20,$20,$20,$20
!byte $60,$60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$60,$a0,$60,$60,$a0,$60,$60,$60,$60,$60,$60,$60,$60,$a0,$60,$60,$20,$60
!byte $60,$60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$60,$60,$a0,$a0,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$a0,$a0,$a0,$60,$60,$60,$60,$60,$60,$a0,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$60,$60,$a0,$a0,$a0,$60,$60,$60,$a0,$60,$a0,$60,$60,$60,$60,$a0,$60,$60,$60,$a0,$a0,$a0,$a0,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$60,$a0,$60,$60,$60,$60,$a0,$60,$60,$60,$a0,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$a0,$60,$60,$60,$60,$a0,$60,$60,$a0,$60,$a0,$60,$60,$60,$a0,$a0,$a0,$60,$60,$a0,$a0,$a0,$60,$60,$60,$a0,$a0,$a0,$a0,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$20,$20,$20,$20,$20,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$09,$13,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$a0,$60,$60,$60,$a0,$a0,$a0,$60,$a0,$a0,$a0,$60,$a0,$a0,$60,$60,$60,$a0,$60,$60,$a0,$60,$60,$a0,$60,$a0,$a0,$a0,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$a0,$60,$60,$60,$a0,$60,$a0,$60,$a0,$60,$a0,$60,$a0,$60,$a0,$60,$60,$a0,$60,$60,$a0,$a0,$60,$a0,$60,$a0,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$a0,$60,$60,$60,$a0,$60,$a0,$60,$a0,$a0,$a0,$60,$a0,$60,$a0,$60,$60,$a0,$60,$60,$a0,$60,$a0,$a0,$60,$a0,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$a0,$60,$60,$60,$a0,$60,$a0,$60,$a0,$60,$a0,$60,$a0,$60,$a0,$60,$60,$a0,$60,$60,$a0,$60,$60,$a0,$60,$a0,$60,$a0,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$a0,$a0,$a0,$60,$a0,$a0,$a0,$60,$a0,$60,$a0,$60,$a0,$a0,$60,$60,$60,$a0,$60,$60,$a0,$60,$60,$a0,$60,$a0,$a0,$a0,$60,$60,$60,$60,$60,$60,$60,$60
!byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
!byte  $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60
          


