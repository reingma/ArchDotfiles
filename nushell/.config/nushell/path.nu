$env.PATH = ($env.PATH 
				| append $"($env.HOME)/.local/scripts"
                | append "/usr/local/texlive/2024/bin/x86_64-linux"
				| append ($env.PATH | split row (char esep))
			)
