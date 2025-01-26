source "~/.config/nushell/keybinds.nu"
source "~/.config/nushell/menus.nu"
source "~/.config/nushell/hooks.nu"
$env.config.show_banner = false
$env.config.edit_mode = 'vi'
$env.config.keybindings = $keybinds
$env.config.menus = $menus
$env.config.hooks = $hooks
$env.config.history = {
	max_size: 100_000
	sync_on_enter: true
	file_format: "plaintext"
	isolation: false
}
$env.config.completions = {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
            completer: {|spans|
                carapace $spans.0 nushell $spans | from json
            }
        }
}

#modules
source "~/.config/nushell/modules.nu"
#path changes
source "~/.config/nushell/path.nu"
#aliases
source "~/.config/nushell/aliases.nu"
#completitions
source "~/.config/nushell/completions.nu"
#prompt
source "~/.config/nushell/prompt.nu"

neofetch
