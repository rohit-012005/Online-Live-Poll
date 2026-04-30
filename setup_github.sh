#!/bin/bash
# ===== CONFIG (EDIT THIS ONLY IF NEEDED) =====
EMAIL="oraxle81205@gmail.com"
KEY_NAME="id_ed25519_rohit"
HOST_ALIAS="github-rohit"
REPO_PATH="Online-Live-Poll"
REPO_SSH="git@github-rohit:rohit-012005/Online-Live-Poll.git"

echo "🚀 Setting up second GitHub account for ONE folder..."

# ===== STEP 1: Create SSH key =====
if [ ! -f ~/.ssh/$KEY_NAME ]; then
  echo "🔑 Creating SSH key..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/$KEY_NAME -N ""
else
  echo "✅ SSH key already exists"
fi

# ===== STEP 2: Start agent & add key (Mac specific) =====
echo "🚀 Starting SSH agent..."
eval "$(ssh-agent -s)"
echo "➕ Adding key to macOS keychain..."
ssh-add --apple-use-keychain ~/.ssh/$KEY_NAME 2>/dev/null || ssh-add ~/.ssh/$KEY_NAME

# ===== STEP 3: Setup SSH config =====
CONFIG_FILE=~/.ssh/config
mkdir -p ~/.ssh
touch $CONFIG_FILE
if ! grep -q "$HOST_ALIAS" "$CONFIG_FILE"; then
  echo "⚙️ Updating SSH config..."
  cat >> $CONFIG_FILE <<EOL

# Rohit GitHub account
Host $HOST_ALIAS
  HostName github.com
  User git
  IdentityFile ~/.ssh/$KEY_NAME
  AddKeysToAgent yes
  UseKeychain yes
EOL
else
  echo "✅ SSH config already contains $HOST_ALIAS"
fi

# ===== STEP 4: Show public key =====
echo ""
echo "📌 COPY THIS KEY and add to GitHub (Settings → SSH Keys):"
echo "-------------------------------------------------------"
cat ~/.ssh/$KEY_NAME.pub
echo "-------------------------------------------------------"
echo ""
echo "👉 Go to GitHub → Settings → SSH Keys and paste it."

# ===== STEP 5: Set repo remote =====
if [ -d "$REPO_PATH" ]; then
  cd $REPO_PATH
  echo "🔁 Updating git remote for this folder..."
  git remote set-url origin $REPO_SSH
  echo "✅ Remote updated!"
else
  echo "⚠️ Folder '$REPO_PATH' not found. Skipping remote setup."
fi

# ===== DONE =====
echo ""
echo "✅ Setup complete!"
echo "👉 After adding SSH key to GitHub, run:"
echo "   ssh -T git@$HOST_ALIAS"
echo "   git push origin main"
