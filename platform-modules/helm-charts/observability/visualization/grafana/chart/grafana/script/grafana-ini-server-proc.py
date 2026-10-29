#!/usr/bin/env python3

import os
import sys


grafana_ini_content=[]
grafana_ini_server_section=[]



"""
scans and extracs the server section
"""
def loadGrafanaIniFileAndParsing(ini_file: str) -> None:

    foundServerSection = False

    with open( ini_file, "r" ) as txt_file:
        for each_line in txt_file:
            if each_line is None or len( each_line.strip() ) == 0:
                continue

            if each_line[0] == ";":
                continue

            each_line = each_line.strip()

            if foundServerSection:
                if each_line[0] == "[":
                    grafana_ini_content.append(each_line)
                    foundServerSection = False
                    continue
                else:
                    grafana_ini_server_section.append(each_line)
                    continue
                     
            if each_line == "[server]":
                foundServerSection = True
                continue
             
            grafana_ini_content.append(each_line)



"""
renders the server section
"""
def renderServerSection(host: str, uri_path: str) -> None:

    new_grafana_ini_server_section=[]

    for each_line in grafana_ini_server_section:
        if each_line.find("serve_from_sub_path") > -1 or \
           each_line.find("root_url") > -1:
            continue

        new_grafana_ini_server_section.append(each_line)

    if len(uri_path) > 0:
        new_grafana_ini_server_section.append("serve_from_sub_path = true")
        new_grafana_ini_server_section.append("root_url = http://"+host+"/"+uri_path)
    else:
        new_grafana_ini_server_section.append("serve_from_sub_path = false")
        new_grafana_ini_server_section.append("root_url = http://"+host)

    if new_grafana_ini_server_section:
        grafana_ini_content.append("[server]")
        for each_line in new_grafana_ini_server_section:
            grafana_ini_content.append(each_line)

    

"""
starts from here
"""

if __name__ == "__main__":
    
    HOST = os.environ.get("INGRESS_HOST")
    URI_PATH = os.environ.get("URI_PATH")
    GRAFANA_INI = os.environ.get("GRAFANA_INI")

    if GRAFANA_INI is None or not os.path.isfile(GRAFANA_INI):
        raise Exception("ERROR: unable to access grafana.ini, abort")
        sys.exit(1)

    if HOST is None or len(HOST) == 0:
        raise Exception("ERROR: no ingress host available, abort")
        sys.exit(2)

    if URI_PATH is None:
        URI_PATH=""

    loadGrafanaIniFileAndParsing(GRAFANA_INI)
    renderServerSection(HOST,URI_PATH)

    for each_line in grafana_ini_content:
        print(each_line)

    sys.exit(0)

