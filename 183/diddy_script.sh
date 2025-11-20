#!/bin/bash

# Get system information
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
CPU_PERCENT="${CPU_USAGE}%"
MEMORY_PERCENT=$(free -m | awk 'NR==2{printf "%.1f", $3*100/$2 }')
MEMORY_USED=$(free -m | awk 'NR==2{printf "%.2f", $3/1024}')
MEMORY_TOTAL=$(free -m | awk 'NR==2{printf "%.2f", $2/1024}')
DISK_PERCENT=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
DISK=$(df -h / | awk 'NR==2{print $5}')
DISK_USED=$(df -h / | awk 'NR==2{print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
HOSTNAME=$(hostname)
PROCESSES=$(ps aux | wc -l)

# Create or update index.html
cat > index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="5">
    <title>System Monitor</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Courier New', monospace;
            background: #0a0a0a;
            color: #fff;
            padding: 40px 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        .header {
            text-align: center;
            margin-bottom: 40px;
            font-size: 14px;
            color: #666;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .card {
            background: #111;
            border: 1px solid #222;
            padding: 20px;
        }
        .label {
            font-size: 11px;
            color: #666;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        .value {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .detail {
            font-size: 12px;
            color: #888;
        }
        .bar {
            width: 100%;
            height: 2px;
            background: #222;
            margin-top: 12px;
        }
        .fill {
            height: 100%;
            background: #fff;
        }
        .ascii {
            text-align: center;
            font-size: 8px;
            line-height: 1.1;
            color: #999;
            margin-top: 40px;
            white-space: pre;
            overflow-x: auto;
        }
        .footer {
            text-align: center;
            font-size: 10px;
            color: #444;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">$HOSTNAME</div>
        
        <div class="grid">
            <div class="card">
                <div class="label">CPU</div>
                <div class="value">$CPU_PERCENT</div>
                <div class="bar">
                    <div class="fill" style="width: $CPU_PERCENT"></div>
                </div>
            </div>
            
            <div class="card">
                <div class="label">Memory</div>
                <div class="value">${MEMORY_PERCENT}%</div>
                <div class="detail">${MEMORY_USED}GB / ${MEMORY_TOTAL}GB</div>
                <div class="bar">
                    <div class="fill" style="width: ${MEMORY_PERCENT}%"></div>
                </div>
            </div>
            
            <div class="card">
                <div class="label">Disk</div>
                <div class="value">$DISK</div>
                <div class="detail">$DISK_USED / $DISK_TOTAL</div>
                <div class="bar">
                    <div class="fill" style="width: $DISK"></div>
                </div>
            </div>
            
            <div class="card">
                <div class="label">Processes</div>
                <div class="value">$PROCESSES</div>
            </div>
        </div>

        <div class="ascii">                                          =############*+.           .-=**##*+---=+++***############
                                 -+=+##%%%%#*+====+***####***+=*%*:               :=*###*+. .   + : 
                              =*##%#*##**%%%%%%%@%#*%%%%%%%%+*%%%****.                      . = * #.
                           -*#%%*%%%%%%%%%%%%%%%%%%@%@@@@@%#%*%%%%%%###:                            
                         =#%%%%###%%%%%%%%%%%###%##%#%%%@@@@@@@%@@%%%%###.                          
                       -%%%%%%%%@@@%%%%########%%#####%%%##%%@@@@@@%##+%%%=                         
                      #%%%%%%@@@@%%###%##################%%%###%@@@@@@@%%#+*:                       
                     *#*%%%@%%%%%#####*******+++*#*#####%%%%%%####%@@@%####+*=                      
                    -++#%%%#########*++++====+++***********#%%%%####%@@%####++=                     
                   -=+*#%%########+=-:::------:-:---=-::---=*###%%####%%@%###*++                    
                  :=+*##########*+-::::::::.......::::::::--==+**##%#*##%@@%##*=..                  
                 .-+*#%**#####**-. ........          ...:::-----=+*#%####%@@%#*+=.                  
                 :=*##-:###***-.   ..::....             .:::----===++*####%@@@###*                  
                  .+%* -#*+==.   ..::::...              ..::-----===+==*###%@@@@%%+                 
                 %%%% .##+=-:...::::::::...          ....:::-----========###%@-.@%%.                
                -%%%: .#*=...::---::::......        .....:::------=======+##%@-  ::                 
                 =%.  .*+::..::-----::.......       .......::------=====++#%%%=                     
                 #==  :#+-:::::---::::....             .....::-----====++**%%%-                     
                :%%%%%%*+=--::::::::...                   ..:::::--====++**%%%%%#**.                
              -=**#####*+==--:::::.....                   .....:::--===+***%%#%%%%%-###             
            -=+:#*******+==--:.......                        ....:----=++**%#+****%=***#            
           .+++=*+=====#==--::--:::......              .....:-====+++==++**#+=---=#*=++*-           
           =**+#*------#===++******+++==--::.......:::-==+*###******#**+***#------##=++**           
           =**#%#----=-#==+*+=====+*#%%##**+=-:...:-=+*##%%##+=---=++*##***#==---=*#*+++#           
           -**#%#====+=*==**+===----=+*#####*=:...:-+######*+-:--=+**###***#+=====*##*+*%           
.......... :*#%%#*+++**#==****++==-:-+**###%#+:.  .:+#####*++===++**###*++*#*+++++#%##**%.          
............##%%%%#**###+=**##****++=++++++++-:.   :-+++*##**++++*###*====*########%%###%...........
............*#%%%%%%##%%+---=+*########*++==-:..   .:-===+**########+---=+**%###%%%%%%#%#...........
::::::::::::-%%@%%%%%%%%*=-:::+*######*=----::..    .::-=-::-+****=--:-==+**%%%%%%%@@%%%#.:::::..:::
:::::::::::::+@@@@@%%%%%*==-::::-===--..:--::..      .:----:....::::::-=+++*%%%%%%@@@@%%*:::::::::::
##############%@@@@@@@%%*==-:...   ....::--:..       ..:----:... ....:--=+*#%@@@@@@@@@@%############
##############%%@@@@@@@@*=-:.........::--::::.       .::-:-==--:...:::--=+*%@@@@@@@@@@@%############
%%%%%%%%%%%####%%@@@@@@@#=-:::.....::----..:--:::::::-==--==---------==++*#%@@@@@@@@@@@%############
%%%%%%%%%%%%%%%%%%@@@@@@%*+===---------:=+++****+++**#####*+---==+++***##%%%@@@@@@@@@@%#############
%%%%%%%%%%%%%%%%%%%@%@@@%*###**++===----=#%%%%%%%%%%%%%%###+===++*##%%%%%%%%@@@@@@@@@@*+#%%#########
%%%%%%%%%%%%%%%%%%%%%%%%%*##%%###*+===---+#####%%%########*+==+++**#%%%%##%%@%%@@@@%%#++=###########
%%%%%%%%%%%%%%%%%%%%%%%%%#**######++++=========+*####*+======+*#####*#####%@%####%%###**+=*#########
#######################%%%******+*##%#*+=---::::..:..:-----==+#%%#++#####%@@%#########***+=+########
########################@@%#****++=+%%%####**+++==++++**####%%#+--+####%%@@%##########*=+++==#######
#######################*%%%%#####*+-:-****++==--=+++=----==+**+=+*#%%%%%@@@@%#############*+=-######
#####################*=+#%%%%%%%###*+--++=-:..        ..::=+*+++*#%%%%@@@@@@@####%#######****=-=####
##################===-===*%%%%%%%%%#*+==+**+==--:::---=+*****+++*%%%@@@@@@@%%##%%%%%######****+=--*#
################*=-------=*@@@@@%%%%#*++++**#############***+++*%%%@@@@@@@@@@@%%@%%%%#########**=-::
#########*****+---=------==*%@@@@@@%%#*+++++**#######****++=++*#%%@@@@@@@@@@@@%%%%%%%%##########*++-
*+=-------===------=-----===+#@@@@@@@%#**+=======----------=**#%@@@@@@@@@@@@%%#############**+++**++
====-----:-=++==----==---===++*%@@@@@@%%#*+==--::::::::--=+*##%@@@@@@@@@@@@@%##***########***++===++
======------====+=---=+=====+++*#%@@@@@@%##*+==------===+*##%@@@@@@@@@@@@@@%#****##****###*+*+++++++
=======------=+===*----++==+++++**#%@@@@@@%%##********####%%@@@@@@@@@@@@@@%#****#****##****+++++++++
=========-----=++=+#+---=*+++++++***#%@@@@@@@%%%%%%%%%%%%@@@@@@@@@@@@@@@@#****#*****#*++++#*+=======
==========-----=++++*%+--=+*+++*******##%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#****#*++**%*===++**#*=======
============---==+++=+##+--=*#+*********##%@@@@@@@@@@@@@@@@@@@@@@@%###+**##*++**#%+====+++**#+======</div>

        <div class="footer">LAST UPDATE: $(date '+%Y-%m-%d %H:%M:%S')</div>
    </div>
</body>
</html>
EOF

# Define your repository path and PAT
REPO_DIR="/home/sarin/mss2025-project-template/"
GITHUB_USERNAME="Sarin-Z"
GITHUB_PAT=$(cat /home/sarin/mss2025-project-template/183/.pat) # Ensure this PAT has repo write permissions
# Navigate to the repository directory
cd "$REPO_DIR" || exit 1

# Add all changes to staging
git add .

# Commit changes (only if there are changes)
git diff-index --quiet HEAD || git commit -m "Automated commit from cron sarin time:$TIME"

# Push to GitHub using the PAT for authentication
git push "https://${GITHUB_USERNAME}:${GITHUB_PAT}@github.com/Harley2zazaa/mss2025-project-template.git" Sarin-Z
