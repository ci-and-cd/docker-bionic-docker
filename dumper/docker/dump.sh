#!/usr/bin/env bash

set -e

ls -l /home/$(whoami)/data
LAYERS=();
mkdir -p $(pwd)/data/image && tar -xf $(pwd)/data/image.tar -C $(pwd)/data/image
for layer in $(pwd)/data/image/*/layer.tar; do
    echo layer: ${layer};

    for element in $(tar -tf ${layer} | grep -E '^dev/.*' | sort -r -n); do echo delete ${element}; tar --delete -f ${layer} "${element}" || echo error on delete ${element}; done
    #for element in $(tar -tf ${layer} | grep -E '^etc/'   | sort -r -n); do echo delete ${element}; tar --delete -f ${layer} "${element}" || echo error on delete ${element}; done

    if [ -n "$(tar -tf ${layer} | grep 'bin/docker-compose')" ]; then echo found bin/docker-compose in ${layer}; LAYERS+=(${layer}); fi
done

echo -e "merge layers '${LAYERS[@]}' into one\n"
if [ ${#LAYERS[@]} -gt 0 ]; then tar Af ${LAYERS[@]}; fi
echo -e "layers merged into ${LAYERS[0]} $(du -sh ${LAYERS[0]})\n"

echo copy ${LAYERS[0]} to $(pwd)/data/layer.tar
cp -f ${LAYERS[0]} $(pwd)/data/layer.tar

echo find empty directories
tar_entries=($(tar tf data/layer.tar))
tar_directories=($(tar tf data/layer.tar | grep -E '.*/$' | grep -v 'docker' | sort -r -n))
tar_empty_directories=()
for directory in ${tar_directories[@]}; do
    if [ -z "$(printf -- '%s\n' "${tar_entries[@]}" | grep -E "${directory}.+")" ]; then tar_empty_directories+=(${directory}); fi
done
echo tar_empty_directories
printf -- '%s\n' "${tar_empty_directories[@]}"
# warnings:
#tar: Deleting non-header from archive
#tar: Malformed extended header: missing length
#tar --delete -f data/layer.tar ${tar_empty_directories[@]}

sudo mkdir -p /data/root && sudo chown -R $(whoami):$(id -gn) /data && tar xf $(pwd)/data/layer.tar -C /data/root/
rm -rf $(pwd)/data/image && sudo rm -f $(pwd)/data/image.tar

rm -rf /data/root/data
rm -rf /data/root/etc/apt
rm -rf /data/root/tmp
rm -rf /data/root/var/cache/apt
rm -rf /data/root/var/lib/apt
rm -rf /data/root/var/log
