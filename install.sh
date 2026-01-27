#!/bin/bash
#
# Digress Installer
# Forks Claude Code sessions into new terminal windows
#

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔════════════════════════════════════════╗"
echo "║         Installing Digress             ║"
echo "║   Fork Claude sessions like git branches   ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Install the script
INSTALL_PATH="/usr/local/bin/digress"
echo -e "1. Installing script to ${YELLOW}${INSTALL_PATH}${NC}"
cp "${SCRIPT_DIR}/digress" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"
echo -e "   ${GREEN}✓${NC} Done"
echo ""

# 2. Create state directory
echo -e "2. Creating state directory ${YELLOW}~/.digress/${NC}"
mkdir -p ~/.digress
echo '{"sessions":{}}' > ~/.digress/tree.json 2>/dev/null || true
echo -e "   ${GREEN}✓${NC} Done"
echo ""

# 3. Install shell functions (optional)
FUNCTIONS_FILE="${HOME}/.digress-functions.sh"
echo -e "3. Installing shell functions to ${YELLOW}${FUNCTIONS_FILE}${NC}"
cp "${SCRIPT_DIR}/digress-functions.sh" "$FUNCTIONS_FILE"
echo -e "   ${GREEN}✓${NC} Done"
echo ""

# 4. Add to user's global CLAUDE.md
CLAUDE_DIR="${HOME}/.claude"
CLAUDE_MD="${CLAUDE_DIR}/CLAUDE.md"

echo -e "4. Configuring Claude Code"
mkdir -p "$CLAUDE_DIR"

if grep -q "DIGRESS COMMAND" "$CLAUDE_MD" 2>/dev/null; then
    echo -e "   ${YELLOW}⚠${NC} Digress instructions already in ~/.claude/CLAUDE.md"
else
    echo -e "   Adding instructions to ${YELLOW}${CLAUDE_MD}${NC}"
    cat >> "$CLAUDE_MD" << 'CLAUDE_INSTRUCTIONS'

## DIGRESS COMMAND

When the user says "digress", "digress to X", "fork", "fork to X", or "branch off to X", they want to fork the current Claude Code session into a new terminal window. The forked session will have full conversation context but changes won't affect the parent.

**To execute a digress/fork request, run this bash command:**

```bash
digress LABEL --dir DIRECTORY
```

Replace:
- LABEL with the user's requested name (default: "tangent")
- DIRECTORY with the current working directory (use the value from your environment)

After forking, tell the user they can return to the parent session with: `claude --resume`

CLAUDE_INSTRUCTIONS
    echo -e "   ${GREEN}✓${NC} Done"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "How to use:"
echo ""
echo -e "  ${CYAN}From within Claude:${NC}"
echo "    Just say: \"digress to my-idea\""
echo "    Or: \"fork this as experiments\""
echo ""
echo -e "  ${CYAN}From terminal:${NC}"
echo "    digress my-idea"
echo "    digress --help"
echo ""
echo -e "  ${CYAN}To return to parent:${NC}"
echo "    claude --resume"
echo ""
echo -e "${YELLOW}Optional: Add to your ~/.zshrc for extra shell functions:${NC}"
echo "    source ~/.digress-functions.sh"
echo ""
