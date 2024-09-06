#!/bin/bash

# Model: Gestion des données et de la logique métier
source ./model/environment.sh
source ./model/project_structure.sh
source ./model/git_operations.sh
source ./model/release_management.sh
source ./model/man_page.sh

# View: Gestion de l'affichage
source ./view/output.sh

# Controller: Gestion du flux de contrôle
source ./controller/main_controller.sh
source ./controller/deploy_controller.sh
source ./controller/rollback_controller.sh

# Chargement de l'environnement
load_environment

# Point d'entrée du script
main "$@"