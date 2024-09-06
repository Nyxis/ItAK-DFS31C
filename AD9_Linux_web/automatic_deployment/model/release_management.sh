#!/bin/bash

get_current_date() {
    date +"%Y%m%d%H%M%S"
}

create_new_release() {
    local release_date=$(get_current_date)
    local release_dir="${RELEASES_DIR}/${release_date}"
    local temp_dir=$(clone_repository)
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    move_repository_contents "$temp_dir" "$release_dir"
    return $?
}

copy_shared_files() {
    local release_dir="${RELEASES_DIR}/$(ls -t ${RELEASES_DIR} | head -n1)"
    local error_count=0
    
    find "${SHARED_DIR}" -type f | while read file; do
        local relative_path="${file#${SHARED_DIR}/}"
        local target_dir="${release_dir}/$(dirname "${relative_path}")"
        mkdir -p "${target_dir}" || { ((error_count++)); continue; }
        ln -s "${file}" "${target_dir}/$(basename "${file}")" || { ((error_count++)); }
    done
    
    return $error_count
}

update_current_link() {
    local latest_release=$(ls -t ${RELEASES_DIR} | head -n1)
    ln -sfn "${RELEASES_DIR}/${latest_release}" "${CURRENT_LINK}" || return 1
    return 0
}

cleanup_old_releases() {
    local keep_releases=$1
    if ! [[ "$keep_releases" =~ ^[0-9]+$ ]] || [ "$keep_releases" -lt 1 ]; then
        return 1
    fi
    local releases_to_delete=$(ls -t ${RELEASES_DIR} | tail -n +$((keep_releases + 1)))
    if [ -n "${releases_to_delete}" ]; then
        echo "${releases_to_delete}" | xargs -I {} rm -rf "${RELEASES_DIR}/{}" || return 1
    fi
    return 0
}

get_previous_release() {
    local current_release=$(readlink "${CURRENT_LINK}")
    ls -t ${RELEASES_DIR} | grep -v "$(basename "${current_release}")" | head -n1
}