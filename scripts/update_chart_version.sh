#!/usr/bin/env bash
#
##  update_chart_version.sh - Workflow helper
##  v0.1 - 07.06.2020
##  It increments the Chart version in the format x.x.x when appVersion changes
##  and replaces image.tag in values{-production}.yaml to use the new appVersion
## 
##  usage: update_chart_version.sh my-chart new-app-version
##  example: update_chart_version.sh "confluence-server" "7.5.0"
##
##  https://github.com/javimox/helm-charts
##  ============================================================================
##  Copyright (C) 2020 jmox@pm.me
##
##  This program is free software: you can redistribute it and/or modify it
##  under the terms of the GNU General Public License as published by the Free
##  Software Foundation, either version 3 of the License, or (at your option)
##  any later version.
##
##  This program is distributed in the hope that it will be useful, but WITHOUT
##  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
##  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
##  more details.
##
##  You should have received a copy of the GNU General Public License along with
##  this program.  If not, see <http://www.gnu.org/licenses/>.
##  ============================================================================
#

# helm chart name
app="$1"

# it needs to point to the charts directory
chart_dir="charts/${app}"

# git vars. use the bot
git_username="moxbot"
git_email="bot@mox.sh"

## code below shouldn't need to be changed
# app variables
app_ver=$(grep "appVersion:" ${chart_dir}/Chart.yaml | awk -F": " '{print $2}')
app_new_ver="$(echo $2 | cut -d" " -f1)"

if [ "${app_ver}" != "${app_new_ver}" ] ; then
    # save current Chart's version
    chart_ver=$(grep "version:" ${chart_dir}/Chart.yaml | head -1 | awk -F": " '{print $2}')
    # increment current version's number
    chart_new_ver=$(echo $chart_ver | awk 'BEGIN { FS="." } { $3++; if ($3 > 9){ $3=0; $2++; if ($2 > 9) { $2=0; $1++ } } } { printf "%d.%d.%d\n", $1, $2, $3 }')

    # replace Chart's version and app version
    sed -i "0,/version:/{s/version:.*/version: $chart_new_ver/}" ${chart_dir}/Chart.yaml
    sed -i "0,/appVersion:/{s/appVersion:.*/appVersion: $app_new_ver/}" ${chart_dir}/Chart.yaml

    # replace tag version in values and values-production
    sed -i "0,/tag:/{s/tag:.*/tag: $app_new_ver/}" ${chart_dir}/{values.yaml,values-production.yaml}

    # replace app version in README
    line_nr=$(grep -n '```diff' ${chart_dir}/README.md | cut -f1 -d:)
    line_nr=$(( line_nr - 1 ))
    sed -i "${line_nr}s/.*/Chart Version ${chart_new_ver}/" ${chart_dir}/README.md

    # commit the changes
    git config user.name "$git_username"
    git config user.email "$git_email"
    git add ${chart_dir}/{Chart.yaml,values.yaml,values-production.yaml}
    git commit -a --signoff -m "[$chart_dir] Release $chart_new_ver: bump to $app_new_ver"

    # for debugging
    echo "Chart version: $chart_new_ver - $app version: $app_new_ver"
else
    echo "appVersion $app_ver is already the latest stable version. Nothing to do."
fi

