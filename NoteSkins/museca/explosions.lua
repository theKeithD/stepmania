local hold_colors= {
	TapNoteSubType_Hold= {0.24,0.74,0.89, 0.5},
	TapNoteSubType_Roll= {0.24,0.89,0.44, 0.5},
	-- At some point in the distant future, checkpoint (pump style) holds will
	-- be implemented as a hold subtype.
	TapNoteSubType_Checkpoint= {0, 1, 1, 0.5},
}
local white= {1, 1, 1, 1}

return function(button_list, stepstype, skin_params)
	local ret= {}
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
		TopLeftSpinR = "BlueL",
		BotLeftSpinR = "WhiteL",
		TopMidSpinR = "BlueL",
		BotRightSpinR = "WhiteL",
		TopRightSpinR = "BlueL",
	}
	for i, button in ipairs(button_list) do
		local column_frame= Def.ActorFrame{
			InitCommand= function(self)
				self:rotationz(rots[button] or 0)
					:draworder(notefield_draw_order.explosion)
			end,
			Def.Sprite{
				Texture= "_bar receptor tap.png", InitCommand= function(self)
					self:visible(false):SetAllStateDelays(.05)
				end,
				ColumnJudgmentCommand= function(self, param)
					local diffuse= {
						TapNoteScore_W1= JudgmentLineToColor("JudgmentLine_W1"),
						TapNoteScore_W2= JudgmentLineToColor("JudgmentLine_W2"),
						TapNoteScore_W3= JudgmentLineToColor("JudgmentLine_W3"),
						TapNoteScore_W4= JudgmentLineToColor("JudgmentLine_W4"),
						TapNoteScore_W5= JudgmentLineToColor("JudgmentLine_W5"),
						HoldNoteScore_Held= {1, 1, 1, 1},
					}
					local exp_color= diffuse[param.tap_note_score or param.hold_note_score]
					if exp_color then
						self:stoptweening()
							:diffuse(exp_color):zoom(1):diffusealpha(0.9):visible(true)
							:smooth(0.2):zoom(1.1):diffusealpha(0)
							:sleep(0):queuecommand("hide")
					end
				end,
				hideCommand= function(self)
					self:visible(false)
				end,
			},
			Def.Sprite{
				Texture= "_bar receptor tap.png", InitCommand= function(self)
					self:visible(false):SetAllStateDelays(.05)
				end,
				HoldCommand= function(self, param)
					if param.start then
						self:finishtweening()
							:zoom(1):diffusealpha(1):visible(true):diffuseshift():effectcolor1(hold_colors[param.type]):effectcolor2(1, 1, 1, 0.8):effectperiod(.4)
					elseif param.finished then
						self:stopeffect():linear(0.06):diffusealpha(0)
							:sleep(0):queuecommand("hide")
					else
						self:zoom(1)
					end
				end,
				hideCommand= function(self)
					self:visible(false)
				end,
			},
			Def.Sprite{
				Texture= "hit_mine_explosion", InitCommand= function(self)
					self:visible(false)
				end,
				ColumnJudgmentCommand= function(self, param)
					if param.tap_note_score == "TapNoteScore_HitMine" then
						self:visible(true):finishtweening()
							:blend("BlendMode_Add"):diffuse{1, 1, 1, 1}
							:zoom(0.8):rotationz(0):decelerate(.3):rotationz(90)
							:linear(.3):rotationz(180):diffusealpha(0)
							:sleep(0):queuecommand("hide")
					end
				end,
				hideCommand= function(self)
					self:visible(false)
				end,
			},
		}
		ret[i]= column_frame
	end
	return ret
end
