#!/bin/bash
#=================================================================================
# File Name : createenv.sh
# Created By: Solomio S. Sisante
# Created On: November 5, 2024
# Created To: Automatically create the environment variables for the application.
#=================================================================================

# Set environment variables
export POSTGRES_URL="postgres://default:lyL7evi0RxYa@ep-sweet-lab-a4913tvc-pooler.us-east-1.aws.neon.tech:5432/verceldb?sslmode=require"
export POSTGRES_PRISMA_URL="postgres://default:lyL7evi0RxYa@ep-sweet-lab-a4913tvc-pooler.us-east-1.aws.neon.tech:5432/verceldb?sslmode=require&pgbouncer=true&connect_timeout=15"
export POSTGRES_URL_NO_SSL="postgres://default:lyL7evi0RxYa@ep-sweet-lab-a4913tvc-pooler.us-east-1.aws.neon.tech:5432/verceldb"
export POSTGRES_URL_NON_POOLING="postgres://default:lyL7evi0RxYa@ep-sweet-lab-a4913tvc.us-east-1.aws.neon.tech:5432/verceldb?sslmode=require"
export POSTGRES_USER="default"
export POSTGRES_HOST="ep-sweet-lab-a4913tvc-pooler.us-east-1.aws.neon.tech"
export POSTGRES_PASSWORD="lyL7evi0RxYa"
export POSTGRES_DATABASE="verceldb"

# Generate a new auth secret (you can replace this with a static one if you prefer)
AUTH_SECRET=$(openssl rand -base64 32)
export AUTH_SECRET
if [ "$ASPNET_DEVELOPMENT" = "Codespace" ]; then
    export AUTH_URL="CODESPACE_NAME/api/auth"
else
    export AUTH_URL="http://localhost:3000/api/auth"
fi


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
