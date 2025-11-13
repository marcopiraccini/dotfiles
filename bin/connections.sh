#!/bin/bash
echo "=== Porte in ascolto (Server) ==="
printf "%-15s %-8s %-30s\n" "PROCESSO" "PID" "PORTA"
printf "%s\n" "$(printf '=%.0s' {1..60})"
sudo lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR>1 {printf "%-15s %-8s %-30s\n", $1, $2, $9}'

echo ""
echo "=== Connessioni attive per processo ==="
printf "%-15s %-8s %-10s %-45s %-45s\n" "PROCESSO" "PID" "DIREZIONE" "LOCAL" "REMOTE"
printf "%s\n" "$(printf '=%.0s' {1..130})"

sudo lsof -iTCP -sTCP:ESTABLISHED -n -P | awk 'NR>1 {
    process = $1
    pid = $2
    connection = $9
    
    split(connection, parts, "->")
    local = parts[1]
    remote = parts[2]
    
    split(local, local_parts, ":")
    local_port = local_parts[length(local_parts)]
    
    if (local_port < 32768) {
        direction = "← INBOUND"
    } else {
        direction = "→ OUTBOUND"
    }
    
    printf "%-15s %-8s %-10s %-45s %-45s\n", process, pid, direction, local, remote
}' | sort -k1,1 -k3,3

echo ""
echo "=== Riepilogo per processo ==="
sudo lsof -iTCP -sTCP:ESTABLISHED -n -P | awk 'NR>1 {print $1}' | sort | uniq -c | sort -rn
