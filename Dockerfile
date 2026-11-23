FROM ghcr.io/cirruslabs/flutter:3.47.1 AS build

# Railway passes service variables as build args when they are declared here.
ARG BASE_URL
ARG FINIK_API_KEY
ARG FINIK_IS_BETA=false
ARG FINIK_ACCOUNT_ID

WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
# flutter_dotenv bundles .env as an asset, so it must exist before the build.
RUN printf 'BASE_URL=%s\nFINIK_API_KEY=%s\nFINIK_IS_BETA=%s\nFINIK_ACCOUNT_ID=%s\n' \
      "$BASE_URL" "$FINIK_API_KEY" "$FINIK_IS_BETA" "$FINIK_ACCOUNT_ID" > .env \
 && dart run build_runner build --delete-conflicting-outputs \
 && flutter build web --release

FROM nginx:1.27-alpine
COPY deploy/nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/build/web /usr/share/nginx/html
ENV PORT=8080
