#!/bin/bash

# CutifyPets Azure Setup Script
# This script sets up the required Azure resources for the CutifyPets application

set -e  # Exit on any error

echo "🎬 CutifyPets Azure Setup"
echo "========================="
echo

# Configuration
RESOURCE_GROUP=${RESOURCE_GROUP:-"MLSA-demo"}
LOCATION=${LOCATION:-"eastus"}

echo "📋 Configuration:"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  Location: $LOCATION"
echo

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it first:"
    echo "https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# Check if user is logged in
if ! az account show &> /dev/null; then
    echo "❌ You are not logged in to Azure CLI. Please run 'az login' first."
    exit 1
fi

echo "🔍 Setting up Azure subscription..."
# Set subscription if provided
if [ ! -z "$AZURE_SUBSCRIPTION" ]; then
    az account set --subscription "$AZURE_SUBSCRIPTION"
    echo "✅ Subscription set to: $AZURE_SUBSCRIPTION"
else
    echo "ℹ️  Using default subscription. Set AZURE_SUBSCRIPTION to use a specific one."
fi

echo
echo "🏗️  Creating resource group..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output table

echo
echo "🔧 Getting or creating Azure Batch account..."
BATCH_NAME=$(az batch account list --resource-group "$RESOURCE_GROUP" --query "[?contains(name,'hpcb')].name" --output tsv)

if [ -z "$BATCH_NAME" ]; then
    echo "Creating new Batch account..."
    BATCH_NAME="hpcb$(date +%s)"
    az batch account create \
        --name "$BATCH_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --output table
else
    echo "✅ Found existing Batch account: $BATCH_NAME"
fi

echo
echo "💾 Getting or creating Azure Storage account..."
STORAGE_NAME=$(az storage account list --resource-group "$RESOURCE_GROUP" --query "[?contains(name,'simsla')].name" --output tsv)

if [ -z "$STORAGE_NAME" ]; then
    echo "Creating new Storage account..."
    STORAGE_NAME="simsla$(date +%s)"
    az storage account create \
        --name "$STORAGE_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --sku Standard_LRS \
        --output table
else
    echo "✅ Found existing Storage account: $STORAGE_NAME"
fi

echo
echo "🔑 Retrieving account keys and URLs..."

# Get Batch account details
BATCH_URL="https://$(az batch account show --name "$BATCH_NAME" --resource-group "$RESOURCE_GROUP" --query accountEndpoint --output tsv)"
BATCH_KEY=$(az batch account keys list --name "$BATCH_NAME" --resource-group "$RESOURCE_GROUP" --query primary --output tsv)

# Get Storage account key
STORAGE_KEY=$(az storage account keys list --account-name "$STORAGE_NAME" --resource-group "$RESOURCE_GROUP" --query [0].value --output tsv)

echo
echo "🎯 Setup Complete!"
echo "=================="
echo
echo "📝 Environment Variables (copy and paste these):"
echo "================================================"
echo "export BATCH_URL='$BATCH_URL'"
echo "export BATCH_NAME='$BATCH_NAME'"
echo "export BATCH_KEY='$BATCH_KEY'"
echo "export STORAGE_NAME='$STORAGE_NAME'"
echo "export STORAGE_KEY='$STORAGE_KEY'"
echo "export RESOURCE_GROUP='$RESOURCE_GROUP'"
echo
echo "💡 Next Steps:"
echo "1. Run the export commands above to set your environment variables"
echo "2. Upload FFmpeg application package to your Batch account:"
echo "   - Download FFmpeg 3.4 from https://ffmpeg.org/download.html"
echo "   - In Azure Portal, go to Batch Account > Application packages"
echo "   - Create new package with ID: 'ffmpeg', Version: '3.4'"
echo "3. Add your MP4 files to the InputFiles directory"
echo "4. Run: dotnet run"
echo
echo "🔗 Useful Links:"
echo "- Batch Account: https://portal.azure.com/#resource/subscriptions/$(az account show --query id --output tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Batch/batchAccounts/$BATCH_NAME"
echo "- Storage Account: https://portal.azure.com/#resource/subscriptions/$(az account show --query id --output tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_NAME"
echo
echo "✨ Happy video processing!"
