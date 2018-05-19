local skin_name= Var("skin_name")
return function(button_list, stepstype)
	local rots= {
		Pedal = 0,
		TopLeftButton = 0, BotLeftButton = 0,
		TopMidButton = 0, BotRightButton = 0,TopRightButton = 0,
		TopLeftSpinL = 0, BotLeftSpinL = 0,
		TopMidSpinL = 0, BotRightSpinL = 0, TopRightSpinL = 0,
		TopLeftSpinR = 0, BotLeftSpinR = 0,
		TopMidSpinR = 0, BotRightSpinR = 0, TopRightSpinR = 0
	}
	local tap_redir= {
		Pedal = "Red",
		TopLeftButton = "Blue",
		BotLeftButton = "White",
		TopMidButton = "Blue",
		BotRightButton = "White",
		TopRightButton = "Blue",
		TopLeftSpinL = "BlueL",
		BotLeftSpinL = "WhiteL",
		TopMidSpinL = "BlueL",
		BotRightSpinL = "WhiteL",
		TopRightSpinL = "BlueL",
		TopLeftSpinR = "BlueR",
		BotLeftSpinR = "WhiteR",
		TopMidSpinR = "BlueR",
		BotRightSpinR = "WhiteR",
		TopRightSpinR = "BlueR",
	}
	local tap_width= {
		Pedal = 64,
		TopLeftButton = 64, BotLeftButton = 64,
		TopMidButton = 64, BotRightButton = 64, TopRightButton = 64,
		TopLeftSpinL = 64, BotLeftSpinL = 64,
		TopMidSpinL = 64, BotRightSpinL = 64, TopRightSpinL = 64,
		TopLeftSpinR = 64, BotLeftSpinR = 64,
		TopMidSpinR = 64, BotRightSpinR = 64, TopRightSpinR = 64
	}
	local hold_flips= {
		Left= "TexCoordFlipMode_None", Right= "TexCoordFlipMode_None",
		Down= "TexCoordFlipMode_None", Up= "TexCoordFlipMode_None",
	}
	local roll_flips= {
		Left= "TexCoordFlipMode_None", Right= "TexCoordFlipMode_None",
		Down= "TexCoordFlipMode_None", Up= "TexCoordFlipMode_None",
	}
	local rev_hold_flips= {
		Left= "TexCoordFlipMode_None", Right= "TexCoordFlipMode_None",
		Down= "TexCoordFlipMode_None", Up= "TexCoordFlipMode_None",
	}
	local rev_roll_flips= {
		Left= "TexCoordFlipMode_None", Right= "TexCoordFlipMode_None",
		Down= "TexCoordFlipMode_None", Up= "TexCoordFlipMode_None",
	}
	local hold_redir= {
		Pedal = "Red",
		TopLeftButton = "Blue",
		BotLeftButton = "White",
		TopMidButton = "Blue",
		BotRightButton = "White",
		TopRightButton = "Blue",
		TopLeftSpinL = "Blue",
		BotLeftSpinL = "White",
		TopMidSpinL = "Blue",
		BotRightSpinL = "White",
		TopRightSpinL = "Blue",
		TopLeftSpinR = "Blue",
		BotLeftSpinR = "White",
		TopMidSpinR = "Blue",
		BotRightSpinR = "White",
		TopRightSpinR = "Blue",
	}
	local parts_per_beat= 48
	local tap_state_map= {
		parts_per_beat= 1, quanta= {{per_beat= 1, states= {1}}}}
	local lift_state_map= {
		parts_per_beat= 1, quanta= {{per_beat= 1, states= {1}}}}
	local hold_length= {
		pixels_before_note= 32,
		topcap_pixels= 32,
		body_pixels= 64,
		bottomcap_pixels= 32,
		pixels_after_note= 32,
		needs_jumpback= false,
	}
	-- Mines only have a single frame in the graphics.
	local mine_state_map= {
		parts_per_beat= 1, quanta= {{per_beat= 1, states= {1}}}}
	local active_state_map= {
		parts_per_beat= parts_per_beat, quanta= {
			{per_beat= 1, states= {1}},
		},
	}
	local inactive_state_map= {
		parts_per_beat= parts_per_beat, quanta= {
			{per_beat= 1, states= {2}},
		},
	}
	local columns= {}
	for i, button in ipairs(button_list) do
		local hold_tex= hold_redir[button].." hold 2x1.png"
		local roll_tex= "Roll 2x1.png"

		-- make spin notes appear in the lane they "belong" in
		local tap_shift_x = 0
		if (tap_redir[button] == "BlueL" or tap_redir[button] == "WhiteL") then
			tap_shift_x = -320
		elseif (tap_redir[button] == "BlueR" or tap_redir[button] == "WhiteR") then
			tap_shift_x = -640
		end

		columns[i]= {
			width= tap_width[button],
			anim_time= 1,
			anim_uses_beats= true,
			padding= 0,
			taps= {
				NoteSkinTapPart_Tap= {
					state_map= tap_state_map,
					actor= Def.ActorFrame {
						Def.Sprite{Texture= tap_redir[button].." tap note.png",
						InitCommand= function(self) self:rotationz(rots[button]):addx(tap_shift_x) end},
					}
				},
				NoteSkinTapPart_Mine= {
					state_map= mine_state_map,
					actor= Def.Sprite{Texture= "mine (doubleres).png",
					InitCommand= function(self) self:spin():effectclock('beat'):effectmagnitude(0,0,-33) end}},
				NoteSkinTapPart_Lift= {
					state_map= lift_state_map,
					actor= Def.Sprite{Texture= tap_redir[button].." tap note.png",
						InitCommand= function(self) self:rotationz(rots[button]) end}},
			},
			holds= {
				TapNoteSubType_Hold= {
					{
						state_map= inactive_state_map,
						textures= {hold_tex},
						flip= hold_flips[button],
						length_data= hold_length,
					},
					{
						state_map= active_state_map,
						textures= {hold_tex},
						flip= hold_flips[button],
						length_data= hold_length,
					},
				},
				TapNoteSubType_Roll= {
					{
						state_map= inactive_state_map,
						textures= {roll_tex},
						flip= roll_flips[button],
						length_data= hold_length,
					},
					{
						state_map= active_state_map,
						textures= {roll_tex},
						flip= roll_flips[button],
						length_data= hold_length,
					},
				},
			},
			reverse_holds= {
				TapNoteSubType_Hold= {
					{
						state_map= inactive_state_map,
						textures= {hold_tex},
						flip= rev_hold_flips[button],
						length_data= hold_length,
					},
					{
						state_map= active_state_map,
						textures= {hold_tex},
						flip= rev_hold_flips[button],
						length_data= hold_length,
					},
				},
				TapNoteSubType_Roll= {
					{
						state_map= inactive_state_map,
						textures= {roll_tex},
						flip= rev_roll_flips[button],
						length_data= hold_length,
					},
					{
						state_map= active_state_map,
						textures= {roll_tex},
						flip= rev_roll_flips[button],
						length_data= hold_length,
					},
				},
			},
		}
	end
	return {
		columns= columns,
		vivid_operation= true, -- output 200%
	}
end
