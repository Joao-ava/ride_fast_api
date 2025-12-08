# Usa a imagem oficial do Elixir com Alpine Linux
FROM elixir:1.15-alpine

# Instala dependências do sistema (build-essential, git, postgresql-client, etc.)
RUN apk add --no-cache build-base git inotify-tools

# Prepara a pasta de trabalho
WORKDIR /app

# Instala Hex e Rebar (gerenciadores de pacotes do Elixir)
RUN mix local.hex --force && \
    mix local.rebar --force

# Copia os arquivos de configuração de dependências primeiro (otimiza cache do Docker)
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copia o restante do código
COPY . .

EXPOSE 4000

# Comando padrão para iniciar o Phoenix (ou o app Elixir)
# O comando phx.server permite o live reload se as inotify-tools estiverem instaladas
CMD ["mix", "phx.server"]