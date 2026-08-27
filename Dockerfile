# sharp's prebuilt Linux x64 binaries (0.34+) require an x86-64-v2 CPU that
# the deployment host does not report, so sharp is compiled from source here.
# That in turn needs libvips >= 8.18.6, which no Debian release ships, so
# libvips is built from source too. Both live in cached layers ahead of the
# app source, so only the first build pays for them.
FROM node:22-bookworm-slim AS libvips

ARG VIPS_VERSION=8.18.6
ARG VIPS_SHA256=3c41e1d5458081bfa4a5bc54e116c46259c75c6760a18027764555632b9dda3e

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential meson ninja-build pkg-config python3 curl ca-certificates \
      libglib2.0-dev libexpat1-dev libjpeg62-turbo-dev libpng-dev libspng-dev \
      libwebp-dev libtiff-dev libexif-dev liblcms2-dev libheif-dev librsvg2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN curl -fsSLO "https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz" \
    && echo "${VIPS_SHA256}  vips-${VIPS_VERSION}.tar.xz" | sha256sum -c - \
    && tar xf "vips-${VIPS_VERSION}.tar.xz" \
    && cd "vips-${VIPS_VERSION}" \
    && meson setup build --buildtype=release --prefix=/usr/local \
         -Dintrospection=disabled -Dexamples=false \
    && meson compile -C build \
    && meson install -C build \
    && ldconfig \
    && rm -rf /src


FROM libvips AS build
WORKDIR /app

# Do not set SHARP_IGNORE_GLOBAL_LIBVIPS: sharp tests it with Boolean(), so
# even "0" would read as true and skip the libvips built above.
ENV SHARP_FORCE_GLOBAL_LIBVIPS=1

COPY package.json package-lock.json ./
RUN npm ci

# sharp 0.35 has no install hook, so the source build is invoked explicitly.
# It writes src/build/Release/sharp-linux-x64-<version>.node, which sharp
# prefers over the prebuilt @img/sharp-linux-x64 package.
RUN cd node_modules/sharp && npm run build
RUN node -e "const s=require('sharp'); console.log('sharp OK', JSON.stringify(s.versions))"

COPY . .
RUN npm run build


FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
