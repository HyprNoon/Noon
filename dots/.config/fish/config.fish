if status is-interactive
    set fish_greeting
    starship init fish | source
end

if test -f ~/.config/fish/alias.fish
    source ~/.config/fish/alias.fish
end

if test -f ~/.env
    source ~/.env
end

# if test -f ~/.local/state/noon/user/generated/terminal/sequences.txt
#     printf "%b" (cat ~/.local/state/noon/user/generated/terminal/sequences.txt)
# end

if test "$USE_POKEMON" = true
    pokemon-colorscripts-go --no-title
end
