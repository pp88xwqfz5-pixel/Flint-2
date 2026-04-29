#!/bin/bash

# 1. Modify default IP
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 2. THE NUCLEAR HZ OVERWRITE
# Force 1000Hz into the Mediatek kernel config templates
find target/linux/mediatek/ -name "config-6.6*" | xargs -I {} sh -c '
    sed -i "/CONFIG_HZ/d" "{}"
    echo "CONFIG_HZ_1000=y" >> "{}"
    echo "CONFIG_HZ=1000" >> "{}"
    echo "CONFIG_PREEMPT=y" >> "{}"
    echo "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y" >> "{}"
'

# 3. THE HEADER STRIKE
# This makes sure the C-code itself is locked to 1000
find ./ -name "param.h" -exec sed -i 's/define HZ.*/define HZ 1000/g' {} +
