#!/bin/bash

battery() {
	local percentage
	percentage="$(cat /sys/class/power_supply/BAT0/capacity)"
	icon=󰂃
	if [ "$percentage" -gt 95 ]
	then
		# nf-md-battery
		icon=󰁹
	elif [ "$percentage" -gt 90 ]
	then
		# nf-md-battery_90
		icon=󰂂
	elif [ "$percentage" -gt 80 ]
	then
		# nf-md-battery_80
		icon=󰂁
	elif [ "$percentage" -gt 70 ]
	then
		# nf-md-battery_70
		icon=󰂀
	elif [ "$percentage" -gt 60 ]
	then
		# nf-md-battery_60
		icon=󰁿
	elif [ "$percentage" -gt 50 ]
	then
		# nf-md-battery_50
		icon=󰁾
	elif [ "$percentage" -gt 40 ]
	then
		# nf-md-battery_40
		icon=󰁽
	elif [ "$percentage" -gt 30 ]
	then
		# nf-md-battery_30
		icon=󰁼
	elif [ "$percentage" -gt 20 ]
	then
		# nf-md-battery_20
		icon=󰁻
	elif [ "$percentage" -gt 0 ]
	then
		# nf-md-battery_10
		icon=󰁺
	fi
	printf '%d%% %b' "$percentage" "$icon"
}

battery
