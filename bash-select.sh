#!/bin/bash

function bashSelect() {
  function printOptions () {
    it=$1
    for i in "${!OPTIONS[@]}"; do
      if [[ "$i" == "$it" ]]; then
        tput rev
        printf '%4d ) %s\n' "$i" "${OPTIONS[$i]}"
        tput sgr0
      else
        printf '%4d ) %s\n' "$i" "${OPTIONS[$i]}"
      fi
    done
  }

  tput civis
  it=0

  printOptions "$it"

  while true; do
    read -rsn1 key
    escaped_char=$(printf "\u1b")
    if [[ $key == "$escaped_char" ]]; then
      read -rsn2 key
    fi
    tput cuu "${#OPTIONS[@]}" && tput ed
    tput sc

    case $key in
        '[A' | '[C' )
            it=$((it-1));;
        '[D' | '[B')
            it=$((it+1));;
        '' )
            tput cnorm
            return "$it";;
    esac

    min_len=0
    farr_len=$(( ${#OPTIONS[@]}-1))
    if [[ "$it" -lt "$min_len" ]]; then
      it=$(( ${#OPTIONS[@]}-1 ))
    elif [[ "$it" -gt "$farr_len"  ]]; then
      it=0
    fi

    printOptions "$it"

  done

}
