# jpmc-external-files
jpmc-external-files  

The create-configmaps.sh script ensures that each file in each subdirectory ends with a newline and creates a ConfigMap YAML file for each subdirectory.  

The workflow will automatically run on every commit to the main branch, create the necessary ConfigMap YAML files, and push the changes to a new branch called readyforargo.
