#!/bin/bash
LOG_FILE="/workspaces/nextjs-dashboard/initializebashfiles.log"

{
  echo "Running initializebashfiles.sh"

  chmod +x /workspaces/nextjs-dashboard/setup.sh
  chmod +x /workspaces/nextjs-dashboard/initapps.sh
  
  ./setup.sh

  echo "initializebashfiles completed"
} 2>&1 | tee -a "$LOG_FILE"
