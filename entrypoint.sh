#!/bin/sh

env > /etc/environment

exec cron -f
