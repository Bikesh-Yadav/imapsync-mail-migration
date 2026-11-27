#!/bin/bash

# ==========================================
# IMAPSYNC BATCH MIGRATION SCRIPT (SECURE TEMP PASS)
# ==========================================

SRC_HOST="domain1(xyz.com)"
SRC_PORT="993"
DST_HOST="domain2 (mail.abz.com)"
DST_PORT="993"

CSV_FILE="users.csv"  #check user.csv format in another file
LOG_DIR="./imap_logs"
TMP_PASS_DIR="/tmp/imap_passes"

mkdir -p "$LOG_DIR" "$TMP_PASS_DIR"

if [ ! -f "$CSV_FILE" ]; then
    echo "Error: $CSV_FILE not found!"
    exit 1
fi

echo "Starting batch migration..."

while IFS=',' read -r SRC_USER SRC_PASS DST_USER DST_PASS; do
    # Clean non-printable/CR characters and quotes from CSV inputs
    SRC_USER=$(echo "$SRC_USER" | tr -d '\r' | tr -dc '[[:print:]]' | sed 's/^"//;s/"$//')
    SRC_PASS=$(echo "$SRC_PASS" | tr -d '\r' | tr -dc '[[:print:]]' | sed 's/^"//;s/"$//')
    DST_USER=$(echo "$DST_USER" | tr -d '\r' | tr -dc '[[:print:]]' | sed 's/^"//;s/"$//')
    DST_PASS=$(echo "$DST_PASS" | tr -d '\r' | tr -dc '[[:print:]]' | sed 's/^"//;s/"$//')

    # Skip empty lines or comments
    [[ -z "$SRC_USER" || "$SRC_USER" =~ ^# ]] && continue

    echo "=================================================="
    echo "Migrating: $SRC_USER -> $DST_USER"
    echo "=================================================="

    LOG_FILE="$LOG_DIR/${SRC_USER//[^a-zA-Z0-9]/_}.log"
    PFILE1="$TMP_PASS_DIR/p1.txt"
    PFILE2="$TMP_PASS_DIR/p2.txt"

    # Write raw passwords directly to temporary files (bypasses shell symbol parsing)
    printf "%s" "$SRC_PASS" > "$PFILE1"
    printf "%s" "$DST_PASS" > "$PFILE2"

    # Run imapsync on a single line to prevent line-continuation backslash errors
    imapsync --host1 "$SRC_HOST" --port1 "$SRC_PORT" --user1 "$SRC_USER" --passfile1 "$PFILE1" --ssl1 --host2 "$DST_HOST" --port2 "$DST_PORT" --user2 "$DST_USER" --passfile2 "$PFILE2" --ssl2 --authmech1 LOGIN --authmech2 LOGIN --sep1 "/" --sep2 "/" --subscribe --logfile "$LOG_FILE"

    STATUS=$?

    # Securely remove temporary password files after execution
    rm -f "$PFILE1" "$PFILE2"

    if [ $STATUS -eq 0 ]; then
        echo "Successfully migrated: $SRC_USER"
    else
        echo "Failed to migrate: $SRC_USER (Check log: $LOG_FILE)"
    fi

done < "$CSV_FILE"

rm -rf "$TMP_PASS_DIR"
echo "Batch migration process completed!"
