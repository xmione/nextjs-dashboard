#!/bin/bash
LOG_FILE="/workspaces/nextjs-dashboard/initializebashfiles.log"

{
  echo "Running initializebashfiles.sh"

  sudo chmod +x /workspaces/nextjs-dashboard/setup.sh
  #chmod +x /workspaces/nextjs-dashboard/initapps.sh
  sudo chmod +x /workspaces/nextjs-dashboard/ivercel.sh
  sudo chmod +x /workspaces/nextjs-dashboard/createenv.sh
  ./setup-linux.sh

  echo "initializebashfiles completed"
} 2>&1 | tee -a "$LOG_FILE"
