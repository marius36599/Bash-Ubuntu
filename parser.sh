#!/bin/bash

while IFS="," read id nume email salariu dataA #IFS - internal field separator
  do
    echo "ID:" $id
    echo "Nume:" $nume
    echo "Email:" $email
    echo "Salariu:" $salariu
    echo "Data Angajarii:" $dataA
    echo "--------------------------"
  done < <(tail -n +2 "date.csv") #tail -n +2 inseamna ca afisez incepand de la a doua linie
