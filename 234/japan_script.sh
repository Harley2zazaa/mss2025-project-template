#!/bin/bash

# Get CPU usage (average over 1 second)
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}'| xargs)

# Get memory usage
MEM=$(free | awk '/Mem:/ {printf("%.1f%%", $3/$2 * 100)}'| xargs)

# Get disk usage (root partition)
DISK=$(df -h / | awk 'NR==2 {print $3 " / " $2}' | xargs)

# Get current time
TIME=$(date +"%Y-%m-%d %H:%M:%S" | xargs)

# Hostname
HOSTNAME=$(hostname)

# Home directory tree (first 2 levels)
HOMEDIR=$(tree /home)


echo "
<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"UTF-8\" />
  <title>Server Stats Dashboard</title>
  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1\" />
  <style>
    :root{
      --card-bg: #fff;
      --panel-bg: #f9f9f9;
      --card-radius: 8px;
      --card-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    body {
      font-family: system-ui, -apple-system, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial;
      background: #f0f0f0;
      margin: 0;
      padding: 20px;
      color: #222;
    }

    .container {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      justify-content: center;
      align-items: flex-start;
    }

    .card {
      background: var(--card-bg);
      border-radius: var(--card-radius);
      box-shadow: var(--card-shadow);
      padding: 18px;
      width: 250px;
      text-align: center;
      box-sizing: border-box;
    }

    .card.wide {
      width: 100%;
      max-width: 800px;
      text-align: left;
    }

    .label {
      font-size: 1.05rem;
      color: #555;
      font-weight: 600;
      margin-bottom: 8px;
    }

    .value {
      font-size: 1.6rem;
      color: #222;
      margin-top: 6px;
      word-break: break-word;
    }

    /* Tree card specific styles */
    .tree-wrapper {
      overflow: hidden;              /* hide any visual overflow from transform */
      padding: 0;
      border-radius: calc(var(--card-radius) - 2px);
    }

    .tree-card {
      background: var(--panel-bg);
      border: 1px solid #e2e2e2;
      padding: 12px;
      margin-top: 8px;
      border-radius: 6px;
      box-sizing: border-box;
      /* ensure the card contents can't push outside container */
      max-width: 100%;
      overflow-x: auto;              /* allow horizontal scroll if content is wider */
    }

    /* The actual tree block that will be visually shifted left */
    .tree-pre {
      margin: 0;
      white-space: pre;              /* preserve whitespace and lines */
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, "Roboto Mono", monospace;
      font-size: 0.9rem;
      line-height: 1.25;
      color: #111;
      display: block;
      /* translate left visually while staying clipped by .tree-wrapper */
      transform: translateX(-18px);
      /* keep transform smooth and limited on small screens */
      max-width: calc(100% + 60px);  /* allow transformed content to still be scrollable */
    }

    /* Responsive adjustments */
    @media (max-width: 720px) {
      .card { width: calc(50% - 12px); }
      .card.wide { width: 100%; max-width: 100%; }
      .tree-pre { transform: translateX(-10px); font-size: 0.85rem; }
    }

    @media (max-width: 420px) {
      .card { width: 100%; }
      .tree-pre { transform: translateX(0); } /* stop translating on tiny screens to avoid clipping */
    }
  </style>
</head>
<body>
  <div class=\"container\">
    <div class=\"card\">
      <div class=\"label\">CPU Usage</div>
      <div class=\"value\">$CPU</div>
    </div>

    <div class=\"card\">
      <div class=\"label\">Memory Usage</div>
      <div class=\"value\">$MEM</div>
    </div>

    <div class=\"card\">
      <div class=\"label\">Storage Used</div>
      <div class=\"value\">$DISK</div>
    </div>

    <div class=\"card\">
      <div class=\"label\">Last Updated</div>
      <div class=\"value\">$TIM</div>
    </div>

    <div class=\"card\">
      <div class=\"label\">Hostname</div>
      <div class=\"value\">$HOSTNAME</div>
    </div>

    <!-- Home directory tree card -->
    <div class=\"card wide\" style=\"margin-left: 20px\;\">
      <div class=\"label\">Home Directory Tree</div>

      <!-- wrapper hides anything shifted out and provides the visible card edge -->
      <div class=\"tree-wrapper\">
        <!-- inner panel allows scrolling if content is wider than visible area -->
        <div class=\"tree-card\" role=\"region\" aria-label=\"home directory tree\">
<pre class=\"tree-pre\">$HOMEDIR</pre>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
" > /home/japansg/git/mss2025-project-template/234/japan.html
# Define your repository path and PAT

REPO_DIR="/home/japansg/git/mss2025-project-template/" # e.g., /home/user/my-project
GITHUB_USERNAME="japanSG"
GITHUB_PAT=$(cat /home/japansg/git/mss2025-project-template/234/.pat) # Ensure this PAT has repo write permissions

# Navigate to the repository directory
cd "$REPO_DIR" || exit 1

# Add all changes to staging
git add .

# Commit changes (only if there are changes)
git diff-index --quiet HEAD || git commit -m "Automated commit from cron 234 time:$TIME"

# Push to GitHub using the PAT for authentication
git push "https://${GITHUB_USERNAME}:${GITHUB_PAT}@github.com/Harley2zazaa/mss2025-project-template.git" JapanSG
echo "https://${GITHUB_USERNAME}:${GITHUB_PAT}@github.com/Harley2zazaa/mss2025-project-template.git"
