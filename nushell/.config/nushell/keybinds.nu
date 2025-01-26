let keybinds = [
    {
      name: sessionize
      modifier: control
      keycode: char_f
      mode: [vi_normal, vi_insert]
      event: [
		{ 
			send: executehostcommand,
			cmd: "tmxses"
		}
      ]
    }
	{
		name: comp_menu_next
		modifier: control
		keycode: char_n
		mode: [vi_normal, vi_insert]
		event: [
			{send: menunext}
		]
	}
	{
		name: comp_menu_prev
		modifier: control
		keycode: char_p
		mode: [vi_normal, vi_insert]
		event: [
			{send: menuprevious}
		]
	}
	{
		name: comp_menu_select
		modifier: control
		keycode: char_y
		mode: [vi_normal, vi_insert]
		event: [
			{send: Enter}
		]
	}
	{
      name: zoxide_menu
      modifier: control
      keycode: char_o
      mode: [vi_normal, vi_insert]
      event: [
        { send: menu name: zoxide_menu }
      ]
    }
]
