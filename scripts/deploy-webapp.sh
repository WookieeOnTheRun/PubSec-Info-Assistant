#!/bin/bash
set -e

figlet Deploy Webapp

# Get the directory that this script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${DIR}"/../scripts/load-env.sh
source "${DIR}/environments/infrastructure.env"
BINARIES_OUTPUT_PATH="${DIR}/../artifacts/build/"

end=`date -u -d "3 years" '+%Y-%m-%dT%H:%MZ'`

cd $BINARIES_OUTPUT_PATH

# check the Azure CLI version to ensure a supported version that uses AD authentication for the webapp deployment
version=$(az version --output tsv --query '"azure-cli"')
version_parts=(${version//./ })
if [ ${version_parts[0]} -lt 2 ]; then
    ehco "Azure CLI version 2.48.1 or higher is required for webapp deployment"
    exit 1
else
    if [ ${version_parts[0]} -eq 2 ] & [ ${version_parts[1]} -lt 48 ]; then
        ehco "Azure CLI version 2.48.1 or higher is required for webapp deployment"
        exit 1
    else
        if [ ${version_parts[0]} -eq 2 ] & [ ${version_parts[1]} -eq 48 ] &  [ ${version_parts[2]} -lt 1 ]; then
            echo "Azure CLI version 2.48.1 or later is required to run this script"
            exit 1
        fi
    fi
    echo "Azure CLI version checked successfully"
fi

# deploy the zip file to the webapp
az webapp deploy --name $AZURE_WEBAPP_NAME --resource-group $RESOURCE_GROUP_NAME --type zip --src-path webapp.zip --async true --timeout 600000 --verbose

echo "Webapp deployed successfully"
