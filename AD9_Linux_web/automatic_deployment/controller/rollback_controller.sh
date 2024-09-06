#!/bin/bash

rollback_controller() {
    local previous_release=$(get_previous_release)
    if [ -n "${previous_release}" ]; then
        ln -sfn "${RELEASES_DIR}/${previous_release}" "${CURRENT_LINK}" || { print_error "Erreur lors du rollback"; return 1; }
        print_success "Rollback effectué vers ${previous_release}"
    else
        print_error "Impossible d'effectuer le rollback : aucune release précédente trouvée"
        return 1
    fi
}