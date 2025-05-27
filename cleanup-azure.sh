#!/bin/bash

# CutifyPets Azure Cleanup Script
# This script cleans up Azure resources created by the CutifyPets application

set -e  # Exit on any error

echo "🧹 CutifyPets Azure Cleanup"
echo "==========================="
echo

# Configuration
RESOURCE_GROUP=${RESOURCE_GROUP:-"MLSA-demo"}

echo "⚠️  WARNING: This will delete the following resources:"
echo "  • Resource Group: $RESOURCE_GROUP"
echo "  • All Batch accounts in the resource group"
echo "  • All Storage accounts in the resource group"
echo "  • All associated data and configurations"
echo

read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cleanup cancelled."
    exit 1
fi

echo
echo "🔍 Checking Azure CLI and login status..."

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed."
    exit 1
fi

# Check if user is logged in
if ! az account show &> /dev/null; then
    echo "❌ You are not logged in to Azure CLI. Please run 'az login' first."
    exit 1
fi

echo "✅ Azure CLI ready"

echo
echo "🗑️  Deleting resource group and all resources..."
echo "This may take a few minutes..."

if az group delete --name "$RESOURCE_GROUP" --yes --no-wait; then
    echo "✅ Deletion initiated for resource group: $RESOURCE_GROUP"
    echo
    echo "📝 Note: Resource deletion is running in the background."
    echo "   You can check the status in the Azure Portal or run:"
    echo "   az group show --name '$RESOURCE_GROUP'"
    echo
    echo "🎉 Cleanup process started successfully!"
else
    echo "❌ Failed to delete resource group. It may not exist or you may not have permissions."
    exit 1
fi

echo
echo "💡 Don't forget to:"
echo "1. Unset environment variables if they're still set:"
echo "   unset BATCH_URL BATCH_NAME BATCH_KEY STORAGE_NAME STORAGE_KEY RESOURCE_GROUP"
echo "2. Remove any local configuration files"
echo "3. Check your Azure subscription for any remaining resources"
