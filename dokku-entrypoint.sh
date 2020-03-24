#!/bin/bash

echo "Listen 9000" > /etc/apache2/ports.conf

/entrypoint.sh "$@"