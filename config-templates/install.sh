#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Codex configuration installer
# Installs config.toml, execpolicy rules, and AGENTS template into ~/.codex.
# ==============================================================================

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
BACKUP_TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$CODEX_HOME/backup-$BACKUP_TIMESTAMP"
LOG_FILE="$CODEX_HOME/install.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELECTED_CONFIG=""
CONFIG_VERSION=""
INSTALL_MODE=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_to_file() {
  mkdir -p "$CODEX_HOME"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

info() {
  echo -e "${BLUE}[INFO]${NC} $1"
  log_to_file "INFO: $1"
}

success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
  log_to_file "SUCCESS: $1"
}

warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
  log_to_file "WARNING: $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
  log_to_file "ERROR: $1"
  exit 1
}

print_header() {
  echo ""
  echo "======================================================================"
  echo -e "  ${CYAN}Codex 配置安装脚本${NC}"
  echo "======================================================================"
  echo ""
}

print_usage_info() {
  echo -e "${CYAN}本脚本将执行以下操作:${NC}"
  echo ""
  echo "  1. 检查配置包文件"
  echo "  2. 备份现有 ~/.codex/config.toml、rules/、AGENTS 模板"
  echo "  3. 让你选择安装模式：rules-only / simple / full"
  echo "  4. 安装 rules/default.rules、AGENTS.template.md，并按需安装 config.toml"
  echo "  5. 记录安装日志到 ~/.codex/install.log"
  echo ""
  echo -e "${YELLOW}不会备份或覆盖:${NC} auth.json、history、sessions、sqlite 日志、skills"
  echo -e "${YELLOW}默认不会覆盖:${NC} config.toml（选择 simple/full 才覆盖）"
  echo -e "${YELLOW}会覆盖:${NC} rules/default.rules、AGENTS.template.md"
  echo ""
  read -r -p "按 Enter 继续，或按 Ctrl+C 取消安装..." _
}

