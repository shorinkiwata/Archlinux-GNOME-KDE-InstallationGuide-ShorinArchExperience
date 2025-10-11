if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

starship init fish | source
zoxide init fish --cmd cd | source

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function code
	command code --ozone-platform=wayland $argv
end


function ls
	command eza
end

thefuck --alias | source
