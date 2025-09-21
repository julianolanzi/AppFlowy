# 🚀 AppFlowy Cloud - Deploy no EasyPanel

Este guia irá te ajudar a fazer deploy do AppFlowy Cloud no EasyPanel de forma simples e eficiente.

## 📋 Pré-requisitos

1. ✅ Conta no EasyPanel configurada
2. ✅ Domínio apontando para seu servidor EasyPanel
3. ✅ Chave de API do OpenAI (opcional, para funcionalidades de IA)

## 🔧 Configuração Passo a Passo

### 1. **Preparar as Variáveis de Ambiente**

1. Copie o arquivo de template:
   ```bash
   cp .env.easypanel .env
   ```

2. Edite o arquivo `.env` e substitua:
   - `YOUR_DOMAIN.COM` pelo seu domínio real (ex: `appflowy.meusite.com`)
   - `your-secure-password-here` por uma senha forte
   - `your-super-secret-jwt-key-here-min-32-chars` por uma chave secreta de pelo menos 32 caracteres
   - `your-openai-api-key-here` pela sua chave da OpenAI (se quiser usar IA)

### 2. **Configurar no EasyPanel**

1. **Acesse o EasyPanel** e crie um novo projeto

2. **Adicione um serviço Docker Compose**:
   - Selecione "Docker Compose"
   - Faça upload do seu `docker-compose.yml`
   - Configure o domínio personalizado

3. **Configurar variáveis de ambiente**:
   - No EasyPanel, vá em "Environment Variables"
   - Copie todo o conteúdo do seu arquivo `.env`
   - Cole nas variáveis de ambiente do projeto

4. **Configurar domínio**:
   - Em "Domains", adicione seu domínio
   - Certifique-se que o SSL está ativado
   - Configure para apontar para a porta 8000

### 3. **Deploy e Verificação**

1. **Fazer deploy**:
   - Clique em "Deploy" no EasyPanel
   - Aguarde todos os serviços ficarem "healthy"

2. **Verificar funcionamento**:
   - Acesse `https://seudominio.com`
   - Você deve ver a interface do AppFlowy
   - Teste criando uma conta de usuário

### 4. **Configurações Avançadas (Opcional)**

#### **4.1. Configurar OAuth (Google, GitHub, Discord)**

Se quiser login social, edite no `.env`:

```env
# Google OAuth
GOTRUE_EXTERNAL_GOOGLE_ENABLED=true
GOTRUE_EXTERNAL_GOOGLE_CLIENT_ID=seu-client-id
GOTRUE_EXTERNAL_GOOGLE_SECRET=seu-secret
```

#### **4.2. Configurar SMTP para Emails**

Para envio de emails de verificação:

```env
APPFLOWY_MAILER_SMTP_HOST=smtp.gmail.com
APPFLOWY_MAILER_SMTP_PORT=587
APPFLOWY_MAILER_SMTP_USERNAME=seu-email@gmail.com
APPFLOWY_MAILER_SMTP_PASSWORD=sua-senha-de-app
```

#### **4.3. Usar S3 Externo (AWS)**

Para usar AWS S3 em vez do MinIO local:

```env
APPFLOWY_S3_USE_MINIO=false
APPFLOWY_S3_ACCESS_KEY=sua-access-key
APPFLOWY_S3_SECRET_KEY=sua-secret-key
APPFLOWY_S3_BUCKET=seu-bucket
APPFLOWY_S3_REGION=us-east-1
```

## 🔒 Segurança Importante

### **Senhas Obrigatórias para Mudar:**

1. **GOTRUE_ADMIN_PASSWORD**: Senha do admin
2. **GOTRUE_JWT_SECRET**: Chave secreta JWT (mínimo 32 chars)
3. **POSTGRES_PASSWORD**: Senha do banco de dados
4. **APPFLOWY_S3_SECRET_KEY**: Chave secreta do MinIO

### **Exemplo de Senhas Seguras:**

```bash
# Gerar senha aleatória de 32 caracteres
openssl rand -base64 32

# Ou usar um gerador online como:
# https://passwordsgenerator.net/
```

## 🐛 Troubleshooting

### **Problema: Serviços não iniciam**
- Verifique se todas as variáveis `YOUR_DOMAIN.COM` foram substituídas
- Confirme se o domínio está apontando corretamente
- Verifique os logs no EasyPanel

### **Problema: Erro de autenticação**
- Verifique se o `GOTRUE_JWT_SECRET` é o mesmo em todos os serviços
- Confirme se as URLs estão corretas (https://)

### **Problema: Upload de arquivos não funciona**
- Verifique se o MinIO está rodando
- Confirme se as credenciais S3 estão corretas

## 📊 Monitoramento

Depois do deploy, você pode monitorar:

1. **Admin Panel**: `https://seudominio.com/admin`
2. **MinIO Console**: `https://seudominio.com/minio`
3. **Logs**: Diretamente no EasyPanel

## 🎉 Pronto!

Seu AppFlowy Cloud agora está rodando no EasyPanel! 

### **URLs Importantes:**
- **App Principal**: `https://seudominio.com`
- **Admin**: `https://seudominio.com/admin`  
- **API**: `https://seudominio.com/api`
- **WebSocket**: `wss://seudominio.com/ws`

---

### 💡 Dicas Extras

- Use **versões `latest`** para sempre ter as versões mais recentes
- Configure **backups automáticos** do PostgreSQL
- Monitore o **uso de recursos** no EasyPanel
- Mantenha suas **chaves secretas** seguras

Se tiver problemas, verifique os logs dos containers no EasyPanel ou abra uma issue no GitHub! 🚀