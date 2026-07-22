function goose-session --description "Start a goose session with a specific DeepSeek model"
    # Default model
    set --local model deepseek-v4-flash
    set --local session_args

    # Parse arguments
    set --local positional
    set --local i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -h --help
                echo "Usage: goose-session [MODEL] [GOOSE_ARGS...]"
                echo ""
                echo "Start a goose session with a DeepSeek model via the custom provider."
                echo ""
                echo "Models:"
                echo "  deepseek-v4-flash    Fast, cheap (default)"
                echo "  deepseek-v4-pro      Slower, more capable"
                echo "  flash                 Alias for deepseek-v4-flash"
                echo "  pro                   Alias for deepseek-v4-pro"
                echo ""
                echo "Goose args are forwarded:"
                echo "  goose-session pro --name my-audit"
                echo "  goose-session flash --resume --session-id abc123"
                echo ""
                echo "Config: ~/Code/Personal/fish-functions/goose-session.fish"
                return 0
            case flash
                set model deepseek-v4-flash
            case pro
                set model deepseek-v4-pro
            case deepseek-v4-flash deepseek-v4-pro
                set model $argv[$i]
            case '*'
                set --append session_args $argv[$i]
        end
        set i (math $i + 1)
    end

    # Validate model
    if not contains -- $model deepseek-v4-flash deepseek-v4-pro
        echo "goose-session: unknown model '$model'. Use flash, pro, deepseek-v4-flash, or deepseek-v4-pro." >&2
        return 1
    end

    echo "▶ goose session · $model"
    env GOOSE_MODEL=$model goose session $session_args
end