check_environment() {
  info "检查安装环境..."
  mkdir -p "$CODEX_HOME"

  local missing=()
  [[ -f "$SCRIPT_DIR/config.simple.toml" ]] || missing+=("config.simple.toml")
  [[ -f "$SCRIPT_DIR/config.full.toml" ]] || missing+=("config.full.toml")
  [[ -f "$SCRIPT_DIR/rules/default.rules" ]] || missing+=("rules/default.rules")
  [[ -f "$SCRIPT_DIR/AGENTS.template.md" ]] || missing+=("AGENTS.template.md")

  if [[ ${#missing[@]} -gt 0 ]]; then
    error "缺少必需文件: ${missing[*]}"
  fi

  if command -v codex >/dev/null 2>&1; then
    info "检测到 Codex: $(codex --version 2>/dev/null || echo unknown)"
  else
    warning "未检测到 codex 命令；仍会安装配置文件"
  fi

  success "环境检查通过"
}

backup_existing_config() {
  info "检查现有 Codex 配置..."
  local items=("config.toml" "rules" "AGENTS.md" "AGENTS.template.md")
  local backup_list=()

  for item in "${items[@]}"; do
    [[ -e "$CODEX_HOME/$item" ]] && backup_list+=("$item")
  done

  if [[ ${#backup_list[@]} -eq 0 ]]; then
    info "未检测到需要备份的配置，跳过备份"
    return
  fi

  echo ""
  echo -e "${YELLOW}检测到现有配置:${NC}"
  printf '  - %s\n' "${backup_list[@]}"
  echo ""
  echo "这些文件将备份到: $BACKUP_DIR"
  echo ""
  read -r -p "是否继续安装？(y/n): " confirm
  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    info "安装已取消"
    exit 0
  fi

  mkdir -p "$BACKUP_DIR"
  for item in "${backup_list[@]}"; do
    cp -R "$CODEX_HOME/$item" "$BACKUP_DIR/"
    info "已备份: $item"
    log_to_file "BACKUP: $item -> $BACKUP_DIR/$item"
  done
  success "配置备份完成"
}

select_config_version() {
  echo ""
  echo "======================================================================"
  echo -e "${CYAN}请选择安装模式:${NC}"
  echo "======================================================================"
  echo ""
  echo "  1) rules-only - 推荐默认"
  echo "     - 保留现有 ~/.codex/config.toml"
  echo "     - 只安装 execpolicy rules 和 AGENTS.template.md"
  echo ""
  echo "  2) simple - 覆盖 config.toml"
  echo "     - workspace-write + on-request"
  echo "     - 适合没有自定义 provider 的新用户"
  echo ""
  echo "  3) full - 覆盖 config.toml"
  echo "     - 包含 safe-review/dev/ci profiles"
  echo "     - 包含 MCP 和 model provider 占位示例"
  echo ""
  echo "  4) 取消安装"
  echo ""

  while true; do
    read -r -p "请输入选择 [1/2/3/4]: " choice
    case "$choice" in
      1)
        INSTALL_MODE="rules-only"
        CONFIG_VERSION="preserve-existing"
        break
        ;;
      2)
        INSTALL_MODE="config"
        SELECTED_CONFIG="config.simple.toml"
        CONFIG_VERSION="simple"
        break
        ;;
      3)
        INSTALL_MODE="config"
        SELECTED_CONFIG="config.full.toml"
        CONFIG_VERSION="full"
        break
        ;;
      4)
        info "安装已取消"
        exit 0
        ;;
      *)
        echo -e "${RED}无效选择，请输入 1、2、3 或 4${NC}"
        ;;
    esac
  done

  if [[ "$INSTALL_MODE" == "rules-only" ]]; then
    info "已选择: rules-only（保留现有 config.toml）"
  else
    info "已选择: $CONFIG_VERSION ($SELECTED_CONFIG)"
  fi
}

install_config() {
  if [[ "$INSTALL_MODE" == "rules-only" ]]; then
    info "保留现有 config.toml，跳过配置覆盖"
    return
  fi

  info "安装 config.toml ($CONFIG_VERSION)..."
  cp "$SCRIPT_DIR/$SELECTED_CONFIG" "$CODEX_HOME/config.toml"
  chmod 600 "$CODEX_HOME/config.toml"
  success "config.toml 安装完成"
}

install_rules() {
  info "安装 execpolicy rules..."
  mkdir -p "$CODEX_HOME/rules"
  cp "$SCRIPT_DIR/rules/default.rules" "$CODEX_HOME/rules/default.rules"
  chmod 600 "$CODEX_HOME/rules/default.rules"
  success "rules/default.rules 安装完成"
}

install_agents_template() {
  info "安装 AGENTS 模板..."
  cp "$SCRIPT_DIR/AGENTS.template.md" "$CODEX_HOME/AGENTS.template.md"
  chmod 600 "$CODEX_HOME/AGENTS.template.md"
  success "AGENTS.template.md 安装完成"
}

show_summary() {
  echo ""
  echo "======================================================================"
  success "Codex 配置安装完成"
  echo "======================================================================"
  echo ""
  echo -e "${CYAN}安装信息:${NC}"
  echo "  安装模式: $INSTALL_MODE"
  echo "  配置版本: $CONFIG_VERSION"
  echo "  安装目录: $CODEX_HOME"
  echo ""
  echo -e "${CYAN}已安装:${NC}"
  if [[ "$INSTALL_MODE" == "config" ]]; then
    echo "  ✓ config.toml"
  else
    echo "  - config.toml 保持不变"
  fi
  echo "  ✓ rules/default.rules"
  echo "  ✓ AGENTS.template.md"
  echo ""
  if [[ -d "$BACKUP_DIR" ]]; then
    echo -e "${CYAN}备份信息:${NC}"
    echo "  备份目录: $BACKUP_DIR"
    echo "  恢复示例: cp -R $BACKUP_DIR/config.toml $CODEX_HOME/"
    echo ""
  fi
  echo -e "${CYAN}下一步:${NC}"
  echo "  1. 重启 Codex 会话"
  echo "  2. 在项目根目录复制模板: cp $CODEX_HOME/AGENTS.template.md ./AGENTS.md"
  echo "  3. 按项目实际命令编辑 AGENTS.md"
  echo "  4. 启动: codex --sandbox workspace-write --ask-for-approval on-request"
  echo ""
  echo "日志文件: $LOG_FILE"
  echo "======================================================================"
}

handle_error() {
  echo ""
  error "安装过程中发生错误，请查看日志: $LOG_FILE"
}
trap handle_error ERR

main() {
  mkdir -p "$CODEX_HOME"
  echo "" >> "$LOG_FILE"
  echo "================================================" >> "$LOG_FILE"
  echo "安装开始: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
  echo "================================================" >> "$LOG_FILE"

  print_header
  print_usage_info
  check_environment
  backup_existing_config
  select_config_version
  install_config
  install_rules
  install_agents_template
  show_summary
}

main
