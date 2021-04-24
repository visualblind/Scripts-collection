#!/usr/bin/env bash
service transmission stop ; service openvpn restart && sleep 15 && curl ipconfig.io/json && service transmission start || echo 'THERE WAS A PROBLEM'
