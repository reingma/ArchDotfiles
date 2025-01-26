$env.PATH = ($env.PATH 
				| append $"($env.HOME)/.local/scripts"
				| append ($env.PATH | split row (char esep))
			)
