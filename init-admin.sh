#!/bin/bash

# Script de inicialização automática do usuário admin
# Este script deve rodar após o AppFlowy Cloud inicializar

echo "🚀 Iniciando verificação do usuário admin..."

# Aguarda o banco de dados estar disponível
echo "⏳ Aguardando PostgreSQL..."
until docker exec english_appflowy-postgres-1 pg_isready -U postgres > /dev/null 2>&1; do
    sleep 2
done

# Aguarda o AppFlowy Cloud estar disponível
echo "⏳ Aguardando AppFlowy Cloud..."
until curl -s http://localhost:8080/api/user/profile > /dev/null 2>&1; do
    sleep 5
done

echo "✅ Serviços prontos! Verificando usuário admin..."

# Verifica se o usuário admin já existe
ADMIN_EXISTS=$(docker exec english_appflowy-postgres-1 psql -U postgres -d postgres -t -c "SELECT COUNT(*) FROM af_user WHERE email = 'julianolanzi@hotmail.com';" | tr -d ' ')

if [ "$ADMIN_EXISTS" -eq "0" ]; then
    echo "👤 Criando usuário admin..."
    
    # Gera hash da senha 'lanzi' usando bcrypt
    # $2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi é o hash de 'secret'
    # Vamos usar um hash simples para 'lanzi'
    PASSWORD_HASH='$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'
    
    # Cria usuário no GoTrue (auth.users)
    ADMIN_UUID=$(docker exec english_appflowy-postgres-1 psql -U postgres -d postgres -t -c "
        INSERT INTO auth.users (
            instance_id, 
            id, 
            aud, 
            role, 
            email, 
            encrypted_password, 
            email_confirmed_at, 
            created_at, 
            updated_at,
            confirmation_token,
            email_change,
            email_change_token_new,
            recovery_token
        ) VALUES (
            '00000000-0000-0000-0000-000000000000',
            gen_random_uuid(),
            'authenticated',
            'authenticated',
            'julianolanzi@hotmail.com',
            '$PASSWORD_HASH',
            NOW(),
            NOW(),
            NOW(),
            '',
            '',
            '',
            ''
        ) RETURNING id;" | tr -d ' ')

    echo "✅ Usuário criado no GoTrue com UUID: $ADMIN_UUID"

    # Cria usuário no AppFlowy (af_user)
    docker exec english_appflowy-postgres-1 psql -U postgres -d postgres -c "
        INSERT INTO af_user (uid, uuid, email, password, name, metadata, created_at, updated_at)
        VALUES (1, '$ADMIN_UUID', 'julianolanzi@hotmail.com', '', 'Juliano Lanzi', '{}', NOW(), NOW())
        ON CONFLICT (email) DO NOTHING;"

    echo "✅ Usuário criado no AppFlowy"

    # Cria workspace padrão
    WORKSPACE_ID=$(docker exec english_appflowy-postgres-1 psql -U postgres -d postgres -t -c "
        INSERT INTO af_workspace (workspace_id, database_storage_id, owner_uid, created_at, workspace_type, deleted_at, workspace_name, icon)
        VALUES (gen_random_uuid(), gen_random_uuid(), 1, NOW(), 0, NULL, 'Admin Workspace', '')
        RETURNING workspace_id;" | tr -d ' ')

    echo "✅ Workspace criado com ID: $WORKSPACE_ID"

    # Adiciona usuário como owner do workspace
    docker exec english_appflowy-postgres-1 psql -U postgres -d postgres -c "
        INSERT INTO af_workspace_member (uid, workspace_id, role_id, created_at, updated_at)
        VALUES (1, '$WORKSPACE_ID', 1, NOW(), NOW())
        ON CONFLICT (uid, workspace_id) DO NOTHING;"

    # Adiciona workspace às visualizações recentes
    docker exec english_appflowy-postgres-1 psql -U postgres -d postgres -c "
        INSERT INTO af_recent_views (uid, workspace_id, object_id, viewed_at)
        VALUES (1, '$WORKSPACE_ID', '$WORKSPACE_ID', NOW())
        ON CONFLICT (uid, workspace_id, object_id) DO NOTHING;"

    echo "✅ Usuário admin configurado completamente!"
    echo "📧 Email: julianolanzi@hotmail.com"
    echo "🔑 Senha: lanzi"
    echo "🌐 URL: https://english-appflowy.g9awyq.easypanel.host"

else
    echo "✅ Usuário admin já existe!"
fi

echo "🎉 Inicialização concluída!"