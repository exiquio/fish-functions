function agentic-team --description "Launch Goose AI team in interactive mode (light|heavy)"
    if test (count $argv) -eq 0
        echo "Error: Missing required mode argument."
        echo "Usage: agentic-team <light|heavy> [goose_args...]"
        return 1
    end

    set -l mode $argv[1]
    # Remove the mode argument so optional flags pass through cleanly
    set -e argv[1]

    # Ensure native DeepSeek provider
    set -lx GOOSE_PROVIDER custom_deepseek

    if test "$mode" = light
        set -lx GOOSE_MODEL deepseek-v4-pro
        set -lx GOOSE_THINKING_EFFORT low
        cat ~/.config/goose/guardrails.md ~/Code/Personal/goose-configs/STATE.md > /tmp/goose-moim-context.txt
        set -lx GOOSE_MOIM_MESSAGE_FILE /tmp/goose-moim-context.txt
        command goose session --name agentic-team-light $argv

    else if test "$mode" = heavy
        set -lx GOOSE_MODEL deepseek-v4-pro
        set -lx GOOSE_THINKING_EFFORT max
        cat ~/.config/goose/guardrails.md ~/Code/Personal/goose-configs/STATE.md > /tmp/goose-moim-context.txt
        set -lx GOOSE_MOIM_MESSAGE_FILE /tmp/goose-moim-context.txt
        command goose session --name agentic-team-heavy $argv

    else
        echo "Error: Invalid mode '$mode'."
        echo "Usage: agentic-team <light|heavy> [goose_args...]"
        return 1
    end
end
