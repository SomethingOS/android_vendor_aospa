#!/bin/bash

generate_json() {
    FILENAME=$1

    if [[ -z "${FILENAME}" ]]; then
        echo "Error: No file provided. Please provide a filename."
        exit 1
    fi

    if [[ ${FILENAME} == *"-image"* ]]; then
        echo "Error: Fastboot packages aren't supported. Please provide an OTA package."
        exit 1
    fi

    CODENAME=$(echo ${FILENAME} | cut -d '-' -f 3)
    VERSION=$(grep 'SOMETHINGOS_VERSION :=' ./vendor/aospa/target/product/version.mk | cut -d ' ' -f 3)
    TIMESTAMP=$(unzip -p ${FILENAME} META-INF/com/android/metadata | grep 'post-timestamp=' | cut -d '=' -f 2)
    MD5_HASH=$(md5sum ${FILENAME} | awk '{print $1}')
    cat <<EOF > ${CODENAME}.json
{
    "response": [
        {
            "timestamp": "${TIMESTAMP}",
            "filename": "${FILENAME}",
            "id": "${MD5_HASH}",
            "size": "$(stat -c%s ${FILENAME})",
            "url": "https://sourceforge.net/projects/somethingos/files/${CODENAME}/${FILENAME}/download",
            "version": "${VERSION}"
        }
    ]
}
EOF
}

generate_json $1