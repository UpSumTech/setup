#!/bin/bash
set -e

main() {
  local file="$1"
  local passwd="$2"

  echo "DELETE FROM mysql.user ;" >> "$file"
  echo "CREATE USER 'root'@'%' IDENTIFIED BY '$passwd' ;" >> "$file"
  echo "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;" >> "$file"
  echo "CREATE DATABASE IF NOT EXISTS test ;" >> "$file"
  echo "FLUSH PRIVILEGES ;" >> "$file"
}

main "$@"
