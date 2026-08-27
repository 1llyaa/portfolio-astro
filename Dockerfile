FROM node:22-bookworm-slim AS build
WORKDIR /app

RUN npm install -g npm@latest

COPY package.json package-lock.json ./
RUN npm ci
RUN grep -m1 flags /proc/cpuinfo | tr ' ' '\n' | grep -xE 'sse4_2|popcnt|ssse3|cx16|sse4_1' | sort; \
    node -e "try{const s=require('@img/sharp-linux-x64/sharp.node');console.log('dlopen OK, x64v2 =',s._isUsingX64V2())}catch(e){console.log('dlopen FAIL:',e.message)}"

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
