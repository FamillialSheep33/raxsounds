#!/bin/bash

# directory
BASE_DIR="/media/sdb1/Media/Music"

# tmp files
TEMP_NEW_ALBUM_DIRS=$(mktemp --tmpdir="/tmp" .new_album_dirs.XXXXXX)
TEMP_CONTADOR=$(mktemp --tmpdir="/tmp" .contador.XXXXXX)
echo "0" > "$TEMP_CONTADOR"

# Cleans temporary files if exists
trap 'rm -f "$TEMP_NEW_ALBUM_DIRS" "$TEMP_CONTADOR"' EXIT

echo "Iniciando organización de archivos FLAC en: $BASE_DIR"
echo "---"

## 1. Mover archivos .flac a carpetas Artista/Álbum
echo "1. Moving flacs..."
while IFS= read -r -d '' FILE; do
    if [[ "$(dirname "$FILE")" != "$BASE_DIR" ]]; then
        echo "ℹ Ignoring file: $(basename "$FILE") (not in the specified directory)"
        continue
    fi

    ARTIST=$(metaflac --show-tag=ALBUMARTIST "$FILE" | cut -d'=' -f2)
    [[ -z "$ARTIST" ]] && ARTIST=$(metaflac --show-tag=ARTIST "$FILE" | cut -d'=' -f2)
    ALBUM=$(metaflac --show-tag=ALBUM "$FILE" | cut -d'=' -f2)

    if [[ -z "$ARTIST" || -z "$ALBUM" ]]; then
        echo "Skipping File without metadata: $(basename "$FILE")"
        continue
    fi

    ARTIST_CLEANED=$(echo "$ARTIST" | sed 's/[\/\\:*?"<>|]/_/g')
    ALBUM_CLEANED=$(echo "$ALBUM" | sed 's/[\/\\:*?"<>|]/_/g')

    DEST_DIR="$BASE_DIR/$ARTIST_CLEANED/$ALBUM_CLEANED"

    if [[ ! -d "$DEST_DIR" ]]; then
        mkdir -p "$DEST_DIR"
        echo "$DEST_DIR" >> "$TEMP_NEW_ALBUM_DIRS"
        echo "🆕 Creado nuevo directorio: $DEST_DIR"
    fi

    if mv "$FILE" "$DEST_DIR/"; then
        echo "Moved $(basename "$FILE") → $DEST_DIR/"
        echo $(($(cat "$TEMP_CONTADOR") + 1)) > "$TEMP_CONTADOR"
    else
        echo "Error moving: $FILE"
    fi
done < <(find "$BASE_DIR" -maxdepth 1 -type f -iname "*.flac" -print0)

## 2. Extraer cover.jpg (SOLO de las carpetas de álbum recién creadas)
echo "2. Extracting cover image..."

if [[ -s "$TEMP_NEW_ALBUM_DIRS" ]]; then
    while IFS= read -r ALBUM_DIR; do
        COVER_PATH="$ALBUM_DIR/cover.jpg"

        if [[ -f "$COVER_PATH" ]]; then
            echo "ℹ cover.jpg already exists on $ALBUM_DIR, skipping."
            continue
        fi

        FIRST_FLAC=""
        for flac_file in "$ALBUM_DIR"/*.flac; do
            if [[ -f "$flac_file" ]]; then
                FIRST_FLAC="$flac_file"
                break
            fi
        done

        if [[ -z "$FIRST_FLAC" ]]; then
            echo "Not .flac files found on $ALBUM_DIR to extract cover."
            continue
        fi

        if metaflac --export-picture-to="$COVER_PATH" "$FIRST_FLAC"; then
            echo "Cover extracted to: $COVER_PATH"
        else
            echo "Couldnt extract cover of $(basename "$FIRST_FLAC") inf $ALBUM_DIR"
        fi
    done < "$TEMP_NEW_ALBUM_DIRS"
else
    echo "No new folders made on this time"
fi

## Reaching jellyfin for new files
echo "Notifyng jellyfin..."

JELLYFIN_URL="http://localhost:8097"
JELLYFIN_API_KEY="privated"
ARCHIVOS_MOVIDOS=$(cat "$TEMP_CONTADOR")

if [[ $ARCHIVOS_MOVIDOS -gt 0 ]]; then
    curl -X POST "${JELLYFIN_URL}/Library/Refresh" \
         -H "X-MediaBrowser-Token: ${JELLYFIN_API_KEY}" \
         -H "Content-Type: application/json" \
         --silent --output /dev/null

    if [ $? -eq 0 ]; then
        echo "Jellyfin reached. ($ARCHIVOS_MOVIDOS moved files"
    else
        echo "Error contacting jellyfin, is the server turned on?"
    fi
else
    echo "No files organized, no action made"
fi

echo "---"
echo "Finishied, running again in 5 minutes"
