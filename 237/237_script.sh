#!/bin/bash

# Get system information (unchanged)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
MEMORY=$(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2 }')
MEMORY_USED=$(free -h | awk 'NR==2{print $3}')
MEMORY_TOTAL=$(free -h | awk 'NR==2{print $2}')
DISK=$(df -h / | awk 'NR==2{print $5}')
DISK_USED=$(df -h / | awk 'NR==2{print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
UPTIME=$(uptime -p | sed 's/up //')
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)
HOSTNAME=$(hostname)
PROCESSES=$(ps aux | wc -l)
CURRENT_DATE_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Ensure values are numbers for progress bar (remove %)
CPU_PERCENT=$(echo "$CPU_USAGE" | sed 's/%//')
MEMORY_PERCENT=$(echo "$MEMORY" | sed 's/%//')
DISK_PERCENT=$(echo "$DISK" | sed 's/%//')


# Create or update 237.html
cat > 237.html << EOF
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="5">
    <title>System Monitor | Dark Mode</title>
    <style>
        /* Variables for easy color changes */
        :root {
            --bg-color: #1a1a2e; /* Deep purple/blue background */
            --card-bg: #22223b; /* Slightly lighter card background */
            --text-color: #f0f0f0; /* Light text */
            --detail-color: #a0a0a0; /* Grey text for details */
            --accent-color: #00bcd4; /* Cyan/Aqua accent for progress */
            --success-color: #4caf50; /* Green for Uptime/Load */
            --warning-color: #ff9800; /* Orange for high usage */
            --danger-color: #f44336; /* Red for critical usage */
        }

        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 40px 20px;
            background: var(--bg-color);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            color: var(--text-color);
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }
        .header {
            text-align: center;
            margin-bottom: 50px;
        }
        .header h1 {
            margin: 0;
            font-size: 56px;
            font-weight: 800;
            color: var(--accent-color);
            letter-spacing: 2px;
            text-shadow: 0 0 10px rgba(0, 188, 212, 0.5);
        }
        .header p {
            margin: 10px 0 0 0;
            font-size: 20px;
            color: var(--detail-color);
            font-weight: 300;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }
        .card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.4); /* Subtle dark shadow */
            border: 1px solid rgba(255, 255, 255, 0.05); /* Very light border */
            transition: transform 0.2s, background 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
            background: #2a2a4b; /* Slight lift and highlight on hover */
        }
        .card h2 {
            margin: 0 0 20px 0;
            font-size: 16px;
            color: var(--detail-color);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 400;
        }
        .value {
            font-size: 48px;
            font-weight: 700;
            color: var(--text-color);
            margin: 10px 0;
            line-height: 1.1;
        }
        .detail {
            color: var(--detail-color);
            font-size: 14px;
            margin-top: 5px;
        }
        
        /* Progress Bar Styling */
        .progress-bar {
            width: 100%;
            height: 12px;
            background: #333;
            border-radius: 6px;
            margin-top: 25px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: var(--accent-color);
            transition: width 0.5s ease-out;
        }
        
        /* Colored Progress Fill based on value (Advanced - Requires JS or more complex shell logic, but setting default here) */
        .cpu-fill { background: linear-gradient(90deg, #ff9800, #f44336); }
        .mem-fill { background: linear-gradient(90deg, #00bcd4, #007bff); }
        .disk-fill { background: linear-gradient(90deg, #4caf50, #00bcd4); }

        .info-card {
            grid-column: 1 / -1;
            border-left: 5px solid var(--success-color);
            background: #22223b; 
        }
        .info-card h2 {
            color: var(--success-color);
        }
        .info-card .detail {
            font-size: 18px;
            line-height: 1.6;
            color: var(--text-color);
            font-weight: 300;
        }
        .footer {
            text-align: center;
            color: var(--detail-color);
            margin-top: 40px;
            font-size: 14px;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .header h1 { font-size: 42px; }
            .grid { grid-template-columns: 1fr; gap: 20px; }
            .value { font-size: 38px; }
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>SYSTEM MONITOR</h1>
            <p>Performance Metrics for Host: <strong>$HOSTNAME</strong></p>
        </div>
        
        <div class="grid">
            <div class="card">
                <h2>CPU Usage</h2>
                <div class="value">$CPU_USAGE</div>
                <div class="progress-bar">
                    <div class="progress-fill cpu-fill" style="width: $CPU_PERCENT%;"></div>
                </div>
                <div class="detail">Current processor load</div>
            </div>
            
            <div class="card">
                <h2>Memory Usage</h2>
                <div class="value">$MEMORY</div>
                <div class="detail">$MEMORY_USED / $MEMORY_TOTAL</div>
                <div class="progress-bar">
                    <div class="progress-fill mem-fill" style="width: $MEMORY_PERCENT%;"></div>
                </div>
                <div class="detail">Physical memory utilization</div>
            </div>
            
            <div class="card">
                <h2>Disk Usage</h2>
                <div class="value">$DISK</div>
                <div class="detail">$DISK_USED / $DISK_TOTAL (Root /)</div>
                <div class="progress-bar">
                    <div class="progress-fill disk-fill" style="width: $DISK_PERCENT;"></div>
                </div>
                <div class="detail">Space used on root filesystem</div>
            </div>
            
            <div class="card">
                <h2>Running Processes</h2>
                <div class="value">$PROCESSES</div>
                <div class="detail">Total processes running</div>
            </div>
            
            <div class="card info-card">
                <h2>System Uptime & Load</h2>
                <div class="detail">
                    <strong>Uptime:</strong> $UPTIME<br>
                    <strong>Load Average (1, 5, 15 min):</strong> $LOAD
                </div>
            </div>
        </div>
        
        <div class="footer">
            Last updated: $CURRENT_DATE_TIME | Refreshing every 5 seconds.
        </div>
    </div>
</body>
</html>
EOF

echo "System monitor HTML (237.html) updated at $(date '+%H:%M:%S')"
REPO_DIR="/home/k9g/mss2025-project-template/"
GITHUB_USERNAME="k9g-fr"
GITHUB_PAT=$(cat /home/k9g/mss2025-project-template/237/.pat)
cd "$REPO_DIR" || exit 1
git add .
git diff-index --quiet HEAD || git commit -m "Automated commit from cron 237 time:$TIME"
git push "https://${GITHUB_USERNAME}:${GITHUB_PAT}@github.com/Harley2zazaa/mss2025-project-template.git" kong
