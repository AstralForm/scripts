#!/bin/bash

# Install gh if not already installed
if ! command -v gh &> /dev/null; then
    sudo apt update
    sudo apt install -y gh
fi

# GitHub Release Settings
GITHUB_REPO_OWNER="your_github_username"
GITHUB_REPO_NAME="your_repo_name"

# Telegram Settings
TELEGRAM_BOT_TOKEN="your_telegram_bot_token"
TELEGRAM_CHAT_ID="your_telegram_chat_id"

# Release Information
ROM_NAME="your_rom_name"
ANDROID_VERSION="your_android_version"
BUILD_DATE="your_build_date"
FILE_SIZE="your_file_size"
SHA256="your_sha256"

# Create Release
gh release create v1.0 --repo "$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME" --title "Release v1.0" --notes "Release description"

# Upload Files
for file in /path/to/files/*; do
  gh release upload v1.0 "$file" --repo "$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME"
done

# Telegram Message
download_url="https://github.com/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/releases/tag/v1.0"
message="📱 New build available for sunny
👤 by @death2feel

ℹ️ ROM:
🔸 Android version: $ANDROID_VERSION
📅 Build date: $BUILD_DATE
📎 File size: $FILE_SIZE
✅ SHA256: $SHA256"

# Create Telegram keyboard markup JSON
keyboard='{"inline_keyboard":[[{"text":"Download","url":"'$download_url'"}]]}'

curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "chat_id": "'"$TELEGRAM_CHAT_ID"'",
    "text": "'"$message"'",
    "parse_mode": "HTML",
    "reply_markup": '$keyboard'
  }' \
  "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
