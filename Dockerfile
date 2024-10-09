# Use a imagem Node.js leve e otimizada para produção
FROM node:20 as builder

WORKDIR /app

# Copie apenas os arquivos necessários para instalar as dependências
COPY package*.json ./

# Instale as dependências de desenvolvimento
RUN npm ci --quiet

# Copie o código fonte para a imagem
COPY . .

# Execute o comando de build
RUN npm run build

# Use uma imagem base mais leve para executar o aplicativo
FROM node:20
WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/dist ./dist
COPY package*.json ./

# Install production dependencies (excluding devDependencies)
RUN npm ci

# Defina o comando de inicialização para o aplicativo em produção
CMD [ "npm", "run", "start:prod" ]
