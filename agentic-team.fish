function agentic-team
    if test (count $argv) -lt 1
        echo "Usage: agentic-team <light|heavy> [goose_args...]"
        return 1
    end
    set -l mode $argv[1]
    set -e argv[1]

    set -l thinking low
    set -l model deepseek-v4-flash
    set -l session_suffix light
    set -l mode_header "⚡ LIGHT"

    if test "$mode" = heavy
        set thinking high
        set model deepseek-v4-pro
        set session_suffix heavy
        set mode_header "🔥 HEAVY"
    else if test "$mode" != light
        echo "Error: mode must be 'light' or 'heavy', got '$mode'"
        return 1
    end

    # Build MOIM context with mode header prepended
    echo "# ACTIVE MODE: $mode_header | Lead: $model | Thinking: $thinking" \
        | cat - ~/.config/goose/guardrails.md ~/Code/Personal/goose-configs/STATE.md \
        > /tmp/goose-moim-context.txt

    set -lx GOOSE_MODE $mode
    set -lx GOOSE_PROVIDER custom_deepseek
    set -lx GOOSE_MODEL $model
    set -lx GOOSE_THINKING_EFFORT $thinking
    set -lx GOOSE_MOIM_MESSAGE_FILE /tmp/goose-moim-context.txt
    set -lx GOOSE_TELEMETRY_ENABLED false

    command goose session --name agentic-team-$session_suffix $argv
end
