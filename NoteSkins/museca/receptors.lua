return function(button_list, stepstype, skin_parameters)
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
		TopLeftSpinR = "BlueR",
		BotLeftSpinR = "WhiteR",
		TopMidSpinR = "BlueR",
		BotRightSpinR = "WhiteR",
		TopRightSpinR = "BlueR",
	}
	for i, button in ipairs(button_list) do
		ret[i]= Def.Sprite{
			Texture= tap_redir[button].." receptor.png", InitCommand= function(self)
			self:rotationz(rots[button] or 0):SetAllStateDelays(1)
					:effectclock("beat"):diffuseramp()
					:effectcolor1(1,1,1,1):effectcolor2(.8,.8,.8,1)
					:effectperiod(0.5):effecttiming(0.25,0.50,0,0.25):effectoffset(-0.25)
			end,
			ColumnJudgmentCommand= function(self)
				self.none = false
			end,
			BeatUpdateCommand= function(self, param)
				if param.pressed then
					self:zoom(.9):diffusealpha(0.7)
				elseif param.lifted then
					self:stoptweening():zoom(.9):linear(.09):zoom(1):diffusealpha(1)
				end
			end,
		}
	end
	return ret
end
