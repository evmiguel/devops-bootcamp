#!/bin/bash

read -p "Would you like to sort the user processes by CPU or memory? Type cpu or mem. " process_type
read -p "How many processes would you like to print? " num_processes

ps aux --sort -p$process_type | grep $USER | head -n $num_processes
