#!/bin/bash

create_project_structure() {
    mkdir -p "${RELEASES_DIR}" "${SHARED_DIR}" || return 1
    return 0
}