#!/usr/bin/env bash
set -euo pipefail

# Download uf2conv.py if it doesn't exist
curl -L -o uf2conv.py https://raw.githubusercontent.com/microsoft/uf2/refs/heads/master/utils/uf2conv.py
curl -L -o uf2families.json https://raw.githubusercontent.com/microsoft/uf2/refs/heads/master/utils/uf2families.json

BUILD_ZIP="/home/annelaure/Downloads/firmware.zip"
WORKDIR=dfu-work
BINWORK="$WORKDIR/bin"
DFUWORK="$WORKDIR/dfu"
DEV_TYPE=0x0052

mkdir -p "$BINWORK" "$DFUWORK"

# unzip if necessary
unzip -o $BUILD_ZIP -d "$WORKDIR"

for uf2 in "$WORKDIR"/*.uf2; do
    [[ -f "$uf2" ]] || continue
    base=$(basename "$uf2" .uf2)
    bin="$BINWORK/$base.bin"
    dfu="$DFUWORK/$base-dfu.zip"

    echo "Converting $uf2 → $bin"
    python3 uf2conv.py -b 0x26000 -o "$bin" "$uf2"

    echo "Creating proper HEX for nRFConnect"
    arm-none-eabi-objcopy -I binary -O ihex "$bin" "$BINWORK/$base.hex" \
      --change-addresses 0x26000

    echo "Generating DFU package $dfu"
    pipx run --spec adafruit-nrfutil adafruit-nrfutil dfu genpkg \
        --dev-type "$DEV_TYPE" \
        --application "$bin" \
        "$dfu"
done

echo "Done. DFU zips are in $DFUWORK"
