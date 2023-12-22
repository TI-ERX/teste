#!/usr/bin/env sh

_() {
  ANO="2018"
  echo "Nome de usuário no GitHub: "
  read -r NOME_USUARIO
  echo "Token de acesso do GitHub: "
  read -r TOKEN_ACESSO

  [ -z "$NOME_USUARIO" ] && exit 1
  [ -z "$TOKEN_ACESSO" ] && exit 1
  [ ! -d $ANO ] && mkdir $ANO

  cd "${ANO}" || exit
  git init
  git config core.autocrlf false  # Desativa a conversão automática de CRLF no Windows
  echo "**${ANO}** - Gerado por Erick" \
    >README.md
  git add README.md

  # Função para adicionar datas para commit
  add_commit_dates() {
    local MES=$1
    shift
    for DIA in "$@"
    do
      echo "Conteúdo para ${ANO}-${MES}-${DIA}" > "day${DIA}.txt"
      git add "day${DIA}.txt"
      GIT_AUTHOR_DATE="${ANO}-${MES}-${DIA}T18:00:00" \
        GIT_COMMITTER_DATE="${ANO}-${MES}-${DIA}T18:00:00" \
        git commit -m "Commit para ${ANO}-${MES}-${DIA}"
    done
  }

  # Commit para os dias do mês
  add_commit_dates "02" 12 24 26 28 30
  add_commit_dates "04" 11 22 23 25

  git remote add origin "https://${TOKEN_ACESSO}@github.com/${NOME_USUARIO}/${ANO}.git"
  git branch -M main
  git push -u origin main -f
  cd ..
  rm -rf "${ANO}"

  echo
  echo "Legal, esqueça tudo, parceiro! https://github.com/${NOME_USUARIO}"
} && _

unset -f _
