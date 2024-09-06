#!/bin/bash

deploy_controller() {
    local keep_releases=$1
    
    create_project_structure || { print_error "Échec de la création de la structure du projet"; return 1; }
    print_success "Structure du projet créée"
    
    create_new_release || { print_error "Échec de la création de la nouvelle release"; return 1; }
    print_success "Nouvelle release créée"
    
    copy_shared_files || { print_error "Échec de la copie des fichiers partagés"; return 1; }
    print_success "Fichiers partagés liés symboliquement"
    
    update_current_link || { print_error "Échec de la mise à jour du lien 'current'"; return 1; }
    print_success "Lien 'current' mis à jour"
    
    cleanup_old_releases "$keep_releases" || { print_error "Échec du nettoyage des anciennes releases"; return 1; }
    print_success "Anciennes releases nettoyées"
    
    print_success "Déploiement terminé avec succès"
}