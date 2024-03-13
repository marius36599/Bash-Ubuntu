#!/bin/bash

afisare_inregistrari() {
    echo "Acum afisez..."
    source /home/kevin/merge/parser.sh

}

adaugare() {
    max_id=$(tail -n +2 date.csv | cut -d ',' -f1 | sort -n -r | head -1)
    new_id=$((max_id + 1))
    while IFS='\n' read -r deleted_id; do
            if [[ $deleted_id -eq $new_id ]]; then
                new_id=$((new_id + 1))
            fi
    done < temp.txt

    echo "Nume:"
    read nume
    while [[ ! $nume =~ ^[a-zA-Z[:space:]]+$ ]]; do
    echo "Te rog sa introduci un nume valid, format doar din litere"
    read nume
    done

    echo "Email:"
    read email
    while [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z]{1,}+\.[a-zA-Z]{2,}$ ]]; do
    echo "Adresa de email introdusă nu este validă. Va rog introduceti alta adresa"
    read email
    done

    echo "Data Angajarii:"
read dataA
while ! [[ $dataA =~ ^(0[1-9]|[12][0-9]|3[01])[-/.](0[1-9]|1[012])[-/.](19|20)[0-9]{2}$ ]]; do
    echo "Data de angajare introdusă nu este validă. Te rugăm să introduci data în formatul zi.lună.an sau zi-luna-an"
    read dataA

    day=$(echo "$dataA" | awk -F'[-./]' '{print $1}')
    month=$(echo "$dataA" | awk -F'[-./]' '{print $2}')
    year=$(echo "$dataA" | awk -F'[-./]' '{print $3}')

    if (( month == 2 && ( day > 28 || ( day == 29 && (( year % 4 > 0 || ( year % 100 == 0 && year % 400 > 0 )) )) ) )); then
        echo "Data introdusă nu este validă. Introduceți o dată validă."
    elif (( ( month == 4 || month == 6 || month == 9 || month == 11 ) && day > 30 )); then
        echo "Data introdusă nu este validă. Introduceți o dată validă."
    else
        echo "Data introdusă nu este validă. Introduceți o dată validă."
    fi
done

    echo "Salariul:"
    read salariu
    while ! [[ $salariu =~ ^([1-9][0-9]{2,})$ ]]; do
    echo "Va rog introduceti un salariu valid"
    read salariu
    done

    echo "$new_id,$nume,$email,$salariu,$dataA" >> date.csv

    echo "Acum adaug..."

}
stergere() {
echo "Introdu ID-ul înregistrării pe care dorești să o ștergi:"
read id

if [[ ! $id =~ ^[0-9]+$ ]]; then
  echo "ID-ul introdus nu este valid!"
  meniu
fi

if grep -q "^$id," date.csv; then
  sed -i "/^$id,/d" date.csv
  echo "Înregistrarea cu ID-ul $id a fost ștearsă."
  echo "$id" >> temp.txt
else
  echo "ID-ul $id nu există în fișierul CSV."
fi

}

actualizare(){
  echo "ID-ul:"
  read id

  if [[ ! $id =~ ^[0-9]+$ ]]; then
 echo "ID-ul introdus nu este valid!"
  meniu
  fi

  if grep -q "^$id," date.csv; then

    echo "Nume:"
    read nume
    while [[ ! $nume =~ ^[a-zA-Z[:space:]]+$ ]]; do
    echo "Te rog sa introduci un nume valid, format doar din litere"
    read nume
    done

    echo "Email:"
    read email
    while [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z]{1,}+\.[a-zA-Z]{2,}$ ]]; do
    echo "Adresa de email introdusă nu este validă. Va rog introduceti alta adresa"
    read email
    done

    echo "Data Angajarii:"
    read dataA
    while ! [[ $dataA =~ ^(0[1-9]|[12][0-9]|3[01])[-/.](0[1-9]|1[012])[-/.](19|20)[0-9]{2}$ ]]; do
    echo "Data de angajare introdusă nu este validă. Te rugăm să introduci data în formatul zi.lună.an sau zi-luna-an"
    read dataA
    done
   echo "Salariul:"
    read salariu
    while ! [[ $salariu =~ ^([1-9][0-9]{2,5}|1000000)$ ]]; do
    echo "Va rog introduceti un salariu valid"
    read salariu
    done

  sed -i "/^$id,/s/.*/$id,$nume,$email,$salariu,$dataA/" date.csv

 echo "Acum modific"
  else
  echo "ID-ul $id nu există în fișierul CSV."
  fi

}

sortare1() {
  echo "Acum sortez..."
  sort -t ',' -k 4 -n  date.csv
}

sortare2(){
  echo "Acum sortez..."
  sort -t ',' -k 5.7,5.10n -k 5.4,5.5n -k 5.1,5.2n date.csv

}

sortare3(){
  echo "Acum sortez..."
  sort -t ',' -k 1 -n date.csv
}

meniu() {
    clear
    echo "1. Pentru afisare inregistrari"
    echo "2. Pentru adaugare"
    echo "3. Pentru stergere"
    echo "4. Sortare in functie de salarii"
    echo "5. Sortare in functie de data angajarii"
    echo "6. Sortare dupa ID"
    echo "7. Actualizare ID"
    echo "0. EXIT"
}
while true
do
    meniu
    read -p "Introduceti o optiune: " optiune
    case $optiune in
        1) afisare_inregistrari;;
        2) adaugare;;
        3) stergere;;
        4) sortare1;;
        5) sortare2;;
        6) sortare3;;
        7) actualizare;;
        0) echo "Am iesit"; break;;
        *) echo "Optiune invalida";;
    esac
    read -p "Apasati Enter pentru a continua..."
done
