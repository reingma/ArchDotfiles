source ~/.config/nushell/modules/custom_completitions/git_completitions.nu
source ~/.config/nushell/modules/custom_completitions/npm_completitions.nu
source ~/.config/nushell/modules/custom_completitions/cargo_completitions.nu
source ~/.config/nushell/modules/custom_completitions/make_completitions.nu
source ~/.config/nushell/modules/custom_completitions/man_completitions.nu
source ~/.config/nushell/modules/custom_completitions/tldr_completitions.nu

export def "nu-complete zoxide path" [line : string, pos: int] {
    let prefix = ($line | str trim | split row ' ' | append ' ' | skip 1 | get 0)
    let data = (^zoxide query $prefix --list | lines)
    return {
        completions: $data,
        options: {
            completion_algorithm: "fuzzy"
        }
    }
}
