FROM node:18-alpine
WORKDIR /app
# プロジェクトのコピー
COPY vite_fast/ ./
RUN apk update
# "yarn dev"は package.json内にscriptｓに記載されています。
# Viteを実行
CMD ["yarn", "dev"]
