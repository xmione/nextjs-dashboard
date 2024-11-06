    echo "Installing vercel cli version 37.14.0..."
    yarn global add vercel@37.14.0 

    # Add Vercel to the PATH
    export PATH="$PATH:/home/codespace/.yarn/bin/"
    echo 'export PATH="$PATH:/home/codespace/.yarn/bin/"' >> ~/.bashrc

    # Load the new environment variables
    source ~/.bashrc 