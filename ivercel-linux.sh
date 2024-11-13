#=================================================================================
# File Name : ivercel-linux.sh
# Created By: Solomio S. Sisante
# Created On: November 3, 2024
# Created To: Install Vercel CLI in Linux.
#
# How to run:
: '             bash setup.sh 
'
#
#=================================================================================
    echo "Installing vercel cli version 37.14.0..."
    yarn global add vercel@37.14.0 

    # Add Vercel to the PATH
    export PATH="$PATH:/home/codespace/.yarn/bin/"
    echo 'export PATH="$PATH:/home/codespace/.yarn/bin/"' >> ~/.bashrc

    # Load the new environment variables
    source ~/.bashrc 