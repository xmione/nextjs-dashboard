#!/bin/bash
LOG_FILE="/workspaces/nextjs-dashboard/setup.log"

{
    echo "Starting setup.sh"

    # Set the SHELL environment variable explicitly
    export SHELL=/bin/bash

    # Download and install pnpm
    curl -fsSL https://get.pnpm.io/install.sh | sh 

    # Set up environment variables for pnpm
    echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.bashrc 
    echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.bashrc 

    # Load the new environment variables
    source ~/.bashrc 

    # Verify pnpm installation
    ls ~/.local/share/pnpm
    pnpm -v 

    # Initialize pnpm
    pnpm setup

    echo "Starting Node.js installation"
: '
    # Install Node.js
    # Download Node.js version 22.0.0
    curl -fsSL https://nodejs.org/dist/v22.9.0/node-v22.9.0-linux-x64.tar.xz -o node.tar.xz

    # Extract the tarball
    tar -xf node.tar.xz

    # Move Node.js binaries to /usr/local
    sudo cp -r node-v22.9.0-linux-x64/* /usr/local/

    # Clean up
    rm -rf node-v22.9.0-linux-x64 node.tar.xz

    # Check Node.js and npm versions
    node -v
    npm -v
 
    echo "Node.js installation completed successfully."
'
    echo "Installing node modules..."
    pnpm i

    echo "Installing vercel cli version 37.14.0..."
    yarn global add vercel@37.14.0 

    # Add Vercel to the PATH
    export PATH="$PATH:/home/codespace/.yarn/bin/"
    echo 'export PATH="$PATH:/home/codespace/.yarn/bin/"' >> ~/.bashrc

    # Load the new environment variables
    source ~/.bashrc 

    node -v
    npm -v
    yarn -v
    pnpm -v
    vercel -v    
      
    echo "setup.sh completed successfully."
    echo "Manually run these commannds to setup vercel environment variables:"
    echo "vercel login"
    echo "After logging in, Copy the token and run the command below replacing the parameters including the generated token string:"
    echo ' bash createenv.sh \
                    your-vercel-token \
                    postgres-url \
                    postgres-prisma-url \
                    postgres-url-no-ssl \
                    postgres-url-non-pooling \
                    postgres-user \
                    postgres-host \
                    postgres-password \
                    postgres-database'


} 2>&1 | tee -a "$LOG_FILE"
