#<<<<<<< HEAD
FROM node:20-alpine AS builder

WORKDIR /app

#=======
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
# ต้องมั่นใจว่าไฟล์ package.json อยู่ในโฟลเดอร์เดียวกับ Dockerfile
#>>>>>>> 90908c0 (update dockerfile)
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Run
FROM node:20-alpine
WORKDIR /app

# --- ส่วนที่ต้องเพิ่ม: ก๊อปปี้ไฟล์จาก stage builder มา ---
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
CMD ["node", "dist/main"]

