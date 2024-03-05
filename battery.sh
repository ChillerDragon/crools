#!/bin/bash

battery() {
	local battery_dir
	if [ -d /sys/class/power_supply/BAT0 ]
	then
		battery_dir=/sys/class/power_supply/BAT0
	else
		printf 'Error: battery directory not found'
		exit 1
	fi
	local percentage
	local status
	percentage="$(cat "$battery_dir/capacity")"
	status="$(cat "$battery_dir/status")"
	icon=󰂃
	if [ "$percentage" -gt 95 ]
	then
		# nf-md-battery
		icon=󰁹
		[ "$status" = Charging ] && icon=󰂅
	elif [ "$percentage" -gt 90 ]
	then
		# nf-md-battery_90
		icon=󰂂
		[ "$status" = Charging ] && icon=󰂋
	elif [ "$percentage" -gt 80 ]
	then
		# nf-md-battery_80
		icon=󰂁
		[ "$status" = Charging ] && icon=󰢞
	elif [ "$percentage" -gt 70 ]
	then
		# nf-md-battery_70
		icon=󰂀
		[ "$status" = Charging ] && icon=󰢞
	elif [ "$percentage" -gt 60 ]
	then
		# nf-md-battery_60
		icon=󰁿
		[ "$status" = Charging ] && icon=󰂉
	elif [ "$percentage" -gt 50 ]
	then
		# nf-md-battery_50
		icon=󰁾
		[ "$status" = Charging ] && icon=󰢝
	elif [ "$percentage" -gt 40 ]
	then
		# nf-md-battery_40
		icon=󰁽
		[ "$status" = Charging ] && icon=󰂈
	elif [ "$percentage" -gt 30 ]
	then
		# nf-md-battery_30
		icon=󰁼
		[ "$status" = Charging ] && icon=󰂇
	elif [ "$percentage" -gt 20 ]
	then
		# nf-md-battery_20
		icon=󰁻
		[ "$status" = Charging ] && icon=󰂆
	elif [ "$percentage" -gt 0 ]
	then
		# nf-md-battery_10
		icon=󰁺
		[ "$status" = Charging ] && icon=󰢜
	fi
	printf '%d%% %b' "$percentage" "$icon"
}

battery
