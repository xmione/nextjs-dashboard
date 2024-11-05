#!/bin/bash
#=================================================================================
# File Name : createenv.sh
# Created By: Solomio S. Sisante
# Created On: November 5, 2024
# Created To: Automatically create the environment variables for the application.
#
# Hot to run:
: '             bash createenv.sh \
                    your-vercel-token \
                    postgres-url \
                    postgres-prisma-url \
                    postgres-url-no-ssl \
                    postgres-url-non-pooling \
                    postgres-user \
                    postgres-host \
                    postgres-password \
                    postgres-database \
                    auth-secret \
                    auth-url

'
#
#=================================================================================

LOG_FILE="/workspaces/nextjs-dashboard/createenv.log"

{
    echo "Starting createenv.sh"

    # Check if all parameters are provided
    if [ "$#" -ne 11 ]; then
      echo "Usage: $0 <VERCEL_TOKEN> <POSTGRES_URL> <POSTGRES_PRISMA_URL> <POSTGRES_URL_NO_SSL> <POSTGRES_URL_NON_POOLING> <POSTGRES_USER> <POSTGRES_HOST> <POSTGRES_PASSWORD> <POSTGRES_DATABASE> <AUTH_SECRET> <AUTH_URL>"
      exit 1
    fi

    # Set environment variables from parameters
    VERCEL_TOKEN="$1"
    POSTGRES_URL="$2"
    POSTGRES_PRISMA_URL="$3"
    POSTGRES_URL_NO_SSL="$4"
    POSTGRES_URL_NON_POOLING="$5"
    POSTGRES_USER="$6"
    POSTGRES_HOST="$7"
    POSTGRES_PASSWORD="$8"
    POSTGRES_DATABASE="$9"
    AUTH_SECRET="${10}"
    AUTH_URL="${11}"

    export VERCEL_TOKEN POSTGRES_URL POSTGRES_PRISMA_URL POSTGRES_URL_NO_SSL POSTGRES_URL_NON_POOLING POSTGRES_USER POSTGRES_HOST POSTGRES_PASSWORD POSTGRES_DATABASE AUTH_SECRET AUTH_URL

    echo "export VERCEL_TOKEN=$VERCEL_TOKEN" >> ~/.bashrc
    echo "export POSTGRES_URL=$POSTGRES_URL" >> ~/.bashrc
    echo "export POSTGRES_PRISMA_URL=$POSTGRES_PRISMA_URL" >> ~/.bashrc
    echo "export POSTGRES_URL_NO_SSL=$POSTGRES_URL_NO_SSL" >> ~/.bashrc
    echo "export POSTGRES_URL_NON_POOLING=$POSTGRES_URL_NON_POOLING" >> ~/.bashrc
    echo "export POSTGRES_USER=$POSTGRES_USER" >> ~/.bashrc
    echo "export POSTGRES_HOST=$POSTGRES_HOST" >> ~/.bashrc
    echo "export POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> ~/.bashrc
    echo "export POSTGRES_DATABASE=$POSTGRES_DATABASE" >> ~/.bashrc
    echo "export AUTH_SECRET=$AUTH_SECRET" >> ~/.bashrc
    echo "export AUTH_URL=$AUTH_URL" >> ~/.bashrc

    # Use the Vercel token to log in non-interactively
    vercel login --token "$VERCEL_TOKEN"

    # Print out the variables to verify they are set
    echo "POSTGRES_URL=$POSTGRES_URL"
    echo "POSTGRES_PRISMA_URL=$POSTGRES_PRISMA_URL"
    echo "POSTGRES_URL_NO_SSL=$POSTGRES_URL_NO_SSL"
    echo "POSTGRES_URL_NON_POOLING=$POSTGRES_URL_NON_POOLING"
    echo "POSTGRES_USER=$POSTGRES_USER"
    echo "POSTGRES_HOST=$POSTGRES_HOST"
    echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD"
    echo "POSTGRES_DATABASE=$POSTGRES_DATABASE"
    echo "AUTH_SECRET=$AUTH_SECRET"
    echo "AUTH_URL=$AUTH_URL"

    echo "createenv.sh completed successfully."
} 2>&1 | tee -a "$LOG_FILE"
